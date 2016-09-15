
# Human Activity Recognition Using Smartphones Dataset - Measurement Means

## Background 

The raw data for this project was taken from the Human Activity Recognition Using Smartphones Dataset 
created by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto of Smartlab.  The outcome was to produce 
a tidy data set (tidy_data.txt) which contained the averages (mean) for a subset of the measurements grouped by subject and activity.  
The background to the original project and datasets 
can be found at:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## STUDY DESIGN

The analysis is implemented in the file run_analysis.R .

The data was downloaded from:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

and unzipped to a local folder with the following structure:


|      |     |     |     |
| ----------------|--------|-------|---------|
| **UCI  HAR Dataset** | | | |
|                 | activity_labels.txt | | |
|                 | features_info.txt| | |
|                 | features.txt | | |
|                 | README.txt | | |
|                 | **train**| | |
|                 |          | **Inertial Signals** | |
|                 |          |                       | body_acc_x_train.txt|
|                 |          |                       | body_acc_y_train.txt|
|                 |          |                       | body_acc_z_train.txt|
|                 |          |                       | body_gyro_x_train.txt|
|                 |          |                       | body_gyro_y_train.txt|
|                 |          |                       | body_gyro_z_train.txt|
|                 |          |                       | total_acc_x_train.txt|
|                 |          |                       | total_acc_y_train.txt|
|                 |          |                       | total_acc_z_train.txt|
|                 |          |subject_train.txt| |
|                 |          | X_train.txt | |
|                 |          | y_train.txt| |
|                 | **test** | _same structure as for train_ | |

### Reading the data into data frames

All files were read into individually named data frames by the Rscript.  The following modifications were made on reading the files:

1. features: The measurement names were updated to replace '-', '(', ')', and ',' characters with underscores '_'.  Multiple
underscores were reduced to single underscore and any trailing underscores removed to produce tidy variable names that could
be related back to the original measurement name.
2. activity_labels: Column names of activity_id and activity_label were assigned to enable joining with other data sets.
3. subject_train and subject_test: Column name of subject_id was assigned.
4. X_train and X_test: These data sets contained the measurements named in the features data set so on reading the data
the column names were assigned directly from the features data set from step 1.
5. y_train and y_test: Column name of activity_id assigned to enable joining with the activity_labels data set.
6. body_acc_x_train and body_acc_x_test: Column names assigned of BodyAcc_x appended with the numbers 1:128 in 
sequence (BodyAcc_x1, BodyAcc_x2, ...)
7. body_acc_y_train and body_acc_y_test through to total_acc_z_train and total_acc_z_test: The same pattern of column naming 
was used as explained in step 6. 

### Merging the data into a single data frame
To create a single data frame of training data, the columns of the following data frames were combined using the cbind command:

- subject_train
- X_train
- y_train
- body_acc_x_train
- body_acc_y_train
- body_acc_z_train 
- body_gyro_x_train
- body_gyro_y_train
- body_gyro_z_train
- total_acc_x_train
- total_acc_y_train
- total_acc_z_train

In addition a column called obs_id was created from 1 through to 7352 (the number of training data set observations) to 
assist in manually validating data as a quick cross check.

The same columns were combined for the test data along with a new colum obs_id ranging from 7353 to 10299.

Once the train and test data frames were complete the rows were merged to create a single data frame using the rbind command.

### Identifying measurements on the mean and standard deviation for each measurement

In order to extract only the mean and standard deviation measurements, a search was done on the column headers to identify 
those containing either the regular expression mean or the regular expression std.  This search result included column headers containing meanFreq
so these additional meanFreq columns were deleted from the list.  Once the relevant column headers had 
been identified a new data frame was created containing only those relevant column headers plus obs_id, subject_id and 
activity_id.  The command, select, from the dplyr library was used to achieve this.

### Obtain descriptive activity labels for each measurement

A column was added to the data by joining the activity_labels data with the data frame on the activity_id value.  The merge 
command was used to execute the join and the data then ordered by obs_id to facilitate manual cross checking.

### Create a tidy data set of averages by subject and activity

The data frame was grouped by subject and activity_label and then the mean function used to summarise each measurement across the groups. Both the 
obs_id and the activity_id were explicitly excluded from the resulting data set. This resulted in a data frame containing 
the subject_id, 
activity_label and the mean for the measurements containing [Mm]ean or [Ss]td in the feature name.

This tidy data set was written in text format to a file called "tidy_data.txt" in the starting folder for the run_analysis.R 
script.

## CODEBOOK

For each record the following is provided:

