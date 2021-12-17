import sys

group = sys.argv[1]
data_file = sys.argv[2]

branch_output = '/path/to/alignments/'+group+'/codeml/'+group+'.codeml_branches.out'
sites_output = '/path/to/alignments/'+group+'/codeml/'+group+'.codeml_sites.out'
iqtree_output = '/path/to/alignments/'+group+'/iqtree/'+group+'.topo_test_outtopo_test_out.iqtree'

with open(branch_output) as b:
    for line in b:
        ## this section will save the likelihood score and number of parameters in the model
        if line.startswith('lnL'):
            branch_np = line[line.find('np: ')+4:line.find(')')]
            branch_lnL = line.split()[-2]
        
        ## this section saves the actual dN/dS values
        if line.startswith('w ('):
            branch_w1 = line.split()[-2]
            branch_w2 = line.split()[-1]

model = 0
p_model = 1
w_model = 1

with open(sites_output, 'r') as s:
    for line in s:
        ## this section will save the likelihood score and number of parameters in each model
        if line.startswith('lnL'):
            if model == 0:
                site_m0_np = line[line.find('np: ')+4:line.find(')')]
                site_m0_lnL = line.split()[-2]
    
            if model == 1:
                site_m1_np = line[line.find('np: ')+4:line.find(')')]
                site_m1_lnL = line.split()[-2]
            
            if model == 2:
                site_m2_np = line[line.find('np: ')+4:line.find(')')]
                site_m2_lnL = line.split()[-2]
            
            model += 1
        
        ## this section saves the actual dN/dS value for model 0
        if line.startswith('omega'):
            site_m0_w = line.split()[-1]
        
        ## this section saves the p values for models 1 and 2
        if line.startswith('p: '):
            if p_model == 1:
                site_m1_p1 = line.split()[1]
                site_m1_p2 = line.split()[2]
        
            if p_model == 2:
                site_m2_p1 = line.split()[1]
                site_m2_p2 = line.split()[2]
                site_m2_p3 = line.split()[3]
        
            p_model += 1
    
        ## this section saves the actual dN/dS values for models 1 and 2
        if line.startswith('w: '):
            if w_model == 1:
                site_m1_w1 = line.split()[1]
                site_m1_w2 = line.split()[2]
            
            if w_model == 2:
                site_m2_w1 = line.split()[1]
                site_m2_w2 = line.split()[2]
                site_m2_w3 = line.split()[3]
            
            w_model += 1
         
with open(iqtree_output, 'r') as i:
    for line in i:
        ## this section will save the p-AU score from the topology test
        if line.startswith('Tree      logL    deltaL'):
            line = i.readline()
            line = i.readline()
            tree1_logL = line.split()[1]
            tree1_pAU = line.split()[-2]
            line = i.readline()
            tree2_logL = line.split()[1]
            tree2_pAU = line.split()[-2]


with open(data_file, 'a') as d:
    d.write(group+','+branch_np+','+branch_lnL+','+branch_w1+','+branch_w2+','+site_m0_np+','+site_m0_lnL+','+site_m0_w+','+site_m1_np+','+site_m1_lnL+','+site_m1_p1+','+site_m1_p2+','+site_m1_w1+','+site_m1_w2+','+site_m2_np+','+site_m2_lnL+','+site_m2_p1+','+site_m2_p2+','+site_m2_p3+','+site_m2_w1+','+site_m2_w2+','+site_m2_w3+','+'\n')

## this section has been commented out due to project specifics, but it will pull out all of the topology test results, if needed. the data is just appended at the end of the rest.
'''with open(data_file, 'a') as d:
    d.write(group+','+','+tree1_logL+','+tree1_pAU+','+tree2_logL+','+tree2_pAU+'\n')'''
