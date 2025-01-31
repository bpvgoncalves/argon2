% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/blake2b.r
\name{blake2b}
\alias{blake2b}
\title{blake2b}
\usage{
blake2b(x, key = NULL, len = 64L)
}
\arguments{
\item{x}{Input to be hashed. Can be a single string or a raw vector.}

\item{key}{An optional key. Should be \code{NULL} (for no key), a single string, or a
raw vector.}

\item{len}{An optional integer indicating the desired length (in bytes) for the output
hash. Defaults to 64 (512-bit).}
}
\value{
The hash of the string as a raw vector.
}
\description{
A blake2b hash implementation with up to a 512-bit output.
}
\details{
The BLAKE2 hash functions were announced in 2012 and are fast cryptographic
hash functions at least as secure as the latest standard SHA-3.
BLAKE2b produces digests of any size between 1 and 64 bytes (512 bits).
}
\examples{
library(argon2)
blake2b("some string")
blake2b("another", "with key")
blake2b("another", "with key", 24)

}
\references{
Aumasson, J.P., Neves, S., Wilcox-O'Hearn, Z. and Winnerlein, C., 2013, June.
BLAKE2: simpler, smaller, fast as MD5. In International Conference on Applied
Cryptography and Network Security (pp. 119-135). Springer Berlin Heidelberg.
}
