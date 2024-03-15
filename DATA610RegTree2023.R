#### Module 9 CART Regression trees

#set the working directory 

setwd("C:/BDataNew")

#load the required libraries/packages 

install.packages("rpart")
install.packages("rpart.plot")
install.packages("randomForest")
install.packages("xgboost")
install.packages("Matrix")
install.packages("caret")
install.packages("gains")
install.packages("forecast")
install.packages("ggplot2)

library(rpart)
library(rpart.plot)
library(randomForest)
library(xgboost)
library(Matrix)
library(caret)
library(gains)
library(forecast)
library(ggplot2)

#### Read CSV data 

Toyota <- read.csv("Toyota33.csv")

names(Toyota)

# partition

set.seed(1)  
train.index <- sample(c(1:dim(Toyota)[1]), dim(Toyota)[1]*0.6)  
valid.index <- setdiff(c(1:dim(Toyota)[1]), train.index)  
trainT <- Toyota[train.index, ]
validT <- Toyota[valid.index, ]


# RT # 1= regression tree , all variables, use "." 
tr1 <- rpart(Y1 ~ ., data = trainT, method = "anova",
             minbucket = 20, maxdepth = 4, cp = 0.001)
prp(tr1) 
tr1

# RT #2 = the same as RT#1 but with var names
# regression tree with variable names list 
# change parameters 
# minbucket=min size of end node
# Maxdepth = max levels for the tree
# cp =complexity parameter (e.g. R-square increase at each step

tr2 <- rpart(Y1 ~  Age_08_04 + KM + 
              HP + Automatic + Doors + Quarterly_Tax + 
              Mfr_Guarantee + Guarantee_Period + Airco + 
              Automatic_airco + CD_Player + Powered_Windows + 
              Sport_Model + Tow_Bar, data = trainT, 
            method = "anova", minbucket = 20, maxdepth = 4, cp = 0.001)
prp(tr2)
tr2

#variable importance for tr2
t(t(tr2$variable.importance))

# validation accuracy - RMSE
accuracy(predict(tr1, validT), validT$Y1)


# the end #################################



