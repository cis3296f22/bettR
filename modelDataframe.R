library(tidyverse)

#538 Past Data:
FiveThirtyEight_Predictions <- read_csv("FiveThirtyEight.csv")
#ESPN Past Data:
ESPN_Predictions <- read_csv("ESPN_PastData.csv")

#Data Cleaning: remove Unnecessary columns from dataframes, remove unnecessary old data, remove bad rows (no win probability):
FiveThirtyEight_Predictions$year <- as.numeric(format(FiveThirtyEight_Predictions$date, "%Y"))
FiveThirtyEight_Predictions <- FiveThirtyEight_Predictions %>%
  dplyr::filter(year == 2018 | year == 2019 | year == 2020 | year == 2021 | year == 2022) %>%
  dplyr::select(team1, team2, fivethirtyeight_home_wp) %>%
  dplyr::rename(homewp = fivethirtyeight_home_wp, home_team = team1, away_team = team2)
ESPN_Predictions <- ESPN_Predictions %>%
  dplyr::select(home_team_abb, away_team_abb, winpb_home) %>%
  dplyr::rename(homewp = winpb_home, home_team = home_team_abb, away_team = away_team_abb) %>%
  dplyr::filter(homewp != -1)

#New Dataframe that appends two datasets:
combined <- FiveThirtyEight_Predictions %>%
  dplyr::bind_rows(ESPN_Predictions)

#Model Dataframe: final column gets average of win probabilities for team1 and team2, in that order
modelDf = combined %>% group_by(home_team, away_team) %>%
  summarise(averageWinpb = mean(homewp))

#Function to find other win probability, if it exists (ex: winpb for BOS vs ATL if ATL vs BOS exists in dataframe)
f <- function(x,output) 
  {
  homeTeam <- x[1]
  awayTeam <- x[2]
  homeProbability <- x[3]
  if (length(which(modelDf[,1] == awayTeam & modelDf[,2] == homeTeam)) != 0)
  {
    rowNumOpposite <- which(modelDf[,1] == awayTeam & modelDf[,2] == homeTeam)
    otherWp <- modelDf[rowNumOpposite,3]
    otherWp <- otherWp[[1]]
    return(otherWp)
  }
  else
  {
    return(homeProbability)
  }
}

#Adding inverse wp into dataframe as separate column
inversePb <- apply(modelDf, 1, f)
modelDf <- cbind(modelDf, otherPb = inversePb)
modelDf <- transform(modelDf, otherPb = as.double(otherPb))

#Getting average of two win probability columns
modelDf <- modelDf %>% rowwise() %>%
  mutate(averagewinpb = mean(c_across(averageWinpb:otherPb)))

#Removing old two win probability columns
modelDf <- modelDf %>%  
  dplyr::select(home_team, away_team, averagewinpb)

#Writing to csv:
write.csv(modelDf, 'model_Data.csv')
