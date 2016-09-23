###################################################################################################################################
###              Global function to evaluate the aggregated number of posts for each subject (by week and month)                ###
###################################################################################################################################

#### Inputs ####
# folder: path of the folder containing data

#### Outputs ####
# Two graphs and two text files of the aggregated number of posts for each thread subject (by week and by month) in Results
# A list of thread files ordered by the reverse number of posts in the thread

statTemporalSubject = function(folder)
{
	source(paste(folder,"/DataMining/statSubjectI.r",sep=""))

	################# Data dy date Manipulation #################

	data = read.table(paste(folder,"/Extraction/data.txt",sep=""),sep="\t",header=TRUE)
	year = read.table(paste(folder,"/DataMining/year.txt",sep=""),sep="\t",header=FALSE)
	month = read.table(paste(folder,"/DataMining/month.txt",sep=""),sep="\t",header=FALSE)

	yearInDay = year[match(as.integer(data$Year),year[,1]),2]
	yearInSecond = yearInDay * 24 * 60 *60
	monthInDay = month[cbind(as.integer(data$Month),year[match(as.integer(data$Year),year[,1]),3])]
	monthInSecond = monthInDay * 24 * 60 * 60

	datesInSecond = as.integer(data$Second) + as.integer(data$Minute) * 60 + as.integer(data$Hour) * 60 * 60 + as.integer(data$Day) * 60 *60 * 24 + monthInSecond + yearInSecond

	# Find the threads and make a list of their subjects
	tempSub = aggregate(rep(1,length(data[,1])),list(data$Subject),sum)
	tempSub = tempSub[tempSub[,2]>1,]
	tempSub = tempSub[rev(sort.int(tempSub[,2],index.return=TRUE)[2]$ix),]
	sub = tempSub[,1]
	write.table(tempSub,paste(folder,"/Results/listSubjectThread.txt",sep=""),sep="\t",col.names=FALSE,row.names=FALSE)

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

	aggMonth = aggregate(rep(1,length(data$Year)),list(yearInSecond + monthInSecond),sum)	

	aggMonthTot = aggMonth[match(monthTot,monthData),2]
	aggMonthTot[which(is.na(aggMonthTot))] = 0

	for(i in 1:length(sub))
	{
		# Create a directory for the thread
		dir.create(paste(folder,"/Results/Subject: ",i,sep=""))
		
		# Evaluate the number of posts in thread number i for each month
		resul = statSubjectI(folder,sub[i])
		
		jpeg(paste(folder,"/Results/Subject: ",i, "/numberOfPostsByMonth.jpg", sep = ""), height = 500, width = 1200, pointsize = 16)
			plot(monthTot, resul$aggMonthTot, xaxt = 'n', type='l', xlab = '', ylab = 'Number of posts', col=1)
			axis(1, at = monthTot, labels = paste(tabMonth[,1],"/", tabMonth[,2], sep = ""), las = 2)
			abline(v = monthTot, lwd = 0.2)
		dev.off()

		postsByMonth = cbind(tabMonth,aggMonthTot,resul$aggMonthTot)
		colnames(postsByMonth) = c("Month","Year","Total number of posts", "Posts subject")
		write.table(postsByMonth, paste(folder, "/Results/Subject: ",i,"/numberOfPostsByMonth.txt", sep = ""), sep = "\t", col.names = TRUE, row.names = FALSE)
	}

	################# Aggregation by week #################

	monday = read.table(paste(folder,"/DataMining/mondays.txt",sep=""),sep="\t",header=TRUE )
	mondayInDay = month[cbind(as.integer(monday$Month),year[match(as.integer(monday$Year),year[,1]),3])] + year[match(as.integer(monday$Year),year[,1]),2] + monday$Day
	dataInDay = month[cbind(as.integer(data$Month),year[match(as.integer(data$Year),year[,1]),3])] + year[match(as.integer(data$Year),year[,1]),2] + data$Day
	
	numWeek = c()
	for(i in 1:length(dataInDay))
	{
		numWeek = c(numWeek,rev(which(mondayInDay<dataInDay[i]))[1])
	}
	aggWeek = aggregate(rep(1,length(data$Year)),list(numWeek),sum)

	weekTot = seq(1,length(monday[,1]),1)
	aggWeekTot = aggWeek[match(weekTot,aggWeek[,1]),2]
	aggWeekTot[which(is.na(aggWeekTot))] = 0

	l=length(aggWeekTot)

	nameWeeks = paste(monday[1:(l-1),1],monday[1:(l-1),2],monday[1:(l-1),3],sep="/")

	for(i in 1:length(sub))
	{
		# Evaluate the number of posts in thread number i for each month
		resul = statSubjectI(folder,sub[i])

		jpeg(paste(folder,"/Results/Subject: ",i, "/numberOfPostsByWeek.jpg", sep = ""), height = 600, width = 1800, pointsize = 14)
			par(mar=c(5.9,4.1,2,2.1))
			plot(weekTot[1:(l-1)], resul$aggWeekTot[1:(l-1)], xaxt=  'n', type = 'l', xlab = '', ylab = 'Number of posts')
			axis(1, at = weekTot[2*(0:floor((l-1)/2))+1], labels = nameWeeks[2*(0:floor((l-1)/2))+1], las = 2)
			abline(v = weekTot[2*(0:floor((l-1)/2))+1], lwd = 0.2)
		dev.off()

		postsByWeek = cbind(monday[1:(l-1),1],monday[1:(l-1),2],monday[1:(l-1),3],aggWeekTot[1:(l-1)],resul$aggWeekTot[1:(l-1)])
		colnames(postsByWeek) = c("Day","Month","Year","Total number of posts", "Posts subject")
		write.table(postsByWeek, paste(folder, "/Results/Subject: ",i,"/numberOfPostsByWeek.txt", sep = ""), sep = "\t", col.names = TRUE, row.names = FALSE)
	}
}