- subject_id: Identifies the subject who performed the activity for each window sample. It ranges is from 1 to 30.
- activity_label: The name of the activity.  It is one of: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, 
LAYING
- tBodyAcc_mean_X: The mean by subject and activity of tBodyAcc-mean()-X. For this and all subsequent variables the units used are the same as the units for the original data.
- tBodyAcc_mean_Y: The mean by subject and activity of tBodyAcc-mean()-Y
- tBodyAcc_mean_Z: The mean by subject and activity of tBodyAcc-mean()-Z
- tBodyAcc_std_X: The mean by subject and activity of tBodyAcc-std()-X
- tBodyAcc_std_Y: The mean by subject and activity of tBodyAcc-std()-Y
- tBodyAcc_std_Z: The mean by subject and activity of tBodyAcc-std()-Z
- tGravityAcc_mean_X: The mean by subject and activity of tGravityAcc-mean()-X
- tGravityAcc_mean_Y: The mean by subject and activity of tGravityAcc-mean()-Y
- tGravityAcc_mean_Z: The mean by subject and activity of tGravityAcc-mean()-Z
- tGravityAcc_std_X: The mean by subject and activity of tGravityAcc-std()-X
- tGravityAcc_std_Y: The mean by subject and activity of tGravityAcc-std()-Y
- tGravityAcc_std_Z: The mean by subject and activity of tGravityAcc-std()-Z
- tBodyAccJerk_mean_X: The mean by subject and activity of tBodyAccJerk-mean()-X
- tBodyAccJerk_mean_Y: The mean by subject and activity of tBodyAccJerk-mean()-Y
- tBodyAccJerk_mean_Z: The mean by subject and activity of tBodyAccJerk-mean()-Z
- tBodyAccJerk_std_X: The mean by subject and activity of tBodyAccJerk-std()-X
- tBodyAccJerk_std_Y: The mean by subject and activity of tBodyAccJerk-std()-Y
- tBodyAccJerk_std_Z: The mean by subject and activity of tBodyAccJerk-std()-Z
- tBodyGyro_mean_X: The mean by subject and activity of tBodyGyro-mean()-X
- tBodyGyro_mean_Y: The mean by subject and activity of tBodyGyro-mean()-Y
- tBodyGyro_mean_Z: The mean by subject and activity of tBodyGyro-mean()-Z
- tBodyGyro_std_X: The mean by subject and activity of tBodyGyro-std()-X
- tBodyGyro_std_Y: The mean by subject and activity of tBodyGyro-std()-Y
- tBodyGyro_std_Z: The mean by subject and activity of tBodyGyro-std()-Z
- tBodyGyroJerk_mean_X: The mean by subject and activity of tBodyGyroJerk-mean()-X
- tBodyGyroJerk_mean_Y: The mean by subject and activity of tBodyGyroJerk-mean()-Y
- tBodyGyroJerk_mean_Z: The mean by subject and activity of tBodyGyroJerk-mean()-Z
- tBodyGyroJerk_std_X: The mean by subject and activity of tBodyGyroJerk-std()-X
- tBodyGyroJerk_std_Y: The mean by subject and activity of tBodyGyroJerk-std()-Y
- tBodyGyroJerk_std_Z: The mean by subject and activity of tBodyGyroJerk-std()-Z
- tBodyAccMag_mean: The mean by subject and activity of tBodyAccMag-mean()
- tBodyAccMag_std: The mean by subject and activity of tBodyAccMag-std()
- tGravityAccMag_mean: The mean by subject and activity of tGravityAccMag-mean()
- tGravityAccMag_std: The mean by subject and activity of tGravityAccMag-std()
- tBodyAccJerkMag_mean: The mean by subject and activity of tBodyAccJerkMag-mean()
- tBodyAccJerkMag_std: The mean by subject and activity of tBodyAccJerkMag-std()
- tBodyGyroMag_mean: The mean by subject and activity of tBodyGyroMag-mean()
- tBodyGyroMag_std: The mean by subject and activity of tBodyGyroMag-std()
- tBodyGyroJerkMag_mean: The mean by subject and activity of tBodyGyroJerkMag-mean()
- tBodyGyroJerkMag_std: The mean by subject and activity of tBodyGyroJerkMag-std()
- fBodyAcc_mean_X: The mean by subject and activity of fBodyAcc-mean()-X
- fBodyAcc_mean_Y: The mean by subject and activity of fBodyAcc-mean()-Y
- fBodyAcc_mean_Z: The mean by subject and activity of fBodyAcc-mean()-Z
- fBodyAcc_std_X: The mean by subject and activity of fBodyAcc-std()-X
- fBodyAcc_std_Y: The mean by subject and activity of fBodyAcc-std()-Y
- fBodyAcc_std_Z: The mean by subject and activity of fBodyAcc-std()-Z
- fBodyAccJerk_mean_X: The mean by subject and activity of fBodyAccJerk-mean()-X
- fBodyAccJerk_mean_Y: The mean by subject and activity of fBodyAccJerk-mean()-Y
- fBodyAccJerk_mean_Z: The mean by subject and activity of fBodyAccJerk-mean()-Z
- fBodyAccJerk_std_X: The mean by subject and activity of fBodyAccJerk-std()-X
- fBodyAccJerk_std_Y: The mean by subject and activity of fBodyAccJerk-std()-Y
- fBodyAccJerk_std_Z: The mean by subject and activity of fBodyAccJerk-std()-Z
- fBodyGyro_mean_X: The mean by subject and activity of fBodyGyro-mean()-X
- fBodyGyro_mean_Y: The mean by subject and activity of fBodyGyro-mean()-Y
- fBodyGyro_mean_Z: The mean by subject and activity of fBodyGyro-mean()-Z
- fBodyGyro_std_X: The mean by subject and activity of fBodyGyro-std()-X
- fBodyGyro_std_Y: The mean by subject and activity of fBodyGyro-std()-Y
- fBodyGyro_std_Z: The mean by subject and activity of fBodyGyro-std()-Z
- fBodyAccMag_mean: The mean by subject and activity of fBodyAccMag-mean()
- fBodyAccMag_std: The mean by subject and activity of fBodyAccMag-std()
- fBodyBodyAccJerkMag_mean: The mean by subject and activity of fBodyBodyAccJerkMag-mean()
- fBodyBodyAccJerkMag_std: The mean by subject and activity of fBodyBodyAccJerkMag-std()
- fBodyBodyGyroMag_mean: The mean by subject and activity of fBodyBodyGyroMag-mean()
- fBodyBodyGyroMag_std: The mean by subject and activity of fBodyBodyGyroMag-std()
- fBodyBodyGyroJerkMag_mean: The mean by subject and activity of fBodyBodyGyroJerkMag-mean()
- fBodyBodyGyroJerkMag_std: The mean by subject and activity of fBodyBodyGyroJerkMag-std()
