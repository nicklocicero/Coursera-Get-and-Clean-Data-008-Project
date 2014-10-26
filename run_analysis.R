# start by caching NULL val into future dataframes
XTrain <- XTest <- NULL

# create run_analysis as function
run_analysis <- function() {
        # Step 0 Get and extract data
        # create filePath
        filePath <- function(...) { paste(..., sep = "/") }
        
        # download Data
        downloadData <- function() {
                # given URL
                url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                # create directory name
                downloadDir <- "data"
                
                # set zipFile
                zipFile <- filePath(downloadDir, "dataset.zip")
                # if it doesn't exist, download it
                if(!file.exists(zipFile)) { download.file(url, zipFile) }
                
                dataDir <- "UCI HAR Dataset"
                # if it's not unzipped, unzip it
                if(!file.exists(dataDir)) { unzip(zipFile, exdir = ".") }
                
                # keeps directory name
                dataDir
        }
        
        dataDir <- downloadData()
        
        # Step 1 merge the training and the test sets to create one data set.
        # create readData function to easily read data
        readData <- function(path) {
                read.table(filePath(dataDir, path))
        }
        
        # Read and cache XTrain and XTest data
        if(is.null(XTrain)) { XTrain <<- readData("train/X_train.txt") }
        if(is.null(XTest))  { XTest  <<- readData("test/X_test.txt") }
        # merge XTrain and XTest
        merged <- rbind(XTrain, XTest)
        
        # add names to merged data
        featureNames <- readData("features.txt")[, 2]
        names(merged) <- featureNames
        
        # Step 2 Extract only the measurements on the mean and standard deviation for each measurement.
        # Limit to columns with feature names matching mean() or std():
        matches <- grep("(mean|std)\\(\\)", names(merged))
        limited <- merged[, matches]
        
        # Step 3 Use descriptive activity names to name the activities in the data set.
        # Get the activity data and map to nicer names:
        yTrain <- readData("train/y_train.txt")
        yTest  <- readData("test/y_test.txt")
        yMerged <- rbind(yTrain, yTest)[, 1]
        
        activityNames <-
                c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
        activities <- activityNames[yMerged]
        
        # Step 4 Appropriately label the data set with descriptive variable names.
        # Change t to Time, f to Frequency, mean() to Mean and std() to StdDev
        # Remove extra dashes and BodyBody naming error from original feature names
        names(limited) <- gsub("^t", "Time", names(limited))
        names(limited) <- gsub("^f", "Frequency", names(limited))
        names(limited) <- gsub("-mean\\(\\)", "Mean", names(limited))
        names(limited) <- gsub("-std\\(\\)", "StdDev", names(limited))
        names(limited) <- gsub("-", "", names(limited))
        names(limited) <- gsub("BodyBody", "Body", names(limited))
        
        # Add activities and subject with nice names
        subjectTrain <- readData("train/subject_train.txt")
        subjectTest  <- readData("test/subject_test.txt")
        subjects <- rbind(subjectTrain, subjectTest)[, 1]
        
        tidy <- cbind(Subject = subjects, Activity = activities, limited)
        
        # Step 5 Create a second, independent tidy data set with the average of each variable for each activity and each subject.
        library(plyr)
        # Column means for all but the subject and activity columns
        limitedColMeans <- function(data) { colMeans(data[,-c(1,2)]) }
        tidymean <- ddply(tidy, .(Subject, Activity), limitedColMeans)
        names(tidymean)[-c(1,2)] <- paste0("Mean", names(tidymean)[-c(1,2)])
        
        # Write file
        write.table(tidymean, "tidymean.txt", row.names = FALSE)
        
        # Also return data
        tidymean
}

# Use to check that the tidymean.txt is properly readable
checkData <- function() {
        read.table("tidymean.txt", header = TRUE)
}

run_analysis()
