### Text mining
The codes in this folder provides a simple text mining analysis for a vector of strings: constructBase.r extract the most 
frequent words in the string, minus the stopwords of the language selected, and traceCloud.r generates a jpeg file of the 
wordcloud in folder "Results".

Both codes can be launched with languageProcessing.r in the root folder of this project, where some default parameters for this
study are proposed.

stopWords_french.txt contains a list of stopWords for french language
listeRm.txt contains words that we wanted to exclude for this analysis specifically
