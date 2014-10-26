Coursera-Get-and-Clean-Data-008-Project
=======================================
R Script merges the test and train sets from Human Activity Recognition Using Smartphones Dataset and pulls in the subject identifiers and activity labels to create a single data set. Then it translates the activity identifiers into human-readable names while keeping only the mean and standard deviation variables. Those variables are averaged by taking the mean for each subject/activity pair. The data is in "wide" format as described by Wickham; there is a single row for each subject/activity pair, and a single column for each measurement.

The final data set will be created as tidyMeans.txt file, and read into R with read.table("tidymean.txt", header = TRUE). A detailed description of the variables can be found in CodeBook.md with the basic naming as:

Mean{timeOrFreq}{measurement}{meanOrStd}{XYZ}

timeOrFreq is either Time or Frequency (measurement comes from Time or Freq), measurement is one of the original measurement featurs, meanOrStd is either Mean or StdDev (measurement was mean or standard deviation var), and XYZ likewise is X, Y, or Z (axis for measurement, or nothing).
