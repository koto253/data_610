#set the working directory
setwd("C:/Users/x-ibah/Desktop/Franklin/Data_610")


#load the required libraries/packages 
pacman::p_load(
   caret,
   gains,
   e1071,
   pROC,
   janitor)

#### Read CSV data 
df <- read.csv("data89.csv")

#table(df$Y2)
table(df$Y2)

percentage_of_ones <- round(mean(df$Y2 == 1) * 100, 2)
# percentage_of_zeros <- round(mean(df$Y2 == 0) * 100, 2)


# To drop a single column named 'column_to_drop'
new_df <- df %>% select(-Y1)
new_df

# Correlation matix with Y2 and the rest of the variabels
# question 2
round(cor(new_df), 2)

# List of the top variables with high correlation with Y2
high_correlated_variable_with_Y1 <- c("Y2", "CHK_ACCT", 
                                      "DURATION", "HISTORY",
                                      "SAV_ACCT", "EMPLOYMENT")

# Question 3
# create a new dataset with Y2 and the top variables highly correlated                                                                            "SAV_ACCT", "EMPLOYMENT")
df2 <- new_df[high_correlated_variable_with_Y1]

# Question 4
# Partition the data in 60% training and 40% validation 
# Use SEED(1)
set.seed(1) # set seed at 1

# training dataset
train.rows <- sample(rownames(df2), dim(df2)[1]*0.6)
train_data <- df2[train.rows, ]

# validation dataset
valid.rows <- setdiff(rownames(df2), train.rows) 
valid_data <- df2[valid.rows, ]

# Question 5
##  Model1. Estimate Logistics Regression model with Y2 as dependent variable
##  Estimate the logistic regression model
model1 <- glm(Y2 ~ ., data = train_data, family = "binomial")
summary(model1)

# Question 6
## Evaluate the accuracy of Model 1 
## (report area under ROC and ROC graph) with validation data. 
## Comment of the results.

## Use validation data
## predict with validation data
Pred1 <- predict(model1, valid_data)

# Use validation data
## Predictive qualities ROC curve for validation data 
test_prob = predict(model1, newdata = valid_data, type = "response")
test_roc = roc(valid_data$Y2 ~ test_prob, plot = TRUE, print.auc = TRUE)
test_roc


# question 7 
## Present separate confusion matrices, overall accuracy, sensitivity and 
## specificity for 3 cut-off points for Model 1:
# Use validation data
## confusion matrix with cutoff point at 0.25 with validation data ###
confusionMatrix(as.factor(ifelse(Pred1 > 0.25, 1, 0)), as.factor(valid_data$Y2))

# Use validation data
# cut-off = 0.5
confusionMatrix(as.factor(ifelse(Pred1 > 0.5, 1, 0)), as.factor(valid_data$Y2))

# Use validation data
# cut-off = 0.75
confusionMatrix(as.factor(ifelse(Pred1 > 0.75, 1, 0)), as.factor(valid_data$Y2))


# question 8
names(df2)
# Model 1B = same as Model 1A but with list variable
# full model Y2 ~ CHK_ACCT+DURATION+HISTORY+SAV_ACCT+EMPLOYMENT

model2 <- glm(Y2 ~ CHK_ACCT+DURATION+HISTORY+SAV_ACCT+EMPLOYMENT,
              data = train_data, family = "binomial") 
summary(model2)

# Model 2 with stepwise methods: "backward", "forward", "both"
# Use training data
back1 = step(model2,trace=0, direction="backward")
summary(model2)

# Use prediction data
## Predictive qualities: ROC curve for the back1 model 
test_prob3 = predict(back1,newdata = valid_data, type = "response")
test_roc3 = roc(valid_data$Y2 ~ test_prob3, plot = TRUE, print.auc = TRUE)
test_roc3


# Use prediction data
# confusion matrix
Pred3 <- predict(back1, valid_data)
confusionMatrix(as.factor(ifelse(Pred3 > 0.5, 1, 0)), as.factor(valid_data$Y2))


read.












