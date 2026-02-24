"""
------------------------------------------------------------------------------------------------------------------------
This workflow handles raw files (reference genomes, paired-end fastqs), maps reads and runs PSMC inference.
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

PIPELINE BLOCKS:
  A. Reference download and indexing
  B. Sample download and preparation
  C. Mapping (mark adapters → map → merge → mark duplicates → coordinate sort → coverage)
  D. PSMC inference (consensus sequence → psmcfa → psmc)
------------------------------------------------------------------------------------------------------------------------
"""

import os
import subprocess
import pandas as pd
from gwf import Workflow, AnonymousTarget
from templates import *

gwf = Workflow()

## -----------------------------------------------------------------------------------------------------------------------
## PATH CONFIGURATION
## -----------------------------------------------------------------------------------------------------------------------
WORKFLOW_DIR = os.path.dirname(os.path.abspath(__file__))        # .../mapping_and_calling
PROJECT_ROOT = os.path.dirname(WORKFLOW_DIR)                     # .../<project_root>
SCRIPTS_DIR  = os.path.join(WORKFLOW_DIR, "additional_scripts")  # .../mapping_and_calling/additional_scripts
OUTPUTS_DIR  = os.path.join(PROJECT_ROOT, "outputs")             # .../outputs
METADATA_DIR = os.path.join(PROJECT_ROOT, "metadata")            # .../metadata

## -----------------------------------------------------------------------------------------------------------------------
## LOAD METADATA FROM supp_table_1.txt
## Expected columns: Binomial.1.2, Genome.accession, Genome.source, SRA.accessions
## -----------------------------------------------------------------------------------------------------------------------
supp = pd.read_table(os.path.join(METADATA_DIR, "supp_table_1.txt"))

## Build a samples dataframe: each SRA accession → one R1 row + one R2 row.
rows = []
for _, row in supp.iterrows():
    binomial       = row["Binomial.1.2"]             # e.g. "Acinonyx_jubatus"
    genus, species = binomial.split("_", 1)
    ref_accession  = row["Genome.accession"]          # e.g. "GCA_002007445.2"
    ref_source     = row["Genome.source"]
    sra_list       = [s.strip() for s in str(row["SRA.accessions"]).split(",")]
    folder         = binomial                         # species-level output folder name

    for sra in sra_list:
        for strand in ("R1", "R2"):
            rows.append({
                "GENUS":            genus,
                "SPECIES":          species,
                "FOLDER":           folder,
                "REFERENCE_FOLDER": ref_accession,
                "IND_ID":           sra,
                "fastq_ftp":        sra,
                "fastq_md5":        "",
                "R1_or_R2":         strand,
            })

data = pd.DataFrame(rows)

## Build references dataframe (one row per unique reference genome).
ref_rows = []
for _, row in supp.iterrows():
    ref_accession = row["Genome.accession"]
    ref_source    = row["Genome.source"]

    if "ncbi" in str(ref_source).lower():
        ftp = (f"https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/"
               f"{ref_accession[4:7]}/{ref_accession[7:10]}/{ref_accession[10:13]}/"
               f"{ref_accession}/{ref_accession}_genomic.fna.gz")
    elif "dnazoo" in str(ref_source).lower():
        ftp = f"https://dnazoo.s3.wasabisys.com/{ref_accession}/{ref_accession}.fasta.gz"
    else:
        ftp = f"https://{ref_source}/{ref_accession}.fna.gz"

    ref_rows.append({
        "REFERENCE_FOLDER": ref_accession,
        "ref_genome_name":  ref_accession,
        "ftp":              ftp,
        "source":           ref_source,
    })

references = (pd.DataFrame(ref_rows)
              .drop_duplicates(subset=["REFERENCE_FOLDER"])
              .reset_index(drop=True))

ref_folders = list(set(data.REFERENCE_FOLDER))
references  = references.loc[references.REFERENCE_FOLDER.isin(ref_folders)].reset_index(drop=True)

## species_and_refs: one row per (species-folder, reference-folder) combination.
species_and_refs = (data[["FOLDER", "REFERENCE_FOLDER"]]
                    .drop_duplicates()
                    .reset_index(drop=True))


