#### Module 5 Logistic regression 

#set the working directory 
setwd("C:/BDataNew")

#load the required libraries/packages 

install.packages("caret")
install.packages("e1071")
install.packages("gains")
install.packages("pROC")
install.packages("janitor")
library(caret)
library(e1071)
library(gains)
library(pROC)
library(janitor)





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

percentage_of_ones <- round(mean(df$Y2 == 1) * 100, 2)
#percentage_of_zeros <- round(mean(df$Y2 == 0) * 100, 2)

names(df)

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
# Model1. Estimate Logistics Regression model with Y2 as dependent variable
# Load the necessary package
library(stats)

# Estimate the logistic regression model
model1 <- glm(Y2 ~ ., data = train_data, family = "binomial")
summary(model1)

# Question 6
# Evaluate the accuracy of Model 1 
#(report area under ROC and ROC graph) with validation data. 
#Comment of the results.



##############################################################################

# question 8
names(high_correlated_variable_with_Y1)
# Model 1B = same as Model 1A but with list variable
# full model Y2 ~ Age+Experience+Income+Family+CCAvg+Mortgage+CreditCard
names(bank1)

Logit2 <- glm(Y2~Age+Experience+Income+Family+            
                 CCAvg+Education+Mortgage+Securities_Account+ CD_Account+        
                 Online+CreditCard,
              data = trainB, family = "binomial") 
summary(Logit2)
















#### Read CSV data 

bank1 <- read.csv("Universalbank33.csv")

# partition data
set.seed(2)
train.index <- sample(c(1:dim(bank1)[1]), dim(bank1)[1]*0.6)  
trainB <- bank1[train.index, ]
validB <- bank1[-train.index, ]

# variable names
# Y2 1=Got loan  0 = didn't get a loan
names(bank1)

# show % with Y2=1 got loan
table(bank1$Y2)
# frequency with percent
tabyl(bank1$Y2, sort = TRUE)

# ***********************************************************************************************

# Model 1A  Y2 with all available variables; use "." for all
# Use training data
Logit1 <- glm(Y2 ~ ., data = trainB, family = "binomial") 
summary(Logit1)

# Use validation data
# predict with validation data
Pred1 <- predict(Logit1, validB)

# Use validation data
## Predictive qualities ROC curve for validation data 
test_prob = predict(Logit1, newdata = validB, type = "response")
test_roc = roc(validB$Y2 ~ test_prob, plot = TRUE, print.auc = TRUE)

# Use validation data
## confusion matrix with cutoff point at 0.5 with validation data ###
confusionMatrix(as.factor(ifelse(Pred1 > 0.5, 1, 0)), as.factor(validB$Y2))

# Use validation data
# cut-off = 0.7
confusionMatrix(as.factor(ifelse(Pred1 > 0.7, 1, 0)), as.factor(validB$Y2))

# Use validation data
# cut-off = 0.3
confusionMatrix(as.factor(ifelse(Pred1 > 0.3, 1, 0)), as.factor(validB$Y2))

# ***********************************************************************************************

# Model 1B = same as Model 1A but with list variable
# full model Y2 ~ Age+Experience+Income+Family+CCAvg+Mortgage+CreditCard
names(bank1)

Logit2 <- glm(Y2~Age+Experience+Income+Family+            
                CCAvg+Education+Mortgage+Securities_Account+ CD_Account+        
                Online+CreditCard,
              data = trainB, family = "binomial") 
summary(Logit2)

# Use validation data
## Predictive qualities ROC curve with validation data 
test_prob2 = predict(Logit2, newdata = validB, type = "response")
test_roc2 = roc(validB$Y2 ~ test_prob2, plot = TRUE, print.auc = TRUE)


# Use validation data
# Consusion matrix
Pred2 <- predict(Logit2, validB)
confusionMatrix(as.factor(ifelse(Pred2 > 0.5, 1, 0)), as.factor(validB$Y2))

# ***********************************************************************************************

# Model 2 with stepwise methods: "backward", "forward", "both"
# Use training data
back1 = step(Logit1,trace=0, direction="backward")
summary(back1)

# Use prediction data
## Predictive qualities: ROC curve for the back1 model 
test_prob3 = predict(back1,newdata = validB, type = "response")
test_roc3 = roc(validB$Y2 ~ test_prob3, plot = TRUE, print.auc = TRUE)

# Use prediction data
# confusion matrix
Pred3 <- predict(back1, validB)
confusionMatrix(as.factor(ifelse(Pred3 > 0.5, 1, 0)), as.factor(validB$Y2))


##### the end   ############################################################
