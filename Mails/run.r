###################################################################################################################################
###                              Fonction globale pour tracer le nuage de mot global d'un corpus                                ###
###################################################################################################################################

#### Inputs ####
# folder: emplacement input/output
# root: racine du projet (pour trouver les fichiers associés)
# search: la recherche Google effectuée
# language: la langue de recherche 

#### Outputs ####
# Un jpeg du nuage de mots global du corpus

run = function(folder,groupe,language)
{
	# folder : emplacement input/output
	# root : racine du projet (pour trouver les fichiers associés)
	# search : query from the client to remove from the output

	source(paste(folder,"/LanguageProcessing/constructBase.r",sep=""))
	source(paste(folder,"/LanguageProcessing/traceNuage.r",sep=""))

	data = read.table(paste(folder,"/Extraction/data.txt",sep=""),sep="\t",header=TRUE)
	nodes = read.table(paste(folder,"/Nodes2.csv",sep=""),sep="\t",header=TRUE)
	stopWords = c(t(read.table(paste(folder,"/TraitementLanguage/stopWords_",language,".txt",sep=""), sep='')))

	resul = constructBase(groupe,data,nodes,language,stopWords)
	traceNuage(folder,resul,groupe)
}
