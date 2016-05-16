library(plyr)
library(data.table)
#url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url,"./data.zip")
#unzip("./data.zip")
features=data.table(read.csv("UCI HAR Dataset/features.txt",sep=" ",head=F))
activity_labels=data.table(read.csv("UCI HAR Dataset/activity_labels.txt",sep=" ",head=F))
colnames(activity_labels)=c("number","description")
activity_labels$number=as.character(activity_labels$number)
setkey(activity_labels,number)

getdata=function(path){
        file=paste0("UCI HAR Dataset/",path,"/X_",path,".txt")
        lines=readLines(file)
        data=data.table(ldply(lines, function(line){
                line=sub("^ *","",line)
                t(as.numeric(unlist(strsplit(gsub("  *",";",line),";"))))
                }))
        colnames(data)=as.character(features$V2)
        
        subject=read.csv(paste0("UCI HAR Dataset/",path,"/subject_",path,".txt"),sep=" ",head=F)
        data$subject=as.integer(unlist(subject))
        activities=as.character(unlist(read.csv(paste0("UCI HAR Dataset/",path,"/y_",path,".txt"),sep=" ",head=F)))
        data$activities=as.character(activity_labels[activities]$description)
        data
}


test=data.frame(getdata("test"),stringsAsFactors = F)
train=data.frame(getdata("train"),stringsAsFactors = F)
merged=rbindlist(list(train,test))
selected=c(grep("(mean|std)\\.*.$",colnames(merged)),562,563)
dt=merged[,selected,with=F]
dt_sub_act=dt[,lapply(.SD,mean,na.rm=T),by=list(subject,activities)]

