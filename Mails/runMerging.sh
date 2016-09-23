#!/bin/bash

cd $1/Extraction
./extractionAdresses.sh $1
./extractionSubject.sh $1

sed -i "s/'/ /g" $1/Extraction/adresses.txt
sed -i 's/"/ /g' $1/Extraction/adresses.txt
sed -i "s/'/ /g" $1/Extraction/dates.txt
sed -i 's/"/ /g' $1/Extraction/dates.txt
sed -i "s/'/ /g" $1/Extraction/sub.txt
sed -i 's/"/ /g' $1/Extraction/sub.txt

Rscript $1/Extraction/merging.r $1
