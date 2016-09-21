args <- commandArgs()
folder = args[6]

nodesClus = read.table(paste(folder,"/Clustering/nodesClus.txt",sep=""),sep=" ",header=TRUE)
nodes = read.table(paste(folder,"/Network/nodesWeighted.txt",sep=""),sep="\t",header=TRUE)

vec1 = as.data.frame(nodes[nodesClus[,4],1])

groups = unique(nodesClus[,11])
vec2 = as.data.frame(match(nodesClus[,11],groups))

vec = cbind(vec1,vec2)
colnames(vec) = c("Id", "Group")

write.table(vec, paste(folder,"/Clustering/nodesClus.txt",sep=""),sep="\t", col.names=TRUE,row.names=FALSE)	

