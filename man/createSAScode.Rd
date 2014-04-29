\name{createSAScode}
\alias{createSAScode}
\title{create the SAS code}
\usage{
createSAScode(SASnatch.working.directory = "", R2SAS = "", SAS2R = "",
  chunk.name = "unlabeled-SASnatch-chunk", code = "")
}
\arguments{
  \item{SASnatch.working.directory,}{optional argument}

  \item{R2SAS}{character value, optional argument}

  \item{SAS2R}{character value, optional argument}

  \item{chunk.name}{character value, optional argument}

  \item{code}{character value, optional argument}
}
\description{
create the SAS code
}
\examples{
createSAScode('U:/Desktop/SAScache','d','regout','SASreg','proc reg data = d; model x = y; out=regout r=resid; run;')
}