def outdir(folder):
    """Return the absolute output directory for a given species/reference folder."""
    return os.path.join(OUTPUTS_DIR, folder)


"""
------------------------------------------------------------------------------------------------------------------------
A. REFERENCE-ASSOCIATED JOBS
------------------------------------------------------------------------------------------------------------------------
"""

for i in range(references.shape[0]):
    ref_folder = references.REFERENCE_FOLDER[i]
    ref_out    = outdir(ref_folder)

    ## A.0. Initialise directories
    for subdir in ["done", "ref"]:
        subprocess.run(["mkdir", "-p", os.path.join(ref_out, subdir)])

    ftp_url   = references.ftp[i]
    ref_fname = str(ftp_url).split("/")[-1][:-3]    # strip trailing .gz → local filename

    ## A.1. Download reference
    jobid_download_ref = "download_ref_" + references.ref_genome_name[i].replace("-", "_")
    gwf.target_from_template(jobid_download_ref,
                             download_ref(
                                 ftp  = ftp_url,
                                 out  = os.path.join(ref_out, "ref", ref_fname),
                                 done = os.path.join(ref_out, "done", jobid_download_ref)))

    ## A.2. Mask reference (uncomment if needed; expects masked_regions.bed in ref/)
    # jobid_mask_reference = "mask_reference_" + references.ref_genome_name[i].replace("-", "_")
    # gwf.target_from_template(jobid_mask_reference,
    #                          mask_reference(
    #                              input     = os.path.join(ref_out, "ref", ref_fname),
    #                              bed       = os.path.join(ref_out, "ref", "masked_regions.bed"),
    #                              output    = os.path.join(ref_out, "ref", ref_fname[:-4] + "_masked.fna"),
    #                              done_prev = os.path.join(ref_out, "done", jobid_download_ref),
    #                              done      = os.path.join(ref_out, "done", jobid_mask_reference)))

    ## A.3. Cut contigs shorter than 1000 bp
    jobid_cut_contigs = "cut_contigs_" + references.ref_genome_name[i].replace("-", "_")
    gwf.target_from_template(jobid_cut_contigs,
                             cut_contigs(
                                 input      = os.path.join(ref_out, "ref", ref_fname),
                                 # input    = os.path.join(ref_out, "ref", ref_fname[:-4] + "_masked.fna"),   # if masked
                                 output     = os.path.join(ref_out, "ref", ref_fname[:-4] + "_LargerThan1000bp.fasta"),
                                 min_length = 1000,
                                 done_prev  = os.path.join(ref_out, "done", jobid_download_ref),
                                 # done_prev= os.path.join(ref_out, "done", jobid_mask_reference),             # if masked
                                 done       = os.path.join(ref_out, "done", jobid_cut_contigs)))

    ## A.4. Build BWA and faidx indices
    jobid_make_fasta = "make_fasta_" + references.ref_genome_name[i].replace("-", "_")
    gwf.target_from_template(jobid_make_fasta,
                             make_fasta(
                                 input     = os.path.join(ref_out, "ref", ref_fname),
                                 # input   = os.path.join(ref_out, "ref", ref_fname[:-4] + "_masked.fna"),    # if masked
                                 done_prev = os.path.join(ref_out, "done", jobid_cut_contigs),
                                 done      = os.path.join(ref_out, "done", jobid_make_fasta)))

    ## A.5. Make regions file (used for coverage calculation in C.6)
    jobid_make_regions = "make_regions_" + references.ref_genome_name[i].replace("-", "_")
    gwf.target_from_template(jobid_make_regions,
                             make_regions(
                                 refFolder  = ref_folder,
                                 ref_outdir = os.path.join(ref_out, "ref"),
                                 input      = ref_fname,
                                 done_prev  = os.path.join(ref_out, "done", jobid_make_fasta),
                                 done       = os.path.join(ref_out, "done", jobid_make_regions)))


"""
------------------------------------------------------------------------------------------------------------------------
B. SAMPLE DOWNLOAD AND PREPARATION FOR MAPPING
------------------------------------------------------------------------------------------------------------------------
"""

