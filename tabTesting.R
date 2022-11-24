# Load R packages
library(shiny)
# library(shinythemes)
library(tidyverse)
library(shinydashboard)
library(rvest)

setwd("/Users/jaredstef/Developer/bettR/")

# Maps 538 Team Abbreviations to Full Names and Icons
lookup <- data.frame(
  abbrev=c(
    "ATL",
    "BOS",
    "BRK",
    "CHI",
    "CHO",
    "CLE",
    "DAL",
    "DEN",
    "DET",
    "GSW",
    "HOU",
    "IND",
    "LAC",
    "LAL",
    "MEM",
    "MIA",
    "MIL",
    "MIN",
    "NOP",
    "NYK",
    "OKC",
    "ORL",
    "PHI",
    "PHO",
    "POR",
    "SAC",
    "SAS",
    "TOR",
    "UTA",
    "WAS"
    ),
  full=c(
    "Atlanta Hawks",
    "Boston Celtics",
    "Brooklyn Nets",
    "Chicago Bulls",
    "Charlotte Hornets",
    "Cleveland Cavaliers",
    "Dallas Mavericks",
    "Denver Nuggets",
    "Detroit Pistons",
    "Golden State Warriors",
    "Houston Rockets",
    "Indiana Pacers",
    "Los Angeles Clippers",
    "Los Angeles Lakers",
    "Memphis Grizzlies",
    "Miami Heat",
    "Milwaukee Bucks",
    "Minnesota Timberwolves",
    "New Orleans Pelicans",
    "New York Knicks",
    "Oklahoma City Thunder",
    "Orlando Magic",
    "Philadelphia 76ers",
    "Phoenix Suns",
    "Portland Trailblazers",
    "Sacramento Kings",
    "San Antonio Spurs",
    "Toronto Raptors",
    "Utah Jazz",
    "Washington Wizards"
    ),
  show=c(
    "Atlanta Hawks",
    "Boston Celtics",
    "Brooklyn Nets",
    "Chicago Bulls",
    "Charlotte Hornets",
    "Cleveland Cavaliers",
    "Dallas Mavericks",
    "Denver Nuggets",
    "Detroit Pistons",
    #"Golden State Warriors",
    "GS Warriors",
    "Houston Rockets",
    "Indiana Pacers",
    #"Los Angeles Clippers",
    "LA Clippers",
    "Los Angeles Lakers",
    "Memphis Grizzlies",
    "Miami Heat",
    "Milwaukee Bucks",
    #"Minnesota Timberwolves",
    "Minn Timberwolves",
    # "New Orleans Pelicans",
    "NOLA Pelicans",
    "New York Knicks",
    # "Oklahoma City Thunder",
    "OKC Thunder",
    "Orlando Magic",
    "Philadelphia 76ers",
    "Phoenix Suns",
    #"Portland Trailblazers",
    "PDX Trailblazers",
    "Sacramento Kings",
    "San Antonio Spurs",
    "Toronto Raptors",
    "Utah Jazz",
    #"Washington Wizards"
    "WAS Wizards"
  )
)

lookup$icon <- paste0(lookup$full, " logo.svg")

df538 <- read.csv('FiveThirtyEight.csv')
# df538$date <- as.Date(df538$date)
# Today's Games -> Table Rows 

as.character(Sys.Date())


todays <- df538[(df538$date >= as.character(Sys.Date())) & (df538$date <= as.character(Sys.Date()+7)),]
todays$obs <- apply(todays, 1, FUN=function(x) { 
  game <- head(todays[x,], 1)
  gsub("-", "x", paste(game$team2, game$team1, game$date, sep="."))
  })




