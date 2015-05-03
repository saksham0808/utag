#! /bin/bash

for file in "$@"
do
	printf '******************************\n'
	printf 'File\t:\t%s\n' "$file"
	artist=$(echo $file | grep -E "^.*\ -\ " -o | sed 's/ - $//g')
	printf 'Artist\t:\t%s\n' "$artist"

	# Retrieving text after hyphen
	posthyphen=$(echo $file | grep -E "\-\ .+" -o | sed 's/^ *- *//g')
	printf 'hyphen\t:\t%s\n' "$posthyphen"
	
	# Removing all text after featuring
	song=$(echo $posthyphen | sed 's/ft\..*//gI' | sed 's/feat\..*//gI')

	# Removing the "official music video" text
	song=$(echo $song 		| sed 's/(official.*)//gI')
	song=$(echo $song 		| sed 's/\[official.*\]//gI')

	# Removing file extension
	song=$(echo $song		| sed 's/ *\.mp4//gI')
	song=$(echo $song		| sed 's/ *\.mp3//gI')

	
	printf 'Song\t:\t%s\n' "$song"
done
