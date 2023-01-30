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

  string <- gsub(" ", "", string, fixed = TRUE) # eliminate potential spaces to eval len
  if (!nchar(string) %% 2 == 0)
    stop("argument 'string' must have an even number of characters")

  if(grepl("[^0-9A-Fa-f]", string))
    stop("argument 'string' has invalid hex characters")

  string <- strsplit(gsub('(.{2})', '\\1 ', string), " ", fixed=TRUE)[[1]]
  return(as.raw(strtoi(string, 16L)))
}
