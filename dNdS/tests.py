#!/usr/bin/env python

## this script automates the processing of all the alignments. 
## It produces a maximum-likelihood tree based on the alignment, and then 
## compares it to the previously made constrained tree via topology test.
## The constrained tree and phylip alignments produced beforehand are utilized 
## by codeml to measure molecular evolutionary rates.

## import necessary modules
import os
import sys
import glob
import shutil
from Bio import SeqIO
from ete3 import Tree
import copy
import subprocess
from Bio import Phylo

def iqtree_runner(seq_file,model, bs_reps,alrt_reps,outdir,outfiles):
    ## the following routine runs iqtree looking for the best model and tree, with no bootstrap. 
    ## It writes results to text files, but also returns the best fitting model.
    import subprocess
    subprocess.run(['iqtree-1.6','-s',seq_file,'-m',model,'-bb',bs_reps,'-alrt',alrt_reps,'-abayes','-pre',outdir+outfiles])
    log_file = open(outdir+outfiles+'.log')	
    best_model = []
    for line in log_file:
        if line.startswith('Best-fit model:'):
            best_model = line.split(' ')[2]
    return best_model

def iqtree_topo_test(seq_file,treefile,model,outfile):
    ## the following begins a new thread to run the topology test with the given model
    import subprocess
    subprocess.run(['iqtree-1.6','-s',seq_file,'-m',model,'-z',treefile,'-zb','10000','-au','-zw','-pre', outfile+'topo_test_out'])

def codeml_sites_runner(codeml_prefix,seq_file,treefile,outfile,scriptfile_s,models = '0 1 2 3'):
    import subprocess
    ## create the control file for codeml to run
    with open('sites.ctl', 'w') as fh: 
        fh.write('seqfile = ' + seq_file +'\n')
        fh.write('treefile = '+ treefile +'\n')
        fh.write('outfile = ' + outfile +'\n')
        fh.write('noisy = 9 \n')
        fh.write('verbose = 0 \n')
        fh.write('runmode = 0 \n')
        fh.write('seqtype = 1 \n')
        fh.write('CodonFreq = 2 \n')
        fh.write('clock = 0 \n')
        fh.write('aaDist = 0 \n')
        fh.write('model = 0 \n')
        fh.write('NSsites = '+ models + '\n')
        fh.write('Mgene = 0 \n')
        fh.write('fix_kappa = 0 \n')
        fh.write('kappa = 2 \n')
        fh.write('fix_omega = 0 \n')
        fh.write('omega = 0.4 \n')
        fh.write('fix_alpha = 1 \n')
        fh.write('alpha = 0 \n')
        fh.write('Malpha = 0 \n')
        fh.write('ncatG = 8  \n')
        fh.write('getSE = 0 \n')
        fh.write('RateAncestor = 1 \n')
        fh.write('Small_Diff = .5e-6 \n')
        fh.write('method = 0 \n')

    with open(scriptfile_s, 'w') as fh:
        fh.write('#PBS -N killifish_codeml_sites \n')
        fh.write('#PBS -l nodes=1:ppn=1 \n')
        fh.write('#PBS -q job_queue \n')
        fh.write('#PBS -r n \n')
        fh.write('#PBS -V \n')
        fh.write('cd '+codeml_prefix+' \n')
        fh.write('codeml sites.ctl \n')

    ## submit the pbs.sh to the queue
    subprocess.call(['qsub', scriptfile_s])

def codeml_branches_runner(codeml_prefix,seq_file,treefile,outfile,scriptfile_b,):
    import subprocess
    ## create the control file for codeml to run
    with open('branches.ctl', 'w') as fh: 
        fh.write('seqfile = ' + seq_file +'\n')
        fh.write('treefile = '+ treefile +'\n')
        fh.write('outfile = ' + outfile +'\n')
        fh.write('noisy = 9 \n')
        fh.write('verbose = 0 \n')
        fh.write('runmode = 0 \n')
        fh.write('seqtype = 1 \n')
        fh.write('CodonFreq = 2 \n')
        fh.write('clock = 0 \n')
        fh.write('aaDist = 0 \n')
        fh.write('model = 2 \n')
        fh.write('NSsites = 0 \n')
        fh.write('Mgene = 0 \n')
        fh.write('fix_kappa = 0 \n')
        fh.write('kappa = 2 \n')
        fh.write('fix_omega = 0 \n')
        fh.write('omega = 0.4 \n')
        fh.write('fix_alpha = 1 \n')
        fh.write('alpha = 0 \n')
        fh.write('Malpha = 0 \n')
        fh.write('ncatG = 8  \n')
        fh.write('getSE = 0 \n')
        fh.write('RateAncestor = 1 \n')
        fh.write('Small_Diff = .5e-6 \n')
        fh.write('method = 0 \n')

    with open(scriptfile_b, 'w') as fh:
        fh.write('#PBS -N killifish_codeml_branches \n')
        fh.write('#PBS -l nodes=1:ppn=1 \n')
        fh.write('#PBS -q job_queue \n')
        fh.write('#PBS -r n \n')
        fh.write('#PBS -V \n')
        fh.write('cd '+codeml_prefix+' \n')
        fh.write('codeml branches.ctl \n')
	
    ## submit the pbs.sh
    subprocess.call(['qsub', scriptfile_b])


alns = glob.glob('*.fasta') ## OR change this to the annual.txt file produced by sort.py 
## but make sure it has absolute paths in it alns = open("annual.txt", "r")
prefix = '/path/to/alignments/'

for alignment in alns:
    ## collect name of alignement
    base_name = alignment.replace('.fasta','')
    outfile = alignment.replace('.fasta','.short_names.fasta')
   
   ## go to iqtree working dir
    os.chdir(prefix+base_name+'/iqtree/')
   
   ## run iqtree keeping the model for topology tests
    model = iqtree_runner(outfile,'TEST','1000','1000','',base_name)
    
    ## set names for constrained tree, iq_tree and concatenate them into a single file
    constrained_tree = outfile.replace('fasta','nwk')
    iq_ML_tree = base_name+'.treefile'
    topo_trees = base_name+'.topo_input'
    
    with open(topo_trees,'w') as topo_in:
        subprocess.run(['cat',constrained_tree,iq_ML_tree],stdout=topo_in)
    
    ## run topology tests
    iqtree_topo_test(outfile,topo_trees,model,base_name+'.topo_test_out')
    
    ## go to codeml folder
    os.chdir(prefix+base_name+'/codeml/')
    codeml_prefix = prefix+base_name+'/codeml/'
    print(codeml_prefix)
    
    ## set names for files to be used by codeml
    seq_file = base_name+'.short_names.phy'
    tree_file = base_name+'.short_names.nwk'
    labeled_tree_file = base_name+'.short_names.all_labels.nwk'
    scriptfile_s = base_name+'.sites.sh'
    scriptfile_b = base_name+'.branches.sh'
    
    ## run codeml
    codeml_sites_runner(codeml_prefix,seq_file,tree_file,base_name+'.codeml_sites.out',scriptfile_s, models = '0 1 2 3')
    codeml_branches_runner(codeml_prefix,seq_file,labeled_tree_file,base_name+'.codeml_branches.out',scriptfile_b)

    ## go back to root of where these files should be
    os.chdir('/path/to/alignments/')
