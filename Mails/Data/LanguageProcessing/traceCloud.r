###################################################################################################################################
###                                                       Plot wordcloud                                                        ###
###################################################################################################################################

#### Inputs ####
# folder: path of the folder containing the data
# resul: a mtrix of frequent word and their frequency
# group: id of the community of interest

#### Outputs ####
# A jpeg of the wordcloud in Results

traceCloud = function(folder,resul,group)
{
	library("wordcloud")
	library("RColorBrewer")

	listeRm=as.matrix(read.table(paste(folder,"/TraitementLanguage/listeRm.txt",sep=""),sep="\t",header=FALSE, fill=TRUE))

	# Suppression des mots identifiés comme non pertinents du nuage de mots (exemple: les mots de la recherche Gogogle, dont la présence est attendue)
	nuage = resul[which(is.na(match(as.matrix(resul[,1]),as.vector(t(listeRm))))),]

	# Tracé du nuage des éléments
	set.seed(1234)

	jpeg(filename = paste(folder,"/Results/MotsSujetGroupe",group,sep=""), width = 600, height = 600, units = "px", pointsize = 20)
		wordcloud(words = nuage[,1], freq = nuage[,2], min.freq = 1, max.words=200,  random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))
	dev.off()
}
