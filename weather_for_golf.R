#Loading library
library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)

# Read data
weather <- read.csv(text = getURL("https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv") )
weather

# Preparing the model to check if we should play the golf according to the user input:
# used decisive model will be random Forest

deciding_model <- randomForest(play ~., data = weather, ntree = 500, mtry = 4, importance = TRUE)
# This function implements Brelman's random forest algorithm for classification 
# and regression. 
# Firstly function want formula which is a data frame or a matrix
# predictors, or formula describing the model to be fitted. In this example
# i wan to use all columns except the play column from data set to predict.

# Second argument specifies the data set we are using. 
# ntree - refers to the numbers of tree to grow, this number
#   shouldn't be set to small, to ensure that every input row gets predicted at least a few times
# mtry - Number of variables randomly sampled as candidates at each split. 
#   Note that the default values are different for classification (sqrt(p) 
#   where p is number of variables in x) and regression (p/3)
# importance - In Random Forest, the importance of predictors is a measure of 
#   the relative contribution of each feature to the total prediction accuracy 
#   of the model. The idea behind the importance of predictors is to identify 
#   which features are more significant in the prediction process, and therefore,
#   contribute the most to the accuracy of the model.

# To save the model:
# saveRDS(deciding_model, "rf_model.rds")

# To read the model for another use:
# deciding_model <- readRDS("rf_model.rds")

# Creating the ui:




