Code Book
=========
This code book describes the data, transformations and variables used to produce a tidy data set.

#Data

The data used is from the Human Activity Recognition Using Smartphones Data Set. The raw data is automatic downloaded by the script  (if not present) from the url contained in the "url" file.

#Output Variables

1. The variables of the  "averaged\_features.txt" file are enumerated in the "variables.txt" file
2. The variables of the  "test\_train.txt" file are the same of the ones described in the downloaded "feature\_info.txt" file.
3. The "activities"  variable corresponds to the ones enumerated in the "activity_label.txt" file from download data.
4. The "subject" variable corresponds to a number identification from 1 to 30 (as described in the raw data).

#Transformations

1. To retrieve Raw Data:
  * I used the *download.file* function to download the raw data from the url in the "url" file.
  * I used the *unzip* function to decompress the raw data into the current directory.
2. To Extract feature descriptive names (feature.txt):
  * The features variable names are read from the "UCI HAR Dataset/features.txt" file with *read.csv* function 
  * Put the result in the {feature} variable. 
  * These are used to name the columns of the merged data set.
3. Extract activity descriptive names (activity\_labels.txt):
  * The activity description names are read from the ""UCI HAR Dataset/activity\_labels.txt"" file with *read.csv* function.   
  * Put result in the {activity\_label} variable. 
  * They are used to substitute the number code of the activity into corresponding descriptive name.
4. Get data test and train into datatables and merge it into one dataset:
  * Sourcing the "get_data.R":
        * We get a function that outputs a data table contaning the 561 features as columns plus the subject id and the activity as aditional columns.
  * Calling the *get_data* function with "test" as input outputs a data table into the {test} variable.
  * Calling the *get_data* function with "train" as input outputs a data table into the {train} variable.
  * Finally the data is merged via *rbindlist* function into the {merged} variable.
5. Select only the relevant data from the merged dataset (mean and standards deviation of each measurements)
  * We use the *select* to select the columns
  * *colnames* to get a string with all features from the merged 
  * *grep* function to filter only the "mean" and "standard deviation" columns from the {merged} data.table.
  * The merged data table is written in the "test_train.txt" file.
6. Summarize the dataset in a new tidy dataset with the average for each subject and activity:
  * We use *lapply* to apply the *mean* function to the columns of the {merged} data.table and group by subject and activities.
7. Make it Tidy.
  * Use *gather* , *mutate* and arrange functions from the tidyr library to make data tidy.
  * Transform the old feature names into a more descriptive one with the *sub* function. 
  * Substituition occurs according to the table described in the "variables.txt" file.
  * The Tidy data set is written in the "averaged_features.txt" file.
