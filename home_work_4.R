# PART I
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Define the components
classified_record_as_fraudulent <- 88
classified_record_as_non_fraudulent <- 952

true_positive <- 30
false_positive <- classified_record_as_fraudulent - true_positive

true_nagative <- 920
false_nagative <- classified_record_as_non_fraudulent - true_nagative

# Calculate the overall ERROR RATE
error_rate <- (false_positive + false_nagative ) /
  (true_positive + false_positive + 
     true_nagative + false_nagative)
error_rate



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PART II
# setting work directory
setwd("C:/Users/x-ibah/Desktop/Franklin/Data_610")

install.packages('pacman')
#installing & loading library
pacman::p_load(
  janitor,
  GGally,
  gplots,
  reshape,
  fastDummies,
  ggplot2,
  readr, 
  caret,
  readxl)

# loading data
data <- read_excel('book1.xlsx')
str(data)

# Create a Binary Prediction Column:
data$Prediction <- ifelse(data$Probability > 0.25, 1, 0)

data$Actual <- factor(data$Actual, levels = c(0, 1))
data$Prediction <- factor(data$Prediction, levels = c(0, 1))

# Generate a 2x2 Confusion Matrix:
confusionMatrix <- confusionMatrix(data$Prediction, data$Actual)
confusionMatrix

# Calculate Overall Accuracy, Sensitivity, and Specificity:
accuracy <- confusionMatrix$overall['Accuracy']
sensitivity <- confusionMatrix$byClass['Sensitivity']
specificity <- confusionMatrix$byClass['Specificity']








