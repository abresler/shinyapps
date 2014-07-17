test_that("Loan affordability is checked", {
     expect_that(canAffordMonthlyPayment(), equals(T))
     expect_that(canAffordMonthlyPayment(C = 0,P = 1000000,I = 5,L = 5), equals(F))
     expect_that(canAffordMonthlyPayment(C = 10,P = 1000000,I = 5,L = 5), equals(F))
     expect_that(canAffordMonthlyPayment(C = 1012.45,P = 100000,I = 4,L = 10), equals(F))
     expect_that(canAffordMonthlyPayment(C = 1012.46,P = 100000,I = 4,L = 10), equals(T))
     expect_that(canAffordMonthlyPayment(C = 1012.47,P = 100000,I = 4,L = 10), equals(T))
     expect_that(canAffordMonthlyPayment(C = 100000000000,P = 1000000,I = 5,L = 5), equals(T))
})

test_that("affordability checker handles negative inputs appropriately", {})

test_that("Interest is calculated", {
  b <- applyMonthlyInterest(V = c(10,10,10), I = 3)
  expect_equal(b, expected = 30.14821963581234243179, tolerance = 10^(-10))
})

test_that("Null input for V returns NA", {
  b <- applyMonthlyInterest(V = c(), I = 3) 
  expect_that(is.na(b), is_true())
})
test_that("V containing a single value has one month's interest applied", {
  b <- applyMonthlyInterest(V = c(10), I = 3)
  expect_equal(b, expected = 10*1.03^(1/12), tolerance = 10^(-10))
})
test_that("A number passed to V has one month's interest applied", {
  b <- applyMonthlyInterest(V = 10, I = 3)
  expect_equal(b, expected = 10*1.03^(1/12), tolerance = 10^(-10))
})