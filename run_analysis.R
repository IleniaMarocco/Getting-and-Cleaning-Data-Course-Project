setwd("C:/Users/Ilenia/Desktop/UCI HAR Dataset")
library(data.table)
library(dplyr)
xtrain<-read.table('./train/X_train.txt', header=FALSE)
ytrain<-read.table('./train/y_train.txt', header=FALSE)
xtest<-read.table('./test/X_test.txt', header=FALSE)
ytest<-read.table('./test/y_test.txt', header=FALSE)
features<-read.table('./features.txt', header=FALSE)
activity<-read.table('./activity_labels.txt', header=FALSE)
subtrain<-read.table('./train/subject_train.txt', header=FALSE)
subtrain<-subtrain%>%
  +     rename(subjectID=V1)
subtest<-read.table('./test/subject_test.txt', header=FALSE)
subtest<-subtest%>%
  +     rename(subjectID=V1)
features<-features[,2]
featrasp<-t(features)
colnames(xtrain)<-featrasp
colnames(xtest)<-featrasp
colnames(activity)<-c('id','actions')
combineX<-rbind(xtrain, xtest)
combineY<-rbind(ytrain, ytest)
combineSubj<-rbind(subtrain,subtest)
YXdf<-cbind(combineY,combineX, combineSubj)
df<-merge(YXdf, activity,by.x = 'V1',by.y = 'id')
colNames<-colnames(df)
df2<-df%>%
  +     select(actions, subjectID, grep("\\bmean\\b|\\bstd\\b",colNames))
df2$actions<-as.factor(df2$actions)
colnames(df2)<-gsub("^t", "time", colnames(df2))
colnames(df2)<-gsub("^f", "frequency", colnames(df2))
colnames(df2)<-gsub("Acc", "Accelerometer", colnames(df2))
colnames(df2)<-gsub("Gyro", "Gyroscope", colnames(df2))
colnames(df2)<-gsub("Mag", "Magnitude", colnames(df2))
colnames(df2)<-gsub("BodyBody", "Body", colnames(df2))
df2.2<-aggregate(. ~subjectID + actions, df2, mean)
write.table(df2.2, file = "FinalData.txt",row.name=FALSE)

