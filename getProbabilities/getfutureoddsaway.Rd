\name{get_future_odds_away}
\alias{get_future_odds_away}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get Future Odds (Away)
}
\description{
Get the win probabilities of the away team in a future game
}
\usage{
get_future_odds_away(id) (Uses id of integer type to lookup an ESPN NBA game and retrieve the win probability)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{id}{
An integer gameID corresponding to a specific NBA game
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
Returns away_pb: double
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
get_future_odds_away(20221205) (Relevant as of December 2nd, 2022)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
