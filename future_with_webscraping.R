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

get_Future_odds_execute <- function(){
  df_t <- espn_nba_scoreboard('20221116')
  df_t <- transform(df_t, game_id = as.integer(game_id))
  df_t$wp_away <- mapply(get_future_odds_away, df_t$game_id)
  df_t$wp_home <- mapply(get_future_odds_home, df_t$game_id)
  df_t
}

