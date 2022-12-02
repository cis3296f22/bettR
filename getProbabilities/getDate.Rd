\name{get_date}
\alias{get_date}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
get_date
}
\description{
Retrieves the date, after a particular number of days have been added
}
\usage{
get_date(date_string, days): Insert a string date of form YYYY-MM-DD and an int days, to retrieve a new date after days have been added
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
%%  ~~ If necessary, more details than the description above ~~
}
\value{
Returns String
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Anubhav Kundu
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
get_date("2022-12-02", 5)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
