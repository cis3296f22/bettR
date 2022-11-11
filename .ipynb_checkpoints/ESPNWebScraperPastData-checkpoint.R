library(hoopR)
library(tidyverse)

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
get_winp_away <- function(id)  
{
  tryCatch(
    expr = {
      wp <- espn_nba_wp(game_id = id)[1, 4]
      wp <- wp[[1]]
    },
    error = function(e){wp <- -1},
    warning = function(w){wp <- -1}
  )
  return(wp)
}
df2022 <- espn_nba_scoreboard(2022)
df2021 <- espn_nba_scoreboard(2021)
df2020 <- espn_nba_scoreboard(2020)
df2019 <- espn_nba_scoreboard(2019)
df2018 <- espn_nba_scoreboard(2018)
newdf <- rbind(df2022,df2021,df2020,df2019,df2018)
newdf <- as.data.frame(newdf)
newdf <- newdf[,c('game_date','season','home_team_abb', 'away_team_abb','game_id')]
newdf <- transform(newdf, game_id = as.integer(game_id))
newdf$winpb_home <- mapply(get_winp_home,newdf$game_id)
newdf <- transform(newdf, winpb_away= ifelse(winpb_home!=-1, 1-winpb_home, -1))
#newdf$winpb_away <- mapply(get_winp_away,newdf$game_id)
head(newdf)
write.csv(newdf, 'ESPN_PastData.csv')
