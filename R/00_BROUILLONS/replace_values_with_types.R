#' Replace values from a 'raw_value' column of a df, according to another dictionnary df
#'
#' Replace values according to the sharedstrings.xml file (e.g., character value of a cell are in this file) and transform other values into dates according to the styles.xml
#'
#' @param cells_df `data.frame` - The raw content data.frame provided by parse_raw_cells_values(). Must contain 'types', 'raw_content' and 'raw_value' columns.
#' @param sharedstrings_df `data.frame` - The content data.frame provided by parse_sharedstrings(). Must contain 'value' and 'index_excel' columns
#' @returns - Return a `data.frame` similar to the one passed by the user (`cells_df` parameter), but the column 'raw_content' is tweaked several times (see details), e.g., accordingly to the sharedstrings `data.frame` (`sharedstrings_df` parameter)
#' @details The cells_df is processed accordingly to the 'types' of values :
#'
#' - types == 'inlineStr' - `character` inline values are extracted (i.e. text within '<t>' and '</t>'),
#' - types == "s" - `character` values are permuted accordingly to the `sharedstrings_df` data.frame
#' - types == "b" - `logical` values are turned into logical `TRUE` / `FALSE` / `NA`
#' - types == "n" - `numeric` values are turned into numeric
#'
#' Note that the date have to be post-processed accordingly to the styles.xml and are treated as numeric values by this function.
#' @examples
#' \dontrun{
#' content <- read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#'
#' cells_df = parse_raw_cells_values(content$sheet)
#' sharedstrings_df = parse_sharedstrings(text = content$sharedstrings)
#'
#' index_df <- replace_values_with_types(cells_df, sharedstrings_df)
#'
#' str(index_df)
#' }
#' @details
#' The XML entities such as '&amp;' '&lt;' are not translated
replace_values_with_types <- function(cells_df, sharedstrings_df) {
# Regardin cells_df :
  # this func' handle the .xml data with a 'types' column (already extracted)
  # and a 'raw_value' column

  # 1. the inline values : we deal with them here
  is_inline <- cells_df$types == "inlineStr" & !is.na(cells_df$types)

  # we match these lines ('inlineStr' type of cell) and extract all the text within t :
  cells_df$raw_value[is_inline] <- extract_inlineStr_text(cells_df$raw_value[is_inline])

  # 2. sharedstrings values
  is_shared <- cells_df$types == "s" & !is.na(cells_df$types) & !is.na(cells_df$raw_value)
  # match these 'shared' cells_df$raw_value with the sharedstrings df, according to an 'index_excel' column
  sorted_values <- match(as.integer(cells_df$raw_value[is_shared]) , as.integer(sharedstrings_df$index_excel))
 # replace by these values the shared values
   cells_df$raw_value[is_shared] <- sharedstrings_df$value[ sorted_values ]

  # 3. logical values : if there is a '1' its converted to TRUE
  is_bool <- cells_df$types == "b" & !is.na(cells_df$types)

  cells_df$raw_value[is_bool] <- as.logical(as.integer(cells_df$raw_value[is_bool]))

  # 4.  numeric values

  is_numeric <-  cells_df$types == "n" |  is.na( cells_df$types )

  cells_df$raw_value[is_numeric] <- as.numeric(  cells_df$raw_value[is_numeric] )

  # 5. date values are converted later after turning into a df
  # return for now... but we must catch error, result of func, etc. to be complete
  return( cells_df )
}
