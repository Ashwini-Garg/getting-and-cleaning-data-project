#################################################################################################################

# Getting and Cleaning Data Course Project on Coursera

# This script performs the following steps on the UCI HAR Dataset downloaded from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable 
#    for each activity and each subject.

#################################################################################################################

# Clean up workspace
rm(list=ls())

# Set the directory containing the data
datafolder <- "~/Documents/training/MachineLearning/videos/getting and cleaning data/project/UCI HAR Dataset/"

# Read the Measurement Variable List from features.txt 
featuresdf <- read.table(paste0(datafolder,"features.txt"), sep=" ", 
                         col.names = c ("num","measurementvars"), stringsAsFactors=FALSE)
measurementvars <- featuresdf$measurementvars

# Read the activity labels from activity_labels.txt
activitiesdf <- read.table(paste0(datafolder,"activity_labels.txt"), sep=" ", 
                           col.names = c ("num","activitylabels"), stringsAsFactors=FALSE)
activitylabels <- activitiesdf$activitylabels

# Remove features and activities data frames.
rm(featuresdf)
rm(activitiesdf)

# Replace special characters in feature names with blanks and underscores.
# Replace "()", ")" with blanks
# Replace "-", "," and "(" with underscores
measurementvars <- gsub("\\(\\)", "", measurementvars)
measurementvars <- gsub("\\)", "", measurementvars)
measurementvars <- gsub("-", "_", measurementvars)
measurementvars <- gsub(",", "_", measurementvars)
measurementvars <- gsub("\\(", "_", measurementvars)

# Read training data from X_train.txt, subject_train.txt and y_train.txt 
# and combine them to get training data set.
traindata <- cbind(
                 read.table(paste0(datafolder,"train/y_train.txt"), sep =" ", 
                            col.names ="activity", colClasses = "integer")
                , read.table(paste0(datafolder,"train/subject_train.txt"), sep =" ", 
                             col.names = "subject", colClasses = "integer") 
                , read.table(paste0(datafolder,"train/X_train.txt"),  
                             col.names = measurementvars, colClasses = "numeric" ))
                

# Read test data from X_test.txt, subject_test.txt and y_test.txt 
# and combine them to test data set.
testdata <- cbind(
    read.table(paste0(datafolder,"test/y_test.txt"), sep =" ", 
               col.names ="activity", colClasses = "integer")
    , read.table(paste0(datafolder,"test/subject_test.txt"), sep =" ", 
                 col.names = "subject", colClasses = "integer")
    , read.table(paste0(datafolder,"test/X_test.txt"),  
                 col.names = measurementvars, colClasses = "numeric" ))


# Combine training and test data sets into one data set
combineddata <- rbind(traindata,testdata)

# Remove train and test data frames  as they are no longer needed 
rm(testdata)
rm(traindata)

# Select subject activity, mean and standard deviation measurements into new data frame
# Copy activity and subject columns from combineddata data frame to meanstddata data frame
meanstddata <- data.frame(activity=combineddata$activity, subject = combineddata$subject)

# Find measurements with _mean and _std in their names, but ingore fields with meanFreq in their names.
meanstdmeasurements <- intersect(grep("_std|_mean",measurementvars),
                                 grep("meanFreq",measurementvars,invert=TRUE))

# Copy the columns selected in the above step from combineddata data frame to meanstddata data frame.
for (i in 1: length(meanstdmeasurements)){
    measurementno <- meanstdmeasurements[i]
    meanstddata[[measurementvars[measurementno]]] <- combineddata[[measurementvars[measurementno]]]
}

# Change activity from integer to activity names factor.
for (i in 1: length(activitylabels)){
    meanstddata$activity <- sub(i, activitylabels[i], meanstddata$activity)
}
meanstddata$activity <- factor(meanstddata$activity,levels=activitylabels)

# Remove combined data  as it is no longer needed
rm(combineddata)

# Change abbreviations in variable names to complete names
colnames <- names(meanstddata)
colnames <- sub("^t","time",colnames)
colnames <- sub("^f","frequency",colnames)
colnames <- gsub("Acc","acceleration",colnames)
colnames <- gsub("Gyro","gyroscope",colnames)
colnames <- gsub("Mag","magnitude",colnames)

# Make variable names lower case and remove underscores
colnames <- tolower(colnames)
colnames <- gsub("_","",colnames)

# Remove multiple "body" in variable names
colnames <- sub("bodybody","body",colnames)

# change the column names of the meanstddata to the modified names.
names(meanstddata) <- colnames



# Create tidy data set with mean of every measurement for each subject and activity
library(reshape2)

meltdata <- melt(meanstddata, id=colnames[1:2], measure.vars=colnames[3:length(colnames)])

# Remove meanstddata data frame 
rm(meanstddata)

tidydata <- dcast(meltdata, ... ~ variable, mean)

# Remove measuremelt data frame 
rm(meltdata)

# Write tidy data to a text file. The file is written to the current working directory.
write.table(tidydata,file="./tidydata.txt")
