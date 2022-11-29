library(hoopR)
library(tidyverse)
library(plyr)

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

years <- list('2018','2019','2020','2021','2022')
months <- list('01','02','03','04','05','06','07','08','09','10','11','12')
dfdates <- do.call(paste0, expand.grid(years, months))
dfdates <- as.numeric(unlist(dfdates))
otherdates <- list(201710,201711,201712,202301,202302,202303,202304)
for (otherDate in seq_along(otherdates))
{
  dfdates <- append(dfdates, otherdates[otherDate])
}


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

newdf <- getCombinedDf(dfdates)
newdf

newdf <- as.data.frame(newdf)

write.csv(newdf, 'ESPN_PastData.csv')
