#! /bin/bash

_upr()
{
    _UPR=
    case $1 in
        a*) _UPR=A ;;        b*) _UPR=B ;;
        c*) _UPR=C ;;        d*) _UPR=D ;;
        e*) _UPR=E ;;        f*) _UPR=F ;;
        g*) _UPR=G ;;        h*) _UPR=H ;;
        i*) _UPR=I ;;        j*) _UPR=J ;;
        k*) _UPR=K ;;        l*) _UPR=L ;;
        m*) _UPR=M ;;        n*) _UPR=N ;;
        o*) _UPR=O ;;        p*) _UPR=P ;;
        q*) _UPR=Q ;;        r*) _UPR=R ;;
        s*) _UPR=S ;;        t*) _UPR=T ;;
        u*) _UPR=U ;;        v*) _UPR=V ;;
        w*) _UPR=W ;;        x*) _UPR=X ;;
        y*) _UPR=Y ;;        z*) _UPR=Z ;;
         *) _UPR=${1%${1#?}} ;;
    esac
}

_cap()
{
  _upr "$1"
  _CAP=$_UPR${1#?}
}

_capwords()
{
  unset _CAPWORDS
  set -f
  for word in $@
  do
    _cap "$word"
    _CAPWORDS="$_CAPWORDS${_CAPWORDS:+ }$_CAP"
  done
}

for file in "$@"
do
	ismpf=$(echo $file | grep -E "\.mp.$" -o)
	if [ "$ismpf" == "" ]
	then
		continue
	fi

	printf '******************************\n'
	printf 'File\t:\t%s\n' "$file"

	artist=$(echo $file | grep -E "^.*\ -\ " -o | sed 's/ - $//g')

	# Converting first character only to Capital
	artist=$(echo $artist	| tr '[:upper:]' '[:lower:]' <<< ${artist}) 
	_capwords $artist
	artist=$_CAPWORDS

	printf 'Artist\t:\t%s\n' "$artist"

	# Retrieving text after hyphen
	posthyphen=$(echo $file | grep -E "\-\ .+" -o | sed 's/^ *- *//g')
	
	# Removing all text after featuring
	song=$(echo $posthyphen | sed 's/ft\..*//gI' | sed 's/feat\..*//gI')

	# Removing the "official music video" text
	song=$(echo $song 		| sed 's/(official.*)//gI')
	song=$(echo $song 		| sed 's/\[official.*\]//gI')

	# Removing file extension
	song=$(echo $song		| sed 's/ *\.mp4//gI')
	song=$(echo $song		| sed 's/ *\.mp3//gI')

	# Converting first character only to Capital
	song=$(echo $song		| tr '[:upper:]' '[:lower:]' <<< ${song}) 
	#song=$(echo $song		| tr '[:lower:]' '[:upper:]' <<< ${song:0:1})${song:1}
	_capwords $song
	song=$_CAPWORDS
	
	printf 'Song\t:\t%s\n' "$song"
	
	# To find featuring artists now
	song=$(echo $song 		| sed 's/(official.*)//gI')
	song=$(echo $song 		| sed 's/\[official.*\]//gI')

	# Converting to mp3
	target=$song".mp3"
	filetype=$(echo "$file" | grep -E ".mp4$") 
	if [ "$filetype" != "" ]
	then
		#ffmpeg -i "$file" "$song"".mp3"
		echo ""
	fi
	file=$target

	# Adding artist information.
	presentartist=$(id3v2 -l "$file" | grep -E "Artist\:.+$" -o | sed 's/Artist: //g')

	if [ "$presentartist" == "" ]
	then
		echo "No present artist. Should we add the above mentioned?"
		read yorno
		# in place of this, show batches of 5 files to verify to allow a faster workflow
		if [ $yorno == "y" ]
		then
			id3v2 -a "$artist" -t "$song" "$file"
		fi	
	elif [ "$presentartist" != "$artist" ]
	then
		echo "Conflicting artist information. Choose 1 or 2:"
		echo "1. " $presentartist
		echo "2. " $artist
		read choice	
		if [ $choice == "2" ]
		then
			id3v2 -a "$artist $song $file"
		fi
	fi

done

printf '******************************\n'
