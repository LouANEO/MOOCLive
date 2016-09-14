###################################################################################################################################
###    Pré-traitement du fichier texte: on liste les mots individuels apparaissant dans le corpus et on enlève les mots non     ###
###                                                         significatifs                                                       ###
###################################################################################################################################

#### Inputs ####
# listText: tableau de textes, 1 ligne = 1 page Web, la colonne 1 est le niméro du texte, les colonnes 2 à 8 sont le texte et les titres
# stopwords: un vecteur contenant les mots de structure du texte (articles, pronoms...)
# language : la langue de recherche

#### Outputs ####
# La liste des mots importants apparaissant dans le corpus

constructBase = function(groupe,data,nodes,language,stopWords)
{
	library("stringr")
	library("tm")
	
	nodes = nodes[nodes$modularity_class==groupe,]
	data = data[which(!is.na(match(data$Sender,nodes[,1]))),]

	listText = data$Subject
	mots = matrix("",1,0)

	listText = str_replace_all(listText, "[^[:alnum:]]", " ")
	listText = str_replace_all(listText, "\\d", " ")

	myDocument <- listText	
	docs <- Corpus(VectorSource(myDocument))
	
	docs <- tm_map(docs, content_transformer(tolower))

	# Supprimer les nombres
	docs <- tm_map(docs, removeNumbers)

	# Supprimer les mots vides anglais
	docs <- tm_map(docs, removeWords, stopwords(language))

	# Supprimer votre propre liste de mots non désirés
	docs <- tm_map(docs, removeWords, stopWords) 

	dico <- docs

	# Transformer les mots dans leur base lexicale
	docs <- tm_map(docs, stemDocument, language = language)

	# Processus inverse, repasser du stem au mot français
#	docs <- tm_map(docs.temp, stemCompletion, dictionary = dico, mc.cores=) 

	# Supprimer les ponctuations
	#docs <- tm_map(docs, removePunctuation)

	# Supprimer les espaces vides supplémentaires
	#docs <- tm_map(docs, stripWhitespace)

	mots <- TermDocumentMatrix(docs)

	mots$v = mots$v/floor(data[mots$j,2]/10+1)

	s = sort.int(aggregate(mots$v,list(mots$i),sum)[,2],index.return=TRUE)[2]$ix
	resul = mots$dimnames$Terms[rev(s)]

	# Tri des mots par fréquence d'apparition
	resul = as.data.frame(resul)
	resul = cbind(resul,aggregate(mots$v,list(mots$i),sum)[rev(s),2])
	
	# Complétion des stems
	resul[,1] = stemCompletion(resul[,1],dico)

	# Complétion des stems liés à la recherche
	resul

}
