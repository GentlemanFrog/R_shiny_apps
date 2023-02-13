#Loding data:
library(shiny)
library(shinythemes)
library(randomForest)
library(RCurl)
library(caret)

# Creating the model on iris set:

# Importing the data:
data("iris")

# Splitting the data for the test and learn part of data:
# We used 20% of the data for the test and the 80% fo the learn
TrainIndex <- createDataPartition(iris$Species, p = 0.8, list = FALSE)

# Remember to set comma in this commands, its crucial, to properly choose columns
TrainSet <- iris[TrainIndex,]
TestSet<- iris[-TrainIndex,]

# Saving the data to csvs:
write.csv(TrainSet, "iris_train_set.csv")
write.csv(TestSet, "iris_test_set.csv")

# Reading the prepered data:
to_train <- read.csv("iris_train_set.csv", header = TRUE)

# Removing first line from the train set because its not needed:
to_train <- to_train[-1] 

# Creating a model: mtry is set to 4 because we want to base on 4 other features
# to predict the species, also its crucial to set the species as factor to make
# the model work because the species feature its not numeric nor logical.
model<-randomForest(as.factor(Species) ~ ., data = to_train, ntree = 500,
                    mtry = 4, importance = TRUE)

# Saving the model:
saveRDS(model, "iris_random_forest_model.rds")


# Defining the ui:
  ui <- fluidPage(
    # Setting the theme
    theme = shinytheme("cyborg"),
    
    #Page header:
    headerPanel("Iris predictor?"),
    
    #Setting panel for inputting values:
    sidebarPanel(
      
      
    )
    
  )



  # Defining server function to run the app:
  server <- function(input, output){
  } # server


  # Creating the shiny object:
  shinyApp(ui = ui, server = server)
