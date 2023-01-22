#' blake2b
#'
#' A blake2b hash implementation with up to a 512-bit output.
#'
#' The BLAKE2 hash functions were announced in 2012 and are fast cryptographic
#' hash functions at least as secure as the latest standard SHA-3.
#' BLAKE2b produces digests of any size between 1 and 64 bytes (512 bits).
#'
#' @param x
#' Input to be hashed. Can be a single string or a raw vector.
#' @param key
#' An optional key. Should be \code{NULL} (for no key), a single string, or a
#' raw vector.
#' @param len
#' An optional integer indicating the desired length (in bytes) for the output
#' hash. Defaults to 64 (512-bit).

#'
#' @return
#' The hash of the string as a raw vector.
#'
#' @references
#' Aumasson, J.P., Neves, S., Wilcox-O'Hearn, Z. and Winnerlein, C., 2013, June.
#' BLAKE2: simpler, smaller, fast as MD5. In International Conference on Applied
#' Cryptography and Network Security (pp. 119-135). Springer Berlin Heidelberg.
#'
#' @examples
#' library(argon2)
#' blake2b("some string")
#' blake2b("another", "with key")
#' blake2b("another", "with key", 24)
#'
#' @export
blake2b <- function(x, key=NULL, len = 64L)
{
  if (!is.string(x) && !is.raw(x))
    stop("argument 'x' must be a single string or a raw vector", call.=FALSE)
  if (!is.null(key) && !is.string(key) && !is.raw(key))
    stop("argument 'key' must be NULL, a single string, or a raw vector", call.=FALSE)
  if (!check.is.posint(len) || len > 64)
    stop("argument 'len' must be an integer between 1 and 64", call.=FALSE)

  .Call(R_blake2b, x, key, as.integer(len))
}
