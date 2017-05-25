
## Download the data from the Cloudfront folder
dir.create(file.path('./', './data'), showWarnings = F)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, './data/dataset.zip')
unzip('./data/dataset.zip')

## Read in the files needed for processing
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = F)
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header = F)

ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header = F)

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = F)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = F)

# Read 'features.txt' to obtain the variable names
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = F)

# Read in activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F)

## Merge the data sets into one dataset

# Bind the columns together
test_data <- cbind(ytest, subject_test, xtest)
train_data <- cbind(ytrain, subject_train, xtrain)

# Merge the data into a single data frame
fulldata <- rbind(test_data, train_data)

# Drop the first column in the features array - this is an index that we don't need
features <- subset(features, select = "V2")

# Add 'activity'  and 'subject' to the front of the features vector
features <- rbind('activity', 'subject', features)

# Assign the values in column 2 of features to be the column names of fulldata
colnames(fulldata) <- features[[1]]

## Extract data sets containing measurements on mean and standard deviation

# Create a regular expression to match 'mean' or 'std'. In reviewing the 
# column names, there are columns for 'meanFreq', which are assumed not to be
# means for each measurement. Therefore thte regular expression must exclude
# these columns from the match. This will be done by assigning a word boundary (\b)
# at the end of the word 'mean'
regex <- "mean\\b|std"

# Create a logical vector of the column names that match the regex
match_col_names <- grepl(regex, colnames(fulldata), perl = TRUE)

# Make the first two columns true - these need to be included in the subset
match_col_names[c(1,2)] <- TRUE

# Create a data frame that only keeps the column names matched by the regex
selected_measurements <- subset(fulldata, select = match_col_names)

## Create descriptive activiy names
# Load in plyr package
library(plyr)

# Recode the 'activity' column into activity names
selected_measurements$activity <- mapvalues(selected_measurements$activity,
                                            from = activity_labels$V1,
                                            to = levels(activity_labels$V2))

## Create tidy data set and wwite it to CSV file
library(reshape2)

# Melt the data so that averages by activity and subject can be calculated
melted_data <-
    melt(selected_measurements, id = c('activity', 'subject'))

# Create the tidy data set
tidy_data <-
    dcast(melted_data, subject + activity ~ variable, mean)

# Write the tidy data out
write.csv(tidy_data, 'tidy_data.csv', row.names = F)
