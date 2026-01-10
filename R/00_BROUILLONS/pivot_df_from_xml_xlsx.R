#' Build a data.frame from a df computed with replace_values_with_types(), i.e. according to a raw_value and a excel_index column of the data.frame provided by the user.
#' @param index_df `data.frame` - The `data.frame` computed by `replace_values_with_types()`. Must contain the following columns : excel_index and raw_value
#' @returns Return a wild `data.frame`, similar to Excel
#' @examples
#' \dontrun{
#' content <- read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#'
#' index_df <- replace_values_with_types(
#' parse_raw_cells_values(content$sheet)
#' , parse_sharedstrings(text = content$sharedstrings))
#'
#' xlsx_data <- pivot_df_from_xml_xlsx(index_df)
#'
#' str(xlsx_data)
#' }
pivot_df_from_xml_xlsx <- function(index_df) {

  # extract col' and lines
  rows <- as.integer(sub("^[A-Z]+", "", index_df$excel_index))
  cols <- sub("[0-9]+$", "", index_df$excel_index)
  # 'cols' modalities (A, B, etc.) ARE FOR EACH CELL

  col_levels <- sort(unique(cols))

  # turn 'cols' into numeric position into - unique - col_levels, for each 'cols' values
  col_levels_indices <- match(cols, col_levels)

  nrow_max <- max(rows, na.rm = TRUE)

  # construct an empty matrix : number of rows and col' are known
  mat <- matrix(NA, nrow = nrow_max, ncol = length(col_levels))

  # fill with raw_value
  mat[cbind(rows, col_levels_indices)] <- index_df$raw_value
# indexing into a col according to col_levels_indices herabove

  # convert into data.frame
  df_wide <- as.data.frame(mat, stringsAsFactors = FALSE)
  colnames(df_wide) <- col_levels
  rownames(df_wide) <- 1:nrow_max

  df_wide
}

