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
	ismp4f=$(echo $file | grep -E ".mp4$" -o)
	if [ "$ismp4f" == "" ]
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
done

printf '******************************\n'
