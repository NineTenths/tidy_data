# Code Book

This document describes the function of the code in `run_analysis.R`.

### Downloading & Loading the Data
* The UCI HAR dataset is downloaded.
* The contents are extracted into the working directory.
* The following files are read in (without headers): `X_test.txt`, `X_train.txt`, `Y_test.txt`, `Y_train.txt`, `subject_test.txt`, `subject_train.txt`, `features.txt`, `activity_labels.txt`.

### Merging the Data
* Colummn-bind the test and train data in to two data frames using: the y-data, the subject data, and the x-data
* Row-bind the test data and train data together
* Add 'activity' and 'subject' to the beginning of the feautres list. 
* Set the features list as the column names for the data frame. 

### Extract 'Mean' and 'Standard Devaition' Data
* Create a regular expression to match 'mean' or 'std' in the column names.

*NOTE: In reviewing the column names, there are columns for 'meanFreq', which are assumed not to be means for each measurement. Therefore thte regular expression must exclude these columns from the match. This will be done by assigning a word boundary (\\b) at the end of the word 'mean'*

* Find the column names that match the regular expression. 
* Add the first two columns ('activity' and 'subject') since we want these as part of the subset.
* Extract the subsetted data.

### Create Descriptive Activity Names
* Using the `plyr` package, **mapvalues** in the 'activity' column of the data frame from the first column of activity_labels to the second column of the activity_labels.

### Create & Export Tidy Data Set
* Using the `reshape2` package, **melt** the data frame using ids: 'activity' and 'subject'.
* Using the `reshape2` package, **dcast** the mean of the data frame by activity and subject.
* Write the data out to a CSV file called `tidy_data.csv`
* The column names of the data set can be found in `tidy_features.txt`

