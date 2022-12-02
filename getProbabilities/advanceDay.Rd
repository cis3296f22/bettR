\name{advance_day}
\alias{advance_day}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
advance_day
}
\description{
Retrieves the date, after a particular number of days have been added
}
\usage{
advance_day(date_string, days): Insert a string date of form YYYY-MM-DD and an int days, to retrieve a new date after days have been added, for use in HoopR
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{date_string}{
String of a particular date of form YYYY-MM-DD
}
\item{days} {
Integer days
  }
}
\details{
This function is meant to produce a date usuable for HoopR's espn_nba_wp() function, that retrieves win probabilities from ESPN's WP Chart
}
\value{
Returns String of form "YYYYMMDD"
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Anubhav Kundu
}
\note{
HoopR library: https://hoopr.sportsdataverse.org/ 
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
advance_day("2022-12-02", 5)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