for i in range(species_and_refs.shape[0]):
    group = species_and_refs.FOLDER[i]
    inds  = list(data.loc[data.FOLDER == group].IND_ID.drop_duplicates())

    ## B.0. Initialise directories
    for subdir in ["done", "fastq", "bam"]:
        subprocess.run(["mkdir", "-p", os.path.join(outdir(group), subdir)])

    for ind in inds:
        data_subset = data.loc[data.IND_ID == ind]

        ## B.1. Download fastq files per individual (with MD5 verification)
        jobid_download_per_individual = f"download_per_individual_{group}_{ind}"
        gwf.target_from_template(jobid_download_per_individual,
                                 download_per_individual(
                                     group          = group,
                                     ind            = ind,
                                     run_accessions = ",".join(list(data_subset.fastq_ftp.drop_duplicates())),
                                     md5s           = ",".join(list(data_subset.fastq_md5.drop_duplicates())),
                                     outputs_dir    = OUTPUTS_DIR,
                                     done           = os.path.join(outdir(group), "done",
                                                                   jobid_download_per_individual)))

        ## B.2. Concatenate (>1 accession) or rename fastqs
        if data_subset.shape[0] > 2:
            jobid_concat_or_rename_fastqs = f"concat_or_rename_fastqs_{group}_{ind}"
            gwf.target_from_template(jobid_concat_or_rename_fastqs,
                                     concatfastqs(
                                         group          = group,
                                         ind            = ind,
                                         fastqs_1       = [os.path.join(outdir(group), "fastq",
                                                            data_subset.loc[data_subset.R1_or_R2 == "R1"].fastq_ftp.iloc[jj].split("/")[-1])
                                                           for jj in range(data_subset.loc[data_subset.R1_or_R2 == "R1"].shape[0])],
                                         fastqs_2       = [os.path.join(outdir(group), "fastq",
                                                            data_subset.loc[data_subset.R1_or_R2 == "R2"].fastq_ftp.iloc[jj].split("/")[-1])
                                                           for jj in range(data_subset.loc[data_subset.R1_or_R2 == "R2"].shape[0])],
                                         species_outdir = outdir(group),
                                         prev_done      = os.path.join(outdir(group), "done",
                                                                       jobid_download_per_individual),
                                         done           = os.path.join(outdir(group), "done",
                                                                       jobid_concat_or_rename_fastqs)))
        else:
            jobid_concat_or_rename_fastqs = f"concat_or_rename_fastqs_{group}_{ind}"
            gwf.target_from_template(jobid_concat_or_rename_fastqs,
                                     renamefastqs(
                                         group          = group,
                                         ind            = ind,
                                         fastq_1        = os.path.join(outdir(group), "fastq",
                                                           data_subset.loc[data_subset.R1_or_R2 == "R1"].fastq_ftp.iloc[0].split("/")[-1]),
                                         fastq_2        = os.path.join(outdir(group), "fastq",
                                                           data_subset.loc[data_subset.R1_or_R2 == "R2"].fastq_ftp.iloc[0].split("/")[-1]),
                                         species_outdir = outdir(group),
                                         prev_done      = os.path.join(outdir(group), "done",
                                                                       jobid_download_per_individual),
                                         done           = os.path.join(outdir(group), "done",
                                                                       jobid_concat_or_rename_fastqs)))

        ## B.3. Make uBAM
        jobid_makeuBAM = f"makeuBAM_{group}_{ind}"
        gwf.target_from_template(jobid_makeuBAM,
                                 makeuBAM(
                                     group          = group,
                                     ind            = ind,
                                     fastq1         = os.path.join(outdir(group), "fastq", f"{ind}_R1.fastq.gz"),
                                     fastq2         = os.path.join(outdir(group), "fastq", f"{ind}_R2.fastq.gz"),
                                     species_outdir = outdir(group),
                                     prev_done      = [os.path.join(outdir(group), "done",
                                                                    jobid_concat_or_rename_fastqs)],
                                     done           = os.path.join(outdir(group), "done", jobid_makeuBAM)))

        ## B.4. Split uBAM into shards
        jobid_splituBAM = f"splituBAM_{group}_{ind}"
        gwf.target_from_template(jobid_splituBAM,
                                 splituBAM(
                                     group          = group,
                                     ind            = ind,
                                     species_outdir = outdir(group),
                                     prev_done      = [os.path.join(outdir(group), "done", jobid_makeuBAM)],
                                     done           = os.path.join(outdir(group), "done", jobid_splituBAM)))


