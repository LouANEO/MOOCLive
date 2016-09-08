This repository contains code to extract data from the mails extracted from the database of exchanges on the liste XXX@mail.com 
between january 2013 and may 2016.

## CONVERSION

The mails extracted directly from the database are registered in MIME format: we used the software TotalMailConverter to extract 
data from these files and create .txt files.

## HOWTO

extractionAdresses.sh and extractionSubject.sh can be launched one after the other in a terminal.
They generate the following files:
- adressesTemp.txt, containing 3 columns ($Folder $File $Sender)
- datesTemp.txt, containing 3 columns ($Folder $File $DateOfEmission)
- subTemp.txt, containing 3 columns ($Folder $File $SubjectOfMail)

In subTemp.txt, the prefixes of the subject were removed, in order to have the same string for each mail of a chain



