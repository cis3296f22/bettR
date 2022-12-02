\name{getCombinedDf}
\alias{getCombinedDf}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
getCombinedDf()
}
\description{
Function to get the dataframe that combines the data from ESPN based on a list of a dates.
It gathers the data into a dataframe from each date in the list, merges the dataframes, and cleans the data.
It also calls the function get_winpb_home in order to get the win probabilities.
}
\usage{
getCombinedDf(listOfDates)
}
\arguments{
  \item{listOfDates}{
the list of desired dates to get data for
}
}
\details{
Used to create dataframe for past ESPN data
}
\value{
newdf: the combined dataframe of ESPN NBA data
}
\references{
hoopR
}
\author{
Arun Agarwal
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
getCombinedDf(list(201710,201711,201712,202301,202302,202303,202304))
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
