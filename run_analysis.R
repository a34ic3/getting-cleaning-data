library(dplyr)
library(stringr)

# Assumes data is in directory x, unpacked
setwd("x/UCI HAR Dataset")

# Reading/merging datasets
# Using read.table to read plain column style mainframe text databases
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
activity_names <- features[, 2]

# Merge train and test data

merged_data <- rbind(cbind(x_test, y_test, subject_test), cbind(x_train, y_train, subject_train))

# Uses descriptive activity names
# Label data set

colnames(merged_data) <- c(activity_names, "activity_id", "subject_id")

# Extract columns with name that contains std or mean, with labels 

extract_mean_std <- select(merged_data, grep("std|mean|activity_id|subject_id", colnames(merged_data)))

####### wrong.. ignore  split the extract_mean_std dataframe into separate data frames for subjects:
####### subjects <- group_split(extract_mean_std, subject_id)


# Creates a data frame with 180 rows (30*6=subject x activity) and length(colnames(extract_mean_std)) columns each column from extract_mean_std hit with mean

x <- aggregate(. ~subject_id + activity_id, extract_mean_std, mean)

# Change label names of data columns by prefixing string "AVG:" to indicate that these are summary variables

z <- colnames(x)
colnames(x) <- c(z[1:2], unlist(lapply(z[3:length(z)], function (x) { paste("AVG:", x, sep="")})))

# Write tidy file into project directory 
setwd("../..")
#write.csv(x, file="tidy.csv")
write.table(x, file="tidy.txt", row.names=FALSE)
