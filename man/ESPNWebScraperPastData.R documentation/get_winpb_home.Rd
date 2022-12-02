\name{get_winpb_home}
\alias{get_winpb_home}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
get_winpb_home()
}
\description{
Function to get win probability for home team
}
\usage{
get_winpb_home(id)
}
\arguments{
  \item{id}{
The game id for a given NBA game
}
}
\details{
To get win prbabilities for a certain NBA team for a certain game on a certain day for the ESPN Past dataframe
}
\value{
wp: the win probability predicted by ESPN, or -1 if none available
}
\references{
hoopR library
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
get_winp_home(400899374)
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
