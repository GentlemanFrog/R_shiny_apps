# Loading packages
library(shiny)
library(shinythemes)

# Project shows the adjustable plot of the ozone level in the air. The data contains 
# the information about the New York air quality measurements of 1973 for five moths
# from May to September recorded daily.

# Loading data:
data("airquality")

# Setting the ui
  ui <- fluidPage(
    # Setting the theme
    theme = shinytheme("cyborg"),
    
    navbarPage("Quality of New York air 1973",
      tabPanel("Ozone",
        #Insides of navbar1:
        
          #Side_bar_Panel_for input:
          sidebarLayout(
              #Setting side_bar_panel_for_input:
            sidebarPanel(
                #Getting info about number of bins displayed form slider"
              sliderInput(inputId = 'bins',
                          label = "Number of bins to display on histogram",
                          min = 1,
                          max = 50,
                          # default val:
                          value = 30)
              
            ),
            
            #Adding main panel to displaying the plot:
            mainPanel(
              
              #Output: histogram: name of plot should be the same as in server
              plotOutput(outputId = 'distPlot')
            )
            
          ) # End_of_sidebar_layout
        
        ), # End_of_tab_panel
      tabPanel("Temperature",
               sidebarLayout(
                 sidebarPanel(
                   sliderInput(inputId = "bins_temp",
                    label = "Number of bins to display on histogram",
                    min = 1,
                    max = 90,
                    value = 45
                  )
                  
                 ),
                 mainPanel(plotOutput(outputId = "distPlot_temp")
                 )
                 
                )
               
               ),
      
      ) #End_of_navbar_Page
    
  ) #End_of_fluid_Page
  
  # Defining server function to run the app:
  server <- function(input, output){
    # Setting the plot to display, rendering it 
    output$distPlot <- renderPlot({
      
      # Setting the properties of the plot from data:
      x <- airquality$Ozone
      
      # Removing the rows with missing values
      x <- na.omit(x) 
      
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # Properties of histogram:
      hist(x, breaks = bins, col = "#75AADB", border = "black",
           xlab = "Ozone levels",
           main = "Histogram of ozone level")
      
    })
    output$distPlot_temp <- renderPlot({
      
      # Setting the properties of the plot from data:
      x <- airquality$Temp
      
      # Removing the rows with missing values
      x <- na.omit(x) 
      
      bins_temp <- seq(min(x), max(x), length.out = input$bins_temp + 1)
      
      # Properties of histogram:
      hist(x, breaks = bins_temp, col = "#75AADB", border = "black",
           xlab = "Temperature levels",
           main = "Histogram of temperature level")
      
    })
  } # server
  
  
  # Creating the shiny object:
  shinyApp(ui = ui, server = server)
