## read in all the RAFs homologs from file
Vert_RAF <- read.csv(file="Vert_RAFs_Ensembl_103.csv")

## subset each gene member
Vert_ARAF <- subset(Vert_RAF, Gene.name=="ARAF")
Vert_BRAF <- subset(Vert_RAF, Gene.name=="BRAF")
Vert_CRAF <- subset(Vert_RAF, Gene.name=="CRAF")

## see which species have duplicates and how many
araf_ids <- data.frame(table(Vert_ARAF$Species.name))
araf_dups <- araf_ids[araf_ids$Freq>1,]
length(araf_dups$Var1) ## number of species with duplications
sum(araf_dups$Freq) ## total number of duplicated ARAFs

braf_ids <- data.frame(table(Vert_BRAF$Species.name))
braf_dups <- braf_ids[braf_ids$Freq>1,]
length(braf_dups$Var1) ## number of species with duplications
sum(braf_dups$Freq) ## total number of duplicated BRAFs

craf_ids <- data.frame(table(Vert_CRAF$Species.name))
craf_dups <- craf_ids[craf_ids$Freq>1,]
length(craf_dups$Var1) ## number of species with duplications
sum(craf_dups$Freq) ## total number of duplicated CRAFs

## pull out the information just for the duplicates from the gene RAF table and write to file.
Vert_ARAF_dups <- Vert_ARAF[Vert_ARAF$Species.name %in% araf_dups$Var1,]
Vert_BRAF_dups <- Vert_BRAF[Vert_BRAF$Species.name %in% braf_dups$Var1,]
Vert_CRAF_dups <- Vert_CRAF[Vert_CRAF$Species.name %in% craf_dups$Var1,]

write.csv(Vert_ARAF_dups,"Vert_ARAF_dups.csv", row.names=FALSE)
write.csv(Vert_BRAF_dups,"Vert_BRAF_dups.csv", row.names=FALSE)
write.csv(Vert_CRAF_dups,"Vert_CRAF_dups.csv", row.names=FALSE)
