"""
------------------------------------------------------------------------------------------------------------------------
This file contains gwf template functions of the pipeline.
------------------------------------------------------------------------------------------------------------------------

DIRECTORY LAYOUT:
  <project_root>/
  ├── mapping_and_calling/          ← this file lives here
  │   ├── workflow.py
  │   ├── templates.py
  │   └── additional_scripts/
  ├── metadata/                     ← supp_table_1.txt goes here
  └── outputs/                      ← all job outputs, organised per species / reference
      ├── <FOLDER>/                 ← species-level folder
      │   ├── done/
      │   ├── fastq/
      │   ├── bam/
      │   ├── cov/
      │   └── psmc/
      └── <REFERENCE_FOLDER>/       ← reference-level folder
          ├── done/
          └── ref/

------------------------------------------------------------------------------------------------------------------------
"""

import os
from gwf import AnonymousTarget

## -----------------------------------------------------------------------------------------------------------------------
## PATH CONFIGURATION
## -----------------------------------------------------------------------------------------------------------------------
WORKFLOW_DIR = os.path.dirname(os.path.abspath(__file__))        # .../mapping_and_calling
PROJECT_ROOT = os.path.dirname(WORKFLOW_DIR)                     # .../<project_root>
SCRIPTS_DIR  = os.path.join(WORKFLOW_DIR, "additional_scripts")  # .../mapping_and_calling/additional_scripts
OUTPUTS_DIR  = os.path.join(PROJECT_ROOT, "outputs")             # .../outputs

job_header = '''
    echo "JOBID:" $PBS_JOBID
    echo "NODE :" $HOSTNAME
    echo "USER :" $USER
    source ~/.bashrc
    conda activate ~/GenerationInterval/people/sharedenv/gatkshared
    echo "CONDA:" $CONDA_DEFAULT_ENV
'''

default_options = {"cores": 1, 'memory': "8g", 'walltime': "1-00:00:00", 'account': "megaFauna"}


"""
------------------------------------------------------------------------------------------------------------------------
A. REFERENCE-ASSOCIATED JOBS
------------------------------------------------------------------------------------------------------------------------
"""

def download_ref(ftp, out, done):
    '''Download genbank reference.'''
    inputs  = []
    outputs = [done]
    options = default_options.copy()
    spec = job_header + f'''
    rm -f {out}
    curl {ftp} | gzip -d > {out}
    touch {done}
    '''
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def mask_reference(input, bed, output, done_prev, done):
    """Mask reference fasta with a BED file of regions to hard-mask."""
    inputs  = [done_prev]
    outputs = [done]
    options = {"cores": 1, 'memory': "8g", 'walltime': "1-00:00:00", 'account': "megaFauna"}
    spec = job_header + '''
    bedtools maskfasta -fi {input} -bed {bed} -fo {output}
    touch {done}
    '''.format(input=input, bed=bed, output=output, done=done)
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def cut_contigs(input, output, min_length, done_prev, done):
    """Make reference fasta with contigs >= min_length bp."""
    inputs  = [done_prev]
    outputs = [done]
    options = {"cores": 1, 'memory': "8g", 'walltime': "1-00:00:00", 'account': "megaFauna"}
    spec = job_header + '''
    reformat.sh -Xmx8g in={input} out={output} minlength={min_length} overwrite=true
    touch {done}
    '''.format(input=input, output=output, min_length=min_length, done=done)
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def make_fasta(input, done_prev, done):
    """Build BWA and faidx indices for the filtered reference fasta.
    Note: gatk CreateSequenceDictionary is not needed for the PSMC-only pipeline
    and has been omitted.
    """
    inputs  = [done_prev]
    outputs = [done]
    options = {"cores": 1, 'memory': "16g", 'walltime': "1-00:00:00", 'account': "megaFauna"}
    spec = job_header + '''
    bwa index -a bwtsw {newFasta}

    samtools faidx {newFasta}

    touch {done}
    '''.format(newFasta=input.split(".f")[0] + "_LargerThan1000bp.fasta",
               done=done)
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def make_regions(refFolder, ref_outdir, input, done_prev, done):
    """Make regions file via make_regions_file.py.
    Output regions_<refFolder>.txt is used directly for coverage calculation (C.6).
    """
    inputs  = [done_prev]
    outputs = [done]
    options = default_options.copy()
    spec = job_header + '''
    python {scripts_dir}/make_regions_file.py {refFolder} {chrs} {ref_outdir}
    touch {done}
    '''.format(scripts_dir=SCRIPTS_DIR,
               refFolder=refFolder,
               chrs=input.split(".f")[0] + "_LargerThan1000bp.fasta.fai",
               ref_outdir=ref_outdir,
               done=done)
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


