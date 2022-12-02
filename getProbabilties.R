#'The purpose of this R file is to retrieve win probabilities from the current week's NBA games from ESPN, and combine them in a singular R DataFrame
#' To be used in the front end
library(tidyverse)
library(rvest)
library(hoopR)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # Set working directory to source


#' Retrieve Future Away Team Win Odds
#' 
#' @param id An integer gameID corresponding to a specific NBA game
#' @return away_pb A double representing win probability
#' @export
get_future_odds_away <- function(id) {
  URL <- paste("https://www.espn.com/nba/game?gameId=", id, sep = '')
  
  get_odds <- read_html(URL) %>% html_node(".copy") %>% html_text()
  get_odds <- gsub('%', '', get_odds)
  away_pb <- as.numeric(get_odds) / 100
  
  return(away_pb)
}

#' Retrieve Future Home Team Win Odds
#' 
#' @param id An integer gameID corresponding to a specific NBA game
#' @return home_pb A double representing win probability
get_future_odds_home <- function(id) {
  home_pb <- 1 - get_future_odds_away(id)
  return(home_pb)
}

#' Function to insert home probabilities into a dataframe
#' 
#' @param id An integer gameID corresponding to a specific NBA game
#' @return None
#' @export
#' @examples 
#' insert_wp_home(20221205)
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

#' Function to insert away probabilities into a dataframe
#' 
#' @param id An integer gameID corresponding to a specific NBA game
#' @return None
#' @export
#' @examples 
#' insert_wp_away(20221205)
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


#' Function to retrieve the date of the last monday
#' 
#' @param x An R Date Object representing a date in YYYY-DD-MM
#' @return An R Date Object
#' @export
#' @examples 
#' lastMonday(Sys.Date())
lastMonday <- function(x) 7 * floor(as.numeric(x-1+4)/7) + as.Date(1-4, origin="1970-01-01")

#' Function to retrieve the date, allowing for adding days, to be inserted into dataframes
#' 
#' @param date_string A string of the a day in format YYYY-DD-MM
#' @param days A integer days to be added to a particular date
#' @return A string object of a date in format YYYY-DD-MM
#' @export
#' @examples 
#' get_date("2022-12-02", 3)
get_date <- function(date_string, days) {
  return(toString(as.Date(date_string)+days))
}

#' Function to retrieve the date, allowing for adding days, to be used in HoopR functions
#' 
#' @param date_string A string of the a day in format YYYY-DD-MM
#' @param days A integer days to be added to a particular date
#' @return A string object of a date in format YYYYDDMM
#' @export
#' @examples 
#' advance_day("2022-12-02", 3)
advance_day <- function(date_string, days) {
  date_string <- toString(as.Date(date_string)+days)
  date_string <- gsub("-", '', date_string)
  return(date_string)
}

cdate <- toString(lastMonday(Sys.Date())) #'Get Date of last monday

df_mon <- espn_nba_scoreboard(season = advance_day(cdate, 0)) #'Create dataframe for Monday's Games
df_mon$date <- get_date(cdate, 0)

df_tues <- espn_nba_scoreboard(season = advance_day(cdate, 1)) #'Create dataframe for Tuesdays' Games
df_tues$date <- get_date(cdate, 1)

df_wed <- espn_nba_scoreboard(season = advance_day(cdate, 2)) #'Create dataframe for Wednesdays' Games
df_wed$date <- get_date(cdate, 2)

df_thurs <- espn_nba_scoreboard(season = advance_day(cdate, 3)) #'Create dataframe for Thursday's Games
df_thurs <- get_date(cdate, 3)

df_fri <- espn_nba_scoreboard(season = advance_day(cdate, 4)) #'Create dataframe for Friday's Games
df_fri$date <- get_date(cdate, 4)

df_sat <- espn_nba_scoreboard(season = advance_day(cdate, 5)) #'Create dataframe for Saturday's Games
df_sat$date <- get_date(cdate, 5)

df_sun <- espn_nba_scoreboard(season = advance_day(cdate, 6)) #'Create dataframe for Sunday's Games
df_sun$date <- get_date(cdate, 6)

df <- rbind(df_mon, df_tues, df_wed, df_thurs, df_fri, df_sat, df_sun, fill=TRUE) #'Combine all of the week's dataframes into one
df<- df[,c('date', 'season', 'home_team_full_name', 'home_team_abb', 'away_team_full_name', 'away_team_abb','game_id')]
df <- transform(df, game_id = as.integer(game_id))
df$wp_home <- mapply(insert_wp_home, df$game_id)
df$wp_away <- mapply(insert_wp_away, df$game_id)
df <- na.omit(df)
df <- apply(df,2,as.character) #not really sure why this works
write.csv(df, "ESPN_CurrentGamesWeek.csv")