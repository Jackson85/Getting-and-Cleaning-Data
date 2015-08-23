# Create directory and filename of the tidy data
dirFile <- "./UCI HAR Dataset"
tidyData <- "./tidy-UCI-HAR-dataset.txt"
tidyDataAVG <- "./tidy-UCI-HAR-dataset-AVG.txt"

## 1. Merges the training and the test sets to create one data set
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Concatenate the data tables by rows
x <- rbind(x_train, X_test)
y <- rbind(y_train, y_test)
s <- rbind(sub_train, sub_test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement
# Read features dataset
features <- read.table("./UCI HAR Dataset/features.txt")
# Names to features column
names(features) <- c('fea_id', 'fea_name')
# Search the data on mean or standard deviation (sd) 
i_features <- grep("-mean\\(\\)|-std\\(\\)", features$fea_name) 
x <- x[, i_features] 
# Replaces all matches of a string features 
names(x) <- gsub("\\(|\\)", "", (features[i_features, 2]))

## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names
# Read activity dataset
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
# Names to activities column
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(s) <- "Subject"

# Concatenate data table by columns
tidyDataSet <- cbind(s, y, x)


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject:
z <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataAVGSet <- aggregate(z,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

# Activity and Subject name of columns 
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"

# Created tidy data set (txt) in directory
write.table(tidyDataSet, tidyData)
write.table(tidyDataAVGSet, tidyDataAVG)

