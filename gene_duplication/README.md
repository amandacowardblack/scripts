# Characterizing Gene Duplication History

All annotated orthologs of a given gene was downloaded from Ensembl. The dataset was in a CSV that looked like this:

    Species name, Common name,Gene name, Taxon ID, Gene ID, Transcript ID, Protein ID, assembly, protein length, location, strand, start, end

This script was to quickly process how many species had duplications of this gene and provide context of what sort of duplications they might be (tandem/WGD/etc).
The same information listed above was written to file only for each duplicate identified for easier subsequent analysis.
