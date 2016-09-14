ponderation = function(folder, edges, bornes)
{
	nodesN = c(as.matrix(edges[,1]),as.matrix(edges[,2]))
	nodesN = aggregate(rep(1,length(nodesN)), list(nodesN), sum)

	produit = nodesN[match(edges[,1], nodesN[,1]), 2] * nodesN[match(edges[,2], nodesN[,1]), 2]

	abs = (bornes[2:length(bornes)] + bornes[1:(length(bornes)-1)])/2

	n = aggregate(rep(1,length(produit)),list(cut(log10(produit),bornes)),sum)
	moyenne = aggregate(edges[,3],list(cut(log10(produit),bornes)),mean)
	sd = aggregate(edges[,3],list(cut(log10(produit),bornes)),sd)
	intervalle= sd[,2]/sqrt(n[,2])

	margePlus = moyenne[,2] + intervalle
	margeMoins = moyenne[,2] - intervalle

	jpeg(paste(folder,"/Results/ponderationLineaire.jpg",sep="",height=800,width=800,pointsize=20))
		plot(exp(abs),log(moyenne[,2]))
		points(exp(abs),log(margePlus),col='red',type='l')
		points(exp(abs),log(margeMoins),col='red',type='l')
	dev.off()

	model = lm(log(moyenne[,2]) ~ exp(abs))
	a = model$coefficients[2]
	b = model$coefficients[1]

	jpeg(paste(folder,"/Results/ponderation.jpg",sep="",height=800,width=800,pointsize=20))
		plot(exp(abs),moyenne[,2], ylab='Nombre d interventions communes', xlab='Produit des interventions séparées')
		points(exp(abs), exp(exp(abs))^a*exp(b),type='l',col='blue')
	dev.off()

	list(a=a, b=b, produit = produit)
}
