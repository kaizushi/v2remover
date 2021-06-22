#!/bin/bash

backup_dir="backup/"

if [ -z "$1" ]; then
	echo "You have not specified a file."
	exit
fi

the_file="$1"

if [ ! -d "$backup_dir" ]; then
	echo "The backup directory does not exist."
	exit
fi

file_backup="$backup_dir$the_file"

if [ ! -f "$the_file" ]; then
	echo "The file you have specified does not exist."
	exit
fi

file_tmp=$(mktemp /tmp/v2strip.XXXXXXXX)

if ! cp $the_file $file_tmp; then
	echo "Creating the temporary file has failed."
	exit
fi

if ! cp $the_file $file_backup; then
	echo "Copying the file to the backup directory failed."
	rm $file_tmp
	exit
fi

grep -ve "HiddenService" < $file_tmp > $the_file; 
grep -A2 -B1 "HiddenServiceVersion 3" < $file_tmp >> $the_file

echo "The file should no longer have V2 hidden services."
echo "Cleaning up."

rm $file_tmp