"""
------------------------------------------------------------------------------------------------------------------------
C. MAPPING
------------------------------------------------------------------------------------------------------------------------
"""

for i in range(species_and_refs.shape[0]):
    group      = species_and_refs.FOLDER[i]
    ref_folder = species_and_refs.REFERENCE_FOLDER[i]
    ref_dir    = outdir(ref_folder)
    inds       = list(data.loc[data.FOLDER == group].IND_ID.drop_duplicates())

    ## Discover the filtered reference at runtime
    ref_fasta_candidates = ([f for f in os.listdir(os.path.join(ref_dir, "ref"))
                              if f.endswith("_LargerThan1000bp.fasta")]
                             if os.path.isdir(os.path.join(ref_dir, "ref")) else [])
    ref_path = (os.path.join(ref_dir, "ref", ref_fasta_candidates[0])
                if ref_fasta_candidates
                else os.path.join(ref_dir, "ref", "REFERENCE_NOT_YET_BUILT.fasta"))

    for ind in inds:
        jobid_splituBAM = f"splituBAM_{group}_{ind}"
        nsplitubams_txt = os.path.join(outdir(group), "bam", f"{ind}_nsplitubams.txt")

        if not os.path.isfile(os.path.join(outdir(group), "done", jobid_splituBAM)):
            continue

        with open(nsplitubams_txt) as fh:
            nbams = int(fh.read().strip())

        for ishard in range(nbams):
            shard = shardstr(ishard)

            ## C.1. Mark adapters
            jobid_markadapt = f"markadapt_{group}_{ind}_{shard}"
            gwf.target_from_template(jobid_markadapt,
                                     markadapt(
                                         group          = group,
                                         ind            = ind,
                                         shard          = shard,
                                         species_outdir = outdir(group),
                                         prev_done      = [os.path.join(outdir(group), "done",
                                                                        jobid_splituBAM)],
                                         done           = os.path.join(outdir(group), "done",
                                                                       jobid_markadapt)))

            ## C.2. Map shard
            jobid_mapBAM = f"mapBAM_{group}_{ind}_{shard}"
            gwf.target_from_template(jobid_mapBAM,
                                     mapBAM(
                                         group          = group,
                                         ind            = ind,
                                         shard          = shard,
                                         ref            = ref_path,
                                         species_outdir = outdir(group),
                                         prev_done      = [os.path.join(outdir(group), "done",
                                                                        jobid_markadapt)],
                                         done           = os.path.join(outdir(group), "done",
                                                                       jobid_mapBAM)))

        ## C.3. Merge mapped shard BAMs
        jobid_mergeBAMs = f"mergeBAMs_{group}_{ind}"
        gwf.target_from_template(jobid_mergeBAMs,
                                 mergeBAMs(
                                     group          = group,
                                     ind            = ind,
                                     bams           = [os.path.join(outdir(group), "bam",
                                                        f"split_uBAM{ind}",
                                                        f"shard_{shardstr(ishard)}_markadapt_mapped.bam")
                                                       for ishard in range(nbams)],
                                     species_outdir = outdir(group),
                                     prev_done      = [os.path.join(outdir(group), "done",
                                                        f"mapBAM_{group}_{ind}_{shardstr(ishard)}")
                                                       for ishard in range(nbams)],
                                     done           = os.path.join(outdir(group), "done", jobid_mergeBAMs)))

        ## C.4. Mark and remove duplicates
        jobid_markduplicates = f"markduplicates_{group}_{ind}"
        gwf.target_from_template(jobid_markduplicates,
                                 markduplicates(
                                     group          = group,
                                     ind            = ind,
                                     species_outdir = outdir(group),
                                     prev_done      = [os.path.join(outdir(group), "done", jobid_mergeBAMs)],
                                     done           = os.path.join(outdir(group), "done", jobid_markduplicates)))

        ## C.5. Coordinate sort
        jobid_coordsort = f"coordsort_{group}_{ind}"
        gwf.target_from_template(jobid_coordsort,
                                 coordsort(
                                     group          = group,
                                     ind            = ind,
                                     species_outdir = outdir(group),
                                     prev_done      = [os.path.join(outdir(group), "done", jobid_markduplicates)],
                                     done           = os.path.join(outdir(group), "done", jobid_coordsort)))

        ## C.6. Coverage statistics
        ##      Reads regions_<ref_folder>.txt produced by A.5.
        regions_file = os.path.join(ref_dir, "ref", f"regions_{ref_folder}.txt")
        if os.path.isfile(regions_file):
            regions      = pd.read_table(regions_file)
            regions_list = list(regions.region)
            chrom_list   = list(regions.chrom)
            start_list   = [jj + 1 for jj in list(regions.start)]
            end_list     = list(regions.end)

            jobid_cov = f"cov_{group}_{ind}"
            gwf.target_from_template(jobid_cov,
                                     cov(
                                         group          = group,
                                         ind            = ind,
                                         regions        = regions_list,
                                         chromosomes    = chrom_list,
                                         starts         = start_list,
                                         ends           = end_list,
                                         species_outdir = outdir(group),
                                         prev_done      = [os.path.join(outdir(group), "done", jobid_coordsort)],
                                         done           = os.path.join(outdir(group), "done", jobid_cov)))

        ## C.7. Alternative batched coverage (uncomment if C.6 times out for large references)
        # no_regions_per_batch = 10000
        # cov_done_files = []
        # for b in range(len(regions_list) // no_regions_per_batch):
        #     jobid_cov_batched = f"cov_{group}_{ind}_batch_{b}"
        #     cov_done_files.append(os.path.join(outdir(group), "done", jobid_cov_batched))
        #     gwf.target_from_template(jobid_cov_batched,
        #                              cov_batched(
        #                                  group          = group,
        #                                  ind            = ind,
        #                                  batch          = b,
        #                                  regions        = regions_list[b*no_regions_per_batch:(b+1)*no_regions_per_batch],
        #                                  chromosomes    = chrom_list[b*no_regions_per_batch:(b+1)*no_regions_per_batch],
        #                                  starts         = start_list[b*no_regions_per_batch:(b+1)*no_regions_per_batch],
        #                                  ends           = end_list[b*no_regions_per_batch:(b+1)*no_regions_per_batch],
        #                                  species_outdir = outdir(group),
        #                                  prev_done      = [os.path.join(outdir(group), "done", jobid_coordsort)],
        #                                  done           = os.path.join(outdir(group), "done", jobid_cov_batched)))
        # b = b + 1
        # ...  (add last partial batch following the same pattern)


