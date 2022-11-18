# Load R packages
library(shiny)
library(shinythemes)
library(tidyverse)
library(shinydashboard)
library(rvest)


processUpcomingGames <- function(){
  upcomingGames <- read.csv('../ESPN_currentGamesWeek.csv')
  
  gameTables <- upcomingGames[,-1]
  
  currentDate = Sys.Date()
  for (t in 1:nrow(gameTables)){
    if(gameTables[t,1]<= currentDate -1 ){
      next
      
    } else {
      gameTables <- gameTables[-c(1:t),]
      break
    }
  }
  
  gameTables <- gameTables[,-c(2,4,6,7)]
  gameTables <- gameTables[c("date", "away_team_full_name", "home_team_full_name", "wp_away", "wp_home")]
  return(gameTables)
}

processUniqueDates <-function(gameTables){
  uniqueDates <- unique(gameTables[,1])
  return(uniqueDates)
  
}

parseGamesForDay <- function(gamesTableInput, date){
  gamesToSelect <- list()
  
  awayTeam <- gamesTableInput$away_team_full_name
  homeTeam <- gamesTableInput$home_team_full_name
  for (i in 1:nrow(gamesTableInput)){
    item <- paste(awayTeam[[i]],homeTeam[[i]],sep= " @ ")
    item <- paste(item, date, sep = " @ ")
    gamesToSelect <- append(gamesToSelect, item)
  }
  
  return(gamesToSelect)
}

sendOddsOfGameToCalculator <- function(string, listOfDays, listOfGames){
  gameInfo <- str_split(string, " @ ")
  gameInfo <- gameInfo[[1]]
  # print(gameInfo)
  awayTeam <- gameInfo[1]
  homeTeam <- gameInfo[2]
  date <- gameInfo[3]
  # print(awayTeam)
  # print(homeTeam)
  # print(date)
  
  if(date == listOfDays[1]){
    gameTable <- listOfGames[[1]]
    for(i in 1:nrow(gameTable)){
      
      if((awayTeam == gameTable[i,2]) && (homeTeam == gameTable[i,3])){
        return(gameTable[i,4])
        break
      }
    }
    
  } else {
    gameTable <- listOfGames[[2]]
    for(i in 1:nrow(gameTable)){
      
      if((awayTeam == gameTable[i,2]) && (homeTeam == gameTable[i,3])){
        return(gameTable[i,4])
        
      }
    }
  }
  # print(gameTable)
}

currentTable <-processUpcomingGames()
# print(currentTable)

distinctDates <- processUniqueDates(currentTable)
# print(distinctDates)

gamesByDay <- split(currentTable, currentTable$date)
# print(gamesByDay)

# totalGames <- getURLINFO()

todayGames <- gamesByDay[[1]]
tomorrowGames <- gamesByDay[[2]]
# colnames(todayGames)[2] = "MATCHUPWITH"

# print(awayTeam)
# print(homeTeam)
dayOneGames <- parseGamesForDay(todayGames, distinctDates[1])

dayTwoGames <- parseGamesForDay(tomorrowGames, distinctDates[2])

totalListOfGames <- append(dayOneGames, dayTwoGames)


