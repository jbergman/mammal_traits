import os
import sys
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq

#### load data
ref   = sys.argv[1]   # full path to the downloaded reference fasta
fasta = list(SeqIO.parse(ref, "fasta"))

#### collect contig lengths, sequences, ids and descriptions
lens = []; seqs = []; ids = []; desc = []
for record in fasta:
    lens.append(len(record))
    seqs.append(str(record.seq))
    ids.append(record.id)
    desc.append(record.description)

#### sort by length (ascending)
sortedSeqs = [x for _, x in sorted(zip(lens, seqs))]
sortedIDs  = [x for _, x in sorted(zip(lens, ids))]
sortedDesc = [x for _, x in sorted(zip(lens, desc))]
sortedLens = sorted(lens)

#### find first contig longer than 1000 bp
for i in range(len(sortedLens)):
    if sortedLens[i] > 1000:
        break

#### take only contigs > 1000 bp, reversed (largest first)
truncSeqs = sortedSeqs[i:][::-1]
truncIDs  = sortedIDs[i:][::-1]
truncDesc = sortedDesc[i:][::-1]

#### write filtered fasta and a chrs file (name + length, one per line)
out_fasta = ref.split(".f")[0] + "_LargerThan1000bp.fasta"
out_chrs  = ref.split(".f")[0] + "_LargerThan1000bp.chrs"

newFasta = []
with open(out_chrs, "w") as o:
    for i in range(len(truncSeqs)):
        newFasta.append(SeqRecord(Seq(truncSeqs[i]), id=truncIDs[i], description=truncDesc[i]))
        o.write(truncIDs[i] + "\t" + str(len(truncSeqs[i])) + "\n")

SeqIO.write(newFasta, out_fasta, "fasta")
