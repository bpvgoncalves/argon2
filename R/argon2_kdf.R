#' @title
#' Argon2 - Key Derivation function
#'
#' @description
#' Key derivation from password
#'
#' This is a wrapper for the argon2_hash function with very robust (aka, paranoid!) parameters.
#'
#' @param password    The plaintext password to derive a key from.
#' @param nonce       The nonce to be used on the calculation. Defaults to a 32-byte random nonce.
#'
#' @return
#' An object of type `argon2.key` consisting of a list of 2 elements: key and salt.
#'
#' @export
#' @examples
#' argon2_kdf("this is a password to derive a key from")

argon2_kdf <- function(password, nonce=32L) {

  h <- argon2_hash(password, nonce, iterations=8, threads=4, len=128)

  out <- list(key = h$raw_hash, salt = h$salt)
  class(out) <- "argon2.kdf"
  class(out$key) <- "argon2.kdf.key"
  class(out$salt) <- "argon2.kdf.salt"
  return(out)
}

#' @export
print.argon2.kdf.key <- function(x, ...) {
  cat("Argon2 Key: ", paste0(rep("*", 16), collapse = ""), "\n", sep="")
}

#' @export
print.argon2.kdf <- function(x, ...) {
  print(x$key)
}
