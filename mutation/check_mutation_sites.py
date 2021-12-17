def main():
    
    ## open file which has converted alignment sites and their associated mutations
    mutations = open('/path/to/project/${protein_name}_alignment_mutations.txt', 'r')
    
    cancer_mutations = {}
    
    for mutation in mutations:
        mutation = mutation.split()
        if mutation[0] not in cancer_mutations:
            cancer_mutations[mutation[0]] = []
        cancer_mutations[mutation[0]].append(mutation[1])
    
    mutations.close()
    
    alignment = open('/path/to/project/${protein_name}_aligned_oncokb_isoform.fa', 'r')
    results = open('/path/to/project/${protein_name}_output.txt', 'w')
    
    for line in alignment:
        if line[0] == '>':
            header = line
        else:
            for mutation in cancer_mutations:
                index = int(mutation) - 1
                if line[index] in cancer_mutations[mutation]:
                    results.write(header)
                    results.write(mutation)
                    results.write(line[index])
                    results.write('\n')
                    
    
    alignment.close()
    results.close()
    
main()
