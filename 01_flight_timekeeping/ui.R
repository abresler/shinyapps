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
shinyUI(navbarPage(
  " "
  ,tabPanel("Airports",
    titlePanel("Airlines @ Airports"),
    sidebarLayout(
      sidebarPanel(""
                   ,fluidRow(helpText(""))
                   ,fluidRow(selectInput("airport", label = "",
                                        choices = c("Dublin","London-LGW"),
                                        selected = "London-LGW" ))
                   ,fluidRow(dateRangeInput("dateRange", 
                                            label = "",
                                            start = "2014-05-01",
                                            end = NULL,
                                            startview = "year"))
      ),
      mainPanel(plotOutput("airportHistogram")
                ,h5(textOutput("airportHistTitle"), align = "center")
                ,googleAnalytics()
                ,verbatimTextOutput("dataPrintOut")
      )
    )
  )
  ,tabPanel("Routes",
            titlePanel("Airline v Routes"),
            sidebarLayout(
              sidebarPanel( "" , 
                            fluidRow(helpText("Choose a route") ),
                            fluidRow(selectInput("route", label = "", 
                                                 choices = list("Dublin to London Gatwick" = "departures", 
                                                                "London Gatwick to Dublin" = "arrivals") ,
                                                 selected = "departures" ))
              ),
              mainPanel(plotOutput("airlineHistogram")
                        ,h5(textOutput("airlineHistTitle"), align = "center")
                        ,googleAnalytics()
                        
              )
            )
  )  
) 
)

