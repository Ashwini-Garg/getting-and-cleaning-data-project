Getting and Cleaning Data Project
=================================

This is a project for Getting and Cleaning Data course on Coursera. The
goal of this project is to prepare tidy data to be used for later data
analysis.

Details of the project can be found here:
<https://class.coursera.org/getdata-004/human_grading/view/courses/972137/assessments/3/submissions>

This repository contains 2 files:

-   run\_analysis.R - The R script which takes in the raw data files and
    creates a tidydata.txt file.

-   CodeBook.md - This markdown file describes the variables, data, and
    the transformations performed by the run\_analysis script to clean
    up the data.

To run the script, you need to perform the following steps:

-   Download the run\_analysis.R file to your working directory.

-   Get the data files for the project from
    <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
    and unzip.

-   Open run\_analysis.R in RStudio and change line number 20 to
    represent the directory containing the data.

        datafolder <- "~/Documents/training/MachineLearning/videos/getting and cleaning data/project/UCI HAR Dataset/"

-   The run\_analysis.R file reads the following data files from the UCI
    HAR Dataset:
    -   activity\_labels.txt
    -   features.txt
    -   train/subject\_train.txt
    -   train/X\_train.txt
    -   train/y\_train.txt
    -   test/subject\_test.txt
    -   test/X\_test.txt
    -   test/y\_test.txt
-   Set the working directory in R to the folder containing the
    run\_analysis script and run the script.

        setwd("~/work/r/workspace/getting and cleaning data/project")
        source("run_analysis.R")

-   The tidydata.txt will be created in current working directory. To
    read this file, run this in R

        tidydata <- read.table("./tidydata.txt",header=TRUE)
