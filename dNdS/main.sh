#!/bin/bash

## make sure this runs in the directory where all the alignments are stored (either by placing this in there OR by cd within this script)

## this python script creates the file structure, makes subtrees based on the species in the alignments, and gets codeml/iqtree subfolders ready for tests

python structure.py
echo "File structure created."

## this function of code converts the fasta alignments into PHYLIP alignments for codeml. I utilized a custom script written by Dr. Mike Vandewege.
## But many conversion scripts exist.

for file in *.fasta; do echo "${file%.*}"; done > file_name.txt

while IFS= read -r file
do
	echo `python2 /path/to/script/fasta2phylipFullName.py /path/to/alignments/"$file"/iqtree/"$file".short_names.fasta > /path/to/alignments/"$file"/codeml/"$file".short_names.phy`

done < "/path/to/alignments/file_name.txt"
echo "FASTA alignments converted to Phylip."

## this python script runs the iqtree and codeml tests
python tests.py

echo "Analyses completed."
