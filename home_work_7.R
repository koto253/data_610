#### Module 9 CART Classification trees Y1 is excluded

#set the working directory 
#set the working directory
setwd("C:/Users/x-ibah/Desktop/Franklin/Data_610")

# load dataset
df <- read.csv("data89.csv")

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
   forecast, adabag, randomForest, rpart.plot, rpart)


# Y1 is excluded in this analysis
# remove Y1 IF present in column 1
### drop Y1 column col 1
df <- df %>% select(-Y1) 

# remove categorical variables OR replace them by dummy variables
# IF you need to select some variables 
# change the name of the variables
# Correlation matix with Y2 and the rest of the variabels
# question 2
round(cor(df), 2)


# List of the top variables with high correlation with Y2
high_correlated_variable_with_Y1 <- c("Y2", "CHK_ACCT", 
                                      "DURATION", "HISTORY",
                                      "SAV_ACCT", "EMPLOYMENT")


# create a new dataset with Y2 and the top variables highly correlated                                                                            "SAV_ACCT", "EMPLOYMENT")
df2 <- df[high_correlated_variable_with_Y1]

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



#############################################################################
## CART specify the tree depth=3-5
Btree2 <- rpart(Y2 ~ ., data = train_data, method = "class",
                minbucket = 1, maxdepth = 3, cp = 0.001)
# plot tree 
prp(Btree2, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10)

### var importance 
Btree2$variable.importance

### ROC curve for validation data 
valid2p <- predict(Btree2,valid_data,type = "prob")[,2]
tree.roc2 <- roc(valid_data$Y2, valid2p)
print(tree.roc2)
plot(tree.roc2)

### confusion matrix for the validation set
PredictValid2 <- predict(Btree2,valid_data,type = "class")
confusionMatrix(PredictValid2,as.factor(valid_data$Y2))

#### end ##############################################


