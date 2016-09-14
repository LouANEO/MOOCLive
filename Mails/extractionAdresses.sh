###################################################################################################################################
###                               Extract sender and date of emission information from txt files                                ###
###################################################################################################################################

#### Inputs ####
# Path of the folder containing the data

#### Outputs ####
# adresses.txt and dates.txt, stocked in Extraction, containing extracted data with the name of their file of origin

#!/bin/bash

rm $1/Extraction/*

# Going through each folder
for folder in $(ls $1/TxtData/)
do

	# Writing the name of the files in a temporary file
	ls $1/$folder | awk '{gsub(/\.txt/,"");print $1,$5}'>> $1/Extraction/fichiersTemp2.txt
	n=$(ls $1/TxtData/$folder -1 | wc -l)
	yes $folder | head -n $n >> $1/Extraction/fichiersTemp.txt

	paste $1/Extraction/fichiersTemp.txt $1/Extraction/fichiersTemp2.txt >> $1/Extraction/fichiers.txt

	rm $1/fichiersTemp.txt
	rm $1/fichiersTemp2.txt

	# Going through the files in the current folder
	for file in $(ls $1/TxtData/$folder)
	do
		# Extract the sender mail adress
		resul=$(grep "From: " -m 1 $1/TxtData/$folder/$file | cut -d':'  -f2 | rev | cut -d' ' -f1 | rev | sed "s/<//g" | sed "s/>//g")

		char=$(echo $resul | head -c 1)

		if [ $char = "=" ]
		then
			resul=$(grep -A1 "From: " -m 1 $1/TxtData/$folder/$file | tail -1 | rev | cut -d' ' -f1 | rev | sed "s/<//g" | sed "s/>//g")
		fi

		echo $resul >> $1/Extraction/adressesTemp.txt

		# Extract the sender mail adress
		resul=$(grep "Date: " -m 1 $1/TxtData/$folder/$file)

		prefix2="   Date: "
		resul=${resul#$prefix2}

                echo $resul >> $1/Extraction/datesTemp.txt
	done

done

# Paste results
paste $1/Extraction/fichiers.txt $1/Extraction/adressesTemp.txt >> $1/Extraction/adresses.txt
paste $1/Extraction/fichiers.txt $1/Extraction/datesTemp.txt >> $1/Extraction/dates.txt

# Supress temporary files
rm $1/Extraction/adressesTemp.txt
rm $1/adresses2.txt
rm $1/Extraction/datesTemp.txt
