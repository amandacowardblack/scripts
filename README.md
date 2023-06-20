# Scripts
Useful scripts I've written during my dissertation research.

The gene duplication and cancer mutation analyses are connected to an updated version of [this project](https://www.biorxiv.org/content/10.1101/2021.08.09.455723v2), wherein we were characterizing the frequency of oncogene duplication (via R's data frame filtering capabilities) and how often mutations known to cause cancer in humans were found in the reference orthologs of other sequenced organisms (via python scripts).

The dN/dS pipeline was connected to [this project](https://www.biorxiv.org/content/10.1101/2021.08.09.455723), wherein we were testing to see if annual and nonannual lineages of killifish had differences in molecular evolutionary rate. This project processed a reference phylogeny and 1000+ alignments, conducted topology testing between pruned versions of the reference phylogeny and calculated maximum likelihood trees, and then measured the evolutionary rate of the sequences. It is intended to be used in a cluster system that creates a new subprocess to run each test script produced by the pipeline. It utilizes a combination of custom bash scripts, custom python scripts, and existing software.
