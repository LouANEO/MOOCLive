#!/bin/bash

rm /home/louaneo/Bureau/TravailMail/Extraction/sub.txt 
cd /home/louaneo/Bureau/TravailMail/Data

for folder in $(ls /home/louaneo/Bureau/TravailMail/Data/)
do

	for file in $(ls /home/louaneo/Bureau/TravailMail/Data/$folder)
	do
		resul=$(grep "Subject: " -m 1 /home/louaneo/Bureau/TravailMail/Data/$folder/$file)
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

		echo $resul >> /home/louaneo/Bureau/TravailMail/Extraction/subTemp.txt
	done

done

paste /home/louaneo/Bureau/TravailMail/Extraction/fichiers.txt /home/louaneo/Bureau/TravailMail/Extraction/subTemp.txt >> /home/louaneo/Bureau/TravailMail/Extraction/sub.txt
rm /home/louaneo/Bureau/TravailMail/Extraction/subTemp.txt
