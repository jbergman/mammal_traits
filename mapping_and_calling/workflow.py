"""
------------------------------------------------------------------------------------------------------------------------
This workflow handles raw files (reference genomes, paired-end fastqs), maps reads, calls and genotypes variants.
------------------------------------------------------------------------------------------------------------------------

DIRECTORY LAYOUT (all paths are derived from this file's location at runtime):
  <project_root>/
  ├── mapping_and_calling/          ← this file lives here
  │   ├── workflow.py
  │   ├── templates.py
  │   └── additional_scripts/
  ├── metadata/                     ← supp_table_1.txt goes here
  └── outputs/                      ← all job outputs, organised per species / reference
      ├── <FOLDER>/                 ← species-level folder  (e.g. Acinonyx_jubatus)
      │   ├── done/
      │   ├── fastq/
      │   ├── bam/
      │   ├── gVCF/
      │   ├── GenomicsDB/
      │   ├── cov/
      │   └── psmc/
      └── <REFERENCE_FOLDER>/       ← reference-level folder (e.g. GCA_002007445.2)
          ├── done/
          └── ref/

------------------------------------------------------------------------------------------------------------------------
"""

import os
import subprocess
import numpy as np
import pandas as pd
from gwf import Workflow, AnonymousTarget
from templates import *

gwf = Workflow()

## -----------------------------------------------------------------------------------------------------------------------
## PATH CONFIGURATION  (derived from this file's location – never hard-code absolute paths below)
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
species_and_refs = pd.DataFrame({
    "FOLDER":           data.FOLDER,
    "REFERENCE_FOLDER": data.REFERENCE_FOLDER,
    "GVCF_FOLDER":      [data.GENUS.iloc[jj] + "_" + data.SPECIES.iloc[jj]
                         for jj in range(data.shape[0])],
}).drop_duplicates().reset_index(drop=True)

species_and_refs = species_and_refs.merge(references, how="left")


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

    ## A.4. Build BWA / faidx / sequence-dictionary indices
    jobid_make_fasta = "make_fasta_" + references.ref_genome_name[i].replace("-", "_")
    gwf.target_from_template(jobid_make_fasta,
                             make_fasta(
                                 input     = os.path.join(ref_out, "ref", ref_fname),
                                 # input   = os.path.join(ref_out, "ref", ref_fname[:-4] + "_masked.fna"),    # if masked
                                 done_prev = os.path.join(ref_out, "done", jobid_cut_contigs),
                                 done      = os.path.join(ref_out, "done", jobid_make_fasta)))

    ## A.5. Make initial regions file
    ##      → produces regions_<ref_folder>.txt; manually edit and save as
    ##        regions_<ref_folder>_updated.txt before D. runs.
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
    for subdir in ["done", "fastq", "bam", "gVCF"]:
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
                                         group        = group,
                                         ind          = ind,
                                         fastqs_1     = [os.path.join(outdir(group), "fastq",
                                                          data_subset.loc[data_subset.R1_or_R2 == "R1"].fastq_ftp.iloc[jj].split("/")[-1])
                                                         for jj in range(data_subset.loc[data_subset.R1_or_R2 == "R1"].shape[0])],
                                         fastqs_2     = [os.path.join(outdir(group), "fastq",
                                                          data_subset.loc[data_subset.R1_or_R2 == "R2"].fastq_ftp.iloc[jj].split("/")[-1])
                                                         for jj in range(data_subset.loc[data_subset.R1_or_R2 == "R2"].shape[0])],
                                         species_outdir = outdir(group),
                                         prev_done    = os.path.join(outdir(group), "done", jobid_download_per_individual),
                                         done         = os.path.join(outdir(group), "done", jobid_concat_or_rename_fastqs)))
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
                                         prev_done      = os.path.join(outdir(group), "done", jobid_download_per_individual),
                                         done           = os.path.join(outdir(group), "done", jobid_concat_or_rename_fastqs)))

        ## B.3. Make uBAM
        jobid_makeuBAM = f"makeuBAM_{group}_{ind}"
        gwf.target_from_template(jobid_makeuBAM,
                                 makeuBAM(
                                     group          = group,
                                     ind            = ind,
                                     fastq1         = os.path.join(outdir(group), "fastq", f"{ind}_R1.fastq.gz"),
                                     fastq2         = os.path.join(outdir(group), "fastq", f"{ind}_R2.fastq.gz"),
                                     species_outdir = outdir(group),
                                     prev_done      = [os.path.join(outdir(group), "done", jobid_concat_or_rename_fastqs)],
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
                                         prev_done      = [os.path.join(outdir(group), "done", jobid_splituBAM)],
                                         done           = os.path.join(outdir(group), "done", jobid_markadapt)))

            ## C.2. Map shard
            jobid_mapBAM = f"mapBAM_{group}_{ind}_{shard}"
            gwf.target_from_template(jobid_mapBAM,
                                     mapBAM(
                                         group          = group,
                                         ind            = ind,
                                         shard          = shard,
                                         ref            = ref_path,
                                         species_outdir = outdir(group),
                                         prev_done      = [os.path.join(outdir(group), "done", jobid_markadapt)],
                                         done           = os.path.join(outdir(group), "done", jobid_mapBAM)))

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
D. CALLING
------------------------------------------------------------------------------------------------------------------------

