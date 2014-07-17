# Examine whether it is better to rent OR buy at an inflated price


# This is only getting started there is a lot to do yet. 
# 1. Have the option of compressing the mortgage duration based on how long you delay taking it out
# 2. Have the option of pushing all future savings into the mortgage 
# 2.a Be able to set a maximum overpayment amount per month
# 3. Benchmark future rates against the yield curve
# 4. Benchmark property price fluctuation based on what has happened previously 
# 5. Select a discount rate
# 6. I've noticed that the mortgage calculator sometimes returns an extra element. Need to properly test the function

# This needs to be completely redone in a test driven development way. 
# It is starting off with a 19 year mortgage. Rather than spend time debuggin a rubbish script I will just rewrite it. 
library(ggplot2)
source('mortgage.R')
source('fnctns.R')
library(shiny)
library(ggplot2)

# Define server logic required
shinyServer(function(input, output) {

# scenario <- reactive({ scenarioOne= data.frame()
#  
# for (r in seq(input$rnt[1],input$rnt[2],100)) {   for (y in 0:5) {
#     v <-  runScenario (rent = r,
#                        year = y,
#                        totDurationYears = input$frcstDur,
#                        totalCashInHand = input$cashOnHand,
#                        percentCashAsDeposit = input$dpstPercent,
#                        housePrice = input$hsPrice,
#                        mortgageYears = input$mrtgDur,
#                        mortgageRate = input$mrtgRat,
#                        standardRateTax = input$txRate,
#                        savingsInterest = input$ntrstRate,
#                        percentValueChange = input$hsValChng,
#                        monthlyCashToPlayWith = input$mnthlCash)
#     scenarioOne <- rbind( scenarioOne ,  c(y,r,v))
#   }}
#   names(scenarioOne) <- c("year","rent","amount")
# })

output$rentOrBuy <- renderPlot({
 
 tdy <- input$frcstDur
 rMin <- input$rnt[1]
 rMax <- input$rnt[2]
 mctp  <- input$mnthlCash
 cih <- input$cashInHand
 pcad  <- input$dpstPercent
 hp  <- input$hsPrice
 pvc  <- input$hsValChng
 my  <- input$mrtgDur
 mr  <- input$mrtgRate
 si  <- input$ntrstRate
 tx  <- input$txRate

  r <- 1000
  y <- 1
 df <- data.frame ( year = c(), rent = c(), amount = c())
 for (r in seq(rMin,rMax,50)) {
 for (y in 0:5) { 
 
  a <-  runScenario ( rent = r,
                      year = y,
                      totDurationYears = tdy,
                      totalCashInHand = cih ,
                      percentCashAsDeposit = pcad,
                      housePrice = hp,
                      mortgageYears = my,
                      mortgageRate = mr,
                      standardRateTax = tx,
                      savingsInterest = si ,
                      percentValueChange = pvc,
                      monthlyCashToPlayWith = mctp)
  df <- rbind (df, c(y,r,a) )
  }}
  
  names(df) <- c("year","rent","amount")
  
  ggplot(df) + geom_point(aes(x=year,y=amount, colour = rent), size = I(1)) +
  scale_color_continuous(low = 'red',high = 'black') +
  theme(legend.position="none")  #+
  #ylim(0,1500000) 
 
})


# Gpl <- ggplot() + geom_point(aes(x=year,y=amount), colour = 'blue', size = I(1),
#                            data = scenarioOne)
})