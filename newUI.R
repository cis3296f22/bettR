# Load R packages
library(shiny)
library(shinydashboard)
library(zoo)

# May want to set working directory to where it is run
setwd("/Users/JaredStef/Developer/BettR/")

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

# Pull in data for model evals
dfEval <- read.csv("./finalDataframe.csv")
dfEval <- dfEval[dfEval$season >= 2019,]
dfEval['ESPN_home_winprob'] <- dfEval['ESPN_away_wp']
dfEval['ESPN_away_winprob'] <- dfEval['ESPN_home_wp']

dfEval['ESPN_away_wp'] <- NA
dfEval['ESPN_home_wp'] <- NA

dfEval['ESPN_Pick'] <- dfEval['ESPN_home_winprob'] >= dfEval['ESPN_away_winprob']
dfEval['FTE_Pick'] <- dfEval['X538_home_wp'] >= dfEval['X538_away_wp']

# it is flipped for passed games but not for future - LMAO

dfEval['TF_Outcome'] <- dfEval['Outcome'] == dfEval['home_team']
dfEval$TF_OutcomeOnes <- as.integer(dfEval$TF_Outcome)


bettr_model <- lm("TF_OutcomeOnes ~ ESPN_Pick + FTE_Pick", data=dfEval)
dfEval$model_home_wp <- predict.lm(bettr_model, dfEval)
dfEval$model_away_wp <- abs(1 - dfEval$model_home_wp)

dfEval['model_Pick'] <- dfEval['model_home_wp'] >= dfEval['model_away_wp']

# They agree 79.8% of the time
dfEval['Agree'] <- dfEval['ESPN_Pick'] == dfEval['FTE_Pick']
sum(dfEval['Agree'])/nrow(dfEval)



# ESPN Accuracy
dfEval$espn_corr <- dfEval$ESPN_Pick == dfEval$TF_Outcome
dfEval$fte_corr <- dfEval$FTE_Pick == dfEval$TF_Outcome
dfEval$model_corr <- dfEval$model_Pick == dfEval$TF_Outcome

espn_365avg <- rollmean(dfEval$espn_corr, 365)
fte_365avg <- rollmean(dfEval$fte_corr, 365)
model_365avg <- rollmean(dfEval$model_corr, 365)
  # ESPN Picks correct 64.6% of the time
espn.overall <- nrow(dfEval[dfEval['ESPN_Pick'] == dfEval['TF_Outcome'],])/nrow(dfEval)
fte.overall <- nrow(dfEval[dfEval['FTE_Pick'] == dfEval['TF_Outcome'],])/nrow(dfEval)
model.overall <- nrow(dfEval[dfEval['model_Pick'] == dfEval['TF_Outcome'],])/nrow(dfEval)

dfEval90 <- dfEval[dfEval$date >= Sys.Date()-90,]

espn.90 <- nrow(dfEval90[dfEval90['ESPN_Pick'] == dfEval90['TF_Outcome'],])/nrow(dfEval90)
fte.90 <- nrow(dfEval90[dfEval90['FTE_Pick'] == dfEval90['TF_Outcome'],])/nrow(dfEval90)
model.90 <- nrow(dfEval90[dfEval90['model_Pick'] == dfEval90['TF_Outcome'],])/nrow(dfEval90)

dfEval365 <- dfEval[dfEval$date >= Sys.Date()-365,]

espn.365 <- nrow(dfEval365[dfEval365['ESPN_Pick'] == dfEval365['TF_Outcome'],])/nrow(dfEval365)
fte.365 <- nrow(dfEval365[dfEval365['FTE_Pick'] == dfEval365['TF_Outcome'],])/nrow(dfEval365)
model.365 <- nrow(dfEval365[dfEval365['model_Pick'] == dfEval365['TF_Outcome'],])/nrow(dfEval365)

# FTE Picks correct 62.7% of the time


# Plot Accuracy over time

# Lookup Key
dfEval['Key'] <- gsub("-", "x", paste(dfEval$away_team, dfEval$home_team, dfEval$date, sep="."))
#paste(dfEval['home_team'], dfEval['away_team'])[1]
dfEval <- dfEval[order(dfEval$date),]
#dfTest <- dfTest[dfTest$date > Sys.Date()-90,]
dfEval$date <- as.Date(dfEval$date)
dfEval$ones <- rep(1, nrow(dfEval))

