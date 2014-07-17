
test_that("aDFmonth holds as many records as months", {
  
  for (yrs in seq(1,30,1)) {
    mnths <- yrs*12
    aDFmonth <- mortgage(P=100000,I = 4, L=yrs)
    expect_that(length(aDFmonth[,"Monthly_Payment"]), equals(mnths))
  }

})

test_that("aDFmonth returns null when duration is zero years", {
  
    yrs <- 0
    mnths <- yrs*12
    aDFmonth <- mortgage(P=100000,I = 4, L=yrs)
    cat(aDFmonth)
    expect_that(length(aDFmonth), equals(mnths))
 
  
})

test_that("aDFmonth holds as many records as months for a long duration", {
  
  for (yrs in seq(1000000,1000000,1)) {
    mnths <- yrs*12
    mortgage(P=100000,I = 4, L=yrs)
    expect_that(length(aDFmonth[,"Monthly_Payment"]), equals(mnths))
  }
  # Suspect that rounding/ceiling is causing the lengths to misalign
  
})

test_that("aDFmonth holds as many records as months for a very long duration", {
  
  for (yrs in seq(10000000000,10000000000,1)) {
    mnths <- yrs*12
    mortgage(P=100000,I = 4, L=yrs,plotData = F)
    expect_that(length(aDFmonth[,"Monthly_Payment"]), equals(mnths))
  }
  # Somewhere the seq value is too large: either in the test itself or in the function called
  
})

test_that("mortgage handles negative values adequately")