### Raw Extraction
extractionAdresses.sh and extractionSubject.sh can be launched one after the other in a terminal with the following command:
./extractionAdresses.sh $PATH
./extractionSubject.sh $PATH
(where $PATH is the path of the folder "Data" extracted previously)

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
The function takes one input: a string with the path of folder "Data")

Data are ordered by date of emission
