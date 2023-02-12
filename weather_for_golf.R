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
# In this project the play varaible is the one that we want to predict. 

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
  ui <- fluidPage(
    # Setting the theme
    theme = shinytheme("cyborg"),
    
    #Page header:
    headerPanel("Should I play golf?"),
    
    #Setting panel for inputing values:
    sidebarPanel(
      
      #Settinh tittle:
      HTML("<h3> Input parameters<h3>"),
      
      selectInput("outlook", label = "The weather condition outside: ",
                  choices = list("sunny" = "sunny", "overcast" = "overcast", "rainy" = "rainy"),
                  selected = "rainy"),
      
      #Temp slider:
      sliderInput("temperature", label = "Temperature: ",
                  min = 64, max = 85, value = 72),
      
      #Humidity slider:
      sliderInput("humidity", label = "Humidity: ",
                  min = 65, max = 96, value = 82),
      
      #Windy list:
      selectInput("windy", label = "Is it windy?: ",
                  choices = list("Yes" = "TRUE", "No" = "FALSE"),
                  selected = "Yes"),
      
      #Submision button:                            defining how button looks
      actionButton("submitbutton", label = "Check", class = "btn btn-primaty"),
    ),
    
    mainPanel(
      
      tags$label(h3('Status/Output of the program')),
      # Product of the server job, output of the prediction:
      verbatimTextOutput("contents"),
      tableOutput("tabeldata") #Prediction results tab
    )
    
    
  ) 

    
  # Defining server function to run the app:
  server <- function(input, output, session){
    
    #Inputing the data:
    datasetInput <- reactive({
      
      #Creating data frame from input values:
      # outlook, temperature, humidity, windy, play:
      df <- data.frame(
        Name= c("outlook",
                "temperature",
                "Humidity",
                "Windy"),
        
        value = as.character(c(input$outlook,
                               input$temperature,
                               input$humidity,
                               input$windy)),
        
        stringsAsFactors = FALSE)
      
      #
      play <- "play"
      df <- rbind(df, play)
      input <- transpose(df)
      
      write.table(input, "input.csv", sep=',', quote = FALSE, row.names = FALSE, col.names = FALSE)
      
      test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
      
      test$outlook <- factor(test$outlook, levels=c("overcast", "rainy", "sunny"))
      
      Output<- data.frame(Prediction = predict(deciding_model, test),
                          round(predict(deciding_model, test, type="prob"), 3))
      print(Output)
    })
    
    # Status/Output text box:
    output$contents <- renderPrint({
      if (input$submitbutton > 0){
        isolate("Calculation complete.")
      }else{
        return("Server is ready for calculation")
      }
    })
    
    # Outputing the prediction:
    output$tabledata <- renderTable({
      if (input$submitbutton > 0){
        isolate(datasetInput())
      }
    })
    
   } # server
 
 
  # Creating the shiny object:
  shinyApp(ui = ui, server = server)

