#' char_as_raw
#'
#' Convert an hexadecimal encoded string to raw vector. This is different from R's
#' \code{charToRaw()}.  See examples for details.
#'
#' @param string
#' A string of hex encoded values.
#'
#' @return
#' A raw vector.
#'
#' @examples
#' library(argon2)
#' str <- "736F6D652074657874"
#'
#' charToRaw(str)
#'
#' char_as_raw(str)
#'
#' @export
char_as_raw <- function(string)
{
  if (!is.string(string))
    stop("argument 'string' must be of character type")

  if (!is.hex(string))
    stop("argument 'string' has invalid hex characters or lenght")

  string <- strsplit(gsub('(.{2})', '\\1 ', gsub(" ", "", string, fixed = TRUE)), " ", fixed=TRUE)[[1]]
  return(as.raw(strtoi(string, 16L)))
}
