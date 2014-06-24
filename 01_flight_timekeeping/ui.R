library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("Airline Timekeeping"),
  
  sidebarLayout(
    sidebarPanel( "" , 
                  fluidRow(
                           helpText("Choose a route") ),
                  fluidRow(
                           selectInput("route", label = "", 
                                       #choices = list("Dublin to London Gatwick" = 1, 
                                       #             "London Gatwick to Dublin" = 2) 
                                       choices = c("Dublin to London Gatwick","London Gatwick to Dublin")
                                       )), 
                  
                  helpText("Create demographic maps with 
        information from the 2010 US Census."),
                  
                  selectInput("var", 
                              label = "Choose a variable to display",
                              choices = c("Percent White", "Percent Black",
                                          "Percent Hispanic", "Percent Asian"),
                              selected = "Percent White"),
                  
                  sliderInput("range", 
                              label = "Range of interest:",
                              min = 0, max = 100, value = c(0, 100))

    ),
    mainPanel(
              plotOutput("airlinehist"),
              h5(textOutput("airlinehisttitle"), align = "center"),
              plotOutput("map")
    )
  )
))

