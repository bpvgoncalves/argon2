#' @title
#' Argon2 - Password Encoding
#'
#' @description
#' Password encoding
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
#'                    Valid arguments are:
#'                        - NULL (default), a random nonce of 16 bytes will be generated. This is
#'                        the size recommended by RFC 9106 for password hashing.
#'                        - Integer, a random nonce with a size equal to the parameter will be
#'                        generated. Max = 64.
#'                        - String or Raw vector, will be used directly as nonce.
#' @param type        Choice of algorithm; currently the supported choices are "i", "d" and "id".
#'                    Defaults to "id".
#' @param iterations  A time cost. Can be any integer from 1 to 2^31 - 1. Maps to parameter `t` on
#'                    RFC 9106. Defaults to 1.
#' @param memory      A memory cost, given in MiB. Can be any integer from 1 to 2^22 - 1. Maps to
#'                    parameter `m` on RFC 9106. Defaults to 2 GiB.
#' @param threads     Number of threads. This affects the speed of hashing, so more is better.
#'                    Maps to parameter `p`on RFC 9106. Defaults to 2.
#' @param len         Length of the desired output hash. Defaults to 68 bytes (512 bits).
#'
#' @return
#' An object of type `argon2.encoded` consisting of a the encoded_hash.
#'
#' @examples
#' library(argon2)
#'
#' pass <- "myPassw0rd!"
#' hash <- argon2_encode(pass)
#' hash # store this
#'
#' @export
#' @useDynLib argon2 R_argon2_encoder
argon2_encode <- function(password, nonce=NULL, type="id", iterations=1,
                          memory=2048, threads=2, len = 64) {

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

  if (is.null(nonce)) {
    salt <- blake2b(gen_nonce(128), len=16)
  } else if (is.integer(nonce)) {
    if (nonce > 64) {
      warning ("nonce value too big. Will use 64 bytes.")
      nonce <- 64
    }
    salt <- blake2b(gen_nonce(128), len=nonce)
  } else if (is.character(nonce)) {
    salt <- charToRaw(nonce)
  } else if (is.raw(nonce)) {
    salt <- nonce
  } else {
    stop("invalid type for 'nonce' argument. See documentation.")
  }

  hash <- .Call(R_argon2_encoder,
                password,
                salt,
                as.integer(type),
                as.integer(iterations),
                as.integer(1024L*memory),
                as.integer(threads),
                as.integer(len))


  class(hash) <- c("argon2.encoded.hash")

  out <- list(encoded_hash = hash)
  class(out) <- "argon2.encoded"
  return(out)
}


#' @title
#' Argon2 - Password Encoding Validation
#'
#' @description
#' validation of an encoded password given the encoded string and a password to be tested.
#'
#' @param encoded_hash  A string or 'argon2.encoded' object containing an encoded password.
#' @param password      A string representing the password to be tested.
#'
#' @return
#' TRUE if the password matches, and FALSE otherwise.
#'
#' @export
#' @useDynLib argon2 R_argon2_verify
#'
#' @examples
#'
#' # Checking 'argon2.encode' object
#' encoded <- argon2_encode("password", memory = 4)
#' argon2_verify(encoded, "password")
#' argon2_verify(encoded, "not_the_password")
#'
#' # Checking a string
#' argon2_verify("$argon2id$v=19$m=16384,t=2,p=4$c21hbGxzYWx0$VMLGGh5t7cTbShJgAJP4gw",
#'               "password")
#' argon2_verify("$argon2id$v=19$m=16384,t=2,p=4$c21hbGxzYWx0$VMLGGh5t7cTbShJgAJP4gw",
#'               "not_the_password")
#'
argon2_verify <- function(encoded_hash, password) {
  if (inherits(encoded_hash, "argon2.encoded"))
    encoded_hash <- encoded_hash$encoded_hash

  check.is.string(encoded_hash)
  check.is.string(password)

  .Call(R_argon2_verify, encoded_hash, password)
}

#' @export
print.argon2.encoded.hash <- function(x, ...) {
    cat("Argon2 Encoded Hash:\n", as.character(x), "\n", sep="")
}

#' @export
print.argon2.encoded <- function(x, ...) {
  print(x$encoded_hash)
}
