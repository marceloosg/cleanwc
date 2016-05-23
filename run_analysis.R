library(plyr)
library(data.table)
library(tidyr)
#1-Retrieving Raw Data

datapath="UCI HAR Dataset"
url=readLines("url",n=1)
if (!file.exists(datapath)){
        download.file(url,destfile="./data.zip",method="curl")
        unzip("./data.zip")
        dateDownloaded = date()
}
stopifnot(file.exists(datapath))

#2-Extracting feature descriptive names
features=data.table(read.csv("UCI HAR Dataset/features.txt",sep=" ",head=F))

#3-Activity Descriptive names
activity_labels=data.table(read.csv("UCI HAR Dataset/activity_labels.txt",sep=" ",head=F))
colnames(activity_labels)=c("number","description")
activity_labels$number=as.character(activity_labels$number)
setkey(activity_labels,number)

#Main  function: receives a string variable {path} as input that can be either "test"
# or "train", and outputs a dataframe with the 561 features (as described in the "UCI HAR Dataset/feature.txt" file), plus
# 2 columns: the first is of type integer identifying the subject (as described in the "UCI HAR Dataset/{path}/subject_{path}.txt")
# the second column is the activity label obtained from the merging between the "UCI HAR Dataset/activity_labels.txt" and the
# "UCI HAR Dataset/{path}/y_{path}.txt" file.
source("get_data.R")

#4-Extract test and train data into dataframes

test=getdata("test")
train=getdata("train")

#5-Merge into one dataset

merged=rbindlist(list(train,test))

#6-Select only the relevant data from the merged dataset (mean and standards deviation of each measurements)
selected=c(grep("(mean|std)\\.*.$",colnames(merged)),562,563)
dt=merged[,selected,with=F]
write.table(dt,"test_train.txt",sep="\t",row.names = F)

#7-Summarize the dataset in a new dataset with the average for each subject and activity 
dt_sub_act=dt[,lapply(.SD,mean,na.rm=T),by=list(subject,activities)]
#6-Make it tidy
tidy = dt_sub_act %>% 
        gather(feature,mean,-subject,-activities) %>%
        mutate(feature=sub("  "," ",feature)) %>%
        mutate(feature=sub("\\.*mean\\.*"," Mean ",feature)) %>%
        mutate(feature=sub("^t","Average Time Domain ",feature)) %>%
        mutate(feature=sub("\\.*std\\.*"," Standard Deviation ",feature)) %>% 
        mutate(feature=sub("Mag", " Magnitude",feature)) %>%
        mutate(feature=sub("Gyro\\.*", " Gyroscope ",feature)) %>%
        mutate(feature=sub("Acc\\.*"," Acceleration ",feature)) %>%
        mutate(feature=sub("^f","Average Frequency Domain ",feature)) %>%
        arrange(subject,activities,feature)
write.table(tidy,"averaged_features.txt",sep="\t",row.names = F)

