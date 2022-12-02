source("../ESPNWebScraperPastData.R", chdir = TRUE)
library(testthat)

test_that("real game id home getting win probability", {
  expect_equal(get_winp_home(401360358), 0.778)
  
})

test_that("fake game id home getting win probability", {
  expect_equal(get_winp_home(4013), 0.778)
})

test_that("real game id away getting win probability", {
  expect_equal(get_winp_away(401360358), 0.778)
  
})

test_that("fake game id away getting win probability", {
  expect_equal(get_winp_away(4013), 0.778)
})