###################################################################################################################################
###                                              Extract the backbone of the network                                              ###
###################################################################################################################################

#### Inputs ####
# folder: path of the folder containing the data

#### Outputs ####
# edgesBackbone.txt and nodesBackbone.txt describing the backbone network, stocked in Network

subGraph = function(folder)
{
	source(paste(folder,"/Network/backbone.r",sep=""))
	
	edges = read.table(paste(folder,"/Extraction/edges.txt",sep=""),sep="\t",header=TRUE)	
	nodes = read.table(paste(folder,"/Extraction/nodes.txt",sep=""),sep="\t",header=TRUE)	

	# A fixed value for the boundaries to perform data aggregation
	boundaries = c(0,1,seq(1.2,4.4,0.2))

	# Evaluate the relationship beyween edges weight and nodes number of posts
	t = backbone(folder, edges, boundaries)

	a = t$a
	b = t$b
	product = t$product

	# Evaluate the quotient between both values for each edge
	weighting = log(as.integer(as.matrix(edges[,3])))/(exp(log10(produit))*a+b)

	# Select the most significantly frequent edges
	lim = quantile(weighting,probs=seq(0,1,0.1))[9]
	edges = edges[which(pondere>lim),]
	nodes = nodes[which(!is.na(match(nodes[,1],unique(c(as.matrix(edges[,1]),as.matrix(edges[,2])))))),]
	
	# Write the files for backbone network
	write.table(edges, paste(folder,"/Network/edgesBackbone.txt",sep=""), sep="\t", col.names=TRUE, row.names=FALSE)
	write.table(nodes, paste(folder,"/Network/nodesBackbone.txt",sep=""), sep="\t", col.names=TRUE, row.names=FALSE)
}

args <- commandArgs()
subGraph(args[6])
