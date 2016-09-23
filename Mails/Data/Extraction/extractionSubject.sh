###################################################################################################################################
###                                           Extract subject of mail from txt files                                            ###
###################################################################################################################################

#### Inputs ####
# Path of the folder containing the data

#### Outputs ####
# sub.txt, stocked in Extraction, containing the subject of mails with the name of their file of origin

#!/bin/bash

rm $1/sub.txt 

# Going through each folder
for folder in $(ls $1/TxtData/)
do

	# Going through each file in the current folder
	for file in $(ls $1/TxtData/$folder)
	do
		# Grep the subject of the mail
		resul=$(grep "Subject: " -m 1 $1/TxtData/$folder/$file)
		prefix="Subject: "
		resul=${resul#$prefix}

		# Remove the characters indicating the mail is a reply
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

		echo $resul >> $1/Extraction/subTemp.txt
	done

done

# Paste the results
paste $1/Extraction/fichiers.txt $1/Extraction/subTemp.txt >> $1/Extraction/sub.txt
rm $1/Extraction/subTemp.txt
