#!/bin/bash

Rscript $1/Network/runNetwork.r $1
Rscript $1/Network/subGraph.r $1
