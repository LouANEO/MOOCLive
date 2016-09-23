###################################################################################################################################
###                       Global function to evaluate the aggregated number of posts (by week and month)                        ###
###################################################################################################################################

#### Inputs ####
# folder: path of the folder containing data

#### Outputs ####
# Two graphs and two text files of the aggregated number of posts (by week and by month) in Results

statTemporal = function(folder)
{
	################# Data dy date Manipulation #################

	data = read.table(paste(folder,"/Extraction/data.txt",sep=""),sep="\t",header=TRUE)
	year = read.table(paste(folder,"/DataMining/year.txt",sep=""),sep="\t",header=FALSE)
	month = read.table(paste(folder,"/DataMining/month.txt",sep=""),sep="\t",header=FALSE)

	# Transformation of year and month in days and seconds
	
	yearInDay = year[match(as.integer(data$Year),year[,1]),2]
	yearInSecond = yearInDay * 24 * 60 *60
	monthInDay = month[cbind(as.integer(data$Month),year[match(as.integer(data$Year),year[,1]),3])]
	monthInSecond = monthInDay * 24 * 60 * 60

	################# Aggregation by month #################

	# Complete month list for visualization
	monthData = unique(monthInDay + yearInDay)
	tabMonth =  unique(cbind(data$Month,data$Year))
	ind = which(floor((monthData[2:length(monthData)]-monthData[1:(length(monthData)-1)])/31)>1) # Which month are missing ?
	monthPrev = c()
	indPrev = 1
	for(i in 1:length(ind))
	{
		# If the missing months are in the same year
		if(tabMonth[ind[i],2]==tabMonth[ind[i]+1,2])
		{
			monthPrev = rbind(monthPrev,tabMonth[indPrev:ind[i],],cbind(seq((tabMonth[ind[i],1]+1),(tabMonth[ind[i]+1,1]-1),1),tabMonth[ind[i],2]))
			indPrev = ind[i]+1
		}

		# If the missing months are in different years
		else
		{
			monthPrev = rbind(monthPrev, tabMonth[indPrev:ind[i],],cbind(seq((tabMonth[ind[i],1]+1),12,1),tabMonth[ind[i],2]),cbind(seq(1,(tabMonth[ind[i]+1,1]-1),1),tabMonth[ind[i]+1,2]))
			indPrev = ind[i] + 1
		}
	}
	tabMonth = rbind(monthPrev, tabMonth[indPrev:(length(tabMonth[,2])),])
	monthTot = unique(month[cbind(as.integer(tabMonth[,1]), year[match(as.integer(tabMonth[,2]), year[,1]), 3])] + year[match(as.integer(tabMonth[,2]), year[,1]), 2])

	# Aggregation of data by month
	aggMonth = aggregate(rep(1,length(data$Year)),list(yearInSecond + monthInSecond),sum)	

	# Complete the aggregation with a zero for missing months
	aggMonthTot = aggMonth[match(monthTot,monthData),2]
	aggMonthTot[which(is.na(aggMonthTot))] = 0
	
	# Visualization
	jpeg(paste(folder,"/Results/numberOfPostsByMonth.jpg", sep = ""), height = 500, width = 1200, pointsize = 16)
		plot(monthTot, aggMonthTot, xaxt = 'n', type='l', xlab = '', ylab = 'Number of posts')
		axis(1, at = monthTot, labels = paste(tabMonth[,1],"/", tabMonth[,2], sep = ""), las = 2)
		abline(v = monthTot, lwd = 0.2)
	dev.off()

	# Printing the data in a txt file
	postsByMonth = cbind(tabMonth,aggMonthTot)
	colnames(postsByMonth) = c("Month","Year","Number of posts")
	write.table(postsByMonth, paste(folder, "/Results/numberOfPostsByMonth.txt", sep = ""), sep = "\t", col.names = TRUE, row.names = FALSE)

	################# Aggregation by week #################

	# Reading the list of mondays for the dataset
	monday = read.table(paste(folder,"/DataMining/mondays.txt",sep=""),sep="\t",header=TRUE )
	
	# Transform data and mondays in a number of days for an easy comparison
	mondayInDay = month[cbind(as.integer(monday$Month),year[match(as.integer(monday$Year),year[,1]),3])] + year[match(as.integer(monday$Year),year[,1]),2] + monday$Day
	dataInDay = month[cbind(as.integer(data$Month),year[match(as.integer(data$Year),year[,1]),3])] + year[match(as.integer(data$Year),year[,1]),2] + data$Day
	
	# Find the number of the week each day is into
	numWeek = c()
	for(i in 1:length(dataInDay))
	{
		numWeek = c(numWeek,rev(which(mondayInDay<dataInDay[i]))[1])
	}
	aggWeek = aggregate(rep(1,length(data$Year)),list(numWeek),sum)

	# Complete the missing weeks
	weekTot = seq(1,length(monday[,1]),1)
	aggWeekTot = aggWeek[match(weekTot,aggWeek[,1]),2]
	aggWeekTot[which(is.na(aggWeekTot))] = 0

	l=length(aggWeekTot)

	# Visualization
	jpeg(paste(folder,"/Results/numberOfPostsByWeeks.jpg",sep=""), height = 600, width = 1800, pointsize = 14)
		par(mar=c(5.9,4.1,2,2.1))
		plot(weekTot[1:(l-1)], aggWeekTot[1:(l-1)], xaxt=  'n', type = 'l', xlab = '', ylab = 'Number of posts')
		nameWeeks = paste(monday[1:(l-1),1],monday[1:(l-1),2],monday[1:(l-1),3],sep="/")
		axis(1, at = weekTot[2*(0:floor((l-1)/2))+1], labels = nameWeeks[2*(0:floor((l-1)/2))+1], las = 2)
		abline(v = weekTot[2*(0:floor((l-1)/2))+1], lwd = 0.2)
	dev.off()

	# Write the aggregation in a text file
	postsByWeek = cbind(monday[1:(l-1),1],monday[1:(l-1),2],monday[1:(l-1),3],aggWeekTot[1:(l-1)])
	colnames(postsByWeek) = c("Day","Month","Year","Number of posts")
	write.table(postsByMonth, paste(folder, "/Results/numberOfPostsByWeek.txt", sep = ""), sep = "\t", col.names = TRUE, row.names = FALSE)
}


