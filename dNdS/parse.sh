#!/bin/bash

## this takes a list of all the alignments and runs a parse script to get all of the data in a single output file.

while IFS= read -r file
do
	echo `python /path/to/project/parse.py ${file} dnds_data.txt`

done < "/path/to/project/file_name.txt"
