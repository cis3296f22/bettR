# Load R packages
library(shiny)
library(shinydashboard)

# May want to set working directory to where it is run
setwd(".")

# DataFrame mapping 538 Team Abbreviations to Full Names and Icons
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
  # The display name for some teams is shortened so they fit on one line
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

# Today's Games -> Table Rows 
# Grab the next 7 days of games from 538
todays <- df538[(df538$date >= as.character(Sys.Date())) & (df538$date <= as.character(Sys.Date()+7)),]

# Generate unique ids for each game. This will but the button ids used with the observers
todays$obs <- apply(todays, 1, FUN=function(x) { 
  game <- head(todays[x,], 1)
  gsub("-", "x", paste(game$team2, game$team1, game$date, sep="."))
  })

# Generate the rows based on the 538 data
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

getGames <- paste(getGames, collapse="")
getGames <- htmlTemplate(document_=FALSE, text_=getGames)

#           X       date season team1 team2 fivethirtyeight_home_wp
#72314 72314 2022-11-23   2023   GSW   LAC                0.763602
#print(head(todays[x,], 1))
#print('------')

todayString <- paste("Today to ", format(Sys.Date()+7, format="%A, %B %d, %Y") ,collapse="")

ui <- htmlTemplate("index.html")

selectedGame <- NA 

server <- function(input, output, session) { 
  
  # Games Navigation
  observeEvent(input$gamesLink, {
    print("clicked games!")
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("todaysGames.html", getGames=getGames, todayString=todayString), immediate = TRUE, session=session)
  })
  
  # Predictions Navigation
  observeEvent(input$predictionsLink, {
    print("clicked predictions!")
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("predictions.html"), immediate = TRUE, session=session)
  })
  
  # Resources Navigation
  observeEvent(input$resourcesLink, {
    print("clicked resources!")
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("resources.html"), immediate = TRUE, session=session)
  })
  
  # The main plot on the projections page
  output$projectionsPlot <- renderPlot({
    s1 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
    s2 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
    s3 <- cumsum(sample(c(-1, 1), 365, replace=TRUE))
    
    plot(c(), type="b", ylim=c(min(min(s1), min(s2), min(s3)),max(max(s1), max(s2), max(s3))), xlim=c(1, 365))
    lines(c(1:365), s1, col="red")
    lines(c(1:365), s2, col="blue")
    lines(c(1:365), s3, col="green")
    legend(x ="topleft", col=c("red", "green", "blue"), legend=c("ESPN", "FiveThirtyEight","Bettr Composite"), lwd=1, lty=c(1,1,1))
  }, width=800, height=400)
  
  # The main table on the projections page 
  
  exampleModels <- data.frame(
    Source=c("Bettr Composite", "ESPN", "FiveThirtyEight"),
    Start.Date=c("11-04-2022", "09-01-2015", "09-01-2015"),
    Accuracy90=c(0.82, 0.71, 0.78),
    Accuracy1yr=c(0.82, 0.71, 0.84),
    AccuracyOverall=c(0.81, 0.77, 0.80)
  )
  names(exampleModels) <- c("Source", "Start Date", "90 Day Accuracy", "1 Year Accuracy", "Overall Accuracy")
  
  output$projectionsTable <- renderTable({ exampleModels })
  
  # The main table when viewing a game
  
  viewModels <- data.frame(
    Source=c("Bettr Composite", "ESPN", "FiveThirtyEight"),
    Home.Win=c("78%", "85%", "82%"),
    Away.Win=c("22%", "15%", "18%"),
    Accuracy90=c(0.82, 0.71, 0.78),
    Accuracy1yr=c(0.82, 0.71, 0.84),
    AccuracyOverall=c(0.81, 0.77, 0.80)
  )
  
  names(viewModels) <- c("Source", "Home Win %", "Away Win %", "90 Day Accuracy", "1 Year Accuracy", "Overall Accuracy")
  
  output$gameProjections <- renderTable({ viewModels })
  
  # Logic for the view game page
  
  handleButton <- function(x) {
    gameInfo <- todays[todays$obs == x,]
    gameDate <- format(as.Date(gameInfo$date), format="%A, %B %d, %Y")
    gameString <- paste0(lookup[lookup$abbrev == gameInfo$team2,]$full, " @ ", lookup[lookup$abbrev == gameInfo$team1,]$full)
    
    awayIcon <- lookup[lookup$abbrev == gameInfo$team2,]$icon
    homeIcon <- lookup[lookup$abbrev == gameInfo$team1,]$icon
    
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("viewGame.html", gameDate=gameDate, gameString=gameString, awayIcon=awayIcon, homeIcon=homeIcon), immediate = TRUE, session=session)
    
    selectedGame <- x
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
  
  # Inputs for view game calculator
  
  observeEvent(input$firstLabel, {
    print(input$firstLabel)
  })
  
  observeEvent(input$spread, {
    print(input$spread)
  })
  
  observeEvent(input$probability, {
    print(input$probability)
  })
  
  observeEvent(input$bettr, {
    print(input$bettr)
  })
  
  result <- -9.60
  color <- "red"
  
  if(result > 0) {
    color <- "green"
  }
  
  output$winnings <- renderUI(htmlTemplate(text_=paste0("<span style=\"color:", color, ";\">$ ", format(result, nsmall=2, big.mark=","),"</span>")))
  
  output$mo1 <- renderUI(htmlTemplate(text_=paste0("<span style=\"color:", color, ";\">$ ", format(result*4, nsmall=2, big.mark=","),"</span>")))
  
  output$mo6 <- renderUI(htmlTemplate(text_=paste0("<span style=\"color:", color, ";\">$ ", format(result*4*6, nsmall=2, big.mark=","),"</span>")))
  
  output$yr1 <- renderUI(htmlTemplate(text_=paste0("<span style=\"color:", color, ";\">$ ", format(result*4*12, nsmall=2, big.mark=","),"</span>")))
  
  output$take <- renderUI(htmlTemplate(text_="Take -354 Odds or Lower"))
}

shinyApp(ui = ui, server = server)

# Was looking into the runApp function for when deploying in the future...
# Prob won't use it but here as a reminder
# app <- 
# runApp(app, appDir = getwd())