\name{insertwphome}
\alias{insertwphome}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Insert Home Probabilities
}
\description{
Function to insert home probabilities into a dataframe
}
\usage{
insert_wp_home(id): (Uses id of integer type to lookup an ESPN NBA game and retrieve the win probability, to be inserted into an R Dataframe)
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
Returns None
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Anubhav Kundu
}
\note{
uses HoopR: https://hoopr.sportsdataverse.org/
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
insert_wp_home(20221205) (Relevant as of December 2nd, 2022)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
