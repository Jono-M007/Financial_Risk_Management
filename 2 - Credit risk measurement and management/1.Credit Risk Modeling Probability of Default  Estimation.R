##  Step 1: Load Required Libraries

# Load the necessary packages
install.packages("tidyverse")
install.packages("caret")
install.packages("pROC")
install.packages("rpart")
install.packages("rpart.plot")

# Load necessary libraries
library(tidyverse)
library(caret)
library(pROC)
library(rpart)
library(rpart.plot)

## Step 2: Load the Dataset

# Define column names as per the UCI dataset documentation
colnames <- c ("Satus_Checking_Account", "Duration_Months", "Credit_History", 
               "Purpose", "Credit_Amount","Savings_Account_Bonds","Employment_Since",
               "Installment_Rate", "Personal_Status_Sex", "Other_Debtors", "Present_Residence_Since",
               "Property", "Age", "Other_Installment_Plans", "Housing", "Existing_Credits",
               "Job", "People_Liable", "Telephone", "Foreign_Worker", "Class")

# Read the data
data <-read.table("C:\\Users\\jomul\\OneDrive\\Desktop\\R programming\\Financial risk management\\2 - Credit risk measurement and management\\german.data",
                  header = FALSE,col.names = colnames)

# Preview
head(data)
view(data)

## Step 3: Data Cleaning and Preprocessing

# Recode the target variable : 'default' (o =Good , 1 = Bad)
data$default <- ifelse(data$Class == 2,1,0)

# drop the old 'Class' column
data <- data %>% select(-Class)

# Convert categorical variables to factors
categorical_vars <- c("Satus_Checking_Account", "Credit_History", "Purpose",
                      "Savings_Account_Bonds","Employment_Since",
                       "Personal_Status_Sex", "Other_Debtors",
                      "Property", "Other_Installment_Plans", "Housing",
                      "Job", "Telephone", "Foreign_Worker")

data[categorical_vars] <- lapply(data[categorical_vars], as.factor)

# Check structure again
str(data)

##Step 4: Split into Training and Testing Sets

# Split data : 70% train , 30% test
set.seed(123)
train_index <- createDataPartition(data$default, p =0.7 , list = FALSE)

train_data <- data[train_index, ]
test_data <- data[-train_index, ]

##Step 5: Build Logistic Regression Model

# Build logistics regression model
logit_model <- glm(default ~ ., data = train_data , family = binomial)

# Model summary
summary(logit_model)


##  Step 6: Model Prediction and Evaluation

# Predict probabilities on test set
pred_probs <- predict(logit_model, test_data, type = "response")

# Predict class (default threshold 0.5)
help("ifelse")
?ifelse
pred_class <- ifelse(pred_probs > 0.5, 1, 0)

#confusion matrix
confusionMatrix(factor(pred_class), factor(test_data$default))

## Step 7: ROC Curve and AUC Score

# ROC Curve
roc_obj <- roc(test_data$default, pred_probs)

# Plot ROC
plot(roc_obj, col ="blue", main ="ROC Curve - Logistic Regression")

# Calculate AUC
auc(roc_obj)

## Step 8: Calculate KS Statistic

# KS Statistic (Maximum distance between Sensitivity and 1-specificity)
ks_stat <- max(attr(roc_obj, "sensitivities") - attr(roc_obj,"specificities"))
print(paste("KS Statistic:", round(ks_stat,4)))






