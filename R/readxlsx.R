#' Read a sheet from an .xlsx file (local filepath or url)
#'
#' Read a single sheet from a .xlsx and guess the correct style (e.g., `Date`, `numeric` values)
#' @param filepath `character` - Local path to the .xlsx file to read
#' @param url `character` - url to an .xlsx file to download and read, downloading is processed with `utils::download.file()`
#' @param sheet `numeric` - Number of the sheet to extract, default = 1
#' @param remove_first_row_as_header `logical` - Use the first row values as colnames if `TRUE`. Default is `FALSE`
#' @param skip_rows `numeric` - Skip first rows of the datas, *before* to consider the first row of this filtered dataset as a header (if `remove_first_row_as_header` is `TRUE`)
#' @param ... - Parameters passed to `utils::download.file()` if needed for the download (only used when the user provide the `url` parameter)
#' @examples
#' datas <- readxlsx(url = "https://go.microsoft.com/fwlink/?LinkID=521962"
#'                 ,  remove_first_row_as_header = TRUE)
#' str(datas)
#' @export
readxlsx <- function(filepath = NULL, url = NULL, sheet = 1
                     , remove_first_row_as_header = F
                     , skip_rows = NULL
                     ,...){

 content <- read_xlsx_raw_content(file = filepath , url = url, sheet = sheet, ...)

  if(length(content) == 0) return(NA)

 if(length(content) == 1) if( is.na(content)) return(NA)

# catch the content into a Large list of list of 1 element (each cell)
cells_list  <- parse_sheet_xml_into_cells_list(content$sheet)


# filter out row if needed
if(!is.null(skip_rows)){
 id_to_exclude <- cells_list$row %in% skip_rows

 cells_list <- lapply(cells_list, FUN = function(x) { x[!id_to_exclude] })

  }

# other .xml files are only a vector :
shared_values <- parse_sharedstrings( content$sharedstrings )
styles_numFmtId <- parse_styles_xml_sheet(content$styles)

cells_list$values <- apply_types_to_sheet_xml_cells_list(values = cells_list$values
, types = cells_list$types
, styles = cells_list$styles
, indexed_shared_values = shared_values
, styles_numFmtId = styles_numFmtId)

# build a data.frame : our styles are preserved here
xlsx_data <- build_df_from_cells_list(cells_list, remove_first_row_as_header = remove_first_row_as_header)

return( structure(xlsx_data
                  , filepath = filepath
                  , url = url
                  , sheet = sheet)
)

}
