# Load R packages
library(shiny)
# library(shinythemes)
library(tidyverse)
library(shinydashboard)
library(rvest)

setwd("/Users/jaredstef/Developer/bettR/")

# Maps 538 Team Abbreviations to Full Names and Icons
lookup <- 

df538 <- read.csv('FiveThirtyEight.csv')
df538$date <- as.Date(df538$date)
df538[df538$date == Sys.Date(),]


ui <- htmlTemplate("index.html")

server <- function(input, output, session) { 
  observeEvent(input$gamesLink, {
    
    print("clicked games!")
    removeUI("#home", immediate = TRUE, session=session)
    insertUI("html", where="afterBegin", htmlTemplate("todaysGames.html"), immediate = TRUE, session=session)
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
}

shinyApp(ui = ui, server = server)
# app <- 
# runApp(app, appDir = getwd())
