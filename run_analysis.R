library(dplyr)
#read test data
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/Y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
#read train data
X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/Y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
#read activity and measurements data
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
#combine test and train data
X <- rbind(X_test, X_train)
Y <- rbind(Y_test, Y_train)
subject <- rbind(subject_test, subject_train)
#extracting positions with mean and std in 'features' which has measurements to be made as variables
variables <- features[grep("mean|std", features[,2]),] 
#with the positions obtained from above we extract the columns from X which corresponds to mean and std respectively
X <- X[,variables[,1]]
#activity names are to be described now
colnames(Y) <- "label"
Y$activity <- factor(Y$label, labels = as.character(activity_labels[,2]))
#in the extracted columns on X based on mean and std we now give column names to the data frame X
colnames(X) <- features[variables[,1],2]
#next we relate each observation to the corresponding subject which are from 1 to 30
# for that we use the subject data frame
colnames(subject) <- "subject"
combine <- cbind(X, Y$activity, subject)
# we now summarize the data for each subject by taking the mean
temp <- group_by(combine, Y$activity, subject)
data <- summarize_all(temp, funs(mean))
# create a file with the obstained tidy data 
write.table(data, file = "./tidy_data.txt", row.names = FALSE, col.names = TRUE)