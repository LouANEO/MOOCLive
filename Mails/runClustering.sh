#!/bin/bash

Rscript $1/Clustering/convert.r $1

cd $1/OSLOM2
./oslom_undir -f $1/Clustering/edges.txt -uw
./pajek_write_undir $1/Clustering/edges.txt

sed -n "/*Vertices/,/*Edges/p" $1/Clustering/edges.txt_oslo_files/pajek_file_1.net > $1/Clustering/nodesClus.txt
sed -i '$d' $1/Clustering/nodesClus.txt
sed -i '1d' $1/Clustering/nodesClus.txt

Rscript $1/Clustering/convert2.r $1
