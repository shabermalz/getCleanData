library(plyr)
library(dplyr)
locotest1 <- "/Users/habbes/getCleanDataProject/UCI HAR Dataset/test/"
locotest2 <- "/Users/habbes/getCleanDataProject/UCI HAR Dataset/train/"
locotest3 <- "/Users/habbes/getCleanDataProject/UCI HAR Dataset/features.txt"
locotest4 <- "/Users/habbes/getCleanDataProject/UCI HAR Dataset/activity_labels.txt"
wid <- rep(c(-1,15), 561)

activityLabels <- read.table(locotest4, col.names = c("num", "activity"), sep = " " )



features <- read.table(locotest3, col.names = c("num", "statistic"), sep = " " )


extract <-grep("-mean\\(\\)|-std\\(\\)", features$statistic)

subject_test <- read.fwf(paste(locotest1, "subject_test.txt", sep = ""), widths = 2 )
X_test <- read.fwf(paste(locotest1, "X_test.txt", sep = ""), widths = wid  )
names(X_test) <- features$statistic
X_test1 <- X_test[,extract]
y_test <- read.fwf(paste(locotest1, "y_test.txt", sep = ""), widths = 1 )


subject_train <- read.fwf(paste(locotest2, "subject_train.txt", sep = ""), widths = 2 )
X_train <- read.fwf(paste(locotest2, "X_train.txt", sep = ""), widths = wid  )
names(X_train) <- features$statistic
X_train1 <- X_train[,extract]
y_train <- read.fwf(paste(locotest2, "y_train.txt", sep = ""), widths = 1 )

subject_test <- rename(subject_test,  subject = V1)
subject_train <- rename(subject_train,  subject = V1)
y_test <- rename(y_test, activity = V1)
y_test$activity <- as.factor(y_test$activity)
levels(y_test$activity) <- activityLabels$activity
y_train <- rename(y_train, activity = V1)
y_train$activity <- as.factor(y_train$activity)
levels(y_train$activity) <- activityLabels$activity

part1 <- data.frame(subject_test,y_test,  X_test1)
part2 <- data.frame(subject_train, y_train, X_train1)

part3 <- rbind(part1, part2)
part4 <- arrange(part3, subject, activity)
part5 <- group_by(part4, subject, activity)
final <- summarize_each(part5, funs(mean(., na.rm=TRUE)))

write.table(final, "/Users/habbes/getCleanDataProject/final.txt", row.names=FALSE)

