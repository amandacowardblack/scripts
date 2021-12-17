## We separated the analysis of those alignments where just one annual lineage was present from
## those were multiple lineages were present.
## the lists produced by this script were separately fed into the "main.sh" script.
## The groups were defined by the phylogeny provided with the dataset.

from Bio import SeqIO
import io
import string
def extract_names(alignment):
    # shorten sequence names in a fasta alignment 
    # keeping just the characters up to the delimiter
    # import biopython modules to read and write fasta files
    species = list(SeqIO.parse(alignment, "fasta"))
    species_short = []
    for s in species:
        species_short.append(s.id[0:s.id.find('|')])
    return species_short

def characterize_groups(species, annual):
        groups_present = []
        #check if any member of species is in annual
        print(species)
        
        for group in annual:
                intersection = [value for value in species if value in annual[group]]
                print(intersection)
                if len(intersection) > 0:
                        groups_present.append(group)

        return groups_present

def main():
        single_lineage_alignments = open('single.txt', 'w')
        multi_lineage_alignments = open('multiple.txt', 'w')

        annual = {"Group_1":["Austrofundulus_limnaeus","Pterolebias_longipinnis"],"Group_2":["Papilolebias_ashlyae"],"Group_3":["Laimosemion_tecminae"],"Group_4":["Nematolebias_whitei","Ophthalmolebias_perpendicularis","Leptolebias_aureoguttatus"],"Group_5":["Nothobranchius_foerschi","Nothobranchius_palmqvisti","Nothobranchius_kilombreroensis","Nothobranchius_furzeri"],"Group_6":["Fundulopanchax_amieti"],"Group_7":["Callopanchax_occidentalis"]}

        file_list = open('annual_alignments.txt', 'r')
        out_file = open('groups_present.txt', 'w')
        for alignment_name in file_list:
                species_list = extract_names(alignment_name.strip())
                groups_included = characterize_groups(species_list,annual)
                out_file.write(alignment_name.strip()+','+str(groups_included)+' \n')

        #close files
        file_list.close()
        out_file.close()

        return

main()
