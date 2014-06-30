library(shiny)

googleAnalytics <- function(account="UA-52253018-1"){
  HTML(paste("<script>
               (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                 (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                 m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
               })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
             
             ga('create', '",account,"', 'shinyapps.io');
             ga('send', 'pageview');
             
             </script>"))
}

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("Airline Timekeeping"),
  
  sidebarLayout(
    sidebarPanel( "" , 
                  fluidRow(
                           helpText("Choose a route") ),
                  fluidRow(
                           selectInput("route", label = "", 
                                       choices = list("Dublin to London Gatwick" = "departures", 
                                                    "London Gatwick to Dublin" = "arrivals") ,
                                       #choices = c("Dublin to London Gatwick","London Gatwick to Dublin"),
                                       selected = "departures"
                                       ))
#                   , 
#                   
#                   helpText("Create demographic maps with 
#         information from the 2010 US Census."),
#                   
#                   selectInput("var", 
#                               label = "Choose a variable to display",
#                               choices = c("Percent White", "Percent Black",
#                                           "Percent Hispanic", "Percent Asian"),
#                               selected = "Percent White"),
#                   
#                   sliderInput("range", 
#                               label = "Range of interest:",
#                               min = 0, max = 100, value = c(0, 100))

    ),
    mainPanel(
              plotOutput("airlinehist"),
              h5(textOutput("airlinehisttitle"), align = "center"),
              googleAnalytics()
           #   plotOutput("map")
    )
  )
))

