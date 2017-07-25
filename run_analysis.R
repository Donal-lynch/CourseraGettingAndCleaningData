#setwd ("C:/Users/USER/Documents/Coursera/Johns Hopkins Data Science Specializition/Getting and cleaning data/Assignments/Week4")
library('dplyr')
library('plyr')
#Read in test data if it is not already in the enviroment - just to save time
if (!exists('x_train')) {
    x_test <- read.table ('./UCI HAR Dataset/test/X_test.txt')
    y_test <- read.table ('./UCI HAR Dataset/test/Y_test.txt')
    x_train <- read.table ('./UCI HAR Dataset/train/X_train.txt')
    y_train <- read.table ('./UCI HAR Dataset/train/Y_train.txt')
    features <- read.table ('./UCI HAR Dataset/features.txt')
    activity_labels <- read.table ('./UCI HAR Dataset/activity_labels.txt')
    # Beacuse  X and Y have a variable named V1, they are renamed here
    y_test <- rename(y_test, labels = V1)
    y_train <- rename(y_train, labels = V1)
}

## 1.Merges the training and the test sets to create one data set.
# The data is also converted into a data.table here
dt <- cbind(y_test, x_test) %>%
    rbind(cbind(y_train, x_train)) %>%
    tbl_df

## 2. Extracts only the measurements on the
##      mean and standard deviation for each measurement.
# Grep() function returns the variables with mean or std followed by an '('
# Select () discards all rows other than those returned by grep ()
dt <- select(dt, grep('.*(mean|std)\\(.*', features$V2))

## 3. Uses descriptive activity names to name the activities in the data set
# These names are taken straight form the activity_labels.txt file
dt$labels <- mapvalues(as.factor(dt$labels),
                       from = as.character(activity_labels$V1),
                       to = as.character(activity_labels$V2))


## 4. Appropriately labels the data set with descriptive variable names.

## 5. From the data set in step 4, creates a second, independent tidy data set
##      with the average of each variable for each activity and each subject.