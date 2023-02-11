# Loading proper packages:
library(shiny)
library(shinythemes)

# This app will perform to getting input values from the user. 
# And then write the information in the output. 

# Defining UI:
ui <- fluidPage(theme = shinytheme("cyborg"),
                navbarPage(
                  "First shiny app!",
                  tabPanel("Navbar1",
                           #Insides of navbar1:
                           sidebarPanel(
                             #Insides of side panel:
                              #Header with the information
                             tags$h3('Input:'),
                             textInput('txt_name', "Write your name: ", ""),
                             textInput('txt_surname', "Write your surname: ", ""),
                             
                           ),
                           mainPanel(
                             h2("This app will write output you provide in the entry places."),
                             
                             h3("So hopefully your name is....: "),
                             verbatimTextOutput("txtout")
                           )# End_of_main_Panel
                          ), # End_of_tab_panel
                  # Setting up another panels to use:
                  tabPanel("Navbar2", "Intensionaly left blank to check how it works"),
                  tabPanel("Navbar3", "Same here...")
                ) #End_of_navbar_Page
              ) #End_of_fluid_Page

# Defining server function to run the app:
server <- function(input, output){
  output$txtout <- renderText({
    paste( input$txt_name, input$txt_surname, sep = ' ')
  })
} # server


# Creating the shiny object:
shinyApp(ui = ui, server = server)