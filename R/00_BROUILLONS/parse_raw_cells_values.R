#' Get all the cells values (raws) before to turn it into a matrix
#'
#' @param sheet_text `character` - The complete raw sheet text (e.g., from 'sheet1.xls')
#' @returns Return a `data.frame` with
#'
#'    - `raw_content` - The raw content
#'    - `raw_value` - The value within the sheet .xml (index or real numeric value)
#'    - `excel_index` - The excel_index given in the .xml (start from 0 for indexing the first entry of the sharedstrings .xml file)
#'    - `types` - The types of value with
#'        - `NA` for numeric,
#'        - "s" for shared string,
#'        - "inlineStr" for inline text value,
#'        - "b" for a logical boolean,
#'        - "str" for a formula result,
#'        - "e" for an Excel error,
#'        - "d" for ISO date
#'
#' @examples
#' \dontrun{
#' excel_df <- parse_raw_cells_values(
#' sheet_text = read_xlsx_raw_content(
#' url = "https://go.microsoft.com/fwlink/?LinkID=521962")$sheet )
#'
#' str(excel_df)
#' }
#'
parse_raw_cells_values <- function(sheet_text = NULL) {

  if(length(sheet_text) > 1) sheet_text <- paste0(sheet_text, collapse = " ")

  if(is.null(sheet_text)) {
    warning("parse_raw_cells_values() don't have a raw text content to parse (unparsed text from a sheet.xml file)")
    return(NA)
  }
  if(is.na(sheet_text)) {
    warning("parse_raw_cells_values() don't have a raw text content to parse (unparsed text from a sheet.xml file)")
    return(NA)
  }

  cells_df <- data.frame()

  # Extract all cells
  cells <- xml_extract(sheet_text, "<c [^>]*>.*?</c>")

  if(length(cells) == 0) return(data.frame(ref = character(0), value_raw = character(0), type = character(0)))

  value_raw <- sub(".*<v>([^<]*)</v>.*", "\\1", cells)
  value_raw[!grepl("<v>", cells)] <- NA_character_

  # utility func : return content after a t= or a r=
  extract_xml_attr_with_equal_sign <- function(cells, balis = "t") {
    pattern <- paste0('.*', balis, '="([^"]*)".*')

    res <- sub(pattern, '\\1', cells, perl = TRUE)

    # sub() laisse la chaîne intacte s’il n’y a pas de match
    res[!grepl(pattern, cells, perl = TRUE)] <- NA_character_

    res <- gsub(x = res, pattern = '"', "")
    return(res)
  }

  results <- data.frame( stringsAsFactors = FALSE
                         , raw_content = cells
                         , raw_value = value_raw
                         , excel_index = extract_xml_attr_with_equal_sign(cells, "r" )
                         , types = extract_xml_attr_with_equal_sign(cells, "t")
                         , styles_index = extract_xml_attr_with_equal_sign(cells, "s" )
  )


  return( results )


}
