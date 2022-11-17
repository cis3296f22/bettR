library(tidyverse)
library(rvest)
library(hoopR)

get_future_odds_away <- function(id) {
  URL <- paste("https://www.espn.com/nba/game?gameId=", id, sep = '')
  
  get_odds <- read_html(URL) %>% html_node(".copy") %>% html_text()
  get_odds <- gsub('%', '', get_odds)
  away_pb <- as.numeric(get_odds) / 100
  
  return(away_pb)
}

get_future_odds_home <- function(id) {
  return(1 - get_future_odds_away(id))
}

insert_wp_home <- function(id) {
  errorCheckers <- tryCatch(espn_nba_wp(game_id = id), error = function(e) e, silent=TRUE)
  if ( is.numeric(errorCheckers$code) ) {
    return(NULL)
  }
  else if (is.null(errorCheckers$code) && length(espn_nba_wp(game_id = id)) == 21) {
    return(espn_nba_wp(game_id = id)[1, c(3, 4)][[1]])
  }
  else {
    return(get_future_odds_home(id))
  }
}

insert_wp_away <- function(id) {
  errorCheckers <- tryCatch(espn_nba_wp(game_id = id), error = function(e) e, silent=TRUE)
  if ( is.numeric(errorCheckers$code) ) {
    return(NULL)
  }
  else if (is.null(errorCheckers$code) && length(espn_nba_wp(game_id = id)) == 21) {
    return(espn_nba_wp(game_id = id)[1, c(3, 4)][[2]])
  }
  else {
    return(get_future_odds_away(id))
  }
}

lastMonday <- function(x) 7 * floor(as.numeric(x-1+4)/7) + as.Date(1-4, origin="1970-01-01")

#Convert date to an integer usable in hoopR
get_date <- function(date_string, days) {
  return(toString(as.Date(date_string)+days))
}

advance_day <- function(date_string, days) {
  date_string <- toString(as.Date(date_string)+days)
  date_string <- gsub("-", '', date_string)
  return(date_string)
}

cdate <- toString(lastMonday(Sys.Date())) #YYYY-MM-DD

df_mon <- espn_nba_scoreboard(season = advance_day(cdate, 0))
df_mon$date <- get_date(cdate, 0)

df_tues <- espn_nba_scoreboard(season = advance_day(cdate, 1))
df_tues$date <- get_date(cdate, 1)

df_wed <- espn_nba_scoreboard(season = advance_day(cdate, 2))
df_wed$date <- get_date(cdate, 2)

df_thurs <- espn_nba_scoreboard(season = advance_day(cdate, 3))
df_thurs <- get_date(cdate, 3)

df_fri <- espn_nba_scoreboard(season = advance_day(cdate, 4))
df_fri$date <- get_date(cdate, 4)

df_sat <- espn_nba_scoreboard(season = advance_day(cdate, 5))
df_sat$date <- get_date(cdate, 5)

df_sun <- espn_nba_scoreboard(season = advance_day(cdate, 6))
df_sun$date <- get_date(cdate, 6)

df <- rbind(df_mon, df_tues, df_wed, df_thurs, df_fri, df_sat, df_sun, fill=TRUE)
df<- df[,c('date', 'season', 'home_team_full_name', 'home_team_abb', 'away_team_full_name', 'away_team_abb','game_id')]
df <- transform(df, game_id = as.integer(game_id))
df$wp_home <- mapply(insert_wp_home, df$game_id)
df$wp_away <- mapply(insert_wp_away, df$game_id)
df <- na.omit(df)

df <- apply(df,2,as.character) #not really sure why this works
write.csv(df, 'ESPN_CurrentGamesWeek.csv')