D.1 (make_simplified_batch_file) reads regions_<ref_folder>_updated.txt which
must be prepared manually (by reviewing and annotating regions_<ref_folder>.txt
produced by A.5) before this block will submit any jobs.
"""

## D.1. Make simplified batch file from the manually-curated updated regions file.
##       One job per reference – depends on A.5 (make_regions).
for ref_folder in ref_folders:
    ref_dir = outdir(ref_folder)

    updated_regions_file = os.path.join(ref_dir, "ref", f"regions_{ref_folder}_updated.txt")
    if not os.path.isfile(updated_regions_file):
        ## File does not exist yet (must be prepared manually after A.5).
        continue

    jobid_make_regions               = f"make_regions_{ref_folder.replace('-', '_')}"
    jobid_make_simplified_batch_file = f"make_simplified_batch_file_{ref_folder}"
    gwf.target_from_template(jobid_make_simplified_batch_file,
                             make_simplified_batch_file(
                                 regions_file = updated_regions_file,
                                 ref_folder   = ref_folder,
                                 ref_outdir   = os.path.join(ref_dir, "ref"),
                                 prev_done    = [os.path.join(ref_dir, "done", jobid_make_regions)],
                                 done         = os.path.join(ref_dir, "done",
                                                             jobid_make_simplified_batch_file)))


## D.2–D.3. Make per-individual batch metadata and call variants.
for i in range(species_and_refs.shape[0]):
    group      = species_and_refs.FOLDER[i]
    ref_folder = species_and_refs.REFERENCE_FOLDER[i]
    ref_dir    = outdir(ref_folder)

    ref_fasta_candidates = ([f for f in os.listdir(os.path.join(ref_dir, "ref"))
                              if f.endswith("_LargerThan1000bp.fasta")]
                             if os.path.isdir(os.path.join(ref_dir, "ref")) else [])
    ref_path = (os.path.join(ref_dir, "ref", ref_fasta_candidates[0])
                if ref_fasta_candidates
                else os.path.join(ref_dir, "ref", "REFERENCE_NOT_YET_BUILT.fasta"))

    inds_to_include = list(data.loc[data.FOLDER == group]["IND_ID"].drop_duplicates())
    cov_stats_file  = os.path.join(ref_dir, "ref", "samples_coverage_stats.txt")

    if not os.path.isfile(cov_stats_file):
        continue

    inds_and_sexes = pd.read_table(cov_stats_file)
    inds_and_sexes = inds_and_sexes[inds_and_sexes.IND_ID.isin(inds_to_include)]
    inds  = list(inds_and_sexes.IND_ID)
    sexes = list(inds_and_sexes.gSEX)

    batches_file = os.path.join(ref_dir, "ref", f"batches_{ref_folder}.txt")
    if not os.path.isfile(batches_file):
        continue

    regions = pd.read_table(batches_file)
    batches = list(regions.batch)

    length_of_chunk                  = 2000000
    jobid_make_simplified_batch_file = f"make_simplified_batch_file_{ref_folder}"

    ## D.2. Make per-individual calling metadata (beds_and_intervals/)
    jobid_make_loc_metadata = f"make_loc_metadata_{group}"
    gwf.target_from_template(jobid_make_loc_metadata,
                             make_batch_metadata(
                                 loc            = length_of_chunk,
                                 group          = group,
                                 regions_file   = os.path.join(ref_dir, "ref",
                                                               f"regions_{ref_folder}_updated.txt"),
                                 inds           = ",".join(inds),
                                 sexes          = ",".join(sexes),
                                 ref_folder     = ref_folder,
                                 species_outdir = outdir(group),
                                 outputs_dir    = OUTPUTS_DIR,
                                 prev_done      = [os.path.join(ref_dir, "done",
                                                               jobid_make_simplified_batch_file)],
                                 done           = os.path.join(outdir(group), "done",
                                                              jobid_make_loc_metadata)))

    ## D.3. Call variants per individual per batch per ploidy
    for j in range(len(inds)):
        jobid_cov = f"cov_{group}_{inds[j]}"
        if not os.path.isfile(os.path.join(outdir(group), "done", jobid_cov)):
            continue

        ploidies_list = (list(regions.male_ploidy)
                         if sexes[j] == "M"
                         else list(regions.female_ploidy))

        for batch in sorted(list(set(regions.batch))):
            iis             = [index for index in range(len(batches)) if batches[index] == batch]
            set_of_ploidies = sorted(list(set([ploidies_list[ii] for ii in iis
                                               if ploidies_list[ii] != 0])))

            for pl in set_of_ploidies:
                jobid_call = f"call_with_bed_{group}_{inds[j]}_batch_{batch}_ploidy_{pl}"
                gwf.target_from_template(jobid_call,
                                         call_batch_with_bed(
                                             group          = group,
                                             ind            = inds[j],
                                             batch          = batch,
                                             bed            = os.path.join(outdir(group), "gVCF",
                                                               "beds_and_intervals",
                                                               f"{inds[j]}_batch_{batch}_ploidy_{pl}.bed"),
                                             intervals      = os.path.join(outdir(group), "gVCF",
                                                               "beds_and_intervals",
                                                               f"{inds[j]}_batch_{batch}_ploidy_{pl}.intervals"),
                                             ref            = ref_path,
                                             ploidy         = pl,
                                             species_outdir = outdir(group),
                                             prev_done      = [os.path.join(outdir(group), "done", jobid_cov),
                                                               os.path.join(outdir(group), "done",
                                                                            jobid_make_loc_metadata)],
                                             done           = os.path.join(outdir(group), "done",
                                                                          jobid_call)))


"""
------------------------------------------------------------------------------------------------------------------------
E. GENOTYPING
------------------------------------------------------------------------------------------------------------------------
"""

## -------- pre-genotyping: make metadata and GenomicsDB folders --------
for gvcf_folder in species_and_refs.GVCF_FOLDER.drop_duplicates():

    for subdir in ["done", "gVCF", "GenomicsDB"]:
        subprocess.run(["mkdir", "-p", os.path.join(outdir(gvcf_folder), subdir)])

    length_of_chunk = 2000000
    groups     = list(species_and_refs.loc[species_and_refs.GVCF_FOLDER == gvcf_folder].FOLDER)
    rr_folders = list(species_and_refs.loc[species_and_refs.GVCF_FOLDER == gvcf_folder].REFERENCE_FOLDER)

    inds    = []
    sexes   = []
    folders = []

    for i in range(len(groups)):
        group      = groups[i]
        ref_folder = rr_folders[i]
        ref_dir    = outdir(ref_folder)

        ref_fasta_candidates = ([f for f in os.listdir(os.path.join(ref_dir, "ref"))
                                  if f.endswith("_LargerThan1000bp.fasta")]
                                 if os.path.isdir(os.path.join(ref_dir, "ref")) else [])
        ref_path = (os.path.join(ref_dir, "ref", ref_fasta_candidates[0])
                    if ref_fasta_candidates
                    else os.path.join(ref_dir, "ref", "REFERENCE_NOT_YET_BUILT.fasta"))

        inds_to_include = list(data.loc[data.FOLDER == group]["IND_ID"].drop_duplicates())
        cov_stats_file  = os.path.join(ref_dir, "ref", "samples_coverage_stats.txt")

        if not os.path.isfile(cov_stats_file):
            continue

        inds_and_sexes = pd.read_table(cov_stats_file)
        inds_and_sexes = inds_and_sexes[inds_and_sexes.IND_ID.isin(inds_to_include)]
        group_inds  = list(inds_and_sexes.IND_ID)
        group_sexes = list(inds_and_sexes.gSEX)

        batches_file = os.path.join(ref_dir, "ref", f"batches_{ref_folder}.txt")
        if not os.path.isfile(batches_file):
            continue

        regions = pd.read_table(batches_file)
        batches = list(regions.batch)

        for j in range(len(group_inds)):
            inds.append(group_inds[j])
            sexes.append(group_sexes[j])
            folders.append(group)

    if not inds:
        continue

    ## E.1. Make genotyping metadata (geno_beds_and_intervals/)
    jobid_make_simplified_batch_file = f"make_simplified_batch_file_{ref_folder}"
    jobid_make_geno_metadata         = f"make_geno_metadata_{gvcf_folder}"
    gwf.target_from_template(jobid_make_geno_metadata,
                             make_geno_metadata(
                                 loc          = length_of_chunk,
                                 group        = gvcf_folder,
                                 regions_file = os.path.join(outdir(ref_folder), "ref",
                                                             f"regions_{ref_folder}_updated.txt"),
                                 inds         = ",".join(inds),
                                 sexes        = ",".join(sexes),
                                 ref_folder   = ref_folder,
                                 gvcf_outdir  = outdir(gvcf_folder),
                                 outputs_dir  = OUTPUTS_DIR,
                                 prev_done    = [os.path.join(outdir(ref_folder), "done",
                                                             jobid_make_simplified_batch_file)],
                                 done         = os.path.join(outdir(gvcf_folder), "done",
                                                            jobid_make_geno_metadata)))

    ## E.2. Make GenomicsDB folder + cohort.sample_map per batch × ploidy pair
    for batch in sorted(list(set(regions.batch))):
        iis = [index for index in range(len(batches)) if batches[index] == batch]
        set_of_ploidy_pairs = pd.DataFrame({
            "female_ploidies": [list(regions.female_ploidy)[ii] for ii in iis],
            "male_ploidies":   [list(regions.male_ploidy)[ii]   for ii in iis],
        }).drop_duplicates()

        if "M" not in sexes:
            set_of_ploidy_pairs.drop(
                set_of_ploidy_pairs[set_of_ploidy_pairs["female_ploidies"] == 0].index,
                inplace=True)

        female_ploidies = list(set_of_ploidy_pairs.female_ploidies)
        male_ploidies   = list(set_of_ploidy_pairs.male_ploidies)

        for j in range(set_of_ploidy_pairs.shape[0]):
            fp = female_ploidies[j]
            mp = male_ploidies[j]

            if fp == mp:
                jobid_make_genDB_folder_and_map = (f"make_genDB_folder_and_map_{gvcf_folder}"
                                                   f"_batch_{batch}_fploidy_{fp}_mploidy_{fp}")
                gwf.target_from_template(jobid_make_genDB_folder_and_map,
                                         make_genDB_folder_and_map(
                                             group       = ",".join(folders),
                                             batch       = batch,
                                             inds        = ",".join(inds),
                                             ploidies    = ",".join(len(inds) * [str(fp)]),
                                             folder_name = os.path.join(outdir(gvcf_folder),
                                                            "GenomicsDB",
                                                            f"batch_{batch}_fploidy_{fp}_mploidy_{mp}") + "/",
                                             outputs_dir = OUTPUTS_DIR,
                                             prev_done   = ([os.path.join(outdir(folders[jj]), "done",
                                                              f"call_with_bed_{folders[jj]}_{inds[jj]}"
                                                              f"_batch_{batch}_ploidy_{fp}")
                                                             for jj in range(len(inds))] +
                                                            [os.path.join(outdir(gvcf_folder), "done",
                                                                          jobid_make_geno_metadata)]),
                                             done        = os.path.join(outdir(gvcf_folder), "done",
                                                                        jobid_make_genDB_folder_and_map)))

            elif fp == 2 and mp == 1:
                jobid_make_genDB_folder_and_map = (f"make_genDB_folder_and_map_{gvcf_folder}"
                                                   f"_batch_{batch}_fploidy_2_mploidy_1")
                gwf.target_from_template(jobid_make_genDB_folder_and_map,
                                         make_genDB_folder_and_map(
                                             group       = ",".join(folders),
                                             batch       = batch,
                                             inds        = ",".join(inds),
                                             ploidies    = ",".join(["2" if sexes[jj] == "F" else "1"
                                                                     for jj in range(len(sexes))]),
                                             folder_name = os.path.join(outdir(gvcf_folder),
                                                            "GenomicsDB",
                                                            f"batch_{batch}_fploidy_{fp}_mploidy_{mp}") + "/",
                                             outputs_dir = OUTPUTS_DIR,
                                             prev_done   = ([os.path.join(outdir(folders[jj]), "done",
                                                              f"call_with_bed_{folders[jj]}_{inds[jj]}"
                                                              f"_batch_{batch}_ploidy_"
                                                              + ("2" if sexes[jj] == "F" else "1"))
                                                             for jj in range(len(inds))] +
                                                            [os.path.join(outdir(gvcf_folder), "done",
                                                                          jobid_make_geno_metadata)]),
                                             done        = os.path.join(outdir(gvcf_folder), "done",
                                                                        jobid_make_genDB_folder_and_map)))

            elif fp == 1 and mp == 2:
                jobid_make_genDB_folder_and_map = (f"make_genDB_folder_and_map_{gvcf_folder}"
                                                   f"_batch_{batch}_fploidy_1_mploidy_2")
                gwf.target_from_template(jobid_make_genDB_folder_and_map,
                                         make_genDB_folder_and_map(
                                             group       = ",".join(folders),
                                             batch       = batch,
                                             inds        = ",".join(inds),
                                             ploidies    = ",".join(["1" if sexes[jj] == "F" else "2"
                                                                     for jj in range(len(sexes))]),
                                             folder_name = os.path.join(outdir(gvcf_folder),
                                                            "GenomicsDB",
                                                            f"batch_{batch}_fploidy_{fp}_mploidy_{mp}") + "/",
                                             outputs_dir = OUTPUTS_DIR,
                                             prev_done   = ([os.path.join(outdir(folders[jj]), "done",
                                                              f"call_with_bed_{folders[jj]}_{inds[jj]}"
                                                              f"_batch_{batch}_ploidy_"
                                                              + ("1" if sexes[jj] == "F" else "2"))
                                                             for jj in range(len(inds))] +
                                                            [os.path.join(outdir(gvcf_folder), "done",
                                                                          jobid_make_geno_metadata)]),
                                             done        = os.path.join(outdir(gvcf_folder), "done",
                                                                        jobid_make_genDB_folder_and_map)))

            elif fp == 0 and mp == 1:
                jobid_make_genDB_folder_and_map = (f"make_genDB_folder_and_map_{gvcf_folder}"
                                                   f"_batch_{batch}_fploidy_0_mploidy_1")
                gwf.target_from_template(jobid_make_genDB_folder_and_map,
                                         make_genDB_folder_and_map(
                                             group       = ",".join([folders[jj] for jj in range(len(folders))
                                                                     if sexes[jj] == "M"]),
                                             batch       = batch,
                                             inds        = ",".join([inds[jj] for jj in range(len(inds))
                                                                     if sexes[jj] == "M"]),
                                             ploidies    = ",".join(sexes.count("M") * ["1"]),
                                             folder_name = os.path.join(outdir(gvcf_folder),
                                                            "GenomicsDB",
                                                            f"batch_{batch}_fploidy_0_mploidy_1") + "/",
                                             outputs_dir = OUTPUTS_DIR,
                                             prev_done   = ([os.path.join(outdir(folders[jj]), "done",
                                                              f"call_with_bed_{folders[jj]}_{inds[jj]}"
                                                              f"_batch_{batch}_ploidy_1")
                                                             for jj in range(len(inds))
                                                             if sexes[jj] == "M"] +
                                                            [os.path.join(outdir(gvcf_folder), "done",
                                                                          jobid_make_geno_metadata)]),
                                             done        = os.path.join(outdir(gvcf_folder), "done",
                                                                        jobid_make_genDB_folder_and_map)))


## -------- genotyping at species level --------
for gvcf_folder in species_and_refs.GVCF_FOLDER.drop_duplicates():

    for subdir in ["done", "gVCF", "GenomicsDB"]:
        subprocess.run(["mkdir", "-p", os.path.join(outdir(gvcf_folder), subdir)])

    length_of_chunk = 2000000
    groups     = list(species_and_refs.loc[species_and_refs.GVCF_FOLDER == gvcf_folder].FOLDER)
    rr_folders = list(species_and_refs.loc[species_and_refs.GVCF_FOLDER == gvcf_folder].REFERENCE_FOLDER)

    inds    = []
    sexes   = []
    folders = []

    for i in range(len(groups)):
        group      = groups[i]
        ref_folder = rr_folders[i]
        ref_dir    = outdir(ref_folder)

        ref_fasta_candidates = ([f for f in os.listdir(os.path.join(ref_dir, "ref"))
                                  if f.endswith("_LargerThan1000bp.fasta")]
                                 if os.path.isdir(os.path.join(ref_dir, "ref")) else [])
        ref_path = (os.path.join(ref_dir, "ref", ref_fasta_candidates[0])
                    if ref_fasta_candidates
                    else os.path.join(ref_dir, "ref", "REFERENCE_NOT_YET_BUILT.fasta"))

        inds_to_include = list(data.loc[data.FOLDER == group]["IND_ID"].drop_duplicates())
        cov_stats_file  = os.path.join(ref_dir, "ref", "samples_coverage_stats.txt")

        if not os.path.isfile(cov_stats_file):
            continue

        inds_and_sexes = pd.read_table(cov_stats_file)
        inds_and_sexes = inds_and_sexes[inds_and_sexes.IND_ID.isin(inds_to_include)]
        group_inds  = list(inds_and_sexes.IND_ID)
        group_sexes = list(inds_and_sexes.gSEX)

        batches_file = os.path.join(ref_dir, "ref", f"batches_{ref_folder}.txt")
        if not os.path.isfile(batches_file):
            continue

        regions = pd.read_table(batches_file)
        batches = list(regions.batch)

        for j in range(len(group_inds)):
            inds.append(group_inds[j])
            sexes.append(group_sexes[j])
            folders.append(group)

    if not inds:
        continue

    ## E.3–E.6. Build GenomicsDB, genotype, concatenate/rename, index
    for batch in sorted(list(set(regions.batch))):
        iis = [index for index in range(len(batches)) if batches[index] == batch]
        set_of_ploidy_pairs = pd.DataFrame({
            "female_ploidies": [list(regions.female_ploidy)[ii] for ii in iis],
            "male_ploidies":   [list(regions.male_ploidy)[ii]   for ii in iis],
        }).drop_duplicates()

        if "M" not in sexes:
            set_of_ploidy_pairs.drop(
                set_of_ploidy_pairs[set_of_ploidy_pairs["female_ploidies"] == 0].index,
                inplace=True)

        female_ploidies = list(set_of_ploidy_pairs.female_ploidies)
        male_ploidies   = list(set_of_ploidy_pairs.male_ploidies)

        for j in range(set_of_ploidy_pairs.shape[0]):
            fp = female_ploidies[j]
            mp = male_ploidies[j]

            ## Resolve the pre-genotyping jobid for this ploidy pair
            if fp == mp:
                jobid_make_genDB_folder_and_map = (f"make_genDB_folder_and_map_{gvcf_folder}"
                                                   f"_batch_{batch}_fploidy_{fp}_mploidy_{fp}")
            elif fp == 2 and mp == 1:
                jobid_make_genDB_folder_and_map = (f"make_genDB_folder_and_map_{gvcf_folder}"
                                                   f"_batch_{batch}_fploidy_2_mploidy_1")
            elif fp == 1 and mp == 2:
                jobid_make_genDB_folder_and_map = (f"make_genDB_folder_and_map_{gvcf_folder}"
                                                   f"_batch_{batch}_fploidy_1_mploidy_2")
            elif fp == 0 and mp == 1:
                jobid_make_genDB_folder_and_map = (f"make_genDB_folder_and_map_{gvcf_folder}"
                                                   f"_batch_{batch}_fploidy_0_mploidy_1")

            prev_done_files      = [os.path.join(outdir(gvcf_folder), "done",
                                                  f"make_geno_metadata_{gvcf_folder}")]
            files_to_concatenate = []

            ## E.3.1 / E.4.1.  Long-contig subbatch genotyping
            subbatch_intervals = os.path.join(
                outdir(gvcf_folder), "gVCF", "geno_beds_and_intervals",
                f"{gvcf_folder}_batch_{batch}_fploidy_{fp}_mploidy_{mp}"
                f"_loc_{length_of_chunk}_subbatches.intervals")

            if os.path.isfile(subbatch_intervals):
                subbatch_file = pd.read_table(subbatch_intervals, header=None)
                for sb in range(subbatch_file.shape[0]):
                    jobid_make_genDB = (f"make_genDB_{gvcf_folder}_batch_{batch}"
                                        f"_fploidy_{fp}_mploidy_{mp}"
                                        f"_loc_{length_of_chunk}_subbatch_{sb}")
                    gwf.target_from_template(jobid_make_genDB,
                                             make_genDB_subbatch_with_bed(
                                                 group     = gvcf_folder,
                                                 batch     = batch,
                                                 fploidy   = fp,
                                                 mploidy   = mp,
                                                 subbatch  = str(sb),
                                                 interval  = subbatch_file.iloc[sb, 0],
                                                 gvcf_outdir = outdir(gvcf_folder),
                                                 prev_done = os.path.join(outdir(gvcf_folder), "done",
                                                                          jobid_make_genDB_folder_and_map),
                                                 done      = os.path.join(outdir(gvcf_folder), "done",
                                                                          jobid_make_genDB)))

                    jobid_GenotypeGVCFs = (f"GenotypeGVCFs_{gvcf_folder}_batch_{batch}"
                                           f"_fploidy_{fp}_mploidy_{mp}"
                                           f"_loc_{length_of_chunk}_subbatch_{sb}")
                    prev_done_files.append(os.path.join(outdir(gvcf_folder), "done",
                                                         jobid_GenotypeGVCFs))
                    files_to_concatenate.append(os.path.join(
                        outdir(gvcf_folder), "gVCF",
                        f"{gvcf_folder}_batch_{batch}_fploidy_{fp}_mploidy_{mp}"
                        f"_subbatch_{sb}_gt.gvcf.gz"))
                    gwf.target_from_template(jobid_GenotypeGVCFs,
                                             GenotypeGVCFs_subbatch_with_bed_new(
                                                 group       = gvcf_folder,
                                                 batch       = batch,
                                                 fploidy     = fp,
                                                 mploidy     = mp,
                                                 subbatch    = str(sb),
                                                 interval    = subbatch_file.iloc[sb, 0],
                                                 out         = os.path.join(
                                                     outdir(gvcf_folder), "gVCF",
                                                     f"{gvcf_folder}_batch_{batch}_fploidy_{fp}"
                                                     f"_mploidy_{mp}_subbatch_{sb}_gt.gvcf.gz"),
                                                 ref         = ref_path,
                                                 cores       = 1,
                                                 memory      = "32g",
                                                 gvcf_outdir = outdir(gvcf_folder),
                                                 prev_done   = os.path.join(outdir(gvcf_folder), "done",
                                                                            jobid_make_genDB),
                                                 done        = os.path.join(outdir(gvcf_folder), "done",
                                                                            jobid_GenotypeGVCFs)))

            ## E.3.2 / E.4.2.  Short-segment genotyping
            short_seg_intervals = os.path.join(
                outdir(gvcf_folder), "gVCF", "geno_beds_and_intervals",
                f"{gvcf_folder}_batch_{batch}_fploidy_{fp}_mploidy_{mp}"
                f"_loc_{length_of_chunk}_short_segments.intervals")

            if os.path.isfile(short_seg_intervals):
                short_segments_limit = 1000
                short_segments_count = sum(1 for _ in open(short_seg_intervals)) - 1

                if short_segments_count > short_segments_limit:
                    to_s = [min(start + short_segments_limit - 1, short_segments_count)
                            for start in range(1, short_segments_count + 1, short_segments_limit)]
                    for sb in range(short_segments_count // short_segments_limit + 1):
                        jobid_make_genDB = (f"make_genDB_{gvcf_folder}_batch_{batch}"
                                            f"_fploidy_{fp}_mploidy_{mp}"
                                            f"_loc_{length_of_chunk}_short_segments_subbatch_{sb}")
                        gwf.target_from_template(jobid_make_genDB,
                                                 make_genDB_short_segments_subbatch(
                                                     group       = gvcf_folder,
                                                     batch       = batch,
                                                     fploidy     = fp,
                                                     mploidy     = mp,
                                                     subbatch    = str(sb),
                                                     intervals   = short_seg_intervals,
                                                     fr          = sb * short_segments_limit + 1,
                                                     to          = to_s[sb],
                                                     gvcf_outdir = outdir(gvcf_folder),
                                                     prev_done   = os.path.join(outdir(gvcf_folder), "done",
                                                                                jobid_make_genDB_folder_and_map),
                                                     done        = os.path.join(outdir(gvcf_folder), "done",
                                                                                jobid_make_genDB)))

                        jobid_GenotypeGVCFs = (f"GenotypeGVCFs_{gvcf_folder}_batch_{batch}"
                                               f"_fploidy_{fp}_mploidy_{mp}"
                                               f"_short_segments_subbatch_{sb}")
                        prev_done_files.append(os.path.join(outdir(gvcf_folder), "done",
                                                             jobid_GenotypeGVCFs))
                        files_to_concatenate.append(os.path.join(
                            outdir(gvcf_folder), "gVCF",
                            f"{gvcf_folder}_batch_{batch}_fploidy_{fp}_mploidy_{mp}"
                            f"_short_segments_subbatch_{sb}_gt.gvcf.gz"))
                        gwf.target_from_template(jobid_GenotypeGVCFs,
                                                 GenotypeGVCFs_short_segments_subbatch(
                                                     group       = gvcf_folder,
                                                     batch       = batch,
                                                     fploidy     = fp,
                                                     mploidy     = mp,
                                                     subbatch    = str(sb),
                                                     intervals   = short_seg_intervals,
                                                     fr          = sb * short_segments_limit + 1,
                                                     to          = to_s[sb],
                                                     out         = os.path.join(
                                                         outdir(gvcf_folder), "gVCF",
                                                         f"{gvcf_folder}_batch_{batch}_fploidy_{fp}"
                                                         f"_mploidy_{mp}_short_segments_subbatch_{sb}_gt.gvcf.gz"),
                                                     ref         = ref_path,
                                                     cores       = 1,
                                                     memory      = "32g",
                                                     gvcf_outdir = outdir(gvcf_folder),
                                                     prev_done   = os.path.join(outdir(gvcf_folder), "done",
                                                                                jobid_make_genDB),
                                                     done        = os.path.join(outdir(gvcf_folder), "done",
                                                                                jobid_GenotypeGVCFs)))
                else:
                    jobid_make_genDB = (f"make_genDB_{gvcf_folder}_batch_{batch}"
                                        f"_fploidy_{fp}_mploidy_{mp}"
                                        f"_loc_{length_of_chunk}_short_segments")
                    gwf.target_from_template(jobid_make_genDB,
                                             make_genDB_with_bed(
                                                 group       = gvcf_folder,
                                                 batch       = batch,
                                                 fploidy     = fp,
                                                 mploidy     = mp,
                                                 intervals   = short_seg_intervals,
                                                 gvcf_outdir = outdir(gvcf_folder),
                                                 prev_done   = os.path.join(outdir(gvcf_folder), "done",
                                                                            jobid_make_genDB_folder_and_map),
                                                 done        = os.path.join(outdir(gvcf_folder), "done",
                                                                            jobid_make_genDB)))

                    jobid_GenotypeGVCFs = (f"GenotypeGVCFs_{gvcf_folder}_batch_{batch}"
                                           f"_fploidy_{fp}_mploidy_{mp}_short_segments")
                    prev_done_files.append(os.path.join(outdir(gvcf_folder), "done",
                                                         jobid_GenotypeGVCFs))
                    files_to_concatenate.append(os.path.join(
                        outdir(gvcf_folder), "gVCF",
                        f"{gvcf_folder}_batch_{batch}_fploidy_{fp}_mploidy_{mp}"
                        f"_short_segments_gt.gvcf.gz"))
                    gwf.target_from_template(jobid_GenotypeGVCFs,
                                             GenotypeGVCFs_with_bed(
                                                 group       = gvcf_folder,
                                                 batch       = batch,
                                                 fploidy     = fp,
                                                 mploidy     = mp,
                                                 intervals   = short_seg_intervals,
                                                 out         = os.path.join(
                                                     outdir(gvcf_folder), "gVCF",
                                                     f"{gvcf_folder}_batch_{batch}_fploidy_{fp}"
                                                     f"_mploidy_{mp}_short_segments_gt.gvcf.gz"),
                                                 ref         = ref_path,
                                                 cores       = 1,
                                                 memory      = "32g",
                                                 gvcf_outdir = outdir(gvcf_folder),
                                                 prev_done   = os.path.join(outdir(gvcf_folder), "done",
                                                                            jobid_make_genDB),
                                                 done        = os.path.join(outdir(gvcf_folder), "done",
                                                                            jobid_GenotypeGVCFs)))

            ## E.5. Concatenate or rename per-chunk GVCFs, then index
            if len(files_to_concatenate) > 1:
                ## E.5.1. Concatenate
                jobid_picardconcat = (f"picardconcat_{gvcf_folder}_batch_{batch}"
                                      f"_fploidy_{fp}_mploidy_{mp}")
                gwf.target_from_template(jobid_picardconcat,
                                         picardconcat(
                                             vcfs      = files_to_concatenate,
                                             vcf       = os.path.join(outdir(gvcf_folder), "gVCF",
                                                          f"{gvcf_folder}_batch_{batch}_fploidy_{fp}"
                                                          f"_mploidy_{mp}_gt.gvcf.gz"),
                                             prev_done = prev_done_files,
                                             done      = os.path.join(outdir(gvcf_folder), "done",
                                                                      jobid_picardconcat)))

                ## E.6. Index
                jobid_index = (f"IndexGVCFs_{gvcf_folder}_batch_{batch}"
                               f"_fploidy_{fp}_mploidy_{mp}")
                gwf.target_from_template(jobid_index,
                                         IndexGVCFs(
                                             group       = gvcf_folder,
                                             batch       = batch,
                                             fploidy     = fp,
                                             mploidy     = mp,
                                             gvcf_outdir = outdir(gvcf_folder),
                                             prev_done   = os.path.join(outdir(gvcf_folder), "done",
                                                                        jobid_picardconcat),
                                             done        = os.path.join(outdir(gvcf_folder), "done",
                                                                        jobid_index)))

            elif len(files_to_concatenate) == 1:
                ## E.5.2. Rename
                jobid_renameGVCF = (f"renameGVCF_{gvcf_folder}_batch_{batch}"
                                    f"_fploidy_{fp}_mploidy_{mp}")
                gwf.target_from_template(jobid_renameGVCF,
                                         renameGVCF(
                                             vcf_in    = files_to_concatenate[0],
                                             vcf_out   = os.path.join(outdir(gvcf_folder), "gVCF",
                                                          f"{gvcf_folder}_batch_{batch}_fploidy_{fp}"
                                                          f"_mploidy_{mp}_gt.gvcf.gz"),
                                             prev_done = prev_done_files,
                                             done      = os.path.join(outdir(gvcf_folder), "done",
                                                                      jobid_renameGVCF)))

                ## E.6. Index
                jobid_index = (f"IndexGVCFs_{gvcf_folder}_batch_{batch}"
                               f"_fploidy_{fp}_mploidy_{mp}")
                gwf.target_from_template(jobid_index,
                                         IndexGVCFs(
                                             group       = gvcf_folder,
                                             batch       = batch,
                                             fploidy     = fp,
                                             mploidy     = mp,
                                             gvcf_outdir = outdir(gvcf_folder),
                                             prev_done   = os.path.join(outdir(gvcf_folder), "done",
                                                                        jobid_renameGVCF),
                                             done        = os.path.join(outdir(gvcf_folder), "done",
                                                                        jobid_index)))


"""
------------------------------------------------------------------------------------------------------------------------
F. PSMC INFERENCE
------------------------------------------------------------------------------------------------------------------------
"""
## PSMC is run per individual using the coordinate-sorted, duplicate-marked BAM.
## Prerequisites per individual: cov done file, coordsort done file.
## The intersect_35_90.bed accessibility mask must be present at:
##   <outputs>/<REFERENCE_FOLDER>/ref/intersect_35_90.bed

for i in range(species_and_refs.shape[0]):
    group      = species_and_refs.FOLDER[i]
    ref_folder = species_and_refs.REFERENCE_FOLDER[i]
    ref_dir    = outdir(ref_folder)

    ref_fasta_candidates = ([f for f in os.listdir(os.path.join(ref_dir, "ref"))
                              if f.endswith("_LargerThan1000bp.fasta")]
                             if os.path.isdir(os.path.join(ref_dir, "ref")) else [])
    ref_path = (os.path.join(ref_dir, "ref", ref_fasta_candidates[0])
                if ref_fasta_candidates
                else os.path.join(ref_dir, "ref", "REFERENCE_NOT_YET_BUILT.fasta"))

    cov_stats_file = os.path.join(ref_dir, "ref", "samples_coverage_stats.txt")
    if not os.path.isfile(cov_stats_file):
        continue

    inds_to_include = list(data.loc[data.FOLDER == group]["IND_ID"].drop_duplicates())
    inds_and_sexes  = pd.read_table(cov_stats_file)
    inds_and_sexes  = inds_and_sexes[inds_and_sexes.IND_ID.isin(inds_to_include)]
    inds            = list(inds_and_sexes.IND_ID)

    psmc_outdir = os.path.join(outdir(group), "psmc")
    subprocess.run(["mkdir", "-p", psmc_outdir])

    for ind in inds:
        ## Skip if coverage file is not yet available
        cov_file = os.path.join(outdir(group), "cov", f"{ind}.cov")
        if not os.path.isfile(cov_file):
            continue

        cc       = pd.read_table(cov_file, header=None)
        mean_cov = str(cc.iloc[:, 6].mean())   # column 6 = per-region mean depth

        jobid_coordsort = f"coordsort_{group}_{ind}"
        jobid_cov       = f"cov_{group}_{ind}"
        if not (os.path.isfile(os.path.join(outdir(group), "done", jobid_coordsort)) and
                os.path.isfile(os.path.join(outdir(group), "done", jobid_cov))):
            continue

        ## F.1. Consensus sequence
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

        ## F.2. Make PSMC input (psmcfa)
        psmcfa_out       = os.path.join(psmc_outdir, f"{ind}_diploid.psmcfa")
        jobid_make_input = f"makePSMCInput_{group}_{ind}"
        gwf.target_from_template(jobid_make_input,
                                 make_psmc_input(
                                     inp  = consseq_out,
                                     out  = psmcfa_out,
                                     done = os.path.join(outdir(group), "done", jobid_make_input)))

        ## F.3. Run PSMC with four atomic-interval configurations
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
