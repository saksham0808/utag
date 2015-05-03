#! /bin/bash

for file in "$@"
do
	printf '******************************\n'
	artist=$(echo $file | grep -E "^.*\ -\ " -o | grep -E "[^\-]+" -o )
	printf 'Artist\t:\t%s\n' "$artist"
	posthyphen=$(echo $file | grep -E "\-\ .+" -o | sed 's/^ *- *//g')
	printf 'hyphen\t:\t%s\n' "$posthyphen"
	#song=$(echo $posthyphen | sed 's/ft\..*//g' | sed 's/(official.*)//gI')
	song=$(echo $posthyphen | sed 's/ft\..*//gI' | sed 's/feat\..*//gI')
	song=$(echo $song 		| sed 's/(official.*)//gI')
	printf 'Song\t:\t%s\n' "$song"
done
