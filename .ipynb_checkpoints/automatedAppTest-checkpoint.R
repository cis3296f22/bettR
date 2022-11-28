library(shinytest)



context("Test Bettr App")

#recordTest("C:/Users/kjang/Desktop/Fall 2022/CIS3296/Final Project/bettR/app.R")

test_that("output is correct", {
  app$setInputs(txt1 = "100")
  app$setInputs(txt2 = "-110")
  # app$setInputs(state = "1")
  
  output <- app$getValue(name = "txtout")
  print(output$txtout)
  
  expect_equal(output, "100 -110")
})