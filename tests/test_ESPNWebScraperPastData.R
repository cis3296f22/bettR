source("../ESPNWebScraperPastData.R", chdir = TRUE)
library(testthat)

test_that("real game id home getting win probability", {
  expect_equal(get_winp_home(400899374), -1)
  
})

test_that("fake game id home getting win probability", {
  expect_equal(get_winp_home(4013), -1)
})