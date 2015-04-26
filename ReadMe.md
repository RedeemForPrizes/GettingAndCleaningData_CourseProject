---
title: "ReadMe.md"
author: "Harvey Siewert"
date: "April 25, 2015"
output: html_document
---

     Assignment:
     
     Getting and Cleaning Data
     by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD
     
     Week 3 Course Project
     
     Required to submit: 
       1) a tidy data set as described below, 
       2) a link to a Github repository with your script for performing the analysis, and 
       3) a code book that describes the variables, the data, and any transformations or 
          work that you performed to clean up the data called CodeBook.md. 

Using data obtained from:
    
                 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The R script included in this archive is a R script called 

        run_analysis.R 
        
and performs the following:
        
     1) Labels the data with descriptive variable names. 
     2) Merges training and the test sets to create one data set.
     3) Uses descriptive activity names to name the activities in the data set. 
     4) Extracts only the measurements on the mean and standard deviation for each measurement.
     5) Using the data set in step 4, creates a second, independent tidy data set with the average of 
        each variable for each activity and each subject.
      
To use the script:

     1) Unzip the study data and rename the directory to "UCI_HAR_Dataset"
     2) Place the run_analysis.R script in the top level directory
     3) Execute the script using R


The directory layout should look similar to:

    TopLevelDir/
        ├── run_analysis.R
        ├── UCI_HAR_Dataset
        │   ├── test
        │   └── train
                                                                                                   
    