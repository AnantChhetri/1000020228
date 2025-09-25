# 📌 Step 1: Load Libraries
library(tidyverse)
library(caret)
library(randomForest)
library(corrplot)

# 📌 Step 2: Load Dataset
# UCI provides the dataset inside a ZIP file, so we download and extract it
zip_url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip"
temp <- tempfile()
download.file(zip_url, temp)
unzip(temp, exdir = tempdir())
student <- read.csv(file.path(tempdir(), "student-mat.csv"), sep = ";", header = TRUE)
unlink(temp)   # cleanup temporary file

# 📌 Step 3: Data Preprocessing
# Convert categorical variables
student$sex <- factor(student$sex)
student$address <- factor(student$address)
student$schoolsup <- factor(student$schoolsup)
student$famsup <- factor(student$famsup)

# Create binary target variable: Pass/Fail
student$Performance <- ifelse(student$G3 >= 10, "Pass", "Fail")
student$Performance <- factor(student$Performance)

# 📌 Step 4: Exploratory Data Analysis
summary(student)
table(student$Performance)

# Correlation plot of numeric features
corrplot(cor(student[, sapply(student, is.numeric)]), method = "color")

# Distribution of grades
ggplot(student, aes(x = G3, fill = Performance)) +
  geom_histogram(bins = 15, alpha = 0.7, position = "identity")

# 📌 Step 5: Split Data (Train/Test)
set.seed(123)
trainIndex <- createDataPartition(student$Performance, p = 0.7, list = FALSE)
train <- student[trainIndex, ]
test <- student[-trainIndex, ]

# 📌 Step 6: Logistic Regression Model
log_model <- glm(Performance ~ G1 + G2 + studytime + failures, 
                 data = train, family = binomial)
summary(log_model)

log_pred <- predict(log_model, newdata = test, type = "response")
log_pred_class <- ifelse(log_pred > 0.5, "Pass", "Fail")
confusionMatrix(as.factor(log_pred_class), test$Performance)

# 📌 Step 7: Decision Tree
library(rpart)
library(rpart.plot)

tree_model <- rpart(Performance ~ G1 + G2 + studytime + failures, data = train, method = "class")
rpart.plot(tree_model)

tree_pred <- predict(tree_model, newdata = test, type = "class")
confusionMatrix(tree_pred, test$Performance)

# 📌 Step 8: Random Forest
rf_model <- randomForest(Performance ~ G1 + G2 + studytime + failures,
                         data = train, ntree = 100)
rf_pred <- predict(rf_model, newdata = test)
confusionMatrix(rf_pred, test$Performance)

# 📌 Step 9: Compare Models
models <- c("Logistic Regression", "Decision Tree", "Random Forest")
accuracy <- c(
  confusionMatrix(as.factor(log_pred_class), test$Performance)$overall["Accuracy"],
  confusionMatrix(tree_pred, test$Performance)$overall["Accuracy"],
  confusionMatrix(rf_pred, test$Performance)$overall["Accuracy"]
)

results <- data.frame(Model = models, Accuracy = accuracy)
print(results)

# 📌 Step 10: Visualization of Model Performance
ggplot(results, aes(x = Model, y = Accuracy, fill = Model)) +
  geom_bar(stat = "identity", width = 0.5) +
  ylim(0,1) +
  ggtitle("Model Accuracy Comparison")





