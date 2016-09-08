This repository contains code to extract data from the mails extracted from the database of exchanges on the liste XXX@mail.com 
between january 2013 and may 2016.

## CONVERSION

The mails extracted directly from the database are registered in MIME format: we used the software TotalMailConverter to extract 
data from these files and create .txt files.

## HOWTO

You can download the folder "Data" to have the data and the structure of files needed to execute the following bash files.

extractionAdresses.sh and extractionSubject.sh can be launched one after the other in a terminal with the following command:
./extractionAdresses.sh $PATH
./extractionSubject.sh $PATH
(where $PATH is the path of the folder Data extracted previously)

They generate the following files:
- adresses.txt, containing 3 columns ($Folder $File $Sender)
- dates.txt, containing 3 columns ($Folder $File $DateOfEmission)
- sub.txt, containing 3 columns ($Folder $File $SubjectOfMail)

In subTemp.txt, the prefixes of the subject were removed, in order to have the same string for each mail of a chain



