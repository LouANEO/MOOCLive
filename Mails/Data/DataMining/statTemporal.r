statTemporal = function(folder)
{
	################# Data dy date Manipulation #################

	data = read.table(paste(folder,"/Extraction/data.txt",sep=""),sep="\t",header=TRUE)
	year = read.table(paste(folder,"/DataMining/year.txt",sep=""),sep="\t",header=FALSE)
	month = read.table(paste(folder,"/DataMining/month.txt",sep=""),sep="\t",header=FALSE)

	yearInDay = year[match(as.integer(data$Year),year[,1]),2]
	yearInSecond = yearInDay * 24 * 60 *60
	monthInDay = month[cbind(as.integer(data$Month),year[match(as.integer(data$Year),year[,1]),3])]
	monthInSecond = monthInDay * 24 * 60 * 60

	datesInSecond = as.integer(data$Second) 
			+ as.integer(data$Minute) * 60 
			+ as.integer(data$Hour) * 60 * 60
			+ as.integer(data$Day) * 60 *60 * 24
			+ MonthInSecond
			+ YearInSecond

	################# Aggregation by month #################

	month = unique(monthInDay + yearInDay)
	tabMonth =  unique(cbind(data$Month,data$Year))
	ind = which(floor((month[2:length(month)]-month[1:(length(month)-1)])/30)>1)
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
			monthPrev = rbind(monthPrev,tabMonth[indPrev:ind[i],],cbind(seq((tabMonth[ind[i],1]+1),12,1),tabMonth[ind[i],2]),cbind(seq(1,(tabMonth[ind[i]+1,1]-1),1),tabMonth[ind[i]+1,2]))
			indPrev = ind[i]+1
		}
	}
	tabMonth = rbind(monthPrev,tabMonth[indPrev:(length(tabMonth[,2])),])
	monthPlein = unique(month[cbind(as.integer(tabMonth[,1]),year[match(as.integer(tabMonth[,2]),year[,1]),3])] + year[match(as.integer(tabMonth[,2]),year[,1]),2])

	aggMonth = aggregate(rep(1,length(data$Year)),list(yearInSecond + monthInSecond),sum)	

	aggMonthPlein = aggMonth[match(monthPlein,month),2]
	aggMonthPlein[which(is.na(aggMonthPlein))]=0

	jpeg(paste(folder,"/Results/numberOfPostsByMonth.jpg",sep=""),height=500,width=1200,pointsize=20)
		plot(monthPlein,aggMonthPlein, xaxt='n',type='l',xlab='',ylab='Number of posts')
		axis(1, at=monthPlein, labels=paste(tabMonth[,1],"/",tabMonth[,2],sep=""),las=2)
		abline(v=monthPlein,lwd=0.2)
	dev.off()

	postsByMonth = cbind(tabMonth,aggMonthPlein)
	colnames(postsByMonth) = c("Month","Year","Number of posts")
	write.table(postsByMonth,paste(folder,"/Results/numberOfPostsByMonth.csv",sep=""),sep="\t",col.names=TRUE,row.names=FALSE)

	################# Aggregation by week #################

	aggWeek = aggregate(rep(1,length(data$Year)),list(floor((yearInDay + monthInDay + data$Day)/7)),sum)

}


