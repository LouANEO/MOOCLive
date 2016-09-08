#!/bin/bash

rm $1/sub.txt 

for folder in $(ls $1/Data/)
do

	for file in $(ls $1/Data/$folder)
	do
		resul=$(grep "Subject: " -m 1 $1/Data/$folder/$file)
		prefix="Subject: "
		resul=${resul#$prefix}

		prefix2="Re: "
		resul=${resul#$prefix2}
		prefix2="RE: "
		resul=${resul#$prefix2}
		prefix2="RE : "
		resul=${resul#$prefix2}
		prefix2="Re : "
		resul=${resul#$prefix2}
		prefix2="SV: "
		resul=${resul#$prefix2}

# |rev | cut -d':'  -f1 | rev)

		echo $resul >> $1/Extraction/subTemp.txt
	done

done

paste $1/Extraction/fichiers.txt $1/Extraction/subTemp.txt >> $1/Extraction/sub.txt
rm $1/subTemp.txt
