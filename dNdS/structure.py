#!/usr/bin/env python

## This creates the necessary files for the subsequent testing.
## The names of fasta sequences are shortened to match the species names
## found in the species phylogeny. A constrained tree based on this species
## phylogeny is produced by pruning any species that are not found in the 
## alignment. The trees are then marked for later dN/dS analysis,
## with any foreground species being marked with a "#1".

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

def aln_labels(alignment):
    ## get a list of all labels in a fasta alignment
    from Bio import SeqIO
    aln = SeqIO.parse(alignment, 'fasta')
    labels = []
    for s in aln:
        labels.append(s.id)
    return labels

def name_shorten(alignment,delimiter,outfile):
    ## shorten sequence names in a fasta alignment 
    ## keeping just the characters up to the delimiter
    ## import biopython modules to read and write fasta files
    from Bio import SeqIO
    short_names = []
    aln = SeqIO.parse(alignment,'fasta')
    for s in aln:
        s.id = s.id[0:s.id.find(delimiter)]
        s.description = s.id
        short_names.append(s)
    SeqIO.write(short_names,outfile,'fasta')
    return short_names

def prunelabels_biopython(master_tree,labels_to_keep,outfile):
    ## remove missing sequences from master tree
    ## using BioPhyton
    from Bio import Phylo
    tree = Phylo.read(master_tree,'newick')
    labels_master_tree = tree.get_terminals()
    for label in labels_master_tree:
        if str(label) not in labels_to_keep:
            tree.prune(label)
    Phylo.write(tree,outfile,'newick')        
    ## the following lines process the tree as a text file to remove branch lengths, which confuse iqtree
    with open(outfile) as fh:
        arbol = fh.read()
        arbol = arbol.replace(':0.00000','')
    with open(outfile,'w') as fh:
        fh.write(arbol)
    return tree

def add_terminal_node_labels_biopython(tree_file,marked_nodes,outfile):
    ## requires Biopython
    ## add labels for terminal nodes in tree
    ## for downstream processing in codeml
    ## load the tree as a Tree object from Phylo 
    tree = Phylo.read(tree_file,'newick')
    for clade in tree.find_clades():
        clade.branch_length = ''
        if clade.name in marked_nodes:
            clade.name = clade.name+'_'+marked_nodes[clade.name]
    Phylo.write(tree, outfile, 'newick')
    ## the following lines process the tree as a text file to edit terminal labels, remove branch lengths and "'" from the tree
    with open(outfile) as fh:
        arbol = fh.read()
        arbol = arbol.replace('_#',' #')
        arbol = arbol.replace(':0.00000','')
        arbol = arbol.replace('\'','')
    with open(outfile,'w') as fh:
        fh.write(arbol)
    return tree

## identify the master tree and the master tree with internal labels  
master_tree = '/path/to/alignments/species_tree.nwk'
master_tree_int_labels = '/path/to/alignments/species_tree.internal_labels.nwk'
annual_species = {'Fundulopanchax_amieti':'#1','Nothobranchius_furzeri':'#1','Nothobranchius_kilombreroensis':'#1','Nothobranchius_foerschi':'#1','Nothobranchius_palmqvisti':'#1','Callopanchax_occidentalis':'#1','Austrofundulus_limnaeus':'#1','Pterolebias_longipinnis':'#1','Papilolebias_ashlyae':'#1','Laimosemion_tecminae':'#1','Leptolebias_aureoguttatus':'#1','Nematolebias_whitei':'#1','Ophthalmolebias_perpendicularis':'#1'}
## collect a list all files in directory with the fasta extension 
alns = glob.glob('*.fasta') ## OR change this to the annual.txt file produced by sort.py but make sure it has absolute paths in it alns = open("annual.txt", "r")

os.chdir('/path/to/alignments/')
prefix = '/path/to/alignments/'

for alignment in alns:
    ## collect name of alignement
    base_name = alignment.replace('.fasta','')
    
    ## create working directories
    os.mkdir(base_name)
    os.mkdir('./'+base_name+'/iqtree')
    os.mkdir('./'+base_name+'/codeml')
    
    os.chdir(base_name)
    
    ## write sequences to fasta, shortening names to just include species names 
    outfile = alignment.replace('.fasta','.short_names.fasta')
    alignment = prefix + alignment
    short_names = name_shorten(alignment,'|',outfile)
        
    ## make a list of sequences in alignment
    short_names =  aln_labels(outfile)   
  
    ## extract subtree from master tree 
    prunelabels_biopython(master_tree,short_names,outfile.replace('fasta','nwk'))
    
    ## copy .short_names.fasta alignment and the pruned tree to group working directory
    shutil.move(outfile, prefix+base_name+'/iqtree/') ## What exactly is this line doing? Moving file, then the next line changes the file type?
    shutil.copy(outfile.replace('fasta','nwk'), prefix+base_name+'/iqtree/')
    
    ## extract labeled subtree from master tree
    prunelabels_biopython(master_tree_int_labels,short_names,outfile.replace('fasta','int_labels.nwk'))
    
    ## add labels to terminal nodes 
    add_terminal_node_labels_biopython(outfile.replace('fasta','int_labels.nwk'),diapause_species,outfile.replace('fasta','all_labels.nwk'))
    ## copy .short_names.phy alignment and the labeled and unlabeled trees tree to codeml working directory
    ## shutil.move(outfile.replace('fasta','phy'), './'+base_name+'/codeml/')
    shutil.move(outfile.replace('fasta','nwk'), prefix+base_name+'/codeml/')
    shutil.move(outfile.replace('fasta','int_labels.nwk'), prefix+base_name+'/codeml/')
    shutil.move(outfile.replace('fasta','all_labels.nwk'), prefix+base_name+'/codeml/')
    
    ## go back to root of where these files should be
    os.chdir('/path/to/alignments/')
