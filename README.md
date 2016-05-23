Getting and Cleaning Data Course Project
=======

This is the repo for the last project of the Coursera Getting and Cleaning Data Course. The data used is from the Human Activity Recognition Using Smartphones Data Set. The raw data is automatic downloaded by the script  (if not present) from the url contained in the "url" file.
The defaul url is  [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip], but can be changed if needed. 

#To the Reviewer:

        An incomplete version of the project was submitted for evaluation, please consider the tidy data
[averaged_features.txt](https://github.com/marceloosg/cleanwc/blob/master/averaged_features.txt) in this repo 
in this repo instead the one submitted. 

Use the preview file [averaged_features_preview.txt](https://github.com/marceloosg/cleanwc/blob/master/averaged_features_preview.txt) to see  that the data is indeed tidy.


#Scripts
There is only two scripts to conduct the cleaning up and formatting the data.
The run\_analysis.R main file sources the file "get\_data.R" which contains a function 
responsible for extracting information from the raw data and outputing into a data.table.

##run\_analysis.R
This script can be break down into six steps:

	1. Retrieve Raw Data
	
	2. Extract feature descriptive names (feature.txt)
	
	3. Extract activity descriptive names (activity_labels.txt)
	
	4. Get data test and train into dataframes and merge it into one dataset
	
	5. Select only the relevant data from the merged dataset (mean and standards deviation of each measurements)
	
	6. Summarize the dataset in a new dataset with the average for each subject and activity
	
	7. Make it Tidy.

##get\_data.R
	It contains the getdata() function that implements step 4. in the main script:
This  function: receives a string variable {path} as input that can be either "test"
or "train", and outputs a dataframe with the 561 features (as described in the "UCI HAR Dataset/feature.txt" file), plus
 2 aditional columns: the first column is of type integer identifying the subject (as described in the "UCI HAR Dataset/{path}/subject\_{path}.txt"), the second column is the activity label obtained from the merging between the "UCI HAR Dataset/activity\_labels.txt" and the "UCI HAR Dataset/{path}/y\_{path}.txt" file.

This function requires the {activity\_labels} and {features} data obtained in step 2) and 3) in order to work. 


##Output
	This scripts outpus two files:
the first ouput file "test\_train.txt" corresponds to the merged data set obtained in step 5), the second output file "averaged\_features.txt" is obtained in step 6). The contents of each file is described in the "features_info.txt" (from downloaded data) and "Codebook.md" file.


##Run

To run it only needs a working internet conection and enough disk space to download  60 MB for the zipped file and 270 MB for the decompressed files.
Set the current working directory to the same as which the run_analysis.R file is located, then

Execute from rstudio console:
        source("run_analysis.R")

Execute from a bash shell:
        ./Rscript run_analysis.R
        
## Other

To see details of the the transformations performed and the variables used please consult the "Codebook.md" file.
The file "variables" contains the variables used in the "averaged\_features.txt" file.
The merged dataset contains the same mean and standard deviation variables described by the "features_info.txt" file.