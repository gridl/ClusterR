% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clustering_functions.R
\name{AP_affinity_propagation}
\alias{AP_affinity_propagation}
\title{Affinity propagation clustering}
\usage{
AP_affinity_propagation(data, p, maxits = 1000, convits = 100,
  dampfact = 0.9, details = FALSE, nonoise = 0, time = FALSE)
}
\arguments{
\item{data}{a matrix. Either a similarity matrix (where number of rows equal to number of columns) or a 3-dimensional matrix where the 1st, 2nd and 3rd column correspond to (i-index, j-index, value) triplet of a similarity matrix.}

\item{p}{a numeric vector of size 1 or size equal to the number of rows of the input matrix. See the details section for more information.}

\item{maxits}{a numeric value specifying the maximum number of iterations (defaults to 1000)}

\item{convits}{a numeric value. If the estimated exemplars stay fixed for convits iterations, the affinity propagation algorithm terminates early (defaults to 100)}

\item{dampfact}{a float number specifying the update equation damping level in [0.5, 1). Higher values correspond to heavy damping, which may be needed if oscillations occur (defaults to 0.9)}

\item{details}{a boolean specifying if details should be printed in the console}

\item{nonoise}{a float number. The affinity propagation algorithm adds a small amount of noise to \emph{data} to prevent degenerate cases; this disables that.}

\item{time}{a boolean. If TRUE then the elapsed time will be printed in the console.}
}
\description{
Affinity propagation clustering
}
\details{
The \emph{affinity propagation} algorithm automatically determines the number of clusters based on the input preference \emph{p}, a real-valued N-vector. p(i) indicates the preference that data point i be 
chosen as an exemplar. Often a good choice is to set all preferences to median(data). The number of clusters identified can be adjusted by changing this value accordingly. If \emph{p} is a scalar, assumes all
preferences are that shared value.

The number of clusters eventually emerges by iteratively passing messages between data points to update two matrices, A and R (Frey and Dueck 2007). The "responsibility" matrix R has values r(i, k) 
that quantify how well suited point k is to serve as the exemplar for point i relative to other candidate exemplars for point i. The "availability" matrix A contains values a(i, k) representing how 
"appropriate" point k would be as an exemplar for point i, taking into account other points' preferences for point k as an exemplar. Both matrices R and A are initialized with all zeros. The AP 
algorithm then performs updates iteratively over the two matrices. First, "Responsibilities" r(i, k) are sent from data points to candidate exemplars to indicate how strongly each data point favors 
the candidate exemplar over other candidate exemplars. "Availabilities" a(i, k) then are sent from candidate exemplars to data points to indicate the degree to which each candidate exemplar is
available to be a cluster center for the data point. In this case, the responsibilities and availabilities are messages that provide evidence about whether each data point should be an exemplar and,
if not, to what exemplar that data point should be assigned. For each iteration in the message-passing procedure, the sum of r(k; k) + a(k; k) can be used to identify exemplars. After the messages 
have converged, two ways exist to identify exemplars. In the first approach, for data point i, if r(i, i) + a(i, i) > 0, then data point i is an exemplar. In the second approach, for data point i, 
if r(i, i) + a(i, i) > r(i, j) + a(i, j) for all i not equal to j, then data point i is an exemplar. The entire procedure terminates after it reaches a predefined number of iterations or if the 
determined clusters have remained constant for a certain number of iterations... ( https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5650075/  -- See chapter 2 )

Excluding the main diagonal of the similarity matrix when calculating the median as preference ('p') value can be considered as another option too.
}
\examples{

set.seed(1)
dat = matrix(sample(1:255, 2500, replace = TRUE), 100, 25)

smt = 1.0 - distance_matrix(dat, method = 'euclidean', upper = TRUE, diagonal = TRUE)
diag(smt) = 0.0

ap = AP_affinity_propagation(smt, p = median(as.vector(smt))) 

}
\references{
https://www.psi.toronto.edu/index.php?q=affinity%20propagation

https://www.psi.toronto.edu/affinitypropagation/faq.html

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5650075/    ( SEE chapter 2 )
}
