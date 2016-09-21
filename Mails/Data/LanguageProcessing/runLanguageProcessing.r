###################################################################################################################################
###                  Global function to generate the wordcloud of the subjects of mails posted by a community                   ###
###################################################################################################################################

#### Inputs ####
# folder: path of the folder containing data
# group: id of the community studied
# language: language of study (french in this work)

#### Outputs ####
# A jpeg of the wordcloud in Results

runLanguageProcessing = function(folder,group,language)
{
	source(paste(folder,"/LanguageProcessing/constructBase.r",sep=""))
	source(paste(folder,"/LanguageProcessing/traceCloud.r",sep=""))

	data = read.table(paste(folder,"/Extraction/data.txt",sep=""),sep="\t",header=TRUE)
	nodes = read.table(paste(folder,"/Clustering/nodesClus.txt",sep=""),sep="\t",header=TRUE)
	stopWords = c(t(read.table(paste(folder,"/TraitementLanguage/stopWords_",language,".txt",sep=""), sep='')))

	nodesGroup = nodes[nodes$Group==group,]
        data = data[which(!is.na(match(data$Sender,nodesGroup[,1]))),]

	resul = constructBase(data$Subject,language,stopWords)
	traceCloud(folder,resul,group)
}

args <- commandArgs()
runLanguageProcessing(args[6],arg[7],arg[8])
