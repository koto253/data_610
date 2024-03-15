#### Module 9 CART Regression trees

#set the working directory 

setwd("C:/Users/x-ibah/Desktop/Franklin/Data_610")

#load the required libraries/packages 

pacman::p_load(
   caret,
   gains,
   e1071,
   pROC,
   janitor,
   tidyverse,
   GGally,
   gplots,
   reshape,
   fastDummies,
   ggplot2,
   readr, 
   readxl,
   glmnet,
   forecast, adabag, randomForest, rpart.plot, rpart, xgboost, Matrix)

#### Read CSV data 
german_bank <- read.csv("data89.csv")

### calculate the mean of Y1
meanOfY1 <- ceiling(mean(german_bank$Y1))


### drop Y1 column col 1
german_bank <- german_bank %>% select(-Y2) 

# variable names
names(german_bank)

# correlation matrix of Y1 and all variables
round(cor(german_bank),2)

# List of the top variables with high correlation with Y2
high_correlated_variable_with_Y1 <- c("Y1", "CHK_ACCT", 
                                      "DURATION", "HISTORY",
                                      "SAV_ACCT", "EMPLOYMENT")


# create a new dataset with Y2 and the top variables highly correlated                                                                            "SAV_ACCT", "EMPLOYMENT")
testDataSet <- german_bank[high_correlated_variable_with_Y1]

# partition

set.seed(1)  
train.index <- sample(c(1:dim(testDataSet)[1]), dim(testDataSet)[1]*0.6)  
valid.index <- setdiff(c(1:dim(testDataSet)[1]), train.index)  
trainT <- testDataSet[train.index, ]
validT <- testDataSet[valid.index, ]


# Model 1 Regression Tree # 1= regression tree , all variables, use "." 
tr1 <- rpart(Y1 ~ ., data = trainT, method = "anova",
             minbucket = 20, maxdepth = 4, cp = 0.001)
prp(tr1) 
tr1

#variable importance for tr2
t(t(tr1$variable.importance))

# validation accuracy - RMSE
accuracy(predict(tr1, validT), validT$Y1)



# Optional:  Model 2 Regression Tree #2 = the same as RT#1 but with var names
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
# end model 2
# the end #################################



