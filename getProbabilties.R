library(tidyverse)
library(rvest)
library(hoopR)
library(berryFunctions)

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
  checkError <- tryCatch(espn_nba_wp(game_id = id), error = function(e) e)
  if ( is.numeric(checkError$code) ) {
    print("executing here")
    return( get_future_odds_home(id) )
  }
  else {
    return( espn_nba_wp(game_id = id) )
  }
}


future = 401468375
past = 401468361

test <- insert_wp_home(future)

test

