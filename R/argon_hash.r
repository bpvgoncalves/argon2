#' Argon2 Password Hashing and Encoding
#'
#' Basic password hashing and encoding.
#'
#' The default options for \code{iterations} and \code{memory} should be
#' sufficient for most purposes.  You are encouraged to read the official
#' documentation before modifying these values, which can be found here
#' \url{https://github.com/P-H-C/phc-winner-argon2/blob/master/argon2-specs.pdf}.
#'
#' On the other hand, \code{nthreads} is safe to change to fit your available
#' resources, and you are encouraged to do so.
#'
#' @details
#' This uses the argon2 (i, d or id variety) hash algorithm.  See references for
#' details and implementation source code (also bundled with this package).
#'
#' Our binding uses a 512 bit salt with data generated from MT.
#'
#' @return
#' \code{pw_hash()} returns a hash to be used as an input to \code{pw_check()}.
#'
#' \code{pw_check()} returns \code{TRUE} or \code{FALSE}, whether or not
#' the plaintext password matches its hash.
#'
#' @references
#' Biryukov, A., Dinu, D. and Khovratovich, D., 2015. Fast and
#' Tradeoff-Resilient Memory-Hard Functions for Cryptocurrencies and Password
#' Hashing. IACR Cryptology ePrint Archive, 2015, p.430.
#'
#' Reference implementation \url{https://github.com/P-H-C/phc-winner-argon2}
#'
#' @examples
#' library(argon2)
#'
#' pass <- "myPassw0rd!"
#' hash <- pw_hash(pass)
#' hash # store this
#'
#' pw_check(hash, pass)       # Correct password will return TRUE
#' pw_check(hash, "password") # Incorrect passwords will return FALSE
#' pw_check(hash, "1234")
#'
#' @name argon2
#' @rdname argon2
NULL



#' @param password
#' The plaintext password to be encoded (maps to parameter `P` on RFC 9106).
#' @param nonce
#' The salt to be used for the encoding (maps to parameter `S` on RFC 9106).
#' @param type
#' Choice of algorithm; currently the supported choices are "i", "d" and "id".
#' Defaults to "id".
#' @param iterations
#' A time cost. Recommended to be at least 10. Can be any integer from 1 to
#' 2^31 - 1. Maps to parameter `t` on RFC 9106.
#' @param memory
#' A memory cost, given in KiB. Can be any integer from 1 to 2^22 - 1 (but
#' don't be ridiculous). Maps to parameter `m`on RFC 9106.
#' @param threads
#' Number of threads. This affects the speed of hashing, so more is better.
#' Maps to parameter `p`on RFC 9106.
#' @param len
#' Length of the desired output hash.
#' @param as_raw
#' When TRUE sets the output as a raw vector. When FALSE encodes output as string.
#'
#' @rdname argon2_hash
#' @export
#' @useDynLib argon2 R_argon2_hasher
argon2_hash <- function(password, nonce=NULL, type="id", iterations=1,
                        memory=2048, threads=2, len = 64, as_raw = TRUE) {

  # Parameters checking
  check.is.string(password)
  type <- match.arg(tolower(type), c("i", "d", "id"))
  type <- switch(type, "d" = 0L, "i" = 1L, "id" = 2L)
  check.is.posint(iterations)
  if (iterations > 2^32 - 1)
    stop("argument 'iterations' - t - MUST be an integer number from 1 to 2^(32)-1.")
  check.is.posint(memory)
  if (memory > 2^22 - 1)
    stop("argument 'memory'- m - MUST be between 1 and 2^22-1.")
  check.is.posint(threads)
  if (threads > 2^24 - 1)
    stop("argument 'threads' MUST be an integer value from 1 to 2^(24)-1.")

  # TODO: Proper management of nonces
  if (!is.null(nonce) & !is.string(nonce)) {
    stop("argument 'nonce' MUST be an a character string, or NULL.")
  } else if (is.null(nonce)) {
    salt <- raw_as_char(blake2b(format(Sys.time(), "%Y-%m-%d %H:%M:%OS6"), len=16))
  } else {
    salt <- nonce
  }

  hash = .Call(R_argon2_hasher,
               password,
               salt,
               as.integer(type),
               as.integer(iterations),
               as.integer(1024L*memory),
               as.integer(threads),
               as.integer(len))

  if (!as_raw) {
    hash <- raw_as_char(hash)
  } else {
    salt <- charToRaw(salt)
  }

  class(hash) <- c("argon2.raw.hash")
  class(salt) <- c("argon2.raw.salt")

  out <- list(raw_hash = hash, salt = salt)
  class(out) <- "argon2.raw"
  return(out)
}

