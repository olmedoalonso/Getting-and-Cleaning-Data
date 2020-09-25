### Course Getting and Cleaning Data - Assignment 
#
## Preparation steps
#
# 1. Load the following packages that I find important to have available in case are needed.
library(dplyr)
library(tidyr)
library(httr)
library(RCurl)
library(data.table)
library(knitr)
#
# 2. Setting the working directory
setwd("C:/Users/Olmedo/Desktop/Coursera/datasciencecoursera")
#
## Pre Assignment Activities
#1. Getting and cleaning the Data
#- Download the file and put it in the folder
if(!file.exists("./Get&CleanDataAssignment")){dir.create(./Get&CleanDataAssignment")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Get&CleanDataAssignment/DataAssignment.zip")

#- Unzip the file to the folder
unzip(zipfile = "./Get&CleanDataAssignment/DataAssignment.zip", exdir = "./Get&CleanDataAssignment")

#- Unzip the files that are in the folder.  I created a function "pathway" for the path.
pathway <- file.path("./Get&CleanDataAssignment", "UCI HAR Dataset") 

#- Read the data sets into the variables. I created them similarly to the files names provided in the zipfile in order to have an easy track.
x_test <- read.table(file.path(pathway, "test", "X_test.txt"), header = FALSE)
x_train <- read.table(file.path(pathway, "train", "X_train.txt"), header = FALSE)
y_test <- read.table(file.path(pathway, "test", "y_test.txt"), header = FALSE)
y_train <- read.table(file.path(pathway, "train", "y_train.txt"), header = FALSE)
sub_test <- read.table(file.path(pathway, "test", "subject_test.txt"), header = FALSE)
sub_train <- read.table(file.path(pathway, "train", "subject_train.txt"), header = FALSE)
features <- read.table(file.path(pathway, "features.txt"), header = FALSE)
activities <- read.table(file.path(pathway, "activity_labels.txt"), header = FALSE)
#
#- Merge the test, train sets and subject to create only one data set x variable. That´s in order to get the data tidier in the way to answer the assignment requirements.
x_data <- rbind(x_test, x_train)
names(x_data) <- features$V2
y_data <- rbind(y_test, y_train)
names(y_data) <- c("activity")
sub_data <- rbind(sub_test, sub_train)
names(sub_data) <- c("subject")
merged_data <- cbind(sub_data, y_data, x_data)

## Assignment Development
#
# 1. Create the script run_analysis.R which I placed in my GitHub repository.
#
# 2. Extract only the measurements of the mean and std dev for each measurement in order to have the data tidier.
tidy_merged _data <- merged_data %>% select(subject, activity, contains("mean"), contains("std"))
#
# 3. Use descriptive activity names to name the activities in the data set. With this I have the specific measurement for each subject activity.
tidy_merged_data$activity <- activities[tidy_merged_data$activity, 2]
#
# 4. Appropriately labels the data set with descriptive variable names. Here I place adjust the title for each column (variable) to be easier to understand.
names(tidy_merged_data) [1] = "Subject"
names(tidy_merged_data) [2] = "Activity"
names(tidy_merged_data) <- gsub("^t", "Time", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("^f", "Frequency", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("Acc", "Accelerometer", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("Gyro", "Gyroscope", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("Mag", "Magnitud", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("BodyBody", "Body", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("-mean", "Mean", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("-std", "STD", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("-freq", "Frecuency", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("angle", "Angle", names(tidy_merged_data))
names(tidy_merged_data) <- gsub("gravity", "Gravity", names(tidy_merged_data))
#
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. With this table I provide a summirized data by each subject and activity.
tidy_merged_data_avg <- tidy_merged_data %>% group_by(Subject, Activity) %>% summarise_all(list(mean = mean))
#
# 6. Save the new table. This allows me to keep the table locally and ready for sharing it to others.
write.table(tidy_merged_data_avg, "./Get&CleanDataAssignment/tidy_merged_data_avg.txt", row.names = FALSE)
#