# Cumulative Sum for each date


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
  
  displayPer <- function(x) {
    return(as.character(round(x, digits=1)))
  }
  
  runCalculator <- function() {
    tryCatch({
      # Validated Against 
      # https://betworthy.com/betting-calculators/odds-value/
      # https://oddsjam.com/betting-calculators/expected-value
      wager <- as.numeric(input$firstLabel)
      probability <- as.numeric(input$probability)
      spread <- as.numeric(input$spread)
      
      print(wager)
      print(probability)
      print(spread)
      
      # Positive - Bet 100, Win 100+spread 
      # Negative - Bet The Spread, win the spread + 100
      
      
      validNumbers <- is.na(probability) | is.na(spread) | is.na(wager)
      
      if (validNumbers) {
        print("Numbers are not valid")
        stop("Numbers are not valid")
      }
      
      probRange <- probability >= 0 & probability <= 100
      spreadRange <- abs(spread) >= 100
      wagerRange <- wager >= 0
      
      validRanges <- probRange & spreadRange & wagerRange
      
      if (!validRanges) {
        print("Not valid ranges")
        stop("Not valid ranges")
      }
      
      probability <- probability / 100
      print("probability")
      print(probability)
      
      if (spread < 0) {
        print("less than 0")
        x <- ((probability*100)+((1-probability)*spread))*(wager/abs(spread))
        return(x)
      } else if (spread > 0) {
        print("more than 0")
        x <- ((probability*spread)+((1-probability)*-100))*(wager/100)
        return(x)  
      }
    }, error = function(e) {
      print("Bad Value")
      print(e)
      return(NA)
    })
  }
  

  result <- reactive({
    print(runCalculator())
    runCalculator()
    })
  
  breakeven <- reactive({
    
    tryCatch({
      probability <- as.numeric(input$probability)
      
      if (is.na(probability)) {
        print("Numbers are not valid")
        stop("Numbers are not valid")
      }
      
      probRange <- probability >= 0 & probability <= 100
      
      if (!probRange) {
        print("Not valid ranges")
        stop("Not valid ranges")
      }
      
      probability = probability / 100
      
      if(probability <= 0.5) {
        val <- (1/probability)-1
        
        return(paste0("+", round(val*100)))
      } else {
        val <-(1/(1-probability))-1
        return(paste0("-", round(val*100)))
      }
      
    }, error=function(e) {
      print("Bad Value")
      print(e)
      return(NA)
    })
  })
  
  renderGameTable <- function() {
    output$gameProjections <- renderTable({ 
      # The main table when viewing a game
      
      game <- dfEval[dfEval$Key == selectedGame,]
      print("Game is")
      print(selectedGame)
      #print(gameValue())
      print(game)
      
      viewModels <- data.frame(
        Source=c("Bettr Composite (Beta)", "ESPN", "FiveThirtyEight"),
        Home.Win=c(displayPer(game$model_home_wp*100), displayPer(game$ESPN_away_winprob*100), displayPer(game$X538_home_wp*100)),
        Away.Win=c(displayPer(game$model_away_wp*100), displayPer(game$ESPN_home_winprob*100), displayPer(game$X538_away_wp*100)),
        #Home.Win=c("", "", ""),
        #Away.Win=c("", "", ""),
        Accuracy90=c(displayPer(model.90*100), displayPer(espn.90*100), displayPer(fte.90*100)),
        Accuracy1yr=c(displayPer(model.365*100), displayPer(espn.365*100), displayPer(fte.365*100)),
        AccuracyOverall=c(displayPer(model.overall*100), displayPer(espn.overall*100), displayPer(fte.overall*100))
      )
      
      names(viewModels) <- c("Source", "Home Win %", "Away Win %", "90 Day Accuracy %", "1 Year Accuracy %", "Overall Accuracy %")
      viewModels
    })
  }
  
  # Logic for the view game page
  
  handleButton <- function(x) {
    gameInfo <- todays[todays$obs == x,]
    gameDate <- format(as.Date(gameInfo$date), format="%A, %B %d, %Y")
    gameString <- paste0(lookup[lookup$abbrev == gameInfo$team2,]$full, " @ ", lookup[lookup$abbrev == gameInfo$team1,]$full)
    
    awayIcon <- lookup[lookup$abbrev == gameInfo$team2,]$icon
    homeIcon <- lookup[lookup$abbrev == gameInfo$team1,]$icon
    
    print("previously selected")
    print(selectedGame)
    selectedGame <<- x
    
    print("New Selected")
    print(selectedGame)
    
    renderGameTable()
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("viewGame.html", gameDate=gameDate, gameString=gameString, awayIcon=awayIcon, homeIcon=homeIcon), immediate = TRUE, session=session)
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
    
    plot(c(), type="b", xlim=c(min(dfEval$date[365]),max(dfEval$date)), ylim=c(55,75), xlab="Date", ylab="Accuracy (%)", main="Model Accuracy Over Time")
    print("plot")
    #print(dfEval)
    print(length(dfEval$date))
    # print(length(s1))
    width <- 3
    dates <- as.Date(dfEval$date[(1:364)*-1])
    print(length(espn_365avg))
    lines(dates, espn_365avg*100, col="#cd1e39", lwd=width)
    lines(dates, fte_365avg*100, col="orange", lwd=width)
    lines(dates, model_365avg*100, col="#66cc33", lty=2, lwd=width)
    legend(x ="topleft", col=c("#cd1e39", "orange", "#66cc33"), legend=c("ESPN", "FiveThirtyEight","Bettr Composite (Beta)"), lwd=1, lty=c(1,1,1))
  }, width=800, height=400)
  
  # The main table on the projections page 
  
  
  output$projectionsTable <- renderTable({ 
  
    exampleModels <- data.frame(
      Source=c("Bettr Composite (Beta)", "ESPN", "FiveThirtyEight"),
      Start.Date=c(rep(min(as.character(dfEval$date)), 3)),
      Accuracy90=c(displayPer(model.90*100), displayPer(espn.90*100), displayPer(fte.90*100)),
      Accuracy1yr=c(displayPer(model.365*100), displayPer(espn.365*100), displayPer(fte.365*100)),
      AccuracyOverall=c(displayPer(model.overall*100), displayPer(espn.overall*100), displayPer(fte.overall*100))
    )
    names(exampleModels) <- c("Source", "Start Date", "90 Day Accuracy", "1 Year Accuracy", "Overall Accuracy")
      
    exampleModels
    })
  
  
  
  
  
  # Inputs for view game calculator
  
  observeEvent(input$firstLabel, {
    print("changed first")
    print(input$firstLabel)
    runCalculator()
  })
  
  observeEvent(input$spread, {
    print(input$spread)
    runCalculator()
  })
  
  observeEvent(input$probability, {
    print(input$probability)
    runCalculator()
  })
  
  observeEvent(input$bettr, {
    print(input$bettr)
  })
  

  print("result")
  print(result)

  safeNA <- function(x) {
    if(is.na(x)) {
      FALSE
    } else {
      x
    }
  }
  
    
  output$winnings <- renderUI(htmlTemplate(text_=paste0("<span style=\"color:", if (safeNA(result() > 0)) "#66cc33" else "#cd1e39", ";\">$ ", format(round(result(), digits=2), nsmall=2, big.mark=","),"</span>")))
  
  output$mo1 <- renderUI(htmlTemplate(text_=paste0("<span style=\"color:", if (safeNA(result() > 0)) "#66cc33" else "#cd1e39", ";\">$ ", format(round(result(), digits=2)*4, nsmall=2, big.mark=","),"</span>")))
  
  output$mo6 <- renderUI(htmlTemplate(text_=paste0("<span style=\"color:", if (safeNA(result() > 0)) "#66cc33" else "#cd1e39", ";\">$ ", format(round(result(), digits=2)*4*6, nsmall=2, big.mark=","),"</span>")))
  
  output$yr1 <- renderUI(htmlTemplate(text_=paste0("<span style=\"color:", if (safeNA(result() > 0)) "#66cc33" else "#cd1e39", ";\">$ ", format(round(result(), digits=2)*4*12, nsmall=2, big.mark=","),"</span>")))
  
  output$take <- renderUI(htmlTemplate(text_=paste0("Take ", breakeven(), " Odds or Higher")))
}

shinyApp(ui = ui, server = server)

# Was looking into the runApp function for when deploying in the future...
# Prob won't use it but here as a reminder
# app <- 
# runApp(app, appDir = getwd())