# Define UI
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  
                  "Welcome to BettR!!!!",
                  tabPanel("Welcome Page",
                           # Sidebar with controls to select a dataset and specify
                           # the number of observations to view
                           # sidebarPanel(
                           #   numericInput("obs", "Observations:", 10)
                           # ),
                           sidebarPanel(
                           h1("Warning!"), "With the rise of the world of online sportsbooks, betting has become more reachable than ever, which can be a good and a bad thing. So, make sure that you know your limits and remember - bet only for entertainment purposes. Yes, the rewards may be higher when the odds are greater, but so is the risk of your money being lost. Wagering tons of money can lead to problem gambling, which is why you must always keep yourself in check.
                            And of course, as a rule of thumb, remember to gamble responsibly."),
                           mainPanel(
                             h1("Gambling Info"), h3("What are spreads?"), "The spread, also referred to as the line, is used to even the odds between two unevenly matched teams.
                            Bookmakers set a spread with the hopes of getting equal action on both sides of a game. For example, the Colts are a -3 point favorite against the Texans. The -3 points is the spread. If you want to bet the Colts on the spread, it would mean the Colts need to win by at least three points for you to win the bet. If the Colts win by two points, you would lose the bet because they didn't hit the key number of three.",
                             h3("What is a money line bet?"), "A moneyline bet is the simplest and most straightforward wager in all of sports betting. It is a bet that has potentially two or three outcomes depending on the sport. When there are two players or teams listed on a moneyline bet, bettors are choosing one player or team to win. All bettors have to do is a pick a winning side — or team or specifically a draw in a soccer/European football match or boxing/MMA fight if a draw is offered as an option. All a person has to do is select a winning team.",
                             h3("How to game responsibly?"), "Gambling responsibly means taking breaks, not using gambling as a source of income, only gambling with money that you can afford to lose, and setting limits for yourself (both with time and money). Limit-setting is actually easier to do online because a lot of online gambling sites have built-in tools that allow gamblers the ability to set limits directly on the site.
                                                              For example, an online casino patron can say, “OK, I only want to gamble for two hours today.” Then, all they have to do is put that time into the site and, after two hours, the site will tell the patron that they’ve reached their daily limit. Oftentimes, online sites also include 24-hour cooling off periods, where players can block themselves from using the platform entirely.",
                             
                           )#mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Upcoming Games",
                           # dashboardSidebar(tableOutput("data1")),
                           dashboardBody(fluidRow(h1("Upcoming NBA games for today and tomorrow"),
                             box(h4(paste("Games for ",distinctDates[1])),tableOutput("data1")),
                             box(h4("Games for ",distinctDates[2]),tableOutput("data2"))),
                             
                           
                           
                           box(
                             mainPanel(selectInput("state", "Choose a game:",
                                                 choices = totalListOfGames),
                                     textOutput("result")
                              
                              )
                             )
                           
                           )
                  ),
                  tabPanel("Betting Line",
                           verbatimTextOutput("txtoutput1"),
                           tags$h3("Input:"),
                           textInput("txt1", "Bet Dollar Amount On Game for Spread Bet: ", "100"),
                           h3("Expected Winnings on Away Team: "),
                           verbatimTextOutput("txtout1"),
                           h3("Expected Value Bet on Away Team: "),
                           verbatimTextOutput("txtout2"),
                           h3("Expected Winnings on Home Team: "),
                           verbatimTextOutput("txtout3"),
                           h3("Expected Value Bet on Home Team: "),
                           verbatimTextOutput("txtout4")
                           )
                  
                ) # navbarPage
                
)
# fluidPage

# Define server function  
server = function(input, output, session){
  currentTable <-processUpcomingGames()
  distinctDates <- processUniqueDates(currentTable)
  gamesByDay <- split(currentTable, currentTable$date)
  
  output$txtout1 <- renderText({
    as.double(sendOddsOfGameToCalculator(input$state, distinctDates, gamesByDay)) * as.double(input$txt1)
  }
  )
  output$txtout2 <- renderText({
    (as.double(sendOddsOfGameToCalculator(input$state, distinctDates, gamesByDay)) * as.double(input$txt1) - (1 - as.double(sendOddsOfGameToCalculator(input$state, distinctDates, gamesByDay))) * as.double(input$txt1))
  }
  )
  output$txtout3 <- renderText({
    (1 - as.double(sendOddsOfGameToCalculator(input$state, distinctDates, gamesByDay))) * as.double(input$txt1)
  }
  )
  output$txtout4 <- renderText({
    (1 - as.double(sendOddsOfGameToCalculator(input$state, distinctDates, gamesByDay))) * as.double(input$txt1) - (as.double(sendOddsOfGameToCalculator(input$state, distinctDates, gamesByDay)) * as.double(input$txt1))
  }
  )
  output$data1 <- renderTable({
    todayGames[,1:5]
  })
  output$data2 <- renderTable({
    tomorrowGames[,1:5]
  })
  output$txtoutput1 <- renderText({
    paste("You chose", input$state)
  })
  
  
  
}



# Run the application 
# Here we run the Shiny Application
# Create Shiny object
shinyApp(ui = ui, server = server)

