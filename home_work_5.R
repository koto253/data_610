#### Module 5 regression

#set the working directory
setwd("C:/Users/x-ibah/Desktop/Franklin/Data_610")


#load the required libraries/packages 
pacman::p_load(
  tidyverse,
  janitor,
  GGally,
  gplots,
  reshape,
  fastDummies,
  ggplot2,
  readr, 
  caret,
  readxl,
  glmnet,
  forecast)

#### Read CSV data 
df <- read.csv("data89_updated.csv")

summary(df)

mean(df$OUTCOME1.Y1)

names(df)

# question 2
round(cor(df), 2)


#question 3
high_correlated_variable <- c("OUTCOME1.Y1", "DURATION", "TELEPHONE", 
                              "JOB", "INSTALL_RATE", "REAL_ESTATE", 
                              "PROP_UNKN_NONE", "USED_CAR")

# Create a new dataset called work with Y1 and the top variables with high
# Correlation with Y1( +/-)
work <- df[high_correlated_variable]

# question 4
# partition the data 60%/40%
set.seed(1) # set seed at 1

# training dataset
train.rows <- sample(rownames(work), dim(work)[1]*0.6)
train_data <- work[train.rows, ]

# validation dataset
valid.rows <- setdiff(rownames(work), train.rows) 
valid_data <- work[valid.rows, ]

# question 5
# use lm() to run a linear regression of Y! on all predictors in the
# train the model on training partition
regress1 <- lm(OUTCOME1.Y1 ~ ., data = train_data)

# show regression model
summary(regress1)

# question 6
# use predict() to make predictions on a new set. 
prediction1 <- predict(regress1, valid_data)
# ME RMSE MAE MPE MAPE
accuracy(prediction1, valid_data$OUTCOME1.Y1)

residuals <- valid_data$OUTCOME1.Y1 - prediction1 # same output the code above
RMSE <- sqrt(mean(residuals^2))
RMSE

# question 7
# use step() to run stepwise regression. 3 ways: "backward", "forward", or "both"
names(work)

regress2 <- lm(OUTCOME1.Y1 ~ DURATION + TELEPHONE + 
                 JOB + INSTALL_RATE + 
                 REAL_ESTATE + PROP_UNKN_NONE + 
                 USED_CAR, data = train_data)
formula(regress2)

Step1 <- step(regress2, direction = "backward")
summary(Step1)

### validation
Step1_pred <- predict(Step1, valid_data)

### Accuracy - errors, RMSE
accuracy(Step1_pred, valid_data$OUTCOME1.Y1)


















# remove some variables/categorical variables or create dummies: > 1 var
#Toyota2 <- subset(Toyota, select = -c(Id,Model,Fuel_Type,Color ))

# or create dummies
library(fastDummies)

# create dummies for variable Model  
Toyota_dummies <- dummy_cols(Toyota,
                              select_columns = "Model",
                              remove_most_frequent_dummy = TRUE,
                              remove_selected_columns = TRUE)

# correlation
cor.mat <- round(cor(Toyota2),2) 
cor.mat 

###  select some variables and create a new file 
myvars <- c("Price","Age_08_04","KM","HP","CC","Doors","Weight","Mfg_Year")
Toyota3 <- Toyota2[myvars]

# check the mean for Y1
summary(Toyota3)

# partition the data
set.seed(1)
train.rows <- sample(rownames(Toyota3), dim(Toyota3)[1]*0.6)
train1 <- Toyota3[train.rows, ]

valid.rows <- setdiff(rownames(Toyota3), train.rows) 
valid1 <- Toyota3[valid.rows, ]

# use lm() to run a linear regression of Price on all predictors in the
# train the model on training partition

regress1 <- lm(Price ~ ., data = train1)
# show regression model
summary(regress1)

# use predict() to make predictions on a new set. 
regress1Pred <- predict(regress1, valid1)
# ME RMSE MAE MPE MAPE
accuracy(regress1Pred, valid1$Price)

#### reg with var names ############################################
#fit the model
regress2 <- lm(Price ~ Age_08_04 + KM + HP + CC + Doors + Weight +Mfg_Year, data = train1)
formula(regress2)
# show model
summary(regress2)

# validation
regress2Pred <- predict(regress2, valid1) # use valid data
# ME RMSE MAE MPE MAPE
accuracy(regress2Pred, valid1$Price)

# use step() to run stepwise regression. 3 ways: "backward", "forward", or "both"

Step1 <- step(regress1, direction = "backward")
summary(Step1)

### validation
Step1.pred <- predict(Step1, valid1)

### Accuracy - errors, RMSE
accuracy(Step1.pred, valid1$Price)

# end

