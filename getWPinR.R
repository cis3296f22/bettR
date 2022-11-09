library("hoopR")
library(tidyverse)

#Get win probability of matchups based on game ID from ESPN
get_winp <- function(id)  {
  wp <- espn_nba_wp(game_id = id)[1, 3:4]
  return(wp)
}

get_winp(401468300)

