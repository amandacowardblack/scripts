def main():
    results = open('araf_output.txt', 'r')

    output = open('araf_output.csv', 'w')

    result_dict = {}

    for line in results:
        line = line.strip()
        if line[0] == '>':
            header = line
        else:
            mutation = line
            if header not in result_dict:
                result_dict[header] = []
            result_dict[header].append(mutation)

    results.close()
    
    print(result_dict)

    for species in result_dict:
        output.write(species)
        output.write('\t')
        for mutations in result_dict[species]:
            output.write(mutations)
            output.write('\t')
        output.write('\n')
        
    output.close()

main()
