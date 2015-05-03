#! /bin/bash

for file in "$@"
do
	artist=$(echo $file | grep -E "^.*\ -\ " -o | grep -E "[^\-]+" -o )
	printf 'Artist\t:\t%s\n' "$artist"
	posthyphen=$(echo $file | grep -E "\-\ .+" -o | grep -E "[^\-]+" -o | sed 's/^ *//g')
	printf 'hyphen\t:\t%s\n' "$posthyphen"
	song=$(echo $posthyphen | sed 's/ft\..*//g' | sed -e 's/(Official.*)'//g)
	printf 'Song\t:\t%s\n' "$song"
done
