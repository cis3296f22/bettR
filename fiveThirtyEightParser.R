library(tidyverse)

fiveThirtyEight_execute <- function(){
    #538 Data:
    FiveThirtyEight_Predictions <- read_csv("https://projects.fivethirtyeight.com/nba-model/nba_elo.csv")

    #Cleaning:
    FiveThirtyEight_Predictions <- FiveThirtyEight_Predictions %>%
      dplyr::select(date, season, team1, team2, elo_prob1) %>%
      dplyr::rename(fivethirtyeight_home_wp = elo_prob1)

    head(FiveThirtyEight_Predictions)
    write.csv(FiveThirtyEight_Predictions, 'FiveThirtyEight.csv')
}


