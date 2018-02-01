# CleaningData
Repo for Assignment Project -- Coursera
run_analysis.R = code to generate tidy data sets for Coursera Data Scientist Specialization – Getting and Cleaning Data Course Project

This README.md file details the logic and flow of the source code, please see the accompanying code book for variable descriptions.

This script does the following (after reading in the appropriate datasets):
1.	Merges the training & test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviations for each measurement.
3.	Uses descriptive activity names to name the activities in the data set.
4.	Appropriately labels the data set with descriptive variable names.
5.	Creates a 2nd, independently tidy data set with the average of each variable for each activity and each subject.

The first 3 sections of the code set the working directories to the appropriate paths and read in the necessary data files ("http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"), downloaded from the UCI Machine Learning Repository (“http://archive.ics.uc.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones”).   Use of the data is permissible by listing the following citing request:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

The read.table function in R is used to read in and store data to variables: 
•	X_test
•	y_test
•	subject_test
•	subject_train
•	X_train
•	y_train
•	features
•	activity_labels
 

The next section calls the library “tidyr” that contains functions used later in the source code, specifically the “unite” function.

Prior to merging the “X_test” and “X_train” data sets some manipulation to each data set was done so that the merged data set would be conducive to analysis beyond the scope of the project, specifically, adding the variables “subject_test” and “subject_train” to their respective data sets.

In preparation for merging the “X_test” and “X_train” data sets, which contain the primary variables to be analyzed, the code replaces the variable names (in both data sets) from a sequence of V1, V2…,Vn to the formal variable names provided in the “features” data set – the UCI documentation provides the insight that these are the correct variable names and quick analysis using the dim() function shows that the number of observations in “features” = the number of variables in both “X_test” and “X_train”.  The replacing is accomplished using the colnames() and as.character() functions in R.

The next section of code adds variables “SubjectNum” to each data set, “X_test” and “X_train”, using the vectors in “subject_test” and “subject_train” which represent the 30 individuals, as integers from 1-30, that were part of either the test group (9 individuals) or the train group (21 individuals).  This information is provided in the UCI documentation and one can see from the dim() function in R that the data sets “X_test” and “subject_test” and “X_train” and “subject_train” have an equal number of observations, respectively.  Adding these variables early, and prior to merging, allows for more robust analysis of the merged data set and ensures correct mapping of records to subject number.

Next, the activity labels are added to the “y_test” and “y_train” data sets by creating a new variable “$activity” in each respective data set.  This is done using the match() and unlist() function in R and comparing the V1 vectors in the original data sets “y_test” and “y_train” with the V2 vector in “activity_labels” – “activity_labels” is a “mapping” matrix of the integer to corresponding labels.  “y_test$activty” and “y_train$activity” are created as a result.

The code then adds the newly created “y_test$activity” and “y_train$activity” to the “X_test” and “X_train” datasets thru simple assignments, creating the “X_test$activity” and “X_train$activity” variables.

At this point, the “X_test” and “X_train” data sets have 3 additional variables added to their data sets, one representing subject number (“$SubjectNum”), one representing the dataset origin (“$Dataset”) and one representing activity, as a label not integer (“$activity”).

The data sets “X_test” and “X_train” are now merged into a new data frame called “test_train_ds” using the rbind() function in R.  This data frame represents the 1st tidy data set which contains:
•	Merged data from test and training data sets
•	Descriptive activity names to name the activities in the data set
•	Appropriately labels the data set with descriptive variable names

From here, the code subsets the 1st tidy data set “test_train_ds” to extract on the “mean” and “standard deviation” (“std”) variables into a 2nd tidy data set called “musig_ds”.  “musig_ds” is created using the grepl() and names() functions in R with the 1st arguments of grepl() consisting of “OR” conditions searching for “mean|Mean|std|Subject|activity”.  “Subject” and “activity” are included so the new data frame will be constructed in a manner that allows calculating the mean by subject and by activity and creating the final tidy data set.  This section accomplishes the task:
•	Extracts only the measurements on the mean and standard deviations for each measurement

The final section of code uses the unite() function, in the library(tidyr), to create a new variable “Subjact” which combines and replaces the 2 variables, $SubjNum and $activity.  This step also creates the new and tidy data set called “musig_out”.  From here the aggregate(), list(), and mean functions in R are used to modify “musig_out” such that it now contains the means by “Subjact” which, from above, represents by subject and by activity.  This is the final, tidy data set which is output to both the monitor using the View() function and to the “musig_out.txt”, file with row.names = FALSE, using the write.table() function in R.  This accomplishes the last task:
•	Creates a 2nd, independently tidy data set with the average of each variable for each activity and each subject.


