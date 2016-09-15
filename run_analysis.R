#
# Getting and Cleaning Data - Week 4 Assignment
#
fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./wk4assignment_dataset.zip")) {
    download.file(fileUrl, "./wk4assignment_dataset.zip", method="curl")
}

# Unzips files to a folder called "UCI HAR Dataset"
unzip("./wk4assignment_dataset.zip", exdir=".")

setwd("./UCI HAR Dataset")

# Read in the data for train and test, assigning column names.
# Inertial signals are included in building the total data set
# but eventually discarded when selecting mean and std measurements.

# Remove problematic special characters from the feature names.
features <- read.table("features.txt", col.names=c("feature_id", "feature"))
features$feature <- gsub("[-\\(\\)\\,]", "_", features$feature)
features$feature <- gsub("_+", "_", features$feature) # Remove multiple underscores
features$feature <- gsub("_$", "", features$feature) # Remove underscores at end

activity_labels <- read.table("activity_labels.txt",  
                              col.names=c("activity_id", "activity_label"))
# TRAINING DATA
subject_train <- read.table("./train/subject_train.txt", col.names="subject_id")
X_train <- read.table("./train/X_train.txt", col.names=features$feature)
y_train <- read.table("./train/y_train.txt", col.names="activity_id")
body_acc_x_train <- read.table("./train/Inertial Signals/body_acc_x_train.txt", col.names=sprintf("BodyAcc_x%d", 1:128))
body_acc_y_train <- read.table("./train/Inertial Signals/body_acc_y_train.txt", col.names=sprintf("BodyAcc_y%d", 1:128))
body_acc_z_train <- read.table("./train/Inertial Signals/body_acc_z_train.txt", col.names=sprintf("BodyAcc_z%d", 1:128))
body_gyro_x_train <- read.table("./train/Inertial Signals/body_gyro_x_train.txt", col.names=sprintf("BodyGyro_x%d", 1:128))
body_gyro_y_train <- read.table("./train/Inertial Signals/body_gyro_y_train.txt", col.names=sprintf("BodyGyro_y%d", 1:128))
body_gyro_z_train <- read.table("./train/Inertial Signals/body_gyro_z_train.txt", col.names=sprintf("BodyGyro_z%d", 1:128))
total_acc_x_train <- read.table("./train/Inertial Signals/total_acc_x_train.txt", col.names=sprintf("TotalAcc_x%d", 1:128))
total_acc_y_train <- read.table("./train/Inertial Signals/total_acc_y_train.txt", col.names=sprintf("TotalAcc_y%d", 1:128))
total_acc_z_train <- read.table("./train/Inertial Signals/total_acc_z_train.txt", col.names=sprintf("TotalAcc_z%d", 1:128))

# TEST DATA
subject_test <- read.table("./test/subject_test.txt", col.names="subject_id")
X_test <- read.table("./test/X_test.txt", col.names=features$feature)
y_test <- read.table("./test/y_test.txt", col.names="activity_id")
body_acc_x_test <- read.table("./test/Inertial Signals/body_acc_x_test.txt", 
                              col.names=sprintf("BodyAcc_x%d", 1:128))
body_acc_y_test <- read.table("./test/Inertial Signals/body_acc_y_test.txt", 
                              col.names=sprintf("BodyAcc_y%d", 1:128))
body_acc_z_test <- read.table("./test/Inertial Signals/body_acc_z_test.txt", 
                              col.names=sprintf("BodyAcc_z%d", 1:128))
body_gyro_x_test <- read.table("./test/Inertial Signals/body_gyro_x_test.txt", 
                               col.names=sprintf("BodyGyro_x%d", 1:128))
body_gyro_y_test <- read.table("./test/Inertial Signals/body_gyro_y_test.txt", 
                               col.names=sprintf("BodyGyro_y%d", 1:128))
body_gyro_z_test <- read.table("./test/Inertial Signals/body_gyro_z_test.txt", 
                               col.names=sprintf("BodyGyro_z%d", 1:128))
total_acc_x_test <- read.table("./test/Inertial Signals/total_acc_x_test.txt", 
                               col.names=sprintf("TotalAcc_x%d", 1:128))
total_acc_y_test <- read.table("./test/Inertial Signals/total_acc_y_test.txt", 
                               col.names=sprintf("TotalAcc_y%d", 1:128))
total_acc_z_test <- read.table("./test/Inertial Signals/total_acc_z_test.txt", 
                               col.names=sprintf("TotalAcc_z%d", 1:128))

# Combine all the columns from the different train data frames
data_train <- cbind("obs_id"=1:nrow(subject_train), 
                    subject_train, X_train, y_train, 
                    body_acc_x_train, body_acc_y_train, body_acc_z_train, 
                    body_gyro_x_train, body_gyro_y_train, body_gyro_z_train, 
                    total_acc_x_train, total_acc_y_train, total_acc_z_train)

# Combine all the columns from the different test data frames
data_test <- cbind("obs_id"=(nrow(subject_train)+1):(nrow(subject_train)+nrow(subject_test)),
                   subject_test, X_test, y_test, 
                   body_acc_x_test, body_acc_y_test, body_acc_z_test, 
                   body_gyro_x_test, body_gyro_y_test, body_gyro_z_test, 
                   total_acc_x_test, total_acc_y_test, total_acc_z_test)

# Step 1
# Merge train and test data sets
data_all <- rbind(data_train, data_test)

# Use the dplyr library
library(dplyr)

# Step 2
# Get a list of feature names that indicate the measurement is a mean or standard 
# deviation measurement by searching for the regular expression mean or std.
# meanFreq values are not required so remove these explicitly from the list.
# Include the obs_id, subject_id and activity id in the combined list of 
# column names to be extracted.
features_mean_std <- features$feature[grepl("mean", features$feature) | grepl("std", features$feature)]
features_mean_std <- features_mean_std[!grepl("meanFreq", features_mean_std)]
cols_mean_std <- combine(c("obs_id", "subject_id", "activity_id"), as.vector(features_mean_std))
data_mean_std <- select(data_all, one_of(cols_mean_std)) 

# Step 3 
# Merge with the activity_labels data to get descriptive activity names
# and order by obs_id to assist with manual validation.
data_labelled <- merge(activity_labels, data_mean_std, by = "activity_id") %>%
    arrange(obs_id)

# Step 4
# Variable names were applied when the different data sets were created.

# Step 5
# Create a second, independent tidy data set with the average of each 
# variable for each activity and each subject. Write to output file as csv.
by_subject_activity <- group_by(data_labelled, subject_id, activity_label)
data_summary <- summarise_each(by_subject_activity, funs(mean), -c(obs_id, activity_id))

write.csv(data_summary, file="../tidy_data.csv", row.names=FALSE)


# Return to starting directory
setwd("..")
















