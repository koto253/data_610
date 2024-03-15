install.packages('tidyverse')
library(tidyverse)

# setting up directory
setwd("C:/Users/x-ibah/Desktop/Franklin/Data_610")

df <- read.csv('data89_updated.csv')
df

names(df)

new_var <- c("OUTCOME1.Y1", "DURATION" , "AGE" , "CHK_ACCT")

df2 <- df[new_var]
df2

# scatterPlot 
plot(df2$OUTCOME1.Y1, df2$DURATION)
# histogram 
hist(df2$OUTCOME1.Y1,
     xlab = 'outcome 1',
     ylab = 'frequency',
     col = 'blue')

#boxplot 
boxplot(df2$OUTCOME1.Y1)

# correlation 
round(cor(df2), 2)

# Partition the dataset into training set (60%) and validation set (40%). 
# Call the new datasets: "mytrain" and "myvalid" respectively.
# partition the data 60%/40%

set.seed(1)
train.rows <- sample(rownames(df2), dim(df2)[1]*0.6)
train_data <- df2[train.rows, ]

valid.rows <- setdiff(rownames(df2), train.rows) 
valid_data <- df2[valid.rows, ]

hist(train_data$OUTCOME1.Y1)
hist(valid_data$OUTCOME1.Y1)


