# source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/mortgage.R")
#############################################################################
## Function to Calculate Monthly Mortgage Payments and Amortization Tables ##
#############################################################################
# Author: Thomas Girke
# Last update: Feb 27, 2007
# Utility: Calculates monthly and annual loan or mortgage payments, generates amortization tables and plots the results
# How to run the script:
#  source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/mortgage.R")

# Definitions: 
#    P = principal, the initial amount of the loan
#	  I = annual interest rate
#	  L = length of the loan in years, or at least the length over which the loan is amortized.
#	  J = monthly interest in decimal form = I / (12 x 100)
#	  M = monthly payment; formula: M = P * ( J / (1 - (1 + J) ^ -N))
#	  N = number of months over which loan is amortized = L x 12
# see also: http://www.jeacle.ie/mortgage/instructions.html

mortgage <- function(P=500000, I=0.06, L=30) { 
  if (L == 0){
    monSchedule <- data.frame(
      Amortization=c(),
      Monthly_Payment=c(),
      Monthly_Principal=c(), 
      #Monthly_Interest=c((monthPay-monthP)[1:(length(monthP)-1)],0), 
      Monthly_Interest=c(),
      Year=c()  )    
  }else{
  monthPay <- loanPayment(P,I,L)
  J <- getMonthlyInterest(I)
  N <- getNumOfMonths(L)
  
  # Calculate Amortization for each Month
    Pt <- P # current principal or amount of the loan
    currP <- NULL
    while(Pt>=0) {
      H <- Pt * J # this is the current monthly interest
      H=round(x = H, digits = 2) #*100)/100
      C <- monthPay - H # this is your monthly payment minus your monthly interest, so it is the amount of principal you pay for that month
      Q <- Pt - C # this is the new balance of your principal of your loan
      Pt <- Q # sets P equal to Q and goes back to step 1. The loop continues until the value Q (and hence P) goes to zero
      currP <- c(currP, Pt)
    }
    monthP <- c(P, currP[1:(length(currP)-1)])-currP
   # browser()
    monSchedule <- data.frame(
      Amortization=c(P, currP[1:(length(currP)-1)]), 
      Monthly_Payment=rep(monthPay,length(currP)),
      Monthly_Principal=monthP, 
      #Monthly_Interest=c((monthPay-monthP)[1:(length(monthP)-1)],0), 
      Monthly_Interest=rep(monthPay,length(currP)) - monthP,
      Year=sort(rep(1:ceiling(N/12), 12))[1:length(currP)]
    )
  }
  return(monSchedule)
}
getMonthlyInterest <- function(I=4){
  t <- I
  return (I/12)
}
getNumOfMonths <- function(L=3){
  return (12 * L)
}
loanPayment <- function(P=100000, I=6, L=10) { 
  J <- getMonthlyInterest(I)
  N <- getNumOfMonths(L)
  M <- P*J/(1-(1+J)^(-N))
  rt <- ceiling(M*100)/100
  return (rt)
}