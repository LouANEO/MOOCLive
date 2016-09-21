#!/bin/bash

cd $1
./extractionAdresses.sh $1 
./extractionSubject.sh $1

Rscript $1/Extraction/merging.r $1
