library(tidyverse)

#' Function to Scrape Five Thirty Eight Data and output as a CSV
#'
#' @return csv file 'FiveThirtyEightParser.csv'
#' @export
#'
#' @examples fiveThirtyEight_execute()
fiveThirtyEight_execute <- function(){
    #538 Data:
    FiveThirtyEight_Predictions <- read.csv("https://projects.fivethirtyeight.com/nba-model/nba_elo.csv")

    #Cleaning:
    FiveThirtyEight_Predictions <- FiveThirtyEight_Predictions %>%
      dplyr::select(date, season, team1, team2, raptor_prob1) %>%
      dplyr::rename(fivethirtyeight_home_wp = raptor_prob1)

    write.csv(FiveThirtyEight_Predictions, 'FiveThirtyEight.csv')
    #Upon Success, return 0:
    return(0)
}



