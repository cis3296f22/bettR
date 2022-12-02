source("../FiveThirtyEightParser.R", chdir = TRUE)
library(testthat)

FiveThirtyEight_Predictions <- read.csv("../FiveThirtyEight.csv")


test_that("getting 538 data", {
  expect_equal(fiveThirtyEight_execute(), 0)
  
})

