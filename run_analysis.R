#1. Load plry library
library(plyr)

#2. Create /data directory and download data set from provided URL
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#3. Unzip data set in existing data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#4. Read training, testing, features and activity_labels tables as data frames
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table('./data/UCI HAR Dataset/features.txt')
activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#5. Column renaming for all data frames loaded to the environment
#5.1 Assign column names for x_train and x_test from features data frame
colnames(x_train) <- features[,2]
colnames(x_test) <- features[,2]

#5.2 Assign "activityId" as column name for y_train and y_test data frames
colnames(y_train) <-"activityId"
colnames(y_test) <- "activityId"

#5.3 Assign "subjectId" as column name for subject_train and subject_test data frames
colnames(subject_train) <- "subjectId"
colnames(subject_test) <- "subjectId"

#5.4 Assign "activityId" and "activityType" as column names for activity_labels data frame
colnames(activity_labels) <- c('activityId','activityType')

#6. Merge train, test, and final data frames
#6.1 Merge train data frames by columns using cbind,
#    make y_train (activityId) and subject_train (subjectId) first and second columns,
#    label train data with new "dtype" column and make it the third column in the resulting train data frame
train <- cbind(y_train, subject_train, dtype = "train", x_train)

#6.2 Merge test data frames by columns using cbind,
#    make y_test (activityId) and subject_test (subjectId) first and second columns,
#    label test data with new "dtype" column and make it the third column in the resulting test data frame
test <- cbind(y_test, subject_test, dtype = "test", x_test)

#6.3 Merge train and test data frames by rows using rbind
mrg_data <- rbind(train, test)

#7. Select columns from mrg_data whose names match "activityId", "subjectId" or "dtype", and
#   select columns from mrg_data whose names contain the words "mean.." or "std.."
selected_columns <- (grepl("activityId", colnames(mrg_data))|
                     grepl("subjectId", colnames(mrg_data))|
                     grepl("dtype", colnames(mrg_data))|
                     grepl("mean..", colnames(mrg_data))|    
                     grepl("std..", colnames(mrg_data)))

#8. Subset mrg_data using the selected_columns whose value is TRUE
subset_data <- mrg_data[ , selected_columns == TRUE]

#9. Use descriptive activity names to name the activities in the final data set
final_data <- merge(subset_data, activity_labels, by='activityId', all.x=TRUE)

#10. Create a tidy data set and sort it by subjectId and activityId
tidy_data <- aggregate(. ~subjectId + activityId + activityType + dtype, data = final_data, mean)
tidy_data <- tidy_data[order(tidy_data$subjectId, tidy_data$activityId),]

#11. Write the tidy data set to a new "TidySet.txt" text file
write.table(tidy_data, "TidySet.txt", row.name=FALSE)