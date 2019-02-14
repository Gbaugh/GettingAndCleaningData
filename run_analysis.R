# run_analysis.R
#
# Peer-graded Assignment: Getting and Cleaning Data Course Project
#
## 
# 

run_analysis <- function(){
library(plyr)
library(dplyr)

# Merges the training and the test sets to create one data set.
  # X_test is data.frame':	2947 obs. of  561 variables
dfTest <- read.table("UCI HAR Dataset/test/X_test.txt")
  # features.txt contains 561 feature labels in column  V2
colnames(dfTest) <- as.vector(read.table("UCI HAR Dataset/features.txt")$V2)
  # Merge y_test into column of X_test Activity labels of y_test column
dfTest$ActivityNum <- read.table("UCI HAR Dataset/test/y_test.txt")[ ,1]
  # subject_test.txt is the subject, add as column "subject"
dfTest$Subject <- read.table("UCI HAR Dataset/test/subject_test.txt")[ ,1]
dfTest <- dfTest[ ,c(563, 562, 1:561)]


# X_test is data.frame':	2947 obs. of  561 variables
dfTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
# features.txt contains 561 feature labels in column  V2
colnames(dfTrain) <- as.vector(read.table("UCI HAR Dataset/features.txt")$V2)
# Merge y_test into column of X_test Activity labels of y_test column
dfTrain$ActivityNum <- read.table("UCI HAR Dataset/train/y_train.txt")[ ,1]
# subject_test.txt is the subject, add as column "subject"
dfTrain$Subject <- read.table("UCI HAR Dataset/train/subject_train.txt")[ ,1]
dfTrain <- dfTrain[ ,c(563, 562, 1:561)]

dfResult <- rbind(dfTrain, dfTest)


# Uses descriptive activity names to name the activities in the data set
  dfActivity <- as.data.frame(read.table("UCI HAR Dataset/activity_labels.txt"))
  names(dfActivity) <- c("ActivityNum", "Activity")
  dfResult <- dfResult %>% left_join(dfActivity)
  dfResult <- dfResult[ ,c(1:3, 564, 4:563)]
  
  
  # Extracts only the measurements on the mean and standard deviation for each measurement.
  # if string contains mean() or std() then extract
  dfResult <- dfResult %>% select(matches("(mean|std|Activity|Subject)"))
  dfResult$ActivityNum <- NULL
  
# Appropriately labels the data set with descriptive variable names.

  names(dfResult) <- gsub(x = names(dfResult), pattern = "Acc", replacement = "Acceleration")  
  names(dfResult) <- gsub(x = names(dfResult), pattern = "Mag", replacement = "Magnitude")  
  names(dfResult) <- gsub(x = names(dfResult), pattern = "Gyro", replacement = "Gyroscope")  
  names(dfResult) <- gsub(x = names(dfResult), pattern = "\\(\\)", replacement = "")  
  names(dfResult) <- gsub(x = names(dfResult), pattern = "tBody", replacement = "TimeDomainSignalForBody")  
  names(dfResult) <- gsub(x = names(dfResult), pattern = "tGravity", replacement = "TimeDomainSignalForGravity")  
  names(dfResult) <- gsub(x = names(dfResult), pattern = "fBody", replacement = "FrequencyDomainSignalForBody")  
  names(dfResult) <- gsub(x = names(dfResult), pattern = "fGravity", replacement = "FrequencyDomainSignalForGravity") 
  names(dfResult) <- gsub(x = names(dfResult), pattern = "std", replacement = "StandardDeviation")  
  names(dfResult) <- gsub(x = names(dfResult), pattern = "angle", replacement = "AngleBetweenVectors") 
  
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

  dfResult <- dfResult %>% group_by(Subject, Activity) %>% summarise_all(funs(mean))
  write.table(dfResult, file = "TidyDataset.txt")

}
