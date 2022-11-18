library(hoopR)
library(tidyverse)

get_winp_home <- function(id) {
  if (is.null(id)) {
    return(0)
  }
  return(espn_nba_wp(game_id = id)[1, c(3, 4)][[1]])
}

get_winp_away <- function(id) {
  if (is.null(id)) {
    return(0)
  }
  return(espn_nba_wp(game_id = id)[1, c(3, 4)][[2]])
}

#Gets last monday (beginning of week)
lastmon <- function(x) 7 * floor(as.numeric(x-1+4)/7) + as.Date(1-4, origin="1970-01-01")

#Convert date to an integer usable in hoopR
cdate <- toString(lastmon(Sys.Date()))
cdate <- gsub("-", "", date)
cdate <- strtoi(cdate)


#dataframes
df_mon <- espn_nba_scoreboard(cdate)
df_tues <- espn_nba_scoreboard(cdate + 1)
df_wed <- espn_nba_scoreboard(cdate + 2)
df_thurs <- espn_nba_scoreboard(cdate + 3)

newdf <- rbind(df_mon, df_tues, df_wed, df_thurs, fill=TRUE)
newdf <- newdf[,c('game_date','season', 'home_team_full_name', 'home_team_abb', 'away_team_full_name', 'away_team_abb','game_id')]
newdf <- transform(newdf, game_id = as.integer(game_id))
newdf$winpb_home <- mapply(get_winp_home,newdf$game_id)
print(newdf$game_id)
newdf$winpb_away <- mapply(get_winp_away,newdf$game_id)
write.csv(newdf, 'ESPN_CurrentGamesWeek.csv')