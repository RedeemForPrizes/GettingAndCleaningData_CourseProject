#########################################################################################################
# 
#     Description:
#     
#     Getting and Cleaning Data
#     by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD
#     
#     Course Project
#     
#     Required to submit: 
#       1) a tidy data set as described below, 
#       2) a link to a Github repository with your script for performing the analysis, and 
#       3) a code book that describes the variables, the data, and any transformations or 
#          work that you performed to clean up the data called CodeBook.md. 
#     
#     Include a README.md in the repo with your scripts. 
#     This repo explains how all of the scripts work and how they are 
#     connected.  
#     
#     Data was obtained from: 
#         
#         http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#     
#     Here are the data for the project: 
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#     
#     You should create one R script called run_analysis.R that does the following. 
#     1) Appropriately label the data set with descriptive variable names. 
#     2) Merge the training and the test sets to create one data set.
#     3) Use descriptive activity names to name the activities in the data set. 
#     4) Extracts only the measurements on the mean and standard deviation for each measurement.
#     5) From the data set in step 4, create a second, independent tidy data set with the average of 
#        each variable for each activity and each subject.
#     
#########################################################################################################


library(dplyr)
library(sqldf)
library(stringr)

# Assign variable names to each of the files for simpler reference
# Test data
file_test_data <- "./UCI_HAR_Dataset/test/X_test.txt"                 #data 	
file_test_subject <- "./UCI_HAR_Dataset/test/subject_test.txt" 	      #test subjects
file_test_activity <- "./UCI_HAR_Dataset/test/y_test.txt"             #activity

# Train data
file_train_data <- "./UCI_HAR_Dataset/train/X_train.txt"      	      #data
file_train_subject <- "./UCI_HAR_Dataset/train/subject_train.txt"     #test subjects	
file_train_activity <- "./UCI_HAR_Dataset/train/y_train.txt"          #activity

# Column headings for the data
file_columnHeadings <- "./UCI_HAR_Dataset/features.txt"               

# Import the data into an appropriate variable for each
# Test data
test_data <-  read.table(file_test_data, header = FALSE)
test_subject <-  read.table(file_test_subject, header = FALSE)
test_activity <-  read.table(file_test_activity, header = FALSE)

# Train data
train_data <-  read.table(file_train_data, header = FALSE)
train_subject <-  read.table(file_train_subject, header = FALSE)
train_activity <-  read.table(file_train_activity, header = FALSE)

# Get the column headings from the features file 
columnHeadings <- read.table(file_columnHeadings, header = FALSE)

#remove the special characters "(" and ")" from the headings using the stringr package
columnHeadings$V2 <- str_replace_all(columnHeadings$V2,"([\\(\\)])","")
columnHeadings$V2 <- str_replace_all(columnHeadings$V2,"([,])","_")

# Add the cleaned-up column headings to test_data and train_data
colnames(test_data) <- columnHeadings[,2] 
colnames(train_data) <- columnHeadings[,2] 

# Get a fresh list of column names
columnHeadings <- read.table(file_columnHeadings, header = FALSE) 

# Get the positions of column names that contain "-mean()" or "-std()"
rowNums_Mean <- grep('-mean\\(\\)',columnHeadings[,2])
rowNums_StdDev <- grep('-std\\(\\)',columnHeadings[,2])

# Combine the column names + columns 1 and 2 for subject and activity
rowNums_MeanAndStdDev <- c(1,2,rowNums_Mean,rowNums_StdDev)
# Sort the result
rowNums_MeanAndStdDev <-sort(rowNums_MeanAndStdDev)

# Remove the unneeded columns from test_data and train_data
test_data <- test_data[,rowNums_MeanAndStdDev]
train_data <- train_data[,rowNums_MeanAndStdDev]

# Apply more meaningful column names to the subject and activity data
colnames(test_subject) <- "Subject"
colnames(test_activity) <- "Activity"
colnames(train_subject) <- "Subject"
colnames(train_activity) <- "Activity"

# Add a column to the activity list that provides a meaningful name for the activity
test_activity <- mutate(test_activity, ActivityByName =  ifelse(Activity == 1,"WALKING",ifelse(Activity == 2,"WALKING_UPSTAIRS",ifelse(Activity == 3,"WALKING_DOWNSTAIRS",ifelse(Activity == 4,"SITTING",ifelse(Activity == 5,"STANDING",ifelse(Activity == 6,"LAYING","")))))))
train_activity <- mutate(train_activity, ActivityByName =  ifelse(Activity == 1,"WALKING",ifelse(Activity == 2,"WALKING_UPSTAIRS",ifelse(Activity == 3,"WALKING_DOWNSTAIRS",ifelse(Activity == 4,"SITTING",ifelse(Activity == 5,"STANDING",ifelse(Activity == 6,"LAYING","")))))))

# Join the subject, activity and data
test_joined <- cbind(test_subject, Activity = test_activity$ActivityByName, test_data)
train_joined <- cbind(train_subject, Activity = train_activity$ActivityByName, train_data)

# Make one big data set from the test and train data
allData <- rbind(test_joined,train_joined)

# Create a data frame containing the means for each value, grouped by subject and activity
TidyDF <- (allData %>%
    group_by(Subject,Activity) %>%
    summarise_each(funs(mean)))

# Write the dataframe to a file specifying "row.name=false" as instructed
write.table(TidyDF, file="TidyData.txt",row.name=FALSE)

# End