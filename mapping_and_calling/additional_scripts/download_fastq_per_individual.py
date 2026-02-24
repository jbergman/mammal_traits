import os
import sys
import time

#### load data
group          = sys.argv[1]
ind            = sys.argv[2]
run_accessions = str(sys.argv[3]).split(",")
outputs_dir    = str(sys.argv[4])   # e.g. <project_root>/outputs

#### derive paths
species_dir = os.path.join(outputs_dir, group)
done_dir    = os.path.join(species_dir, "done")
fastq_dir   = os.path.join(species_dir, "fastq")

#### run
attempt = 0
a_files = [f"download_pe2_{group}_" + ra.replace("/", "_") for ra in run_accessions]
a_exist = [f for f in a_files if os.path.isfile(os.path.join(done_dir, f))]

while len(a_files) != len(a_exist):
    os.system(f'echo Attempt: "{attempt}"')

    for i in range(len(run_accessions)):
        run_accession      = run_accessions[i]
        run_accession_name = run_accessions[i].split("/")[-1]
        job_name           = f"download_pe2_{group}_" + run_accessions[i].replace("/", "_")

        if job_name in os.listdir(done_dir):
            os.system(f"""
            echo "{job_name} present in {done_dir}"
            echo "Skipping..."
            """)
        else:
            os.system(f"""
            echo "Starting download: {run_accession_name}"

            rm -fr {fastq_dir}/{run_accession_name}

            wget --progress=dot:giga --timeout=120 --waitretry=60 --tries=10000 --retry-connrefused -P {fastq_dir}/ {run_accession}

            touch {done_dir}/{job_name}

            """)

    a_exist = [f for f in a_files if os.path.isfile(os.path.join(done_dir, f))]
    attempt += 1
    l1 = len(a_files)
    l2 = len(a_exist)
    os.system(f'echo "a_files: {l1}"')
    os.system(f'echo "a_exist: {l2}"')
    if attempt == 100:
        break

if len(a_files) == len(a_exist):
    master_done = os.path.join(done_dir, f"download_per_individual_{group}_{ind}")
    os.system(f"""
              echo "Making master done file: {master_done}"
              touch {master_done}
              """)