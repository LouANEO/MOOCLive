#!/bin/bash

rm /home/louaneo/Bureau/TravailMail/Extraction/*
cd /home/louaneo/Bureau/TravailMail/Data

for folder in $(ls /home/louaneo/Bureau/TravailMail/Data/)
do

	ls /home/louaneo/Bureau/TravailMail/Data/$folder | awk '{gsub(/\.txt/,"");print $1,$5}'>> /home/louaneo/Bureau/TravailMail/Extraction/fichiersTemp2.txt
	n=$(ls /home/louaneo/Bureau/TravailMail/Data/$folder -1 | wc -l)
	yes $folder | head -n $n >> /home/louaneo/Bureau/TravailMail/Extraction/fichiersTemp.txt

	paste /home/louaneo/Bureau/TravailMail/Extraction/fichiersTemp.txt /home/louaneo/Bureau/TravailMail/Extraction/fichiersTemp2.txt >> /home/louaneo/Bureau/TravailMail/Extraction/fichiers.txt

	rm /home/louaneo/Bureau/TravailMail/Extraction/fichiersTemp.txt
	rm /home/louaneo/Bureau/TravailMail/Extraction/fichiersTemp2.txt

	for file in $(ls /home/louaneo/Bureau/TravailMail/Data/$folder)
	do
		resul=$(grep "From: " -m 1 /home/louaneo/Bureau/TravailMail/Data/$folder/$file | cut -d':'  -f2 | rev | cut -d' ' -f1 | rev | sed "s/<//g" | sed "s/>//g")

		char=$(echo $resul | head -c 1)

		if [ $char = "=" ]
		then
			resul=$(grep -A1 "From: " -m 1 /home/louaneo/Bureau/TravailMail/Data/$folder/$file | tail -1 | rev | cut -d' ' -f1 | rev | sed "s/<//g" | sed "s/>//g")
		fi

		echo $resul >> /home/louaneo/Bureau/TravailMail/Extraction/adressesTemp.txt

		resul=$(grep "Date: " -m 1 /home/louaneo/Bureau/TravailMail/Data/$folder/$file)

		prefix2="   Date: "
		resul=${resul#$prefix2}

                echo $resul >> /home/louaneo/Bureau/TravailMail/Extraction/datesTemp.txt
	done

done

# paste 
paste /home/louaneo/Bureau/TravailMail/Extraction/fichiers.txt /home/louaneo/Bureau/TravailMail/Extraction/adressesTemp.txt >> /home/louaneo/Bureau/TravailMail/Extraction/adresses.txt
paste /home/louaneo/Bureau/TravailMail/Extraction/fichiers.txt /home/louaneo/Bureau/TravailMail/Extraction/datesTemp.txt >> /home/louaneo/Bureau/TravailMail/Extraction/dates.txt
rm /home/louaneo/Bureau/TravailMail/Extraction/adressesTemp.txt
#rm /home/louaneo/Bureau/TravailMail/Extraction/adresses2.txt
rm /home/louaneo/Bureau/TravailMail/Extraction/datesTemp.txt
