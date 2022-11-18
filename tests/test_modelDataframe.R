source("../modelDataframe.R", chdir = TRUE)
library(testthat)

#To test script, we create dummy dataframe and call function 'f':
home_team <- c("BOS", "ATL", "CTR")
away_team <- c("ATL", "BOS", "WLP")
homewp <- c(0.777,0.999,0.123)
dummyDf <- data.frame(home_team, away_team, homewp)
inverseList = list(0.999,0.777,0.123)

test_that("get similar win probability", {
  expect_equal(apply(modelDf, 1, f), inverseList)
})