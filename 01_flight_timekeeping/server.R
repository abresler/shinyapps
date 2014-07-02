library(shiny)
library(ggplot2)
library(lubridate)
library(grid)
library(gridExtra)
library(scales)

# Define server logic required
shinyServer(function(input, output) {
  flights <- read.csv("data/timekeeping.transformed.csv")
  flights$scheduled_x <- ymd_hms(flights$scheduled_x)
  flights$datetimestatus_x <- ymd_hms(flights$datetimestatus_x)
  
  day(flights$datetimestatus_x) <- day(flights$scheduled_x)
  month(flights$datetimestatus_x) <- month(flights$scheduled_x)
  year(flights$datetimestatus_x) <- year(flights$scheduled_x)
  flights$datetimestatus_x <- as.POSIXct(flights$datetimestatus_x)
  flights$scheduled_x <- as.POSIXct(flights$scheduled_x)
  
  flights$scheduled_y <- ymd_hms(flights$scheduled_y)
  flights$datetimestatus_y <- ymd_hms(flights$datetimestatus_y)
  
  day(flights$datetimestatus_y) <- day(flights$scheduled_y)
  month(flights$datetimestatus_y) <- month(flights$scheduled_y)
  year(flights$datetimestatus_y) <- year(flights$scheduled_y)
  flights$datetimestatus_y <- as.POSIXct(flights$datetimestatus_y)
  flights$scheduled_y <- as.POSIXct(flights$scheduled_y)
  
  flights$departureDelays_x = as.double(flights$datetimestatus_x - flights$scheduled_x )/60
  tmp <- flights[flights$direction_x == "departures", c("scheduled_x","departureDelays_x","airline_x","location_y")]
  
  average_airline_delay = aggregate(tmp$departureDelays_x, by=list(tmp$airline_x,tmp$location_y), FUN = mean)
  
  
    output$airlineHistogram <- renderPlot({
    p <-  ggplot(flights[flights$direction_x == input$route,], aes(flightduration, fill=airline_x)) + geom_density(alpha=0.3)
     print(p)
    })
  
    output$airportHistogram <- renderPlot({
      
      filter_airline <- average_airline_delay$Group.1[order (average_airline_delay$x) &
                                                      average_airline_delay$Group.2 == input$airport ][1]
      filter_airline_mean_delay <-average_airline_delay$x[order (average_airline_delay$x) &
                                                            average_airline_delay$Group.2 == input$airport ][1]
      
      rect1 <- data.frame ( xmin=filter_airline_mean_delay + 0.25 
                           ,xmax=filter_airline_mean_delay - 0.25
                           ,ymin=-Inf
                           ,ymax=Inf) # Plot a vertical line marking the average delay
      
      p1 <- ggplot()  + 
            geom_density(data=tmp[  tmp$airline_x == filter_airline & 
                                    tmp$location_y == input$airport & 
                                    tmp$scheduled_x >= as.POSIXct(input$dateRange[1]) & 
                                    tmp$scheduled_x <= as.POSIXct(input$dateRange[2]) , ]
                         ,aes(departureDelays_x, fill=airline_x  ) ,
                         alpha=0.2 , 
                         colour="darkgreen", fill="green") + 
            scale_y_continuous(limits = c(0,.05) , name = "Flights" ,labels=percent) + 
            scale_x_continuous( limits = c(-50,100), name = paste(filter_airline, ": departure delay in minutes",sep ="" )) +
        geom_rect(data=rect1,aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),alpha=0,fill="black")
        
      
      filter_airline <- average_airline_delay$Group.1[order (average_airline_delay$x) &
                                                      average_airline_delay$Group.2 == input$airport ][2]
      filter_airline_mean_delay <-average_airline_delay$x[order (average_airline_delay$x) &
                                                                  average_airline_delay$Group.2 == input$airport ][2]

      rect1 <- data.frame ( xmin=filter_airline_mean_delay + 0.25 
                           ,xmax=filter_airline_mean_delay - 0.25
                           ,ymin=-Inf
                           ,ymax=Inf) # Plot a vertical line marking the average delay
      p2 <- ggplot() + 
        geom_density(data=tmp[  tmp$airline_x == filter_airline & 
                                  tmp$location_y == input$airport & 
                                  tmp$scheduled_x >= as.POSIXct(input$dateRange[1]) & 
                                  tmp$scheduled_x <= as.POSIXct(input$dateRange[2]) , ]
                         ,aes(departureDelays_x, fill=airline_x  ) ,
                         alpha=0.2 , 
                         colour="darkgreen", fill="green") + 
            scale_y_continuous(limits = c(0,.05), name = "Flights", labels=percent) + 
            scale_x_continuous(limits = c(-50,100), name = paste(filter_airline, ": departure delay in minutes",sep ="")) +
        geom_rect(data=rect1,aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),alpha=0,fill="black") 
              
      gp1<- ggplot_gtable(ggplot_build(p1))
      gp2<- ggplot_gtable(ggplot_build(p2))
      
      maxWidth = unit.pmax(gp1$widths[2:3], gp2$widths[2:3]) #, gp3$widths[2:3])
      gp1$widths[2:3] <- maxWidth
      gp2$widths[2:3] <- maxWidth
      grid.arrange(gp1, gp2) 
    })
  

})