getGames <- apply(todays, 1, FUN=function(x) {
    game <- head(todays[x,], 1)
    awayInfo <- lookup[lookup$abbrev == game$team2,]
    homeInfo <- lookup[lookup$abbrev == game$team1,]
 
    paste0('<div class="grid-item">
                        <div class="background">
                            <div class="left">
                                <div class="side">
                                    <img src="team-icons/', awayInfo$icon, '" class="team-logo"/>
                                    <h3 class="team-name">', awayInfo$show, '</h3>
                                </div>
                                <div class="side">
                                    <img src="team-icons/', homeInfo$icon, '" class="team-logo"/>
                                    <h3 class="team-name">',homeInfo$show, '</h3>
                                </div>
                            </div>
                            <div class="right">
                                {{  actionButton(', '"', as.character(game$obs), '"', ', "View") }}                              
                            </div>
                        </div>
                    </div>', collapse="")
    })

# <button onclick="window.alert(\'worked!\')">View</button>

getGames <- paste(getGames, collapse="")

getGames <- htmlTemplate(document_=FALSE, text_=getGames)

#           X       date season team1 team2 fivethirtyeight_home_wp
#72314 72314 2022-11-23   2023   GSW   LAC                0.763602
#print(head(todays[x,], 1))
#print('------')

# Thursday, November 17th, 2022

todayString <- paste("Today to ", format(Sys.Date()+7, format="%A, %B %d, %Y") ,collapse="")

ui <- htmlTemplate("index.html")

server <- function(input, output, session) { 
  observeEvent(input$gamesLink, {
    
    print("clicked games!")
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("todaysGames.html", getGames=getGames, todayString=todayString), immediate = TRUE, session=session)
  })
  
  observeEvent(input$predictionsLink, {
    print("clicked predictions!")
    
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("predictions.html"), immediate = TRUE, session=session)
  })
  observeEvent(input$resourcesLink, {
    print("clicked resources!")
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("resources.html"), immediate = TRUE, session=session)
  })
  
  output$projectionsPlot <- renderPlot({
    s1 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
    s2 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
    s3 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
    
    plot(c(), type="b", ylim=c(min(min(s1), min(s2), min(s3)),max(max(s1), max(s2), max(s3))), xlim=c(1, 365))
    lines(c(1:365), s1, col="red")
    lines(c(1:365), s2, col="blue")
    lines(c(1:365), s3, col="green")
    legend(x ="topleft", col=c("red", "green", "blue"), legend=c("ESPN", "FiveThirtyEight","Bettr Composite"), lwd=1, lty=c(1,1,1))
  }, width=800, height=500)
  
  exampleModels <- data.frame(
    Source=c("Bettr Composite", "ESPN", "FiveThirtyEight"),
    Start.Date=c("11-04-2022", "09-01-2015", "09-01-2015"),
    Accuracy90=c(0.82, 0.71, 0.78),
    Accuracy1yr=c(0.82, 0.71, 0.84),
    AccuracyOverall=c(0.81, 0.77, 0.80)
  )
  names(exampleModels) <- c("Source", "Start Date", "90 Day Accuracy", "1 Year Accuracy", "Overall Accuracy")
  output$projectionsTable <- renderTable({ exampleModels })
  
  handleButton <- function(x) {
    gameInfo <- todays[todays$obs == x,]
    gameDate <- format(as.Date(gameInfo$date), format="%A, %B %d, %Y")
    gameString <- paste0(lookup[lookup$abbrev == gameInfo$team2,]$full, " @ ", lookup[lookup$abbrev == gameInfo$team1,]$full)
    
    awayIcon <- lookup[lookup$abbrev == gameInfo$team2,]$icon
    homeIcon <- lookup[lookup$abbrev == gameInfo$team1,]$icon
    
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("viewGame.html", gameDate=gameDate, gameString=gameString, awayIcon=awayIcon, homeIcon=homeIcon), immediate = TRUE, session=session)
    print("Clicked!")
    print(x)
  }
  
  # Hack to register all of the buttons to use the same handler function above
  # The ID of the button is also passed so we know what game to show
  
  # I am so proud of this code, def gonna be on my slide
  lapply(todays$obs, function(x) {
    eval(parse(text=paste0(
      'observeEvent(input$', x, ', {
        handleButton(x)
      })')))
  })
  
  print(input)
  print(class(input))

  
}

shinyApp(ui = ui, server = server)
# app <- 
# runApp(app, appDir = getwd())
