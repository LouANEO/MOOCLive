###################################################################################################################################
###                          Evaluate the relationship between edges weight and nodes number of posts                           ###
###################################################################################################################################

#### Inputs ####
# folder: path of the folder containing the data
# edges: matrix containing the list of edges and their weights
# boundaries: a vector of boundaries to aggregate the results

#### Outputs ####
# A list object containing the parameters of the model and the product of the number of posts for couples of nodes
# 2 jpeg files in Results showing the relationship between parameters

backbone = function(folder, edges, boundaries)
{
	nodesN = c(as.matrix(edges[,1]),as.matrix(edges[,2]))
	nodesN = aggregate(rep(1,length(nodesN)), list(nodesN), sum)

	# Evaluate the product of number of posts for couple of nodes
	produit = nodesN[match(edges[,1], nodesN[,1]), 2] * nodesN[match(edges[,2], nodesN[,1]), 2]

	# Vector of values for the following plot of results 
	abs = (boundaries[2:length(boundaries)] + boundaries[1:(length(boundaries)-1)])/2

	n = aggregate(rep(1,length(produit)),list(cut(log10(produit),boundaries)),sum)
	moyenne = aggregate(edges[,3],list(cut(log10(produit),boundaries)),mean)
	sd = aggregate(edges[,3],list(cut(log10(produit),boundaries)),sd)
	
	# Confidence interval
	interval= sd[,2]/sqrt(n[,2])
	margePlus = moyenne[,2] + interval
	margeMoins = moyenne[,2] - interval

	# Raw plot (X-YLog)
	jpeg(paste(folder,"/Results/linearModel.jpg",sep=""),height=800,width=800,pointsize=20)
		plot(exp(abs),log(moyenne[,2]),ylab='Number of shared threads (log)', xlab='Product of number of interventions')
		points(exp(abs),log(margePlus),col='red',type='l')
		points(exp(abs),log(margeMoins),col='red',type='l')
	dev.off()

	# Evaluate the parameters of the model
	model = lm(log(moyenne[,2]) ~ exp(abs))
	a = model$coefficients[2]
	b = model$coefficients[1]

	# Plot with the model (X-Y)
	jpeg(paste(folder,"/Results/model.jpg",sep=""),height=800,width=800,pointsize=20)
		plot(exp(abs),moyenne[,2], ylab='Number of shared threads', xlab='Product of number of interventions')
		points(exp(abs), exp(exp(abs))^a*exp(b),type='l',col='blue')
	dev.off()

	# Save the parameter for further use
	list(a=a, b=b, product = produit)
}
