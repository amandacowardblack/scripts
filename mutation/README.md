# Characterizing Frequency of Mutations
The mutation sites were found from [OncoKB](https://www.oncokb.org/). These were saved as ${protein_name}_mutations.txt. OriginalAminoAcid Location MutatedAminoAcid. Example:

    S	257	L
    S	259	F
    S	259	A
    S	427	G
    I	448	V
    K	106	N
    S	257	W

The exact isoform referenced from OncoKb was downloaded and an alignment with it and orthologs from species of interest was created and named ${protein_name}_aligned_oncokb_isoform.fa.

The sequence location was converted to alignment location (which has gaps) and saved as ${protein_name}_alignment_mutations.txt. Location MutatedAminoAcid. Example:

    452 A
    508 H
    559 P

The alignment was then analyzed using [check_mutation_sites.py](https://github.com/amandacowardblack/scripts/blob/main/mutation/check_mutation_sites.py). It outputs a file listing the sequence name which possesses the mutation followed by which mutation it has. Example:

    >Sequence_Name
    523T

This text file was then converted into a .csv for easier analysis in a spreadsheet using [format_output.py](https://github.com/amandacowardblack/scripts/blob/main/mutation/format_output.py). If a sequence possessed multiple mutations, it now only takes up one line. Use: python3 format_output.py ${results_file.txt} ${output_file.csv}. Example:

    >Sequence_Name	1093L	1097S 

At this point, the mutation identities need to be converted back from the alignment position # to the actual sequence position #.
