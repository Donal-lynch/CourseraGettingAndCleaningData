# Code Book
## For creating a tidy data set from Human Activity Recognition Using Smartphones Dataset
See README for full details of data source and code to produce this dataset

### Explanation of columns

#### subject
30 subjects were recoded for this test. Each subject was given a number, 1-30

#### activity
Each subject was recorded undertaking 6 activities: <br/>
1. WALKING
2. WALKING UPSTAIRS
3. WALKING DOWNSTAIRS
4. SITTING
5. STANDING
6. LAYING

#### Variables

The following list of data has been recorded from the Samsung devices. The -XYZ suffix implies that the measurement is made up of 3 separate measurements, the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

From each of these measurements, the following variables were calculated:
* mean(): Mean value
* std(): Standard deviation