#' @title
#' Argon2 - Password Hashing
#'
#' @description
#' Password hashing
#'
#' This uses the argon2 (i, d or id variety) hash algorithm with tweekable parameters.
#'
#' The function uses by default the recommended defaults set on chapter 7.4 of RFC 9106 ("Argon2id
#' variant with t=1 and 2 GiB memory (...) is secure against side-channel attacks and maximizes
#' adversarial costs on dedicated brute-force hardware.").
#' See references for details and implementation source code (also bundled with this package).
#'
#' @param password    The plaintext password to be encoded (maps to parameter `P` on RFC 9106).
#' @param nonce       The salt to be used for the encoding (maps to parameter `S` on RFC 9106).
#'                    If not provided a random nonce of 16 bytes will be generated. This is the size
#'                    recommended by RFC 9106 for password hashing.
#' @param type        Choice of algorithm; currently the supported choices are "i", "d" and "id".
#'                    Defaults to "id".
#' @param iterations  A time cost. Can be any integer from 1 to 2^31 - 1. Maps to parameter `t` on
#'                    RFC 9106. Defaults to 1.
#' @param memory      A memory cost, given in MiB. Can be any integer from 1 to 2^22 - 1. Maps to
#'                    parameter `m` on RFC 9106. Defaults to 2 GiB.
#' @param threads     Number of threads. This affects the speed of hashing, so more is better.
#'                    Maps to parameter `p`on RFC 9106. Defaults to 2.
#' @param len         Length of the desired output hash. Defaults to 68 bytes (512 bits).
#' @param as_raw      TRUE (default) sets the output to a raw vector. FALSE sets output to string.
#'
#' @return
#' An object of type `argon2.raw` consisting of a list of 2 elements: raw_hash and salt.
#'
#' @examples
#' library(argon2)
#'
#' pass <- "myPassw0rd!"
#' hash <- argon2_hash(pass)
#' hash # store this
#'
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

  if (!is.null(nonce) & !is.string(nonce) & !is.raw(nonce)) {
    stop("argument 'nonce' MUST be an a character string, a raw vecor, or NULL.")
  } else if (is.null(nonce)) {
    salt <- blake2b(gen_nonce(128), len=16)
  } else if (is.character(nonce)) {
    salt <- charToRaw(nonce)
  } else { # must be raw
    salt <- nonce
  }

  hash <- .Call(R_argon2_hasher,
                password,
                salt,
                as.integer(type),
                as.integer(iterations),
                as.integer(1024L*memory),
                as.integer(threads),
                as.integer(len))

  if (!as_raw) {
    hash <- raw_as_char(hash)
    salt <- raw_as_char(salt)
  }

  class(hash) <- c("argon2.raw.hash")
  class(salt) <- c("argon2.raw.salt")

  out <- list(raw_hash = hash, salt = salt)
  class(out) <- "argon2.raw"
  return(out)
}

#' @export
print.argon2.raw.hash <- function(x, ...) {
  if (typeof(x) == "raw") {
    cat("Argon2 Raw Hash: ", raw_as_char(x), "\n")
  } else {
    cat("Argon2 Raw Hash: ", x, "\n")
  }
}

#' @export
print.argon2.raw <- function(x, ...) {
  print(x$raw_hash)
}
