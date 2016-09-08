#!/bin/bash


rm $1/Extraction/*

for folder in $(ls $1/Data/)
do

	ls $1/$folder | awk '{gsub(/\.txt/,"");print $1,$5}'>> $1/Extraction/fichiersTemp2.txt
	n=$(ls $1/Data/$folder -1 | wc -l)
	yes $folder | head -n $n >> $1/Extraction/fichiersTemp.txt

	paste $1/Extraction/fichiersTemp.txt $1/Extraction/fichiersTemp2.txt >> $1/Extraction/fichiers.txt

	rm $1/fichiersTemp.txt
	rm $1/fichiersTemp2.txt

	for file in $(ls $1/Data/$folder)
	do
		resul=$(grep "From: " -m 1 $1/Data/$folder/$file | cut -d':'  -f2 | rev | cut -d' ' -f1 | rev | sed "s/<//g" | sed "s/>//g")

		char=$(echo $resul | head -c 1)

		if [ $char = "=" ]
		then
			resul=$(grep -A1 "From: " -m 1 $1/Data/$folder/$file | tail -1 | rev | cut -d' ' -f1 | rev | sed "s/<//g" | sed "s/>//g")
		fi

		echo $resul >> $1/Extraction/adressesTemp.txt

		resul=$(grep "Date: " -m 1 $1/TravailMail/Data/$folder/$file)

		prefix2="   Date: "
		resul=${resul#$prefix2}

                echo $resul >> $1/Extraction/datesTemp.txt
	done

done

# paste 
paste $1/Extraction/fichiers.txt $1/Extraction/adressesTemp.txt >> $1/Extraction/adresses.txt
paste $1/Extraction/fichiers.txt $1/Extraction/datesTemp.txt >> $1/Extraction/dates.txt
rm $1/Extraction/adressesTemp.txt
rm $1/adresses2.txt
rm $1/Extraction/datesTemp.txt
