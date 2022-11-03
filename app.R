# Load R packages
library(shiny)
library(shinythemes)
library(tidyverse)
library(shinydashboard)
library(rvest)

#this can be moved somewhere else. Just for now its left here to run at the start to pull the games for the schedule
myURL<-read_html("https://www.espn.com/nba/schedule")
myURLTable<-html_table(myURL)
todayGames <- myURLTable[[2]]
print(todayGames)

# Define UI
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  
                  "Welcome to BettR!!!!",
                  tabPanel("Welcome Page",
                           sidebarPanel(
                             tags$h3("Input:"),
                             textInput("txt1", "Given Name:", ""),
                             textInput("txt2", "Surname:", "")
                             
                           ), # sidebarPanel
                           # Sidebar with controls to select a dataset and specify
                           # the number of observations to view
                           sidebarPanel(
                             selectInput("dataset", "Choose a dataset:",
                                         choices = c("rock", "pressure", "cars")),
                             
                             numericInput("obs", "Observations:", 10)
                           ),
                           
                           mainPanel(
                             h1("Header 1"),
                             
                             h4("Output 1"),
                             verbatimTextOutput("txtout")
                           ) # mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Upcoming Games" ,  dashboardHeader(title = "Games for Today"),
                           dashboardSidebar(width = "300px",
                                            tableOutput("data1")),
                           dashboardBody()
                  ),
                  tabPanel("Navbar 3", "This panel is intentionally left blank")
                  
                ) # navbarPage
) # fluidPage

# Define server function  
server <- function(input, output) {
  
  output$txtout <- renderText({
    paste( input$txt1, input$txt2, sep = " " )
  }
  )
}
server = function(input, output, session){
  output$data1 <- renderTable({
    head(todayGames[,1:3])
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)

