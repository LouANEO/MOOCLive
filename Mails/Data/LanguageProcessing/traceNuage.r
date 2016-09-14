###################################################################################################################################
###                                                  Tracé d'un nuage de mots                                                   ###
###################################################################################################################################

#### Inputs ####
# nuage: table des mots avec le nombre d'occurences
# folder: emplacement input/output
# root: racine du projet (pour trouver les fichiers associés)
# type: type d'entités à traiter [LOC, ORG, PER]

#### Outputs ####
# Un jpeg avec un nuage de mot

traceNuage = function(folder,resul,groupe)
{
	library("wordcloud")
	library("RColorBrewer")

	listeRm=as.matrix(read.table(paste(folder,"/TraitementLanguage/listeRm.txt",sep=""),sep="\t",header=FALSE, fill=TRUE))

	# Suppression des mots identifiés comme non pertinents du nuage de mots (exemple: les mots de la recherche Gogogle, dont la présence est attendue)
	nuage = resul[which(is.na(match(as.matrix(resul[,1]),as.vector(t(listeRm))))),]

	# Tracé du nuage des éléments
	set.seed(1234)

	jpeg(filename = paste(folder,"/Results/MotsSujetGroupe",groupe,sep=""), width = 600, height = 600, units = "px", pointsize = 20)
		wordcloud(words = nuage[,1], freq = nuage[,2], min.freq = 1, max.words=200,  random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))
	dev.off()
}
