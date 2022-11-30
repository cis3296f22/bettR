library(tidyverse)

fiveThirtyEight_execute <- function(){
    #538 Data:
    FiveThirtyEight_Predictions <- read.csv("https://projects.fivethirtyeight.com/nba-model/nba_elo.csv")

    #Cleaning:
    FiveThirtyEight_Predictions <- FiveThirtyEight_Predictions %>%
      dplyr::select(date, season, team1, team2, raptor_prob1) %>%
      dplyr::rename(fivethirtyeight_home_wp = raptor_prob1)

    head(FiveThirtyEight_Predictions)
    write.csv(FiveThirtyEight_Predictions, 'FiveThirtyEight.csv')
}



