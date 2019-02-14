---
title: "CodeBook: Getting and Cleaning Data Course Project"
author: "Gunther Baugh"
date: "February 14, 2019"
output: html_document
---

This Codebook summarizes the R Script is in the file: run_analysis.R.  

### List of Tables in the UCI HAR Dataset
  Test dataset : "UCI HAR Dataset/test/X_test.txt" (2947 obs. of  561 variables)
  Activity variables for test dataset : "UCI HAR Dataset/test/y_test.txt"
  Subject variables for test dataset : "UCI HAR Dataset/test/subject_test.txt"
  The data was read into the variable (dfTest), with the Activity and Subject tables read in to dfTest as columns.  

  Train dataset (dfTrain) : "UCI HAR Dataset/train/X_train.txt" (7352 obs. of  561 variables)
  Activity variables for train dataset : "UCI HAR Dataset/train/y_train.txt"
  Subject variables for train dataset : "UCI HAR Dataset/train/subject_train.txt"
  The data was read into the variable (dfTrain), with the Activity and Subject tables read in to dfTrain as columns.  

  The variable labels for both datasets are in the file: "UCI HAR Dataset/features.txt".  This data was imported as the column names. 

Merges the training and the test sets to create one data set.

  - features.txt contains 561 feature labels in column  V2
  
  - added the labels as column names
  
  - Merge y_test into column of X_test Activity labels of y_test column
  
  - subject_test.txt is the subject, add as column "subject"
  
  - Merge y_test into column of X_test Activity labels of y_test column
  
  - subject_test.txt is the subject, add as column "subject"
  
  - merged into one variable "dfResult"
  
```{r eval = FALSE}
  dfTest <- read.table("UCI HAR Dataset/test/X_test.txt")
  colnames(dfTest) <- as.vector(read.table("UCI HAR Dataset/features.txt")$V2)
  dfTest$ActivityNum <- read.table("UCI HAR Dataset/test/y_test.txt")[ ,1]
  dfTest$Subject <- read.table("UCI HAR Dataset/test/subject_test.txt")[ ,1]
  dfTest <- dfTest[ ,c(563, 562, 1:561)]
  dfTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
  colnames(dfTrain) <- as.vector(read.table("UCI HAR Dataset/features.txt")$V2)
  dfTrain$ActivityNum <- read.table("UCI HAR Dataset/train/y_train.txt")[ ,1]
  dfTrain$Subject <- read.table("UCI HAR Dataset/train/subject_train.txt")[ ,1]
  dfTrain <- dfTrain[ ,c(563, 562, 1:561)]
  dfResult <- rbind(dfTrain, dfTest)
```

I added descriptive activity names to name the activities in the data set by linking the activity_labels.txt file. 

```{r eval = FALSE}
  dfActivity <- as.data.frame(read.table("UCI HAR Dataset/activity_labels.txt"))
  names(dfActivity) <- c("ActivityNum", "Activity")
  dfResult <- dfResult %>% left_join(dfActivity)
  dfResult <- dfResult[ ,c(1:3, 564, 4:563)]
```
  
I created a subset of only the measurements on the mean and standard deviation for each measurement.  If string contains mean() or std() then I extracted to the subset in dfResult. 
 
```{r eval = FALSE}
  dfResult <- dfResult %>% select(matches("(mean|std|Activity|Subject)"))
  dfResult$ActivityNum <- NULL
 ```
  
Create more appropriate labels the data set with descriptive variable names. I used gsub to replace text in column names.

```{r eval = FALSE}
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
 ```
  
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r eval = FALSE}
  dfResult <- dfResult %>% group_by(Subject, Activity) %>% summarise_all(funs(mean))
  write.table(dfResult, file = "TidyDataset.txt")
 ```



