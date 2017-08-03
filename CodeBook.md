# Code Book
This Code Book describes the data source, attributes, and transformation process performed to clean up the data and produce the final "TidySet.txt" output.

<br />

**Data Source**

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

<br />

**Attributes**

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

<br />

**Transformation Process**

The following sequence details the process defined in the run_analysis.R script for the clean up of the source data and the creation of the "TidySet.txt" output.

_**1. Load plry library**_

The plyr package must be loaded in the environment in order to leverage functions for data analysis and manipulation.

_**2. Create a "data" directory and download the data set from the web**_

Search for a "data" directory in the current environment. If it does not exist, the script creates a new "data" directory. The zipped source file is downloaded from the URL provided in the course project instructions and saved to the "data" directory. 

_**3. Unzip data set in existing data directory**_

The script unzips the source file into the current "data" directory.

_**4. Read training, testing, features and activity_labels tables as data frames**_

The script reads and creates data frames from each of the source tables using the data.frame() function. These data frames are stored in the current environment with the following variable names:
 
1) x_train
2) y_train
3) subject_train
4) x_test
5) y_test
6) subject_test
7) features
8) activity_labels

_**5. Column renaming for data frames loaded to the environment**_

The script performs four column renaming tasks as follows:
- Assign column names for x_train and x_test from features data frame
- Assign "activityId" as column name for y_train and y_test data frames
- Assign "subjectId" as column name for subject_train and subject_test data frames
- Assign "activityId" and "activityType" as column names for activity_labels data frame

_**6. Merge train, test, and final data frames**_

The script merges the data frames following these rules: 

- First, merge train data frames by columns using cbind, make y_train (activityId) and subject_train (subjectId) first and second columns, label train data with new "dtype" column and make it the third column in the resulting train data frame.
- Second, merge test data frames by columns using cbind, make y_test (activityId) and subject_test (subjectId) first and second columns, label test data with new "dtype" column and make it the third column in the resulting test data frame.
- Third, merge train and test data frames by rows using rbind.

_**7. Select columns from merged data frame**_
 
 The script selects columns from the merged data frame whose names match "activityId", "subjectId" or "dtype", and contain the words "mean.." or "std.." using the grepl() function.

_**8. Subset merged data using selected columns**_

The script uses the selected columns from the previous step whose value is TRUE in order to create a subset of the merged data frame.

_**9. Use descriptive activity names**_
 
The script merges the activity labels with the subset data frame from the previous step in order to name the activities using descriptive activity names.

_**10. Create a tidy data set**_
 
The script uses the aggregate() function to calculate the mean of the of the measured mean and std variables in the data frame, and it sorts the output by subjectId and activityId.

_**11. Write the tidy data set**_
 
 The script creates a new "TidySet.txt" text file in the working directory and it copies the data frame produced in the previous step to that file.