## Import train files section
# Import train activity labels with no header
train_y <- read.table("Y_train.txt", header = FALSE)

# Import column names from features.txt file, features specified in 2nd column
col_names <- read.table("features.txt", sep = "", header = FALSE)

# Import subject attribute from subject_train.txt 
train_subject <- read.table("subject_train.txt", sep = "", header = FALSE)

# Import training dataset with no header and column names stored in 2nd of col_names
df_train <- read.table("X_train.txt", sep = "", header = FALSE, dec = ".", col.names = col_names$V2)

# Compose subject, activity label and train datasets in one dataframe
df_train <- cbind(train_subject, train_y, df_train)

# Rename columns of subject and activity labels
names(df_train)[1] <- "subject"
names(df_train)[2] <- "activity_labels"


## Import test files section
# Import test activity labels with no header
test_y <- read.table("Y_test.txt", header = FALSE)

# Import subject attribute from subject_train.txt 
test_subject <- read.table("subject_test.txt", sep = "", header = FALSE)

# Import training dataset with no header and column names stored in 2nd of col_names
df_test <- read.table("X_test.txt", sep = "", header = FALSE, dec = ".", col.names = col_names$V2)

# Compose subject, activity label and train datasets in one dataframe
df_test <- cbind(test_subject, test_y, df_test)

# Rename columns of subject and activity labels
names(df_test)[1] <- "subject"
names(df_test)[2] <- "activity_labels"


## Merging training and testing datasets into a full dataset
df_full <- rbind(df_train, df_test)


## Renaming Activity labels
# Read descriptive activity labels into dataframe 
activity_labels <- read.table("activity_labels.txt", sep = "", header = FALSE)

# Rename digital activity labels to descriptive activity labes that match
df_full$activity_labels <- activity_labels[match(df_full$activity_labels, activity_labels$V1), 2]


## Extracting only the measurements on the mean and standard deviation for each measurement
df_mean_sd <- df_full %>% select(matches("mean|std"))


## Making independent dataset with the average of each variable for each activity and each subject
df_summary <- df_full %>% group_by(activity_labels, subject) %>% summarise_all(funs(mean))