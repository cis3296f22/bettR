# Bettr

![The bettr icon](www/bettrIcon.png)


Bettr provides users with betting information and education tools.

## Project Vision:
With the legalization of sports betting many sports fans are putting their money where their mouth is for the first time. Most users lose money, however, due to following useless heuristics or pundits. Bettr is an open source information aggregation platform whose aim is to create a web dashboard displaying the current spreads for sports games along with models from multiple publicly available sites side-by-side with their relative historical performances. Users can enter their bets and receive their expected payout/loss and break even point. It provides resources and betting calculators with open source formulas. Bettr allows users to have statistically informed insight into their betting and helps society mitigate the negative externalities of betting through education.

## Feature Set:
1. Resources explaining sports betting and statistics to novices
2. Dashboard displaying model performances over time from multiple sources on the web
3. Calculators determining breakeven spread and expected profit for upcoming games

## For User to access the BettR web app:
https://BettrSportsBetting.com/
The web server is currently down. Users must ran manually until server is back online.
Bettr has been tested on Firefox and Chrome.

- The front page you are directed to will be our homepage which includes links and an explaination of the resources on the site
- The games page shows the future NBA games for the next week. One can be selected to view the model odds and bet screening calculator for that game.
- The predictions page shows how accurate various predictive web models have performed over time, including our own.
- The resources page has educational content related to how sports betting works and strategies to promote healthy and successful betting.

## How to see code and run manually:
- Install R-Studio Desktop Open Source Edition on your preferred platform [here](https://www.rstudio.com/products/rstudio/)
- Download the R programming language (this should be an option when downloading R-Studio Desktop) but you can also download [here](https://cran.r-project.org/bin/windows/base/)
- Clone the Git Repository into your desired location
- Open the Bettr folder
- Open the newUI.R file in RStudio
- Press the green Run App button on the top right of the code editing section (you can alternatively click the Run button that lets you run the code line by line)
- Depending on what is installed when you download R, you may need to install some additional libraries. These include (shiny, shinydashboard, tidyverse, rvest). There are multiple ways to download/install libraries. In RStudio go to Tools → Install Packages and in the Install from option select Repository (CRAN) and then specify the packages you want. In classic R IDE go to Packages → Install package(s) , select a mirror and install the package.
- At this point, Bettr will run and open in your browser
- Instructions on how to use Bettr will be provided within the application/browser

NOTE: Steps remain the same for Windows, macOS, and Linux.

## Future Directions:
- Development of a User Database: implement user registration and betting history to encourage better decisions 
- Diverse Data Aggregation: expand data sources beyond ESPN and FiveThirtyEight
- Bettr Machine Learning Model: develop a competitive machine learning model and use the model to aid user decisions
- Automated Testing Implementation: find alternate solution to automate testing in R Programming Language

## Resources and References:
538 CSVs: 
- https://data.fivethirtyeight.com/

ESPN:
- https://www.espn.com/ 

Open Source Contribution:
- https://github.com/jmhayes3/fivethirtyeight_scraper 

References:
- https://www.vegasinsider.com/betting-odds-calculator/ 
- https://www.fangraphs.com/livescoreboard.aspx 

Resources to learn more about sports betting: 
- https://www.sportsbettingdime.com/guides/betting-101/ 
- Ed Miller & Matthew Davidow’s The Logic of Sports Betting

Resources to learn more about R and the R Shiny library:
- Learn R: https://www.w3schools.com/r/ 
- Learn R Shiny: https://shiny.rstudio.com/tutorial/ 

Losses:
- https://www.legalsportsreport.com/sports-betting/revenue/


## Contributors
Bettr was conceptualized and created in a month long sprint during a Software Design class Fall 2022 at Temple University.
- Jared Stefanowicz
- Kevin Jang
- Anubhav Kundu
- Arun Agarwal
