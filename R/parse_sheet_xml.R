#' Parse the raw - text - content of sheet.xml into a list of cells
#' @param xml_text `character` - The text of a sheet.xml from an .xlsx file
#' @returns Return a `list` with one entry per row.
#' Each entry is a `list` with a string representing a cell : all returned values are `character` excepted the 'col' entry (`numeric`).
#' For exemple within the first entry, returned values are :
#'
#' - entry 1
#'  - `ref` - `character` : Excel-style complete reference of the cell, e.g., 'A1' for the first cell
#'  - `row` - `numeric` : Excel-style reference of the row, e.g., '1'
#'  - `col` - `character` :  Excel-style reference of the col, e.g., 'A'
#'  - `type` - `character` :  xml-style type of cell, e.g., e.g., 's'
#'  - `values` - `character` raw value expressed in the .xml, e.g., '100'
#'
#' @examples
#' \dontrun{
#' xmls <-  read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#' xml_text <- xmls$sheet
#' cells_list  <- parse_sheet_xml_into_cells_list(xml_text)
#' }
#'
parse_sheet_xml_into_cells_list <- function(xml_text){

  all_cells <- xml_extract(xml_text, "<c .*?>.*?</c>")

  results <- list()

  # 1. row letter and col' numbers  :
  results$ref <- sub('.*r ?= ?"([A-Z]+[0-9]+)".*', '\\1', all_cells)
  # ---- row & col ----
  results$row <- as.integer(sub("^[A-Z]+", "", results$ref))
  results$col <- sub("[0-9]+$", "", results$ref)

# 2. Other conventional values are captured or filled with NA if missing
 opex <- list(types = '.*t ?="([a-z]+)".*'
         , values = '.*<v>(.*?)</v>.*'
       , styles = '.*s="([0-9]+)".*'
  )

values <- lapply(opex, FUN = function(x) as.list(get_regex_suppress_white(all_cells, x)  ))
# we have a list with our previous entries, types, values, styles

results <- append(values, results)

# transform into a proper list
results <- lapply(results, as.list  )

return(results)
}
