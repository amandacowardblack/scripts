## the dataset I was given was 1302 gene alignments.
## this script sorts them to make sure we only analyzed those that actually had annual lineages within them.

from Bio import SeqIO
import io
import string
def extract_names(alignment):
    # shorten sequence names in a fasta alignment 
    # keeping the just the characters up to the delimiter
    # import biopython modules to read and write fasta files
    species = list(SeqIO.parse(alignment, "fasta"))
    species_short = []
    for s in species:
        species_short.append(s.id[0:s.id.find('|')])
    return species_short

def includes_annual(species, annual):
        #check if any member of species is in annuali
        print(species)
        intersection = [value for value in species if value in annual]
        #if yes, result = TRUE
        if len(intersection) > 0:
                result = True
        #if no, result = FALSE
        else:
                result = False
        return result

def main():
        annual = ['Austrofundulus_limnaeus', 'Pterolebias_longipinnis', 'Papilolebias_ashlyae', 'Laimosemion_tecminae', 'Nematolebias_whitei', 'Ophthalmolebias_perpendicularis', 'Leptolebias_aureoguttatus', 'Nothobranchius_foerschi', 'Nothobranchius_palmqvisti', 'Nothobranchius_kilombreroensis', 'Nothobranchius_furzeri', 'Fundulopanchax_amieti', 'Callopanchax_occidentalis']
        annual_alignments = open('annuals.txt', 'w')
        nonannual_alignments = open('nonannuals.txt', 'w')


        file_list = open('alignments.txt', 'r')
        for alignment_name in file_list:
                species_list = extract_names(alignment_name.strip())
                if includes_annual(species_list,annual) == True:
                        #write alignment_name to annual_alignments
                        annual_alignments.write(alignment_name)
                else:
                        #write alignment_name to nonannual_alignments
                        nonannual_alignments.write(alignment_name)
        #close annual_alignments
        #close _nonannual_alignments
        file_list.close()
        annual_alignments.close()
        nonannual_alignments.close()

        return

main()
