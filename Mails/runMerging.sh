#!/bin/bash

cd $1/Extraction
./extractionAdresses.sh $1 
./extractionSubject.sh $1

Rscript $1/Extraction/merging.r $1
