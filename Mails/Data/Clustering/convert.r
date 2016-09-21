args <- commandArgs()
folder = args[6]

nodes = read.table(paste(folder,"/Network/nodesWeighted.txt",sep=""),sep="\t",header=TRUE)
edges = read.table(paste(folder,"/Network/edgesWeighted.txt",sep=""),sep="\t",header=TRUE)

edges4Clus = cbind(match(edges[,1],nodes[,1]), match(edges[,2],nodes[,1]),edges[,3])
edges4Clus = edges4Clus[order(edges4Clus[,1],edges4Clus[,2],decreasing=FALSE),]

write.table(edges4Clus, paste(folder,"/Clustering/edges.txt",sep=""),sep="\t", col.names=FALSE,row.names=FALSE)	

