#' Parse the sharedstrings.xml file
#'
#' sharedstrings.xml  is a dictionnary with the values within the .xlsx sheet
#' @param text `character` - The raw text content of a sharedstrings.xml file
#' @returns Return a `character` value : the first entry returned is the first sharedstrings entry (entry 0).
#'
#'  - `index_excel` for the Excel '0-first' index (line-number - 1)
#'  - `index_R` for the '1-first' index, as the main line numbering method within R
#'  - `value` for the raw value
#' @examples
#' \dontrun{
#' content <- read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#' shared_values <- parse_sharedstrings(text = content$sharedstrings)
#'
#' content <- read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#' shared_values <- parse_sharedstrings(text = content$sharedstrings)
#' }
#'
#
parse_sharedstrings <- function(text) {
  if(length(text) > 1) text <- paste0(text, collapse = " ")

  # text <- paste(text, collapse = "\n")
  si_nodes <- xml_extract(text, "<si[\\s\\S]*?</si>")
  if (!length(si_nodes)) return(character(0))

  # 2. Remove any XML tags (<r>, etc.)
  strings <- gsub("<[^>]+>", "", si_nodes)

  # 5. Decode minimal XML entities (Excel scope)
  strings <- gsub("&amp;", "&", strings, fixed = TRUE)
  strings <- gsub("&lt;", "<", strings, fixed = TRUE)
  strings <- gsub("&gt;", ">", strings, fixed = TRUE)
  strings <- gsub("&quot;", "\"", strings, fixed = TRUE)
  strings <- gsub("&apos;", "'", strings, fixed = TRUE)

  return( strings  )
}

