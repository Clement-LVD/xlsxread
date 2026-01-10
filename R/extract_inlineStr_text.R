#' Extract text from inlineStr XML cell content
#'
#' @param raw_content character vector containing inlineStr XML
#' @return character vector of extracted text (NA if no <t> node)
#' @details The inlineStr text is supposed to be between <t> ... </t> but other types of inline content are not handled yet
#' @keywords internal
extract_inlineStr_text <- function(raw_content) {
  #  create na values (returned by default)
  out <- raw_content
  is_ok <- !is.na(raw_content)

    # identify <t> and </t> text
  # <t and all that is NOT a '>' (repeated *) until a '>' (!) then capture group until the last </t>
  t_nodes <- gregexpr( "<t[^>]*>(?s:.*?)</t>",  raw_content[is_ok], perl = TRUE)
# and we just add all char including linebreaks with : (?s:.*?)

  # extract matches of t_nodes previously extracted
  matches <- regmatches(raw_content[is_ok], t_nodes)

  # for each matches entries :
  out[is_ok] <- vapply(
    matches,
    function(x) {
      if (length(x) == 0) {
       return( NA_character_ )
        # deal with no matches hereabove (na value)
      } else {
        x <- unlist(x)
        # if several entries : we paste & collapse them
       result <-  paste(collapse = "" , x )
       # suppress the balises
       result <-  suppress_balises(result, balis = "t")
       return(result)
       }
    },
    character(1)
  )


return(out)
}

