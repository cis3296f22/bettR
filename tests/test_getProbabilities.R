source("C:/Users/aruna/bettR/getProbabilties.R", chdir = TRUE)
library(testthat)

test_that("getting future odds away for real game", {
  expect_equal(get_future_odds_away(401360358), 0.778)
  
})

test_that("getting future odds home for real game", {
  expect_equal(get_future_odds_home(4013), 0.778)
})

test_that("real game id home getting win probability", {
  expect_equal(insert_wp_home(401360358), 0.778)
  
})

test_that("real game id away getting win probability", {
  expect_equal(insert_wp_away(401360358), 0.778)
})

test_that("getting date string", {
  expect_equal(get_date("2022-11-18",1), 2022-11-18)
})

test_that("testing function that advances the day", {
  expect_equal(advance_day("2022-11-18",1), 2022-11-19)
})

