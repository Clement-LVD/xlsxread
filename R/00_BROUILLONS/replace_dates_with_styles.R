#' Replace values into dates according to the styles.xml file
#'
#' @param cells_df `data.frame` - A data.frame with 3 columns for permuting values : "styles_index" for filter out the 'date' style of the 1st line (optionnal), "excel_index" and "raw_value". Typically produced by parse_raw_cells_values()
#' @param styles_df `data.frame` - The data.frame of styles.xml, Must contain 'styles_index' and 'numFmtId' columns. Typically produced by parse_styles_xml_sheet()
#' @param row1_is_colnames `logical` - The 1st row are not treated as `Date` if `TRUE`. Default is `FALSE` (don't ignre the 1st line date styles)
#' @returns Return the cells_df data.frame with (a) raw_values permuted into `Date` and (b) a new numFmtId column
#' @examples
#' \dontrun{
#' content <- read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#'
#' cells_df = parse_raw_cells_values(content$sheet)
#' styles_df = parse_styles_xml_sheet(content$styles)
#'
#' values_df <- replace_dates_with_styles(cells_df, styles_df )
#' }
#'
replace_dates_with_styles <- function(cells_df, styles_df, row1_is_colnames = F){

  if( !(is.data.frame(cells_df) & is.data.frame(styles_df)) ){
    warning("You have to pass 2 data.frame : sheet.xml & styles.xml")
    return(NA)
  }

# columns for matching :
  if(!all(c("styles_index", "raw_value", "excel_index") %in% colnames(cells_df) )){

    warning('The "cells_df" data.frame need "styles_index", "excel_index" and "raw_value" columns')}

  if(!all(c("styles_index", "numFmtId") %in% colnames(styles_df) )){
    warning('The "styles_df" data.frame need "styles_index" and "numFmtId" columns')}

cells_df$numFmtId <- styles_df$numFmtId[
  match(cells_df$styles_index, styles_df$styles_index)
]

# bunch of excel styles :s
excel_date_numFmt <- c(
  14, 15, 16, 17, 18, 19, 20, 21, 22,
  27, 28, 29, 30, 31, 32, 33, 34,
  35, 36, 45, 46, 47
)

is_date <- cells_df$numFmtId %in% excel_date_numFmt & !is.na(cells_df$raw_value)

# filter out 1st rows (only within date)

if(row1_is_colnames){
  is_date[is_date][grep("[A-z]1$",cells_df$excel_index[is_date] )] <- F
}

# the 1st column is a fake date :s
cells_df$raw_value[is_date] <- as.Date(as.numeric(cells_df$raw_value[is_date]), origin = "1899-12-30")

datecols <- unique(gsub(x = cells_df$excel_index[is_date], pattern = "[0-9]*", replacement = ""))

return( structure(cells_df
                 , date_columns = datecols) )
}
