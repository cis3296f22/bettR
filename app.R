# Load R packages
library(shiny)
library(shinythemes)
library(tidyverse)
library(shinydashboard)
library(rvest)

icon <- function (name, class = NULL, lib = "font-awesome"){
  if(lib=="local"){
    if(is.null(name$src)) {
      stop("If lib='local', 'name' must be a named list with a 'src' element
           and optionally 'width' (defaults to 100%).")
    }
    if(is.null(name$width)) name$width <- "100%"
    return(tags$img(class="img img-local", src=name$src, width=name$width))
  }
}

valueBox <- function (value, subtitle, icon = NULL, color = "aqua", width = 4, href = NULL){
  shinydashboard:::validateColor(color)
  if (!is.null(icon)) 
    shinydashboard:::tagAssert(icon, type = icon$name)
  if(!is.null(icon)){
    if(!icon$name %in% c("i", "img")) stop("'icon$name' must be 'i' or 'img'.")
    iconClass <- if(icon$name=="i") "icon-large" else "img"
  }
  boxContent <- div(class = paste0("small-box bg-", color), 
                    div(class = "inner", h3(value), p(subtitle)), if (!is.null(icon)) 
                      div(class = iconClass, icon))
  if (!is.null(href)) 
    boxContent <- a(href = href, boxContent)
  div(class = if (!is.null(width)) 
    paste0("col-sm-", width), boxContent)
}

#this can be moved somewhere else. Just for now its left here to run at the start to pull the games for the schedule
# myURL<-read_html("https://www.espn.com/nba/schedule")
# myURLTable<-html_table(myURL)
todayGames <- FALSE#myURLTable[[3]]
todayGames <- data.frame()
# colnames(todayGames)[2] = "MATCHUPWITH"
# print(todayGames)
# print(nrow(todayGames))
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


welcomePage <- tabPanel("Welcome Page",
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
)

upcomingGames <- tabPanel("Upcoming Games" ,  dashboardHeader(title = "Games for Today"),
                          dashboardSidebar(width = "300px",
                                           tableOutput("data1")),
                          dashboardBody(),
                          selectInput("state", "Choose a game:",
                                      choices = gamesForTheDay),
                          textOutput("result"),
                          
                          sidebarPanel(
                            verbatimTextOutput("txtoutput")
                          )
)

bettingLine <- tabPanel("Betting Line", tags$h3("Input:"),
                        textInput("txt1", "Home Team Bet Line:", ""),
                        textInput("txt2", "Away Team Bet Line:", "")
)

# icon=icon(list(src="bettrIcon.png", width=200), lib="local")

# includeHTML("index.html")
# How to make sure it prioritizes stylesheet
# tags$iframe(src="index.html",width="100%", height="500%")
# , includeHTML("index.html"), includeCSS("stylesheet.css")
newHome <- tabPanel("Home", h1("home"), img(src="bettrIcon.png"), a(href="https://jaredstef.me", "Jared Stefanowicz"), actionButton("link1", ""), includeCSS("www/app.css"))
newGames <- tabPanel("Games",
                     h1("Games"),
                     dateInput("date1", "Date"),
                     h2("Mon, November 7 2022"),
                     column( 6,
                             fluidRow(
                               column(4, 
                                      h4("Brooklyn Nets"),
                                      h4("Philadelphia 76ers")),
                               column(2, actionButton("button1", "View"))
                             ),
                             fluidRow(
                               column(4, 
                                      h4("Brooklyn Nets"),
                                      h4("Philadelphia 76ers")),
                               column(2, actionButton("button1", "View"))
                             )
                     ),
                     column( 6,
                             fluidRow(
                               column(4, 
                                      h4("Brooklyn Nets"),
                                      h4("Philadelphia 76ers")),
                               column(2, actionButton("button1", "View"))
                             ),
                             fluidRow(
                               column(4, 
                                      h4("Brooklyn Nets"),
                                      h4("Philadelphia 76ers")),
                               column(2, actionButton("button1", "View"))
                             )
                     ),
                     h2("Mon, November 7 2022"),
                     column( 6,
                             fluidRow(
                               column(4, 
                                      h4("Brooklyn Nets"),
                                      h4("Philadelphia 76ers")),
                               column(2, actionButton("button1", "View"))
                             ),
                             fluidRow(
                               column(4, 
                                      h4("Brooklyn Nets"),
                                      h4("Philadelphia 76ers")),
                               column(2, actionButton("button1", "View"))
                             )
                     ),
                     column( 6,
                             fluidRow(
                               column(4, 
                                      h4("Brooklyn Nets"),
                                      h4("Philadelphia 76ers")),
                               column(2, actionButton("button1", "View"))
                             ),
                             fluidRow(
                               column(4, 
                                      h4("Brooklyn Nets"),
                                      h4("Philadelphia 76ers")),
                               column(2, actionButton("button1", "View"))
                             )
                     )
                    )
newPredictions <- tabPanel(
  "Predictions", 
  h1("Predictions"), 
  selectInput("times", "Time Range", c("1 Month", "6 Months", "1 Year", "3 Years")),
  plotOutput("plot1"),
  tableOutput("table1")
  )

ipsum <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

newResources <- tabPanel("Resources",
                         h1("Resources"),
                         sidebarPanel(
                           navlistPanel(
                             tabPanel("Section1"),
                             tabPanel("Section2"),
                             tabPanel("Section3"),
                             tabPanel("Section4"),
                             well=FALSE
                           )
                         ),
                         mainPanel(
                           h2("Section1"),
                           p(ipsum),
                           p(ipsum),
                           p(ipsum),
                           h2("Section2"),
                           p(ipsum),
                           p(ipsum),
                           p(ipsum),
                           h2("Section3"),
                           p(ipsum),
                           p(ipsum),
                           p(ipsum),
                           h2("Section4"),
                           p(ipsum),
                           p(ipsum),
                           p(ipsum),
                           )
                         )
newAbout <- tabPanel("About", h1("About"))
newView <- tabPanel("View",
                    h1("November 7th, 2022"),
                    h2("Nets"),
                    h2("@"),
                    h2("Sixers"),
                    h2("New York Nets at"),
                    h2("Philaelphia 76ers"),
                    tableOutput("table2"),
                    h1("Bet Screener"),
                    textInput("text1", "Amount"),
                    textInput("text2", "Spread"),
                    textInput("text3", "Probability"),
                    checkboxInput("box1", "Use Bettr Projection"),
                    h3("Expected Winnings:"),
                    h3("$-9.80"),
                    h4("Weekly for 1 Month: $-38.40"),
                    h4("Weekly for 6 Months: $-249.60"),
                    h4("Weekly for 1 Year: $-499.20"),
                    h3("Take -354 Odds or Lower")
                    )

# Define UI
ui <- fluidPage(theme="app.css",
                navbarPage(
                  # "Welcome to BettR!!!!",
                  # welcomePage, # Navbar 1, tabPanel
                  # upcomingGames,
                  # bettingLine
                  "Bettr",
                  newHome,
                  newGames,
                  newPredictions,
                  newResources,
                  newAbout,
                  newView
                ) # navbarPage
)
# fluidPage

# Define server function  
server = function(input, output, session) { 
  print("test")
  output$plot1 <- renderPlot({
    s1 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
    s2 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
    s3 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
                              
    plot(c(), type="b", ylim=c(min(min(s1), min(s2), min(s3)),max(max(s1), max(s2), max(s3))), xlim=c(1, 365))
    lines(c(1:365), s1, col="red")
    lines(c(1:365), s2, col="blue")
    lines(c(1:365), s3, col="green")
    legend(x ="topleft", col=c("red", "green", "blue"), legend=c("ESPN", "FiveThirtyEight","Bettr Composite"), lwd=1, lty=c(1,1,1))
  })
    print("rendered")
    
    exampleModels <- data.frame(
      Source=c("Bettr Composite", "ESPN", "FiveThirtyEight"),
      Start.Date=c("11-04-2022", "09-01-2015", "09-01-2015"),
      Accuracy90=c(0.82, 0.71, 0.78),
      Accuracy1yr=c(0.82, 0.71, 0.84),
      AccuracyOverall=c(0.81, 0.77, 0.80)
    )
    names(exampleModels) <- c("Source", "Start Date", "90 Day Accuracy", "1 Year Accuracy", "Overall Accuracy")
    output$table1 <- renderTable({ exampleModels })
    
    print("example models")
    
    gameModels <- data.frame(
      Source=c("Bettr Composite", "ESPN", "FiveThirtyEight"),
      Home.Win.Per=c("78%", "85%", "74%"),
      Away.Win.Per=c("22%", "15%", "26%"),
      Accuracy90=c(0.82, 0.71, 0.78),
      Accuracy1yr=c(0.82, 0.71, 0.84),
      AccuracyOverall=c(0.81, 0.77, 0.80)
    )
    names(gameModels) <- c("Source", "Home Win %", "Away Win %", "90 Day Accuracy", "1 Year Accuracy", "Overall Accuracy")
    output$table2 <- renderTable({ gameModels })
    print("game models")
    
    observeEvent(input$link1, {
      print("clicked!")
    })
    print("finish")
  }
    
  # output$txtout <- renderText({
  #   paste( input$txt1, input$txt2, sep = " " )
  # }
  # )
  # output$data1 <- renderTable({
  #   head(todayGames[,1:3])
  # })
  # output$txtoutput <- renderText({
  #   paste("You chose", input$state)
  # })



# Run the application 
# Here we run the Shiny Application
# Create Shiny object
shinyApp(ui = ui, server = server)

