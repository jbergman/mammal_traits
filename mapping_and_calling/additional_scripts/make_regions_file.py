import os
import sys
import pandas as pd

#### load data
fastaFolder = sys.argv[1]   # reference folder name (e.g. GCA_002007445.2)
fai_file    = sys.argv[2]   # full path to the .fasta.fai index file
ref_outdir  = sys.argv[3]   # full path to <outputs>/<REFERENCE_FOLDER>/ref/

#### read fai (chrom name + length in first two columns)
chrs = pd.read_table(fai_file, header=None)
chr_name = list(chrs.iloc[:, 0])
chr_len  = list(chrs.iloc[:, 1])

#### group chromosomes into batches of ~30 Mbp each
chr_groups      = []
chr_group_names = []
gn = 0
temp_group = []
temp_len   = 0

for ii in range(len(chr_name)):
    if temp_len > 30_000_000:
        chr_groups.append(temp_group)
        chr_group_names.append(str(gn))
        gn += 1
        temp_group = [chr_name[ii]]
        temp_len   = chr_len[ii]
    else:
        temp_group.append(chr_name[ii])
        temp_len += chr_len[ii]
    if ii == len(chr_name) - 1:
        chr_groups.append(temp_group)
        chr_group_names.append(str(gn))

#### write regions file (ploidy defaults to diploid = 2/2; edit manually for X/Y/mt)
out_path = os.path.join(ref_outdir, f"regions_{fastaFolder}.txt")
with open(out_path, "w") as oo:
    oo.write("region\tchrom\tstart\tend\tbatch\tfemale_ploidy\tmale_ploidy\n")
    for ii in range(len(chr_groups)):
        for jj in chr_groups[ii]:
            oo.write(jj + "\t" + jj + "\t0\t" + str(chr_len[chr_name.index(jj)]) +
                     "\t" + str(ii) + "\t2\t2\n")
