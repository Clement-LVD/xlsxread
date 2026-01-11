
# Suppose cells_list has: values, row, col
remove_header_row <- function(cells_list, header_row = 1) {

  # Identify indices of the header row
  header_idx <- which(unlist(cells_list$row) == header_row)

  # Extract header values
  header_values <- unlist(cells_list$values[header_idx])

  # Remove header row from the list
  keep_idx <- setdiff(seq_along(cells_list$values), header_idx)

  cells_list_trimmed <- lapply(cells_list, `[`, keep_idx)

  list(
    header = header_values,
    cells_list = cells_list_trimmed
  )
}

#' Build a data.frame from a cells list, preserving types (Date, numeric, character)
#'
#' @param cells_list A list containing at least:
#'   - values: list of cell contents (each element can be numeric, character, Date, etc.)
#'   - row: vector or list of row numbers corresponding to each value
#'   - col: vector or list of column letters corresponding to each value
#' @param remove_first_row_as_header Logical, if TRUE the first row is used as column names
#' @return A `data.frame` with optional headers
#' @examples
#' \dontrun{
#'
#' url = "https://go.microsoft.com/fwlink/?LinkID=521962"
#' content <- read_xlsx_raw_content(url = url, sheet = 1)
#' cells_list  <- parse_sheet_xml_into_cells_list(content$sheet)
#' shared_values <- parse_sharedstrings( content$sharedstrings )
#' styles_numFmtId <- parse_styles_xml_sheet(content$styles)
#'
#' cells_list$values <- apply_types_to_sheet_xml_cells_list(values = cells_list$values
#' , types = cells_list$types
#' , indexed_shared_values = shared_values
#' , styles_numFmtId = styles_numFmtId)
#'
#' datas <- build_df_from_cells_list(cells_list, remove_first_row_as_header = TRUE)
#' str(datas)
#' }
#'

build_df_from_cells_list <- function(cells_list, remove_first_row_as_header = TRUE) {
  # Remove header row

  if (remove_first_row_as_header) {
    header_row <- min(unlist(cells_list$row))
    tmp <- remove_header_row(cells_list, header_row = header_row)
    header <- trimws(tmp$header)
    cells_list <- tmp$cells_list
  } else {
    header <- NULL
  }

  all_rows <- sort(unique(unlist(cells_list$row)))
  all_cols <- sort(unique(unlist(cells_list$col)))

  # Build columns preserving type
  df_list <- lapply(all_cols, function(col) {

    idx <- which(cells_list$col == col)

    # missing_value <- all_rows[!all_rows %in% unique(cells_list$row[idx]) ]

    row_order <- match(unlist(cells_list$row[idx]), all_rows)

    # flatten each cell list (1 element per cell) to atomic vector, preserving type
    vals <- cells_list$values[idx][order(row_order)]
    do.call(base::c, vals)  # preserves Date, numeric, logical, character
  })
  names(df_list) <- all_cols

  # Convert to data.frame
  df <- as.data.frame(df_list, stringsAsFactors = FALSE)

  if (remove_first_row_as_header) colnames(df) <- header
  return(df)
}
