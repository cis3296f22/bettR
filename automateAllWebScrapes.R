library(hoopR)
library(tidyverse)
library(rvest)
library(reticulate)
library(plyr)
library(dplyr)

execute_All <- function(){
  working_Dir <- getwd()
  setwd(working_Dir)
  wd_value <- paste(working_Dir,"/","getProbabilties.R", sep = "")
  wd_value
  print("executing getProbabilities.R")
  source("C:/Users/kjang/Desktop/Fall 2022/CIS3296/Final Project/bettR/getProbabilties.R")
  get_Probabilities_execute()
  print("executing future_with_webscraping.R")
  source("C:/Users/kjang/Desktop/Fall 2022/CIS3296/Final Project/bettR/future_with_webscraping.R")
  get_Future_odds_execute()
  #print("executing fiveThirtyEightParser.R")
  #source("C:/Users/kjang/Desktop/Fall 2022/CIS3296/Final Project/bettR/fiveThirtyEightParser.R")
  #fiveThirtyEight_execute()
  #print("executing ESPNWebScraperPastData.R")
  #source("C:/Users/kjang/Desktop/Fall 2022/CIS3296/Final Project/bettR/ESPNWebScraperPastData.R")
  #ESPNPastScrape_execute()
  print("executing modelDataFrameBuilder.py")
  py_run_file("C:/Users/kjang/Desktop/Fall 2022/CIS3296/Final Project/bettR/modelDataFrameBuilder.py")
}

execute_All()