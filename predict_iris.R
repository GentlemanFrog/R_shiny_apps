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
      
      #Setting tittle:
      HTML("<h4>Select your iris parameter on sliders<h4>"),
      
      #Sepal length slider:
      sliderInput("sepal_length", label = "Sepal length: ",
                  min = min(to_train$Sepal.Length),
                  max = max(to_train$Sepal.Length), value = 5.0),
      
      #Sepal width slider:
      sliderInput("sepal_width", label = "Sepal width: ",
                  min = min(to_train$Sepal.Width),
                  max = max(to_train$Sepal.Width), value = 3.0),
      
      #Petal length slider:
      sliderInput("petal_length", label = "Petal length: ",
                  min = min(to_train$Petal.Length),
                  max = max(to_train$Petal.Length), value = 5.0),
      
      #Petal width slider:
      sliderInput("petal_width", label = "Petal width: ",
                  min = min(to_train$Petal.Width), 
                  max = max(to_train$Petal.Width), value = 0.3),
      
      #Submission button:                            defining how button looks
      actionButton("submitbutton", label = "Check", class = "btn btn-primaty"),
    ),
    
    mainPanel(
      
      tags$label(h3('Status/Output of the program')),
      # Product of the server job, output of the prediction:
      verbatimTextOutput("contents"),
      tableOutput("tabledata") #Prediction results tab
    )
    
  )



  # Defining server function to run the app:
  server <- function(input, output){
    
    # Inputting the data:
    data_set_input <- reactive({
      
      df <- data.frame(
        
        Name = c("sepal_length",
                 "sepal_width",
                 "petal_length",
                 "petal_width"),
        
        Value = as.character(c(input$sepal_length,
                               input$sepal_width,
                               input$petal_length,
                               input$petal_width)),
        stringsAsFactors = FALSE
      )
      
      Species <- 0
      
      df <- rbind(df, Species)
      input<- t(df)
      write.table(input, "iris_predictor_input.csv", sep = ",",
                  quote = FALSE, row.names = FALSE, col.names = FALSE)
      
      test <- read.csv(paste("iris_predictor_input", ".csv", sep=''), header = TRUE)
      
      # Making prediction about the species
      Output <- data.frame(Prediction = predict(model, test),
                           round(predict(model, test, type = "prob"), 3))
      
      # Printing output in the console:
      print(Output)
    })
    
    # Status/Output Text Box
    output$contents <- renderPrint({
      if (input$submitbutton>0) { 
        isolate("Calculation complete.") 
      } else {
        return("Server is ready for calculation.")
      }
    })
    
    # Prediction results table
    output$tabledata <- renderTable({
      if (input$submitbutton>0) { 
        isolate(data_set_input()) 
      } 
    })
    
  } # server


  # Creating the shiny object:
  shinyApp(ui = ui, server = server)
