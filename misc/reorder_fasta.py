import sys

muscle_file = sys.argv[1]
order_file = sys.argv[2]
reorder_file = open(sys.argv[3], 'w')

seqs = {}

with open(muscle_file) as a:
    for line in a:
        if line[0] == '>':
            header = line
        else:
            seq = line
            if header not in seqs:
                seqs[header] = []
            seqs[header].append(seq)

with open(order_file) as b:
    for line in b:
        reorder_file.write(line)
        for align in seqs[line]:
            reorder_file.write(align)

reorder_file.close()
