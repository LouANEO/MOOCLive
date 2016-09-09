This repository contains code to extract data from the mails extracted from the database of exchanges on the liste XXX@mail.com 
between january 2013 and may 2016.

## CONVERSION

The mails extracted directly from the database are registered in MIME format: we used the software TotalMailConverter to extract 
data from these files and create .txt files.

## FOLDER "CODE"

The folder "Code" can be downloaded to have the data and the structure of files needed to execute the following bash files.

It contains 2 folders:
- Extraction, where the extracted data will be stored
- archivesMail, where the initial files are stored
- Data were the text files are stored

## HOWTO

### Raw extraction
extractionAdresses.sh and extractionSubject.sh can be launched one after the other in a terminal with the following command:
./extractionAdresses.sh $PATH
./extractionSubject.sh $PATH
(where $PATH is the path of the folder "Code" extracted previously)

They generate the following files:
- adresses.txt, containing 3 columns ($Folder $File $Sender)
- dates.txt, containing 3 columns ($Folder $File $DateOfEmission)
- sub.txt, containing 3 columns ($Folder $File $SubjectOfMail)

In subTemp.txt, the prefixes of the subject were removed, in order to have the same string for each mail of a chain

### Merging
Function merge.r merges the 3 files in a single dataset data.txt, with following columns:
- Folder
- File
- Sender adress
- Date in 6 columns DD\tMM\tYYYY\tHH\tMM\tSS
- Subject 
The function takes one input: a string with the path of folder "Code")

Data are ordered by date of emission

### Graph generation
function networkMail.r generates 2 files "nodes.txt" and "edges.txt", containing the nodes and the degs of the network generated with data.

It takes the path of folder "Code" as an input

