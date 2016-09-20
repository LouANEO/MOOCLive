statSubjectI = function(folder, subject)
{
	################# Data dy date Manipulation #################

	data = read.table(paste(folder,"/Extraction/data.txt",sep=""),sep="\t",header=TRUE)
	groupes = read.table(paste(folder,"/Nodes2.csv",sep=""),sep="\t",header=TRUE)
	year = read.table(paste(folder,"/DataMining/year.txt",sep=""),sep="\t",header=FALSE)
	month = read.table(paste(folder,"/DataMining/month.txt",sep=""),sep="\t",header=FALSE)

	vec = rep(1,length(data[,1]))
	vec[which(is.na(match(data$Subject,subject)))]=0

	yearInDay = year[match(as.integer(data$Year),year[,1]),2]
	yearInSecond = yearInDay * 24 * 60 *60
	monthInDay = month[cbind(as.integer(data$Month),year[match(as.integer(data$Year),year[,1]),3])]
	monthInSecond = monthInDay * 24 * 60 * 60

	datesInSecond = as.integer(data$Second) + as.integer(data$Minute) * 60 + as.integer(data$Hour) * 60 * 60 + as.integer(data$Day) * 60 *60 * 24 + monthInSecond + yearInSecond

	################# Aggregation by month #################

	monthData = unique(monthInDay + yearInDay)
	tabMonth =  unique(cbind(data$Month,data$Year))
	ind = which(floor((monthData[2:length(monthData)]-monthData[1:(length(monthData)-1)])/30)>1)
	monthPrev = c()
	indPrev = 1
	for(i in 1:length(ind))
	{
		if(tabMonth[ind[i],2]==tabMonth[ind[i]+1,2])
		{
			monthPrev = rbind(monthPrev,tabMonth[indPrev:ind[i],],cbind(seq((tabMonth[ind[i],1]+1),(tabMonth[ind[i]+1,1]-1),1),tabMonth[ind[i],2]))
			indPrev = ind[i]+1
		}

		else
		{
			monthPrev = rbind(monthPrev, tabMonth[indPrev:ind[i],],cbind(seq((tabMonth[ind[i],1]+1),12,1),tabMonth[ind[i],2]),cbind(seq(1,(tabMonth[ind[i]+1,1]-1),1),tabMonth[ind[i]+1,2]))
			indPrev = ind[i] + 1
		}
	}
	tabMonth = rbind(monthPrev, tabMonth[indPrev:(length(tabMonth[,2])),])
	monthTot = unique(month[cbind(as.integer(tabMonth[,1]), year[match(as.integer(tabMonth[,2]), year[,1]), 3])] + year[match(as.integer(tabMonth[,2]), year[,1]), 2])

	aggMonth = aggregate(vec,list(yearInSecond + monthInSecond),sum)	

	aggMonthTot = aggMonth[match(monthTot,monthData),2]
	aggMonthTot[which(is.na(aggMonthTot))] = 0

	postsByMonth = cbind(tabMonth,aggMonthTot)
	colnames(postsByMonth) = c("Month","Year","Number of posts")

	################# Aggregation by week #################

	monday = read.table(paste(folder,"/DataMining/mondays.txt",sep=""),sep="\t",header=TRUE )
	mondayInDay = month[cbind(as.integer(monday$Month),year[match(as.integer(monday$Year),year[,1]),3])] + year[match(as.integer(monday$Year),year[,1]),2] + monday$Day
	dataInDay = month[cbind(as.integer(data$Month),year[match(as.integer(data$Year),year[,1]),3])] + year[match(as.integer(data$Year),year[,1]),2] + data$Day
	
	numWeek = c()
	for(i in 1:length(dataInDay))
	{
		numWeek = c(numWeek,rev(which(mondayInDay<dataInDay[i]))[1])
	}
	aggWeek = aggregate(vec,list(numWeek),sum)

	weekTot = seq(1,length(monday[,1]),1)
	aggWeekTot = aggWeek[match(weekTot,aggWeek[,1]),2]
	aggWeekTot[which(is.na(aggWeekTot))] = 0

	l=length(aggWeekTot)

	postsByWeek = cbind(monday[1:(l-1),1],monday[1:(l-1),2],monday[1:(l-1),3],aggWeekTot[1:(l-1)])
	colnames(postsByWeek) = c("Day","Month","Year","Number of posts")

	list(aggMonthTot = aggMonthTot, aggWeekTot = aggWeekTot)

}


