library(shiny)
library(ggplot2)


# Define server logic required
shinyServer(function(input, output) {
  flights <- read.csv("data/timekeeping.transformed.csv")
  flights$airline_dir_x <- c(with(flights, paste(airline_x,direction_x) ))
  flights$loc_dir_x <- c(with(flights, paste(location_x,direction_x) ))
  
    output$airlinehisttitle <- renderText({ 
      paste("",input$route)
    })
  
#   output$map <- renderPlot({
#     
#     args <- switch(input$var,
#                    "Percent White" = list(counties$white, "darkgreen", "% White"),
#                    "Percent Black" = list(counties$black, "black", "% Black"),
#                    "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
#                    "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
#     
#     args$min <- input$range[1]
#     args$max <- input$range[2]
#     
#     do.call(percent_map, args)
#   })
    output$airlinehist <- renderPlot({
    p <-  ggplot(flights[flights$direction_x == input$route,], aes(flightduration, fill=airline_x)) + geom_density(alpha=0.3)
     print(p)
    })
  
   #     temp <- switch(input$route,
#                        "Dublin to London Gatwick" = flights[flights$airline_dir_x == "Dublin departures",],
#                        "London Gatwick to Dublin" = flights[flights$airline_dir_x == "Dublin arrivals",]
#     )
# 
#    
#    if (input$route == "Dublin to London Gatwick") {
#      # "Dublin to London Gatwick"
#      mpgData <- data.frame(flights[flights$airline_dir_x == "Dublin departures",])
#    }
#    else {
#      # cyl and gear
#      mpgData <- data.frame(mpg = mtcars$mpg, var = factor(mtcars[[input$variable]]))
#    }
#   cat (summary(mpgData)) 
#  p <-  ggplot(mpgData, aes(flightduration, fill=airline_x) ) + geom_density(alpha=0.3)
 # p <- ggplot(temp, aes(temp$flightduration, fill=temp$airline_x)) + geom_density(alpha=0.3)
 # print(p)



  })