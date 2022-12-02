library(hoopR)
library(tidyverse)
library(plyr)

#' Function to get win probability for home team
#'
#' @param id The game id for a given NBA game
#'
#' @return the win probability predicted by ESPN, or -1 if none available
#' @export
#'
#' @examples get_winp_home(400899374)
get_winp_home <- function(id)  
{
  wp = -1
  tryCatch(
    expr = {
      wp <- espn_nba_wp(game_id = id)[1, 4]
      wp <- wp[[1]]
    },
    error = function(e){wp = -1},
    warning = function(w){wp = -1}
  )
  return(wp)
}

#' Function to get the dataframe that combines the data from ESPN based on a list of a dates.
#' It gathers the data into a dataframe from each date in the list, merges the dataframes, and cleans the data.
#' It also calls the function get_winpb_home in order to get the win probabilities
#'
#' @param listOfDates: the list of desired dates to get data for
#'
#' @return the combined dataframe of ESPN NBA data
#' @export
#'
#' @examples getCombinedDf(list(201710,201711,201712,202301,202302,202303,202304))
getCombinedDf <- function(listOfDates)
{
  dictList <- list()
  for(date in listOfDates)
  {
    tempDf <- espn_nba_scoreboard(date)
    dictList <- append(dictList, list(tempDf))
  }
  newdf <- bind_rows(dictList, .id = "column_label")
  newdf <- newdf[,c('game_date','season','home_team_abb', 'away_team_abb','game_id')]
  newdf <- transform(newdf, game_id = as.integer(game_id))
  newdf$winpb_home <- mapply(get_winp_home,newdf$game_id)
  newdf <- transform(newdf, winpb_away= ifelse(winpb_home!=-1, 1-winpb_home, -1))
  return(newdf)
}

#' Function to Execute ESPN Web Scraper. 
#' Creates list of dates and calls getCombinedDf using this list of dates.
#' The data frame is then written to the csv 'ESPN_PastData.csv'
#'
#' @return writes csv 'ESPN_PastData.csv'
#' @export
#'
#' @examples ESPNPastScrape_execute()
ESPNPastScrape_execute <- function(){
  years <- list('2018','2019','2020','2021','2022')
  months <- list('01','02','03','04','05','06','07','08','09','10','11','12')
  dfdates <- do.call(paste0, expand.grid(years, months))
  dfdates <- as.numeric(unlist(dfdates))
  otherdates <- list(201710,201711,201712,202301,202302,202303,202304)
  for (otherDate in seq_along(otherdates))
  {
    dfdates <- append(dfdates, otherdates[otherDate])
  }
  newdf <- getCombinedDf(dfdates)
  newdf

  newdf <- as.data.frame(newdf)

  write.csv(newdf, 'ESPN_PastData.csv')
}
ESPNPastScrape_execute()