"""
------------------------------------------------------------------------------------------------------------------------
D. PSMC INFERENCE
------------------------------------------------------------------------------------------------------------------------
PSMC is run per individual using the coordinate-sorted, duplicate-marked BAM.
Prerequisites per individual: cov done file, coordsort done file.
The intersect_35_90.bed accessibility mask must be present at:
  <outputs>/<REFERENCE_FOLDER>/ref/intersect_35_90.bed

Coverage is read from <outputs>/<FOLDER>/cov/<IND_ID>.cov (column 7, 0-indexed col 6).
Individuals are sourced from samples_coverage_stats.txt in the reference ref/ folder;
this file must have at minimum an IND_ID column listing the individuals to run PSMC on.
"""

for i in range(species_and_refs.shape[0]):
    group      = species_and_refs.FOLDER[i]
    ref_folder = species_and_refs.REFERENCE_FOLDER[i]
    ref_dir    = outdir(ref_folder)

    ## Discover the filtered reference at runtime
    ref_fasta_candidates = ([f for f in os.listdir(os.path.join(ref_dir, "ref"))
                              if f.endswith("_LargerThan1000bp.fasta")]
                             if os.path.isdir(os.path.join(ref_dir, "ref")) else [])
    ref_path = (os.path.join(ref_dir, "ref", ref_fasta_candidates[0])
                if ref_fasta_candidates
                else os.path.join(ref_dir, "ref", "REFERENCE_NOT_YET_BUILT.fasta"))

    ## samples_coverage_stats.txt gates which individuals are ready for PSMC.
    ## Required column: IND_ID.
    cov_stats_file = os.path.join(ref_dir, "ref", "samples_coverage_stats.txt")
    if not os.path.isfile(cov_stats_file):
        continue

    inds_to_include = list(data.loc[data.FOLDER == group]["IND_ID"].drop_duplicates())
    inds_df         = pd.read_table(cov_stats_file)
    inds_df         = inds_df[inds_df.IND_ID.isin(inds_to_include)]
    inds            = list(inds_df.IND_ID)

    psmc_outdir = os.path.join(outdir(group), "psmc")
    subprocess.run(["mkdir", "-p", psmc_outdir])

    for ind in inds:
        ## Skip if coverage file is not yet available
        cov_file = os.path.join(outdir(group), "cov", f"{ind}.cov")
        if not os.path.isfile(cov_file):
            continue

        ## Read mean depth across all regions (column 7, 0-indexed col 6)
        cc       = pd.read_table(cov_file, header=None)
        mean_cov = str(cc.iloc[:, 6].mean())

        ## Also require both coordsort and cov done files before submitting
        jobid_coordsort = f"coordsort_{group}_{ind}"
        jobid_cov       = f"cov_{group}_{ind}"
        if not (os.path.isfile(os.path.join(outdir(group), "done", jobid_coordsort)) and
                os.path.isfile(os.path.join(outdir(group), "done", jobid_cov))):
            continue

        ## D.1. Consensus sequence (samtools mpileup → bcftools call → vcfutils.pl vcf2fq)
        consseq_out   = os.path.join(psmc_outdir, f"{ind}_diploid.fq.gz")
        jobid_consSeq = f"consSeq_{group}_{ind}"
        gwf.target_from_template(jobid_consSeq,
                                 get_consSeq(
                                     ref  = ref_path,
                                     bam  = os.path.join(outdir(group), "bam",
                                             f"{ind}_markadapt_mapped_merged_markduplicates_coordsort.bam"),
                                     bed  = os.path.join(ref_dir, "ref", "intersect_35_90.bed"),
                                     cov  = mean_cov,
                                     out  = consseq_out,
                                     done = os.path.join(outdir(group), "done", jobid_consSeq)))

        ## D.2. Make PSMC input (psmcfa)
        psmcfa_out       = os.path.join(psmc_outdir, f"{ind}_diploid.psmcfa")
        jobid_make_input = f"makePSMCInput_{group}_{ind}"
        gwf.target_from_template(jobid_make_input,
                                 make_psmc_input(
                                     inp  = consseq_out,
                                     out  = psmcfa_out,
                                     done = os.path.join(outdir(group), "done", jobid_make_input)))

        ## D.3. Run PSMC with four atomic-interval configurations
        psmc_configs = {
            "10x1p15x2":                "10*1+15*2",
            "6x1p24x2p1x4p1x6":         "6*1+24*2+1*4+1*6",
            "1x20p20x2p1x20":           "1*20+20*2+1*20",
            "1x4p251x1p1x4p1x6p1x10":   "1*4+251*1+1*4+1*6+1*10",
        }
        for config_label, p_string in psmc_configs.items():
            psmc_out       = os.path.join(psmc_outdir, f"{ind}_diploid_{config_label}.psmc")
            jobid_run_psmc = f"runPSMC_{group}_{ind}_{config_label}"
            gwf.target_from_template(jobid_run_psmc,
                                     run_psmc(
                                         inp  = psmcfa_out,
                                         out  = psmc_out,
                                         p    = p_string,
                                         done = os.path.join(outdir(group), "done", jobid_run_psmc)))
