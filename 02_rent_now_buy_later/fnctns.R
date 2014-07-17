source('mortgage.R')

canAffordMonthlyPayment <- function(C=3000, P=500000, I=6, L=30) { 
  #   C = Max permissible monthly payment
  #  	P = principal (loan amount)
  #		I = annual interest rate
  #		L = length of the loan in years 
  C<- C
  P <- P
  I <- I
  L <- L
  return (C >= loanPayment(P,I,L))
  
}

applyMonthlyInterest <- function(V=c(1,2,3),I=0.04) {
  # Interest is expected to be 0 < I < 1
  library('Matrix')
  if (length(V) == 0) {b <- NA}else{
  monthlyI <- 1 + ( I )
  monthlyI <- monthlyI^(1/12)
  
  b <- Diagonal(x = monthlyI^(length(V):1)) %*% V
  b <- sum(b)
  }
  return (b)
}


runScenario <- function( rent = 1000,
                        year = 0,
                        totDurationYears = 20,
                        totalCashInHand = 200000,
                        percentCashAsDeposit = 1,
                        housePrice = 400000,
                        mortgageYears = 20,
                        mortgageRate = 4,
                        standardRateTax = .2,
                        savingsInterest = 3 ,
                        percentValueChange = -25,
                        monthlyCashToPlayWith = 2500,
                        staticDeposit = 0 ) {
  

      t <- savingsInterest * (1-standardRateTax)
      savingsInterest <- t
      totDurationMonths <- totDurationYears * 12     
      mortgageFreeBeforeYears <- year 
      mortgageFreeBeforeMonths <- mortgageFreeBeforeYears * 12 
      
      # lesser duration of mortgageYears and time left after initial rental period
      mortgageYears <- min(totDurationYears-mortgageFreeBeforeYears,mortgageYears) 
      
      savingsBefore <- rep(monthlyCashToPlayWith-rent, mortgageFreeBeforeMonths) 
      savingsBefore[1] <- savingsBefore[1] + totalCashInHand 
      
      endPhaseOne <- applyMonthlyInterest(V = savingsBefore,I = savingsInterest)
      # If endSavings is NA then we were saving for zero months and so our savings
      # are what we started with
      if (is.na(endPhaseOne)){endPhaseOne <- totalCashInHand}

      # We now have the amount of cash on hand when we are taking out a mortgage
      if (staticDeposit> 0) {
        deposit <- staticDeposit
      }else{
        deposit <- (endPhaseOne * percentCashAsDeposit )
      }
      
      mortgageAmount <- housePrice - deposit
      
      #browser()
      mortgageIsAffordable <- canAffordMonthlyPayment(C = monthlyCashToPlayWith,
                                                      P = mortgageAmount, 
                                                      I = mortgageRate,
                                                      L = mortgageYears)

      
       
      if (mortgageIsAffordable) {
        mortgageSchedule <- mortgage( P=mortgageAmount,
                                      I=mortgageRate,
                                      L=mortgageYears) 
        mortgageTotInt <- sum(mortgageSchedule$Monthly_Interest)
        mortgageMonthlyPrincipal <- mortgageSchedule$Monthly_Principal[1]
        mortgageMonths <- mortgageYears * 12
        rent <- 0 
      }else{
        mortgageYears <- 0
        mortgageTotInt <- 0
        mortgageMonthlyPrincipal <- 0
        mortgageMonths <- 0
        deposit <- 0 
        housePrice <- 0 } 
       
      mortgageFreeAfterMonths <- totDurationMonths - mortgageMonths - mortgageFreeBeforeMonths
           
      savingsAfter <- c( rep(monthlyCashToPlayWith - mortgageMonthlyPrincipal,mortgageMonths)
                        ,rep(monthlyCashToPlayWith - rent, mortgageFreeAfterMonths))
      savingsAfter[1] <- savingsAfter[1] + endPhaseOne - deposit 

      endPhaseTwo <- applyMonthlyInterest(V = savingsAfter,I = savingsInterest)
      # If endSavings is NA then we were saving for zero months and so our savings
      # are what we started with
      if (is.na(endPhaseTwo)){endPhaseTwo <- endPhaseOne}
      
      housePrice <- housePrice * (1 + (percentValueChange/100) )
      return (endPhaseTwo + housePrice)
}