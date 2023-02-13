#Loding data:
library(shiny)
library(shinythemes)
library(randomForest)
library(RCurl)
library(caret)

# Creating the model on iris set:

# Importing the data:
data("iris")

# Spliting the data:


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
