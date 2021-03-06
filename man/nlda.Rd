% wll-14-09-2006
%
\name{nlda}
\alias{nlda}
\alias{nlda.default}
\alias{nlda.formula}
\alias{print.nlda}
\alias{summary.nlda}
\alias{print.summary.nlda}

\title{
  Linear Discriminant Analysis for High Dimensional Problems
}
\description{
  Linear discriminant analysis for high dimensional problems. See details for implementation. 
}

\usage{
  nlda(dat, \dots)
  \method{nlda}{default}(dat,cl,prior=NULL,scale=FALSE,comprank = FALSE, \dots)

  \method{nlda}{formula}(formula, data = NULL, \dots, subset, na.action = na.omit)
}

% ----------------------------------------------------------------------------
\arguments{
  \item{formula}{
    A formula of the form \code{groups ~ x1 + x2 + \dots}  That is, the
    response is the grouping factor and the right hand side specifies
    the (non-factor) discriminators.
  }
  \item{data}{
    Data frame from which variables specified in \code{formula} are
    preferentially to be taken.
  }
  \item{dat}{
    A matrix or data frame containing the explanatory variables if no formula is
    given as the principal argument.
  }
  \item{cl}{
    A factor specifying the class for each observation if no formula principal 
    argument is given.
  }
  \item{prior}{
   The prior probabilities of class membership. If unspecified, the class 
   proportions for the training set are used. If present, the probabilities 
   should be specified in the order of the factor levels.
  }
  \item{scale}{
  A logical value indicating whether or not PCA is scaled.
  }
  \item{comprank}{
    A computation rank.
  }
  \item{\dots}{
    Arguments passed to or from other methods.
  }
  \item{subset}{
    An index vector specifying the cases to be used in the training
    sample.  
  }
  \item{na.action}{
    A function to specify the action to be taken if \code{NA}s are found. The 
    default action is \code{na.omit}, which leads to rejection of cases with 
    missing values on any required variable. An alternative is \code{na.fail}, 
    which causes an error if \code{NA} cases are found. 
  }	
}

% ----------------------------------------------------------------------------
\details{
A critical issue of applying linear discriminant analysis (LDA) is both the
singularity and instability of the within-class scatter matrix. In practice, 
there are often a large number of features available, but the total number of 
training patterns is limited and commonly less than the dimension of the feature 
space. To tackle this issue, \code{nlda} combines principal components analysis 
(PCA) and linear discriminant analysis (LDA) for the classification problem. 
Because the determination of the optimal number of principal components 
representative for a dataset is not trivial and the number of dimensions varies 
from one comparison to another introducing a bias to the estimation of the
 separability measure, we have opted for a 2 steps procedure proposed in
  Thomaz, C. E. and Gillies, D. F. (2004): the number of principal components to
   retain is equal to the rank of the covariance matrix (usually number of 
   training samples minus one) and the within-class scatter matrix is replaced
    by a version where  the less reliable eigenvalues have been replaced. In
     addition to the proportion of explained variance in each projection, the
      eigenvalue is a useful diagnostic quantity (output \code{stats}).
}

% ----------------------------------------------------------------------------
\value{
  An object of class \code{nlda} containing the following components:
  \item{stats}{
    The statistics based on the training data.
  }
  \item{Tw}{
    The proportion of trace.
  }
  \item{rankmat}{
    The rank used for LDA.
  }
  \item{means}{
    The means of training data.
  }
  \item{loadings}{
    A matrix of the coefficients of linear discriminants.
  }
  \item{x}{
    The rotated data on discriminant variables.
  }
  \item{xmeans}{
    The group means obtained from training.
  }
  \item{pred}{
   The predicted class labels of training data. 
  }
  \item{cl}{
  The observed class labels of training data. 
  }
  \item{prior}{
  The prior probabilities used.  
  }
  \item{conf}{
  The confusion matrix based on training data. 
  }
  \item{acc}{
  The accuracy rate of training data. 
  }
  \item{lev}{
  The levels of class. 
  }
  \item{call}{
    The (matched) function call.
  }
}

% ----------------------------------------------------------------------------
\note{
  This function may be given either a formula and
  optional data frame, or a matrix and grouping factor as the first
  two arguments. 
}

% ----------------------------------------------------------------------------
\references{
  Venables, W. N. and Ripley, B. D. (2002)
  \emph{Modern Applied Statistics with S.} Fourth edition.  Springer.

  Ripley, B. D. (1996)
  \emph{Pattern Recognition and Neural Networks}. Cambridge University Press.
  
  Thomaz, C. E. and Gillies, D. F. (2004) 
  A Maximum Uncertainty LDA-based approach for  Limited Sample Size problems
  with application to Face Recognition. \emph{Technical Report}. 
  Department of Computing, Imperial College London.
  
  Yang, J. and Yang J.-Y. (2003)
  Why can LDA be performed in PCA transformed space? \emph{Pattern Recognition}, 
  vol.36, 563 - 566. 
}

% ----------------------------------------------------------------------------
\author{
  David Enot \email{dle@aber.ac.uk} and Wanchang Lin \email{wll@aber.ac.uk}.
}

% ----------------------------------------------------------------------------
\seealso{
  \code{\link{predict.nlda}}, \code{\link{plot.nlda}},  \code{\link{hca.nlda}}
}

% ----------------------------------------------------------------------------
\examples{
## load abr1
data(abr1)
cl   <- factor(abr1$fact$class)
dat <- preproc(abr1$pos , y=cl, method=c("log10","TICnorm"),add=1)[,110:500]  

## define random training and test datasets
idx <- sample(1:nrow(dat), round((2/3)*nrow(dat)), replace=FALSE) 
train.dat  <- dat[idx,]
train.t    <- cl[idx]
test.dat   <- dat[-idx,]        
test.t     <- cl[-idx] 

## build nlda on the training data
model    <- nlda(train.dat,train.t)
## print summary
summary(model)

## map samples on the first 2 DFs
plot(model,dimen=c(1,2),main = "Training data",abbrev = TRUE)
## map samples on all the DFs
plot(model,main = "Training data",abbrev = TRUE)

## predict test sample membership
pred.te  <- predict(model, test.dat)$class
## confusion matrix and error rates
table(test.t,pred.te)

}

\keyword{classif}
