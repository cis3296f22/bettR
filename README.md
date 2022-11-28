# Bettr

![The bettr icon](www/bettrIcon.png)


Bettr provides users with betting information and education tools.

## Project Vision
With the legalization of sports betting many sports fans are putting their money where their mouth is for the first time. Most users lose money, however, due to following useless heuristics or pundits. Bettr's aim is to create a web dashboard displaying the current spreads for sports games along with models from multiple publicly available sites side-by-side with their relative historical performances. Users can enter their bets and receive their expected payout/loss and break even point. Bettr allows users to have statistically informed insight into their betting and helps society mitigate the negative externalities of betting through education.

## For User to access the BettR web app.
https://bettr.shinyapps.io/bettr/
Click link (or copy and paste into your web browser.)
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
- Open the tabTesting.R file in RStudio
- Press the green Run App button on the top right of the code editing section (you can alternatively click the Run button that lets you run the code line by line)
- Depending on what is installed when you download R, you may need to install some additional libraries. These include (shiny, shinydashboard, tidyverse, rvest). There are multiple ways to download/install libraries. In RStudio go to Tools → Install Packages and in the Install from option select Repository (CRAN) and then specify the packages you want. In classic R IDE go to Packages → Install package(s) , select a mirror and install the package.
- At this point, Bettr will run and open in your browser
- Instructions on how to use Bettr will be provided within the application/browser

NOTE: Steps remain the same for Windows, macOS, and Linux.

## Contributors
Bettr was conceptualized and created in a month long sprint during a Software Design class Fall 2022 at Temple University.
- Jared Stefanowicz
- Kevin Jang
- Anubhav Kundu
- Arun Agarwal
