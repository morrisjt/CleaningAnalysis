#Getting the working directory
getwd()
##Setting the working directory
setwd("~/R_Code/CleaningProject/")

#Reading Activity Data
yTestData <- read.table("test/Y_test.txt",header=FALSE)
yTrainData <- read.table("train/Y_train.txt",header=FALSE)

#Reading  Features Data
xTestData <- read.table("test/X_test.txt",header=FALSE)
xTrainData <- read.table("train/X_train.txt",header=FALSE)

#Reading Subject Data
subjectTestData <- read.table("test/subject_test.txt",header=FALSE)
subjectTrainData <- read.table("train/subject_train.txt",header=FALSE)

#Binding the Testing, Training Data and Subject data
##Using row bind 
activityData<-rbind(yTestData,yTrainData)
featureData<-rbind(xTestData,xTrainData)
subjectData<-rbind(subjectTestData,subjectTrainData)

#Reading features.txt in order to apply feature names
featureColNames<-read.table("features.txt",header=FALSE)

#Appling feature names to feature data set
names(featureData)<-featureColNames[,2]

#Giving subject and activity more reader friendly names
names(activityData) <- 'activity'
names(subjectData) <- 'subject'

#Binding all the Data sets into one view
##using column bind to cat the data together
bigData<-cbind(subjectData,activityData,featureData)

#Getting mean and standard deviation via grepping the names column for mean or std
##using grep to pull only the columns we are concerned with
measurementsBigData <- bigData[,grepl("*mean\\(\\)*|*std\\(\\)*",names(bigData))]

#Putting the subjects and activitys back on there.
##Lost the subjects and actvities will grepping, column binding them back in
subsetMeasurementsBigData<-cbind(subjectData,activityData,measurementsBigData)

#Reading activity labels table
activityLables<-read.table("activity_labels.txt",header=FALSE)

#Converting numeric activity type to more reader friendly activity description
##using factor to overlay the numeric activities with correct lables from the activity_labels.txt
subsetMeasurementsBigData$activity<-factor(subsetMeasurementsBigData$activity,levels=activityLables[,1],labels=activityLables[,2])

#Cleaning up the column names to make them more readable
names(subsetMeasurementsBigData)<-gsub("Acc","Accelerometer",names(subsetMeasurementsBigData))
names(subsetMeasurementsBigData)<-gsub("Gyro","Gyroscopic",names(subsetMeasurementsBigData))
names(subsetMeasurementsBigData)<-gsub("Mag","Magnitude",names(subsetMeasurementsBigData))
names(subsetMeasurementsBigData)
names(subsetMeasurementsBigData)<-gsub("BodyBody","Body",names(subsetMeasurementsBigData))
names(subsetMeasurementsBigData)<-gsub("^t","Time",names(subsetMeasurementsBigData))
names(subsetMeasurementsBigData)<-gsub("^f","Freq",names(subsetMeasurementsBigData))

#Bringing in dplyer in order to group by and apply an average to subject and activity 
#per measurement per subject per activity
library(dplyr)
names(subsetMeasurementsBigData)
holder<-subsetMeasurementsBigData %>% group_by(subject,activity) %>% summarise_each(funs(mean))

holder

write.table(holder, file="tidatdata.txt", row.names=FALSE)


