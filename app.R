# Load R packages
library(shiny)
library(shinythemes)
library(tidyverse)
library(shinydashboard)
library(rvest)

#this can be moved somewhere else. Just for now its left here to run at the start to pull the games for the schedule
myURL<-read_html("https://www.espn.com/nba/schedule")
myURLTable<-html_table(myURL)
todayGames <- myURLTable[[3]]
colnames(todayGames)[2] = "MATCHUPWITH"
print(todayGames)
print(nrow(todayGames))
# tableSize <- nrow(todayGames)
# print(tableSize)
awayTeam <- todayGames$MATCHUP
homeTeam <- todayGames$MATCHUPWITH

# print(awayTeam)
# print(homeTeam)
gamesForTheDay <- list()
for (i in 1:nrow(todayGames)){
  # print(i)
  # print(awayTeam[[i]])
  # print(homeTeam[[i]])
  item <- paste(awayTeam[[i]],homeTeam[[i]],sep= " ")
  # print(item)
  gamesForTheDay <- append(gamesForTheDay, item)
}
print(gamesForTheDay)

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
                             h1("Gambling Info"), h2("What are spreads?"), "The spread, also referred to as the line, is used to even the odds between two unevenly matched teams.
                            Bookmakers set a spread with the hopes of getting equal action on both sides of a game. For example, the Colts are a -3 point favorite against the Texans. The -3 points is the spread. If you want to bet the Colts on the spread, it would mean the Colts need to win by at least three points for you to win the bet. If the Colts win by two points, you would lose the bet because they didn't hit the key number of three.",
                             h3("What is a money line bet?"), "A moneyline bet is the simplest and most straightforward wager in all of sports betting. It is a bet that has potentially two or three outcomes depending on the sport. When there are two players or teams listed on a moneyline bet, bettors are choosing one player or team to win. All bettors have to do is a pick a winning side — or team or specifically a draw in a soccer/European football match or boxing/MMA fight if a draw is offered as an option. All a person has to do is select a winning team.",
                             h4("How to game responsibly?"), "Gambling responsibly means taking breaks, not using gambling as a source of income, only gambling with money that you can afford to lose, and setting limits for yourself (both with time and money). Limit-setting is actually easier to do online because a lot of online gambling sites have built-in tools that allow gamblers the ability to set limits directly on the site.
                                                              For example, an online casino patron can say, “OK, I only want to gamble for two hours today.” Then, all they have to do is put that time into the site and, after two hours, the site will tell the patron that they’ve reached their daily limit. Oftentimes, online sites also include 24-hour cooling off periods, where players can block themselves from using the platform entirely.",
                             h5("Odds Line "),
                             verbatimTextOutput("txtout")
                           )#mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Upcoming Games" ,  dashboardHeader(title = "Games for Today"),
                           dashboardSidebar(width = "300px",
                                            tableOutput("data1")),
                           dashboardBody(),
                           selectInput("state", "Choose a game:",
                                       choices = gamesForTheDay),
                           textOutput("result"),
                           
                           sidebarPanel(
                              verbatimTextOutput("txtoutput")
                           )
                  ),
                  tabPanel("Betting Line", tags$h3("Input:"),
                           textInput("txt1", "Home Team Bet Line:", ""),
                           textInput("txt2", "Away Team Bet Line:", "")
                           )
                  
                ) # navbarPage
)
# fluidPage

# Define server function  
server = function(input, output, session){
  output$txtout <- renderText({
    paste( input$txt1, input$txt2, sep = " " )
  }
  )
  output$data1 <- renderTable({
    head(todayGames[,1:3])
  })
  output$txtoutput <- renderText({
    paste("You chose", input$state)
  })
}



# Run the application 
# Here we run the Shiny Application
# Create Shiny object
shinyApp(ui = ui, server = server)

