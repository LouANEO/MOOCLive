subGraph = function(folder, bornes)
{
	source(paste(folder,"/Network/ponderation.r",sep=""))

	edges = read.table(paste(folder,"/Extraction/edges.txt",sep=""),sep="\t",header=TRUE)	
	nodes = read.table(paste(folder,"/Extraction/nodes.txt",sep=""),sep="\t",header=TRUE)	

	t = ponderation(folder, edges, bornes)

	a = t$a
	b = t$b
	product = t$product

	pondere = log(as.integer(as.matrix(edges[,3])))/(exp(log10(produit))*a+b)

	lim = quantile(pondere,probs=seq(0,1,0.1))[9]
	edges = edges[which(pondere>lim),]
	nodes = nodes[which(!is.na(match(nodes[,1],unique(c(as.matrix(edges[,1]),as.matrix(edges[,2])))))),]
	
	write.table(edges, paste(folder,"/Network/edgesWeighted.txt",sep=""), sep="\t", col.names=TRUE, row.names=FALSE)
	write.table(nodes, paste(folder,"/Network/nodesWeighted.txt",sep=""), sep="\t", col.names=TRUE, row.names=FALSE)
}