"""
------------------------------------------------------------------------------------------------------------------------
B. SAMPLE DOWNLOAD AND PREPARATION FOR MAPPING
------------------------------------------------------------------------------------------------------------------------
"""

def download_pe2(srr, out, done):
    """Download paired end fastq reads."""
    inputs  = []
    outputs = [done]
    options = {'cores': 1, 'memory': '4g', 'walltime': "48:00:00", 'account': "megaFauna"}
    spec = job_header + """
    rm -f {prev_file}
    wget --progress=dot:giga --timeout=120 --waitretry=60 --tries=10000 --retry-connrefused -P {out} {srr}
    touch {done}
    """.format(prev_file=out + srr.split("/")[-1], srr=srr, out=out, done=done)
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def download_per_individual(group, ind, run_accessions, md5s, outputs_dir, done):
    """Download paired end fastq reads per individual and verify md5.
    Passes outputs_dir to download_fastq_per_individual_check_md5.py so it
    can build the correct done-file paths at runtime.
    """
    inputs  = []
    outputs = [done] + [os.path.join(outputs_dir, group, "done",
                         f"download_pe2_{group}_{ra.replace('/', '_')}") for ra in run_accessions.split(",")]
    options = {'cores': 1, 'memory': '8g', 'walltime': "06:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    python {SCRIPTS_DIR}/download_fastq_per_individual_check_md5.py {group} {ind} {run_accessions} {md5s} {outputs_dir}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def prefetch(srr, out, done):
    """Download SRA data via prefetch."""
    inputs  = []
    outputs = [done]
    options = {'cores': 1, 'memory': '4g', 'walltime': "12:00:00", 'account': "megaFauna"}
    spec = job_header + """
    cd {out}
    prefetch --max-size 1t {srr}
    touch {done}
    """.format(srr=srr, out=out, done=done)
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def download_straggler_old(srr, out, done):
    """Split paired end fastq reads (old method)."""
    inputs  = []
    outputs = [done]
    options = {'cores': 1, 'memory': '4g', 'walltime': "24:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    conda activate workflowMap
    fastq-dump --split-files --gzip -O {out} {srr}
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def download_straggler(srr, out, done):
    """Split paired end fastq reads."""
    inputs  = []
    outputs = done
    options = {'cores': 1, 'memory': '4g', 'walltime': "24:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    conda activate workflowMap
    fastq-dump --split-files --gzip -O {out} {srr}
    touch {done[0]} {done[1]}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def split_srr(srr, out, done_prev, done):
    """Split paired end fastq reads."""
    inputs  = [done_prev]
    outputs = [done + "_1.fastq.gz", done + "_2.fastq.gz"]
    options = {'cores': 1, 'memory': '4g', 'walltime': "24:00:00", 'account': "megaFauna"}
    spec = job_header + """
    conda activate workflowMap
    fastq-dump --gzip --split-files -O {out} {srr}
    rm {srr}
    touch {done1}
    touch {done2}
    """.format(srr=out + srr, out=out, done1=done + "_1.fastq.gz", done2=done + "_2.fastq.gz")
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def concatfastqs(group, ind, fastqs_1, fastqs_2, species_outdir, prev_done, done):
    '''Concatenate fastqs for an individual with multiple run accessions.'''
    inputs  = [prev_done]
    outputs = [done]
    options = {'cores': 1, 'memory': '8g', 'walltime': "06:00:00", 'account': "megaFauna"}
    spec = job_header + f'''
    out_dir={species_outdir}/fastq
    mkdir -p ${{out_dir}}
    cat {" ".join(fastqs_1)} > ${{out_dir}}/{ind}_R1.fastq.gz
    cat {" ".join(fastqs_2)} > ${{out_dir}}/{ind}_R2.fastq.gz
    rm {" ".join(fastqs_1)}
    rm {" ".join(fastqs_2)}
    touch {done}
    '''
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def renamefastqs(group, ind, fastq_1, fastq_2, species_outdir, prev_done, done):
    '''Rename fastqs for an individual with a single run accession.'''
    inputs  = [prev_done]
    outputs = [done]
    options = {'cores': 1, 'memory': '8g', 'walltime': "06:00:00", 'account': "megaFauna"}
    spec = job_header + f'''
    out_dir={species_outdir}/fastq
    mkdir -p ${{out_dir}}
    mv {fastq_1} ${{out_dir}}/{ind}_R1.fastq.gz
    mv {fastq_2} ${{out_dir}}/{ind}_R2.fastq.gz
    touch {done}
    '''
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def makeuBAM(group, ind, fastq1, fastq2, species_outdir, prev_done, done):
    '''Make uBAM file.'''
    inputs  = prev_done
    outputs = [done]
    options = {"cores": 1, 'memory': "8g", 'walltime': "1-00:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    mkdir -p {species_outdir}/bam
    picard FastqToSam --FASTQ  {fastq1}                        \\
                      --FASTQ2 {fastq2}                        \\
                      --OUTPUT {species_outdir}/bam/u{ind}.bam \\
                      --SAMPLE_NAME {ind}                      \\
                      --QUALITY_FORMAT Standard                \\
                      --TMP_DIR /scratch/$SLURM_JOB_ID
    rm {fastq1} {fastq2}
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def splituBAM(group, ind, species_outdir, prev_done, done):
    '''Split uBAM into shards of 48M reads each.'''
    inputs  = prev_done
    outputs = [done]
    options = default_options.copy()
    spec = job_header + f"""
    splitubamdir={species_outdir}/bam/split_uBAM{ind}
    rm    -fr ${{splitubamdir}}
    mkdir -p  ${{splitubamdir}}
    picard SplitSamByNumberOfReads -I {species_outdir}/bam/u{ind}.bam \\
                                   -O ${{splitubamdir}}               \\
                                   --CREATE_INDEX true                \\
                                   -N_READS 48000000
    ls ${{splitubamdir}} | wc -l > {species_outdir}/bam/{ind}_nsplitubams.txt
    rm {species_outdir}/bam/u{ind}.bam
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def further_splituBAM(group, ind, shard_path, shard, n_reads, species_outdir, prev_done, done):
    '''Further split an oversized uBAM shard.'''
    inputs  = prev_done
    outputs = [done]
    options = default_options.copy()
    spec = job_header + f"""
    mkdir -p {species_outdir}/bam/split_uBAM{ind}_shard_{shard}
    picard SplitSamByNumberOfReads -I {shard_path}                                        \\
                                   -O {species_outdir}/bam/split_uBAM{ind}_shard_{shard}  \\
                                   --CREATE_INDEX true                                     \\
                                   -N_READS {n_reads}
    ls {species_outdir}/bam/split_uBAM{ind}_shard_{shard} | wc -l > {species_outdir}/bam/{ind}_shard_{shard}_nsplitubams.txt
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


"""
------------------------------------------------------------------------------------------------------------------------
C. MAPPING
------------------------------------------------------------------------------------------------------------------------
"""

def shardstr(ishard):
    return (4 - len(str(ishard + 1))) * "0" + str(ishard + 1)


def markadapt(group, ind, shard, species_outdir, prev_done, done):
    '''Mark adaptor sequences in a uBAM shard.'''
    inputs  = prev_done
    outputs = [done]
    options = default_options.copy()
    spec = job_header + f"""
    picard MarkIlluminaAdapters -I {species_outdir}/bam/split_uBAM{ind}/shard_{shard}.bam          \\
                                -O {species_outdir}/bam/split_uBAM{ind}/shard_{shard}_markadapt.bam \\
                                -M {species_outdir}/bam/split_uBAM{ind}/shard_{shard}_markadapt.txt \\
                                --TMP_DIR /scratch/$SLURM_JOB_ID
    rm -f {species_outdir}/bam/u{ind}.bam
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def mapBAM(group, ind, shard, ref, species_outdir, prev_done, done):
    '''SamToFastq | bwa mem | MergeBamAlignment for a single shard.'''
    inputs  = prev_done
    outputs = [done]
    options = {"cores": 1, 'memory': "16g", 'walltime': "1-00:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    picard SamToFastq -I           {species_outdir}/bam/split_uBAM{ind}/shard_{shard}_markadapt.bam  \\
                      --FASTQ      /dev/stdout                                                        \\
                      --INTERLEAVE true                                                               \\
                      --TMP_DIR    /scratch/$SLURM_JOB_ID                                             \\
        | bwa mem -M                    \\
                  -t {options["cores"]} \\
                  -p {ref}              \\
                  /dev/stdin            \\
        | picard MergeBamAlignment --ALIGNED_BAM                  /dev/stdin                                                                            \\
                                   --UNMAPPED_BAM                 {species_outdir}/bam/split_uBAM{ind}/shard_{shard}_markadapt.bam                      \\
                                   --OUTPUT                       {species_outdir}/bam/split_uBAM{ind}/shard_{shard}_markadapt_mapped.bam               \\
                                   -R                             {ref}                                                                                 \\
                                   --CREATE_INDEX                 true                                                                                  \\
                                   --INCLUDE_SECONDARY_ALIGNMENTS false                                                                                 \\
                                   --TMP_DIR                      /scratch/$SLURM_JOB_ID
    rm -f {species_outdir}/bam/split_uBAM{ind}/shard_{shard}.bam
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def mergeBAMs(group, ind, bams, species_outdir, prev_done, done):
    '''Merge all mapped shard BAMs into one queryname-sorted BAM per individual.'''
    inputs  = prev_done
    outputs = [done]
    options = {"cores": 1, 'memory': "16g", 'walltime': "1-00:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    picard MergeSamFiles {" ".join([f"-I {bam} " for bam in bams])}                           \\
                         -O {species_outdir}/bam/{ind}_markadapt_mapped_merged.bam             \\
                         --SORT_ORDER   queryname                                              \\
                         --TMP_DIR      /scratch/$SLURM_JOB_ID
    rm -f {species_outdir}/bam/split_uBAM{ind}/shard_*_markadapt.bam
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def mergeBAMs_custom(bams, output, prev_done, done):
    '''Merge BAMs with a custom output path.'''
    inputs  = prev_done
    outputs = [done]
    options = {"cores": 1, 'memory': "16g", 'walltime': "24:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    picard MergeSamFiles {" ".join([f"-I {bam} " for bam in bams])}  \\
                         -O {output}                                   \\
                         --SORT_ORDER   queryname                      \\
                         --TMP_DIR      /scratch/$SLURM_JOB_ID
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def merge_further_split_BAMs(group, ind, bams, shard, species_outdir, prev_done, done):
    '''Merge sub-shards back into a single shard BAM.'''
    inputs  = prev_done
    outputs = [done]
    options = {"cores": 1, 'memory': "16g", 'walltime': "1-00:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    picard MergeSamFiles {" ".join([f"-I {bam} " for bam in bams])}                                               \\
                         -O {species_outdir}/bam/split_uBAM{ind}/shard_{shard}_markadapt_mapped.bam              \\
                         --SORT_ORDER   queryname                                                                  \\
                         --TMP_DIR      /scratch/$SLURM_JOB_ID
    rm -f {species_outdir}/bam/split_uBAM{ind}/shard_*_markadapt.bam
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def markduplicates(group, ind, species_outdir, prev_done, done):
    '''Mark and remove PCR duplicates.'''
    inputs  = prev_done
    outputs = [done]
    options = {"cores": 1, 'memory': "16g", 'walltime': "12:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    picard MarkDuplicates -I {species_outdir}/bam/{ind}_markadapt_mapped_merged.bam                \\
                          -M {species_outdir}/bam/{ind}_markadapt_mapped_merged_markduplicates.txt \\
                          -O {species_outdir}/bam/{ind}_markadapt_mapped_merged_markduplicates.bam \\
                          --REMOVE_DUPLICATES true                                                  \\
                          --CREATE_INDEX true                                                       \\
                          --TMP_DIR /scratch/$SLURM_JOB_ID
    rm -fr {species_outdir}/bam/split_uBAM{ind}
    rm -f  {species_outdir}/bam/{ind}_markadapt_mapped_merged_markduplicates.txt
    rm     {species_outdir}/bam/{ind}_markadapt_mapped_merged.bam
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def coordsort(group, ind, species_outdir, prev_done, done):
    '''Sort BAM by coordinates and index.'''
    inputs  = prev_done
    outputs = [done]
    options = default_options.copy()
    spec = job_header + f"""
    picard SortSam -I {species_outdir}/bam/{ind}_markadapt_mapped_merged_markduplicates.bam           \\
                   -O {species_outdir}/bam/{ind}_markadapt_mapped_merged_markduplicates_coordsort.bam \\
                   -SO coordinate                                                                      \\
                   --CREATE_INDEX true                                                                 \\
                   --TMP_DIR /scratch/$SLURM_JOB_ID
    rm -f {species_outdir}/bam/{ind}_markadapt_mapped_merged_markduplicates.bam
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def cov(group, ind, regions, chromosomes, starts, ends, species_outdir, prev_done, done):
    '''Get mean coverage per region for a coordinate-sorted BAM.'''
    inputs  = prev_done
    outputs = [done]
    options = default_options.copy()
    spec = job_header + f"""
    covdir={species_outdir}/cov
    rm    -f ${{covdir}}/{ind}.cov
    mkdir -p  ${{covdir}}

    regions=({" ".join(regions)})
    chromosomes=({" ".join(chromosomes)})
    starts=({" ".join([str(s) for s in starts])})
    ends=({" ".join([str(e) for e in ends])})
    length=${{#regions[@]}}

    for ((i = 0; i < length; i++)); do
        region=${{regions[i]}}
        chrom=${{chromosomes[i]}}
        start=${{starts[i]}}
        end=${{ends[i]}}
        echo ${{region}} ${{chrom}}
        date
        samtools depth -r ${{chrom}}:${{start}}-${{end}} {species_outdir}/bam/{ind}_markadapt_mapped_merged_markduplicates_coordsort.bam \\
            | awk '{{sum += $3}} END {{if(sum == 0 || NR == 0){{cov=0}}else{{cov=sum/NR}};print "'${{region}}'\t'${{chrom}}'\t'${{start}}'\t'${{end}}'\t"NR"\t"sum"\t"cov}}' >> ${{covdir}}/{ind}.cov
    done

    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def cov_batched(group, ind, batch, regions, chromosomes, starts, ends, species_outdir, prev_done, done):
    '''Get mean coverage per region in batches (for very large numbers of contigs).'''
    inputs  = prev_done
    outputs = [done]
    options = default_options.copy()
    spec = job_header + f"""
    covdir={species_outdir}/cov
    rm    -f ${{covdir}}/{ind}_batch_{batch}.cov
    mkdir -p  ${{covdir}}

    regions=({" ".join(regions)})
    chromosomes=({" ".join(chromosomes)})
    starts=({" ".join([str(s) for s in starts])})
    ends=({" ".join([str(e) for e in ends])})
    length=${{#regions[@]}}

    for ((i = 0; i < length; i++)); do
        region=${{regions[i]}}
        chrom=${{chromosomes[i]}}
        start=${{starts[i]}}
        end=${{ends[i]}}
        echo ${{region}} ${{chrom}}
        date
        samtools depth -r ${{chrom}}:${{start}}-${{end}} {species_outdir}/bam/{ind}_markadapt_mapped_merged_markduplicates_coordsort.bam \\
            | awk '{{sum += $3}} END {{if(sum == 0 || NR == 0){{cov=0}}else{{cov=sum/NR}};print "'${{region}}'\t'${{chrom}}'\t'${{start}}'\t'${{end}}'\t"NR"\t"sum"\t"cov}}' >> ${{covdir}}/{ind}_batch_{batch}.cov
    done

    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def concatenate_cov_files(files, out_file, prev_done, done):
    '''Concatenate batched coverage files into a single file.'''
    inputs  = prev_done
    outputs = [done]
    options = default_options.copy()
    spec = job_header + f"""
    cat {" ".join(files)} > {out_file}
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


"""
------------------------------------------------------------------------------------------------------------------------
D. PSMC INFERENCE
------------------------------------------------------------------------------------------------------------------------
"""

def get_consSeq(ref, bam, bed, cov, out, done):
    """Get consensus fastq for PSMC using samtools mpileup + bcftools call."""
    inputs  = [bed]
    outputs = [out, done]
    options = {'cores': 1, 'memory': "40g", 'walltime': "48:00:00", 'account': "megaFauna"}
    spec = job_header + """
    samtools mpileup -A -q 20 -Q 20 -C 50 -R -u -f {ref} {bam} | bcftools call -c -V indels - | vcfutils.pl vcf2fq -d {cov1} -D {cov2} -l 5 | gzip > {out}
    touch {done}
    """.format(ref=ref, bam=bam, cov1=str(float(cov) / 3), cov2=str(2 * float(cov)), out=out, done=done)
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def make_psmc_input(inp, out, done):
    """Convert diploid fastq to PSMC input (psmcfa) format."""
    inputs  = [inp]
    outputs = [out, done]
    options = {'cores': 1, 'memory': "10g", 'walltime': "12:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    fq2psmcfa -q20 {inp} > {out}
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)


def run_psmc(inp, out, p, done):
    """Run PSMC with a given atomic-interval configuration string."""
    inputs  = [inp]
    outputs = [out, done]
    options = {'cores': 1, 'memory': "40g", 'walltime': "06:00:00", 'account': "megaFauna"}
    spec = job_header + f"""
    psmc -p "{p}" -o {out} {inp}
    touch {done}
    """
    return AnonymousTarget(inputs=inputs, outputs=outputs, options=options, spec=spec)
