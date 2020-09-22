## 1) Download and unzip data

#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip")

#unzip("data.zip")

## 2) Load features (columns) and activity labels.

features <- read.table("UCI HAR Dataset/features.txt")
labels <- read.table("UCI HAR Dataset/activity_labels.txt")

ftsids <- grep("mean|std", features[[2]])

## 3) Load X and Y from test

xTe <- read.table("UCI HAR Dataset/test/x_test.txt")
yTe <- read.table("UCI HAR Dataset/test/y_test.txt")

## 4) Set column names, bind Y to X and change labels to characters

tidydata <- function(x, y, fids, lbls) {
  
  x <- x[, fids]
  
  merged <- cbind(y[[1]], x)
  
  merged[[1]] <- factor(merged[[1]], levels=lbls[[1]], labels=lbls[[2]])
  
  merged
  
}

test <- tidydata(xTe, yTe, ftsids, labels)

## 5) Clean variables we no longer need

rm(xTe, yTe)

## 6) Repeat points 3 to 5 but using the train data set.

xTr <- read.table("UCI HAR Dataset/train/x_train.txt")
yTr <- read.table("UCI HAR Dataset/train/y_train.txt")

train <- tidydata(xTr, yTr, ftsids, labels)

rm(xTr, yTr)

## 7) Merge the 2 data sets between them and set column names

merged <- rbind(train, test)

colnames(merged) <- c("Labels", features[ftsids, 2])

# For lowered column names
#colnames(merged) <- c("labels", tolower(features[ftsids, 2]))

## 8) Group by activity and calculate means of all columns

averages <- aggregate(merged[, -1], by=list(labels=merged$labels), mean)

## 9) Save into file

write.table(averages, "averages.txt", row.names = FALSE)