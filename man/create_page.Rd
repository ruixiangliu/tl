% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_page.R
\name{create_page}
\alias{create_page}
\title{Create Page}
\usage{
create_page(fun, namespace = NULL)
}
\arguments{
\item{fun}{name of function being documented}

\item{namespace}{the package the function is in}
}
\value{
nothing
}
\description{
Function to create template rmd file pre-populated with sections to fill out.
}
\examples{
\dontrun{
create_page(dplyr::first)
}
}
