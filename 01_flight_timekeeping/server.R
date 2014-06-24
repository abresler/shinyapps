library(shiny)

library(maps)
counties <- readRDS("data/counties.rds")
source("helpers.R")

# Define server logic required
shinyServer(function(input, output) {

  output$airlinehisttitle <- renderText({ 
    paste("",input$route)
  })
  
  output$map <- renderPlot({
    args <- switch(input$var,
                   "Percent White" = list(counties$white, "darkgreen", "% White"),
                   "Percent Black" = list(counties$black, "black", "% Black"),
                   "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
                   "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
    
    args$min <- input$range[1]
    args$max <- input$range[2]
    
    do.call(percent_map, args)
  })
  
  })