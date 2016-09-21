##Code

languageProcessing.r runs constructBase.r and traceCloud.r to perform the text mining analyse.
It take the path to folder Data, the id of the group studied and the language of study as an input.

### Text mining functions
The 2 text mining functions perform a simple text mining analyse for a vector of strings: constructBase.r extract the most 
frequent words in the string, minus the stopwords of the language selected, and traceCloud.r generates a jpeg file of the 
wordcloud in folder "Results".

Both codes can be launched with languageProcessing.r in the root folder of this project, where some default parameters for this
study are proposed.

## Data files
stopWords_french.txt contains a list of stopWords for french language
listeRm.txt contains words that we wanted to exclude for this analysis specifically
