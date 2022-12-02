\name{sendOddsOfgameToCalculator()}
\alias{sendOddsOfgameToCalculator()}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
Gets the probabilities of winning for the specific upcoming game and returns the probability for the away team
}
\usage{
sendOddsOfGameToCalculator()(splits the string value into away team and home team. Then looks for the game inside of listOfGames and returns the away teams winning probability)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{string}{ string of the upcoming game away team at home team}
  \item{listOfDays}{ a list of days for the specific game}
  \item{listOfGames}{ a list of the upcoming games}
%%     ~~Describe \code{x} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Kevin Jang
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
    sendOddsOfGameToCalculator(Detroit @ Philadelphia, list(2022-11-19, 2022-11,20), upcomingGamesProbabilities)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
