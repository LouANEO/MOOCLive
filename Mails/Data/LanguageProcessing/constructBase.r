###################################################################################################################################
###                                       Extraction of the most frequent significant words                                     ###
###################################################################################################################################

#### Inputs ####
# listText: vector of string
# stopwords: a vector containing stop words we wish to exclude from the analysis
# language : language of study

#### Outputs ####
# List of important words from the corpus, with their frequency

constructBase = function(listText,language,stopWords)
{
	library("stringr")
	library("tm")
	
	mots = matrix("",1,0)

	listText = str_replace_all(listText, "[^[:alnum:]]", " ")
	listText = str_replace_all(listText, "\\d", " ")

	myDocument <- listText	
	docs <- Corpus(VectorSource(myDocument))
	
	docs <- tm_map(docs, PlainTextDocument)

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
