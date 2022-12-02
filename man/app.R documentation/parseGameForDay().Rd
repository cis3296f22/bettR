\name{parseGameForDay()}
\alias{parseGameForDay()}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
#' Compiles games into away team at home team format for drop down list usage.
}
\usage{
parseGameForDay()( Once you have a data frame of the teams playing and their respective win probabilities, call this function in order to
  create a list for the drop down selection menu. This will return a list object of the teams in away_team @ home team format)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gameTables}{
    data frame of upcoming games
}
\item{date}{current date in sys.Date() format}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
A list of upcoming games in away_team @ home_team format 
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
    parsegameForDay(gameDataFrame,2022-11-19)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
