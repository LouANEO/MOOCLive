networkMail = function(folder)
{
	data = read.table(paste(folder,"/Extraction/data.txt",sep=""),sep="\t",header=TRUE)

	users = aggregate(rep(1,length(data$Sender)),list(data$Sender),sum)

	edges = c()

	temp = aggregate(rep(1,length(data$Subject)),list(data$Subject),sum)

	fil = temp[temp[,2]>1,1]	

	for(i in 1:length(fil))
	{	
		dataFil = data[data$Subject==fil[i],]

		edges = rbind(edges,cbind(which(users[,1] == dataFil$Sender[1]),match(dataFil$Sender[2:length(dataFil$Sender)],users[,1]),1))
	}

	edges = cbind(as.data.frame(users[edges[,1],1]),as.data.frame(users[edges[,2],1]),edges[,3])

	edges = aggregate(edges[,3],list(edges[,1],edges[,2]),sum)
	colnames(edges) = c("Source","Target","Weight")

	nodes = cbind(as.data.frame(users[,1]),as.data.frame(users[,1]),as.data.frame(users[,2]))
	colnames(nodes) = c("Id","Label","N")

	write.table(nodes, paste(folder,"/Network/nodesAllNet.txt",sep=""), sep = "\t", col.names = TRUE, row.names=FALSE)
	write.table(edges, paste(folder,"/Network/edgesAllNet.txt",sep=""), sep = "\t", col.names = TRUE, row.names=FALSE)
}
