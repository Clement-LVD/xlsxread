#' Read a sheet from an .xlsx file (local filepath or url)
#'
#' Read a single sheet from a .xlsx and guess the correct style (e.g., `Date`, `numeric` values)
#' @param filepath `character` - Local path to the .xlsx file to read
#' @param url `character` - url to an .xlsx file to download and read, downloading is processed with `utils::download.file()`
#' @param sheet `numeric` - Number of the sheet to extract, default = 1
#' @param row1_is_colnames `logical` - Use the first row values as colnames if `TRUE`. Default is `FALSE`.
#' @param ... - Parameters passed to `utils::download.file()`
#' @examples
#' datas <- readxlsx(url = "https://go.microsoft.com/fwlink/?LinkID=521962",  row1_is_colnames = TRUE)
#' str(datas)
#' @export
readxlsx <- function(filepath = NULL, url = NULL, sheet = 1, row1_is_colnames = F , ...){

 content <- read_xlsx_raw_content(file = filepath , url = url, sheet = sheet, ...)

  if(length(content) == 0) return(NA)

 if(length(content) == 1) if( is.na(content)) return(NA)

 cells_df = parse_raw_cells_values(content$sheet)

sharedstrings_df <- parse_sharedstrings(text = content$sharedstrings)

styles_df = parse_styles.xml_sheet(content$styles)

index_df <- replace_values_with_types(cells_df, sharedstrings_df, styles_df)

xlsx_data <- pivot_df_from_xml_xlsx(index_df)

if(row1_is_colnames) {
  colnames(xlsx_data) <- xlsx_data[1, ]
  xlsx_data <- xlsx_data[-1, ]
}

return( structure(xlsx_data
                  , styles = styles_df
                  , filepath = filepath
                  , url = url
                  , sheet = sheet)
)

}
