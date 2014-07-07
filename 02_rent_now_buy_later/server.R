# Examine whether it is better to rent OR buy at an inflated price


# This is only getting started there is a lot to do yet. 
# 1. Have the option of compressing the mortgage duration based on how long you delay taking it out
# 2. Have the option of pushing all future savings into the mortgage 
# 2.a Be able to set a maximum overpayment amount per month
# 3. Benchmark future rates against the yield curve
# 4. Benchmark property price fluctuation based on historical 
# 5. Select a discount rate
# 6. I've noticed that the mortgage calculator sometimes returns an extra element. Need to properly test the function
source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/mortgage.R")

timeframe <- 20 #years
mortgageStart <- 0 #year from now
  # need to check that you don't buy the house so far in the future that you don't pay it all off
totalCashInHand <- 150000
percentCashAsDeposit <- 1

houseprice <- 450000
rent <- 1200
mortgageYears <- 20
mortgageRate <- 6.25
savingsInterest <- 3.25* (1-.2)
percentValueChange <- 0
monthlyCashToPlayWith <- 2100

overallPosition <- rep(NA,length(0:5))

for (j in 0:5) {
    
    mortgageStart <- j
    
    mortgageFreeBeforeMonths <- mortgageStart * 12 
    savingsBefore <- rep(monthlyCashToPlayWith-rent, mortgageFreeBeforeMonths) 
    savingsWithIntBefore <- rep(0, mortgageFreeBeforeMonths )
    savingsBefore; savingsWithIntBefore
    
    savingsBefore[1] <- savingsBefore[1] + totalCashInHand 
    #plot(savingsBefore)
    #savingsBefore
    
    savingsInterest <- 1 + ( savingsInterest / 100 )
    #savingsInterest
    
    start <- 0
    for (i in 1:length(savingsBefore)) {
      savingsWithIntBefore[i] <-  ( start + savingsBefore[i] ) * savingsInterest^(1/12)
      start <- savingsWithIntBefore[i]
    }
    #plot(savingsWithIntBefore)
    #savingsWithIntBefore
    savingsWithIntBefore[length(savingsWithIntBefore)]
    
    # We now have the amount of cash on hand in two years
    if ( is.na(savingsWithIntBefore[length(savingsWithIntBefore)]) ) {
      mortgageAmount <- houseprice - (totalCashInHand * percentCashAsDeposit )  
    }else {
      mortgageAmount <- houseprice - (savingsWithIntBefore[length(savingsWithIntBefore)] * percentCashAsDeposit )
    }
    
    mortgage(P=mortgageAmount,I=mortgageRate,
             L=min(timeframe-mortgageStart,mortgageYears), # As we delay the length of the mortgage reduces
             # we need to make sure that the monthly payment ! > monthly money available
             amort=T)
    
    
    totDurationMonths <- timeframe * 12 
    #totDurationMonths
    
    mortgageMonths <- min(timeframe-mortgageStart,mortgageYears) * 12  
    #mortgageMonths
    mortgageFreeAfterMonths <- totDurationMonths - mortgageMonths - mortgageFreeBeforeMonths
    #mortgageFreeAfterMonths
    deadMoneyOut <- c( rep(rent, mortgageFreeBeforeMonths) 
                      ,aDFmonth$Monthly_Interest
                      ,rep(0, mortgageFreeAfterMonths))
    
    #plot(deadMoneyOut)
    #length(deadMoneyOut)
    
    propertyInvestmentIn <- c(rep(0, mortgageFreeBeforeMonths) 
                              ,aDFmonth$Monthly_Principal
                              ,rep(0, mortgageFreeAfterMonths))
    #plot(propertyInvestmentIn)
    #length(propertyInvestmentIn)
    propertyInvestmentIn <- ( 1 + ( percentValueChange /100) ) * propertyInvestmentIn
    #plot(propertyInvestmentIn)
    
    savingsAfter <- c(monthlyCashToPlayWith - aDFmonth$Monthly_Payment
                   ,rep(monthlyCashToPlayWith, mortgageFreeAfterMonths))
    #plot(savingsAfter)
    savingsWithIntAfter <- rep(0, length(savingsAfter) )
    
    if (is.na(savingsWithIntBefore[length(savingsWithIntBefore)])) {
      start <- totalCashInHand * (1- percentCashAsDeposit)
    }else {
    start <- savingsWithIntBefore[length(savingsWithIntBefore)] * (1 - percentCashAsDeposit)
    }
    #start
    for (i in 1:length(savingsAfter)) {
      savingsWithIntAfter[i] <-  ( start +  savingsAfter[i] ) * savingsInterest^(1/12)
      start <- savingsWithIntAfter[i]
    }
    #plot(savingsWithIntAfter)
    
    
    if (is.na(savingsWithIntBefore)) {
      savingsWithInt <- savingsWithIntAfter
    }else { 
    savingsWithInt <- c(savingsWithIntBefore, savingsWithIntAfter)
    }
    #length(savingsWithInt)
    #plot(savingsWithInt)
 if (j == 0 | j == 1) {   
     print(j) 
     print(propertyInvestmentIn)
     print(savingsWithInt)
     print(deadMoneyOut) }
    
    overallPosition[j+1] = 
    sum(propertyInvestmentIn) +
    savingsWithInt[length(savingsWithInt)] -
    sum(deadMoneyOut) 
  

}

plot(overallPosition)

