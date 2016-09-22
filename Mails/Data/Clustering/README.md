## Code

### Concept

The clustering algorithm OSLOM (www.oslom.org) was used in this study.
To make it work, download and install the software form the website in "Data". runClustering.sh should take care of data manipulation and executing the clustering.

### Data manipulation

convert.r and convert2.r simply modify the network data files so that OSLOM can work with them. 

convert.r produces a text files with all network edges in which the label of the nodes is replaced with an index.
The bash file runClustering.sh produces a file node2.txt in this folder with the result from OSLOM in which ach node is associated to a group.
convert2.r reads nodes2.txt and replace the nodes represented by an index by te label of the nodes. 

In the end, nodes2.txt contains a list of nodes indexed by their label and the index of the cluster they belong to.
