#' Unzip a .xlsx file into a bunch of .xml
#'
#' @importFrom utils unzip download.file
#' @param file `character` - Path to a .xlsx file to unzip
#' @param url `character` - url to an .xlsx file to download and unzip, downloading is processed with `utils::download.file()`
#' @param ... - Parameters passed to `utils::download.file()`
#' @seealso [utils::download.file()]
#' @details When an url is provided, a binary download mode is used, i.e. utils::download.file(mode = "wb").
#' @returns `character` - Return a temporary directory path : the - main - directory path of the bunch of .xml files produced
unzip_xlsx <- function(file = NULL, url = NULL, ...){

  if (!is.null(url)) {
    tmpfile <- tempfile(fileext = ".xlsx")
    utils::download.file(url, tmpfile, mode = "wb", ...)
    file <- normalizePath(tmpfile)
  }

  if (is.null(file)) {
    warning("No file path or url for unzip_xlsx(): returning NA")
    return(NA)
  }

  # temp. dir :

  tmpdir <- tempfile()
  # tmpdir <- "tests"
  dir.create( tmpdir )

  # Extraction ZIP
  utils::unzip(file, exdir = tmpdir)

  return( tmpdir )
}

#' Utility function : don't repeat regmatches(text, grepexpr) ad nauseam
#' @param text `character` - Text to process with regmatches(text, gregexpr( pattern , text ) )
#' @param pattern `character` - pattern to process
xml_extract <- function(text, pattern) {
  return(regmatches(text, gregexpr(perl = T, pattern, text))[[1]])
}

# catch text with sub and suppress full text
get_regex_suppress_white <- function(texts, regex = '.*t="([a-z]+)".*'){
result <- sub(regex, '\\1', texts)
result[result == texts] <- NA
return(result)
}
