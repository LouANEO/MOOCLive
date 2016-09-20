runDataMining = function(folder,group)
{
	source(paste(folder,"/DataMining/statTemporal.r",sep=""))
	source(paste(folder,"/DataMining/statTemporalGroupes.r",sep=""))
	source(paste(folder,"/DataMining/statTemporalSubject.r",sep=""))

	statTemporal(folder)
	statTemporalSubject(folder)

	if(group==1)
	{
		statTemporalGroupes(folder)
	}
}
