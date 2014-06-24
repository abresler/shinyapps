
flights <- read.csv("ShinyApps/01_flight_timekeeping//timekeeping.transformed.csv")
flights$airline_dir_x <- c(with(flights, paste(airline_x,direction_x) ))

ggplot(flights, aes(flightduration, fill=airline_x) ) + geom_bar(alpha=0.5)
ggplot(flights, aes(flightduration, fill=airline_x) ) + geom_bar(pos="dodge", alpha=0.5)
ggplot(flights, aes(log(flightduration), fill=(airline_x,direction_x) ) + geom_density(alpha=0.2)

       
ggplot(flights, aes(flightduration), fill=[airline_x,direction_x] ) + geom_density(alpha=0.2)

ggplot(flights, aes(flightduration), fill=c(airline_x,direction_x) ) + geom_density(alpha=0.2)
