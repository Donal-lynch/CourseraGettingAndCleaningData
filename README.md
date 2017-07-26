# CourseraGettingAndCleaningData

# Readme
## For creating a tidy data set from Human Activity Recognition Using Smartphones Dataset

### Data source and details
####This data has been sourced from from:
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. <br/>
Smartlab - Non Linear Complex Systems Laboratory<br/> 
DITEN - Università degli Studi di Genova.<br/> 
Via Opera Pia 11A, I-16145, Genoa, Italy.<br/> 
activityrecognition@smartlab.ws<br/> 
www.smartlab.ws<br/> 

From their README file:
>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.<br/>

The data can be found at:<br/>
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
And more information can be found:<br/>
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


### Stepping through the code to tidy the data
#### 0. Loading the data from files
A commented `setwd ()` command is included for my future reference to the data and code location
The commands to load the data are surrounded by an `if` statement for speed. The `read.table()` command is slow, so the `if` statement prevents it running every time. None of the variables created in the if statement are ever modified, so there is no need to reload the the data every time

#### 1. Merges the training and the test sets to create one data set.
```dt <- cbind(subject_test, y_test, x_test) %>%```<br/> 
    ```rbind(cbind(subject_train, y_train, x_train)) %>%``` <br/> 
    ```tbl_df```

`cbind` is used to combine the subjects, the y data which is the activities information, and the x data which contains the variables. By using `cbind` in this way the correct rows will line up with each other.
The test and training sets are combined together using `rbind`.
The data is also converted into a data.table object here

#### 2. Extract only the measurements on the mean and standard deviation for each measurement.
```dt <- select(dt, c(1,2,  grep('.*(mean|std)\\(.*', features$V2)+2))```

A decision has been made to exclude the MeanFreq() data from this data set. The question can be interpreted either way, but as I see it, the question asks *only* for the mean and std of each observation.
A regular expression which returns: `the literal strings 'mean' OR 'std', immediately followed by '('` is sent to `grep()`. The grep call here returns the indicies of the varialbles which match the regular expression.

The `select()` function keeps only the specified rows in the data.table. The integers 1 and 2 are required, because columns 1 and 2 are kept as they relate to subject and activity respectively. The `grep()` function has 2 added to every returned value to account for the these two rows.

#### 3. Use descriptive activity names to name the activities in the data set
```dt$activity <- mapvalues(as.factor(dt$activity),```<br/> 
                       ```from = as.character(activity_labels$V1),```<br/> 
                     ```to = as.character(activity_labels$V2))```<br/> 

The `mapvalues()` function replaces the variable names. The new names are copied straight from the `activity_labels.txt` file, which was loaded in at the beginning of the script


#### 4. Appropriately label the data set with descriptive variable names.
```colNames <- grep('.*(mean|std)\\(.*', features$V2, value = TRUE)```<br/> 
 ```dt <- setnames(dt, names(dt)[-1:-2], colNames)```

A temporary variable, `colNames` is created which contains the strings of the variable names. `colNames` is created by sending the same regular expression to `grep()` as in section 2, but this time `values = TRUE`, so that the actual required strings are returned, not their indicies.
`setnames()` is used to update all of the variable names in `dt` *except* the first 2 columns.


#### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

```tidy_dt <- group_by(dt, subject, activity) %>%```<br/> 
          ```summarise_all(funs(mean))```

```write.table(tidy_dt, file = 'tidy_activity_data.txt', row.name=FALSE)```

A combination of `group_by()` and `summerise_all()` produce tidy with the means of all of the variables for the same subset and activity.
