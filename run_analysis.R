#setwd ("C:/Users/USER/Documents/Coursera/Johns Hopkins Data Science Specializition/Getting and cleaning data/Assignments/Week4")
library('plyr')
library('dplyr')
library('data.table')
#Read in test data if it is not already in the enviroment - just to save time
if (!exists('x_train')) {
    x_test <- read.table ('./UCI HAR Dataset/test/X_test.txt')
    y_test <- read.table ('./UCI HAR Dataset/test/Y_test.txt')
    subject_test <- read.table ('./UCI HAR Dataset/test/subject_test.txt')
    x_train <- read.table ('./UCI HAR Dataset/train/X_train.txt')
    y_train <- read.table ('./UCI HAR Dataset/train/Y_train.txt')
    subject_train <- read.table ('./UCI HAR Dataset/train/subject_train.txt')
    features <- read.table ('./UCI HAR Dataset/features.txt')
    activity_labels <- read.table ('./UCI HAR Dataset/activity_labels.txt')
    # Beacuse  X and Y have a variable named V1, they are renamed here
    subject_test <- rename(subject_test, subject = V1)
    subject_train <- rename(subject_train, subject = V1)
    y_test <- rename(y_test, activity = V1)
    y_train <- rename(y_train, activity = V1)
}

## 1.Merges the training and the test sets to create one data set.
# The data is also converted into a data.table here
dt <- cbind(subject_test, y_test, x_test) %>%
    rbind(cbind(subject_train, y_train, x_train)) %>%
    tbl_df

## 2. Extracts only the measurements on the
##      mean and standard deviation for each measurement.

# Grep() function returns the variables with mean or std followed by an '('
# Select () discards all rows other than those returned by grep ()
# c (1,2, grep(...)+2) is required beecause an extra varaibles, activity and
# subject have been added to dt
dt <- select(dt, c(1,2,  grep('.*(mean|std)\\(.*', features$V2)+2))

## 3. Uses descriptive activity names to name the activities in the data set
# These names are taken straight form the activity_labels.txt file
dt$activity <- mapvalues(as.factor(dt$activity),
                       from = as.character(activity_labels$V1),
                       to = as.character(activity_labels$V2))


## 4. Appropriately label the data set with descriptive variable names.
# Using the variable names straight from features.txt
 colNames <- grep('.*(mean|std)\\(.*', features$V2, value = TRUE)
 dt <- setnames(dt, names(dt)[-1:-2], colNames)

## 5. From the data set in step 4, create a second, independent tidy data set
##      with the average of each variable for each activity and each subject.

tidy_dt <- group_by(dt, subject, activity) %>%
            summarise_all(funs(mean))

write.table(tidy_dt, file = 'tidy_activity_data.txt', row.name=FALSE)

