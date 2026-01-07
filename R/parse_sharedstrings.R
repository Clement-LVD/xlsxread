#' Parse the sharedstrings.xml file
#'
#' sharedstrings.xml  is a dictionnary with the values within the .xlsx sheet
#' @param text `character` - The raw text content of a sharedstrings.xml file
#' @returns Return a `data.frame` with 3 columns :
#'
#'  - `index_excel` for the Excel '0-first' index (line-number - 1)
#'  - `index_R` for the '1-first' index, as the main line numbering method within R
#'  - `value` for the raw value
#' @examples
#' \dontrun{
#' content <- read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#' parse_sharedstrings(text = content$sharedstrings)
#' }
#'
#
parse_sharedstrings <- function(text) {
  if(length(text) > 1) text <- paste0(text, collapse = " ")

  text <- paste(text, collapse = "\n")  # << important
  si_nodes <- xml_extract(text, "<si[\\s\\S]*?</si>")

  strings <- vapply(si_nodes, function(si) {
    #capture between <t> ... </t>
    t_nodes <- xml_extract(si, "<t[^>]*>([\\s\\S]*?)</t>")
    # remove <t> and </t>
    t_nodes <- gsub("^<t[^>]*>|</t>$", "", t_nodes)
 # force colapsing if several texts
    t <- paste0(t_nodes, collapse = "")

    # replace some encoding troubles
    t <- gsub("&amp;", "&", t)
    t <- gsub("&lt;", "<", t)
    t <- gsub("&gt;", ">", t)
    t
  }, character(1))

  data.frame(
    index_excel = seq_along(strings) - 1,
    index_R     = seq_along(strings),
    value       = strings,
    stringsAsFactors = FALSE
  )
}

# legacy version
# parse_sharedstrings <- function(text) {
#
#   if(length(text) > 1) text <- paste0(text, collapse = " ")
#   # extract between <si>...</si>
#   matches <- xml_extract(text, "<si[\\s\\S]*?</si>")
#
#   # Construct <t> dictionnary from a sharedstrings .xml file (rich text)
#   strings <- vapply(matches, function(match) {
#     # extract all <t> nodes
#     nodes <- xml_extract(match, "<t[^>]*>([\\s\\S]*?)</t>")
#
#     # remove <t> tags if present
#     nodes <- gsub("^<t[^>]*>|</t>$", "", nodes)
#
#     # concatenate all <t> nodes into one string
#     paste0(nodes, collapse = "")
#   }, character(1))
#
#   strings <- trimws(strings)
#
#   # replace char
#   strings <- gsub(x = strings, pattern = "&amp;", replacement = "&")
#
#   sharedstrings_df <- data.frame(
#     index_excel = seq_along(strings) - 1,  # Excel 0-based
#     index_R     = seq_along(strings),      # R 1-based
#     value       = strings,
#     stringsAsFactors = FALSE
#   )
#
#   return( sharedstrings_df )
#
# }
