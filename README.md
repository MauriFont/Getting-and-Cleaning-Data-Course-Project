# Getting-and-Cleaning-Data-Course-Project

## Code explanation

### 1) Download data

First download the data sets which are stored in a zip file and unzip it.

Link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip *

```R
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip")

unzip("data.zip")
```

The files will be unziped in a directory called "UCI HAR Dataset".

### 2) Loading features and activity labels.

```R
features <- read.table("UCI HAR Dataset/features.txt")
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
```

Also prepare a variable that contains the ids of the columns that we care about (means ands STDs).

```R
ftsids <- grep("mean|std", features[[2]])
```

We'll use this later to subset the data sets.

### 3) Loading test data set

We could load all data sets at the same time but it would require more memory, so I decided to do it separately.

First load both X and Y of the test data set.

```R
xTe <- read.table("UCI HAR Dataset/test/x_test.txt")
yTe <- read.table("UCI HAR Dataset/test/y_test.txt")
```

### 4) Create a function to partially tidy the data sets

We use a function because we'll need to run this code for both data sets.

```R
tidydata <- function(x, y, fids, lbls) {
  
  # Just keep the columns we want
  x <- x[, fids]
  
  #Join the Y (activity labels) column to the data frame
  merged <- cbind(y[[1]], x)
  
  #Change the labels numbers with their character meanings
  merged[[1]] <- factor(merged[[1]], levels=lbls[[1]], labels=lbls[[2]])
  
  merged
  
}
```

Technically the arguments "fids" and "lbls" are not needed since we can just call the ones in global scope directly from inside the function, but it is usually good practice to include them.

### 5) Tidy test data set and clean.

Use the function from previous point to tidy the test data set.

```R
test <- tidydata(xTe, yTe, ftsids, labels)

rm(xTe, yTe)
```

We clean the data we'll no longer use so it doesn't occupy memory.

### 6) Repeat steps 3 to 5 with the train data set

```R
xTr <- read.table("UCI HAR Dataset/train/x_train.txt")
yTr <- read.table("UCI HAR Dataset/train/y_train.txt")

train <- tidydata(xTr, yTr, ftsids, labels)

rm(xTr, yTr)
```

### 7) Merge the two data sets into one and add column names

```R
merged <- rbind(train, test)

colnames(merged) <- c("Labels", features[ftsids, 2])

# For lowered column names
#colnames(merged) <- c("labels", tolower(features[ftsids, 2]))
```

I let the column names with camel case by default because it's easier to read.

### 8) Create the avarage data set based on the previous one

```R
averages <- aggregate(merged[, -1], by=list(labels=merged$labels), mean)
```

### 9) Save the data set in a text file

```R
write.table(averages, "averages.txt", row.names = FALSE)
```

* Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
