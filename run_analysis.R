require("data.table")
require("reshape2")

# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# read features
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# find features that measure mean and standard deviation
extract_features <- grepl("mean|std", features)

# load test data
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(x_test) = features

# extract test mean and standard deviation measurements
x_test = x_test[,extract_features]

# combine activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# combine all test data
test_data <- cbind(as.data.table(subject_test), y_test, x_test)

# load train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(x_train) = features

# extract train mean and standard deviation
x_train = x_train[,extract_features]

# combine activity labels
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# combine all train data
train_data <- cbind(as.data.table(subject_train), y_train, x_train)

# combine all data
data = rbind(test_data, train_data)
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# create tidy data
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")