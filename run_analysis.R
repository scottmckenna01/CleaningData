##
##  "run_analysis.R" script
##  
##  Using data from "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
##  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
##
##  [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition
##  on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted
##  Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
##
##  This script does the following (after reading in the appropriate datasets):
##    1.  Merges the training & test sets to create one data set.
##    2.  Extracts only the measurements on the mean and standard deviations for each measurement.
##    3.  Uses descriptive activity names to name the activities in the data set.
##    4.  Appropriately labels the data set with descriptive variable names.
##    5.  Creates a 2nd, independently tidy data set with the average of each variable for each activity and each subject.
##
##  setwd() and read in text files
##
  setwd("C:/KCAlphaALL/Reposit/Scott/Coursera/Course3/Week4/UCI HAR Dataset/test")
  subject_test <- read.table("subject_test.txt", quote="\"", comment.char="")
  X_test <- read.table("X_test.txt", quote="\"", comment.char="")
  y_test <- read.table("y_test.txt", quote="\"", comment.char="")
##
  setwd("C:/KCAlphaALL/Reposit/Scott/Coursera/Course3/Week4/UCI HAR Dataset/train")
  subject_train <- read.table("subject_train.txt", quote="\"", comment.char="")
  X_train <- read.table("X_train.txt", quote="\"", comment.char="")
  y_train <- read.table("y_train.txt", quote="\"", comment.char="")
##
  setwd("C:/KCAlphaALL/Reposit/Scott/Coursera/Course3/Week4/UCI HAR Dataset")
  features <- read.table("features.txt", quote="\"", comment.char="")
  activity_labels <- read.table("activity_labels.txt", quote="\"", comment.char="")
##
##  Load libraries
##  

  library(tidyr)
##
##  merge variable/column names from "features" to X_test and X_train
##
  colnames(X_test)[1:561] = as.character(features[,2])
  colnames(X_train)[1:561] = as.character(features[,2])
##
##  add subjectNum & dataset variables to test and train data.frames
##  
  X_test$SubjectNum <- subject_test$V1
  X_train$SubjectNum <- subject_train$V1
  X_test$Dataset <- "Test"
  X_train$Dataset <- "Train"
##  
##  add activity labels to y_test & y_train
##  
  y_test$activity <- activity_labels$V2[match(unlist(y_test), activity_labels$V1)]
  y_train$activity <- activity_labels$V2[match(unlist(y_train), activity_labels$V1)]
##
##  add activity variable to test & train data.frames
##  
  X_test$activity <- y_test$activity
  X_train$activity <- y_train$activity
##
##  combine test & train into 1 data.frame -- TIDY DATA set #1, full dataset of call variables
##
  test_train_ds <- rbind(X_test, X_train)
##
##  subset test_train_ds data.frame to mean & std only dataset -- musig_ds
##  
  musig_ds <- test_train_ds[, grepl("mean|Mean|std|Subject|activity", names(test_train_ds))]
##
##  create tidy data subset of musig_ds, containing means for each variable for each activity and each subject
##
  musig_out <- unite(musig_ds, Subjact, SubjectNum:activity, sep="")
  musig_out <- aggregate(musig_out[,1:86], list(musig_out$Subjact), mean)
  musig_out <- separate(musig_out, Group.1, into = c("SubjNum", "activity"), sep = 2)
  View(musig_out)
  write.table(musig_out, "musig_out.txt", row.names = FALSE)
  