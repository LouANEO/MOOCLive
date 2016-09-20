###################################################################################################################################
###               Global function to evaluate the aggregated number of posts for each group (by week and month)                 ###
###################################################################################################################################

#### Inputs ####
# folder: path of the folder containing data

#### Outputs ####
# Two graphs and two text files of the aggregated number of posts for each group (by week and by month) in Results

statTemporalGroupes = function(folder)
{
	source(paste(folder,"/DataMining/statGpeI.r",sep=""))

	################# Data dy date Manipulation #################

	data = read.table(paste(folder,"/Extraction/data.txt",sep=""),sep="\t",header=TRUE)
	gpe = read.table(paste(folder,"/Nodes2.csv",sep=""),sep="\t",header=TRUE)
	year = read.table(paste(folder,"/DataMining/year.txt",sep=""),sep="\t",header=FALSE)
	month = read.table(paste(folder,"/DataMining/month.txt",sep=""),sep="\t",header=FALSE)

	yearInDay = year[match(as.integer(data$Year),year[,1]),2]
	yearInSecond = yearInDay * 24 * 60 *60
	monthInDay = month[cbind(as.integer(data$Month),year[match(as.integer(data$Year),year[,1]),3])]
	monthInSecond = monthInDay * 24 * 60 * 60

	maxGpe = max(gpe[,4])

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

	postsByMonth = cbind(tabMonth,aggMonthTot)

	jpeg(paste(folder,"/Results/numberOfGroupPostsByMonth.jpg", sep = ""), height = 500, width = 1200, pointsize = 16)
		plot(monthTot, aggMonthTot, xaxt = 'n', type='l', xlab = '', ylab = 'Number of posts', col=1)

		# Evaluate the number of posts in each month for each group i
		for(i in 1:maxGpe)
		{
			resul = statGpeI(folder,i)
			points(monthTot, resul$aggMonthTot, type='l', col=i+1)
			postsByMonth = cbind(postsByMonth,resul$aggMonthTot) 
		}
		axis(1, at = monthTot, labels = paste(tabMonth[,1],"/", tabMonth[,2], sep = ""), las = 2)
		abline(v = monthTot, lwd = 0.2)
		legend("topright",bg="white",lwd=1,col=seq(1,maxGpe+1,1),legend=c("Total Number",paste("group ",seq(1,maxGpe,1),sep=" ")))
	dev.off()

	colnames(postsByMonth) = c("Month","Year","Total number of posts", paste("Posts by group",seq(1,maxGpe,1),sep=" "))
	write.table(postsByMonth, paste(folder, "/Results/numberOfGroupPostsByMonth.txt", sep = ""), sep = "\t", col.names = TRUE, row.names = FALSE)

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

	postsByWeek = cbind(monday[1:(l-1),1],monday[1:(l-1),2],monday[1:(l-1),3],aggWeekTot[1:(l-1)])

	jpeg(paste(folder,"/Results/numberOfGroupPostsByWeeks.jpg",sep=""), height = 600, width = 1800, pointsize = 14)
		par(mar=c(5.9,4.1,2,2.1))
		plot(weekTot[1:(l-1)], aggWeekTot[1:(l-1)], xaxt=  'n', type = 'l', xlab = '', ylab = 'Number of posts')
		
		# Evaluate the number of posts in each week for each group i
		for(i in 1:maxGpe)
		{
			resul = statGpeI(folder,i)
			points(weekTot[1:(l-1)], resul$aggWeekTot[1:(l-1)], type = 'l', col = i+1)
			postsByWeek = cbind(postsByWeek,resul$aggWeekTot[1:(l-1)]) 
		}
		nameWeeks = paste(monday[1:(l-1),1],monday[1:(l-1),2],monday[1:(l-1),3],sep="/")
		axis(1, at = weekTot[2*(0:floor((l-1)/2))+1], labels = nameWeeks[2*(0:floor((l-1)/2))+1], las = 2)
		abline(v = weekTot[2*(0:floor((l-1)/2))+1], lwd = 0.2)
		legend("topright",bg="white",lwd=1,col=seq(1,maxGpe+1,1),legend=c("Total Number",paste("group ",seq(1,maxGpe,1),sep=" ")))
	dev.off()

	colnames(postsByWeek) = c("Day","Month","Year","Total number of posts", paste("Posts by group",seq(1,maxGpe,1),sep=" "))
	write.table(postsByWeek, paste(folder, "/Results/numberOfGroupPostsByWeek.txt", sep = ""), sep = "\t", col.names = TRUE, row.names = FALSE)
}


