#' Permute values in a 'raw_value' column of a df, according to another dictionnary df
#'
#' Permute values according to the sharedstrings.xml file (e.g., character value of a cell are in this file) and transform other values into dates according to the styles.xml
#' @param cells_df `data.frame` - The raw content data.frame provided by parse_raw_cells_values(). Must contain 'types', 'raw_content' and 'raw_value' columns.
#' @param sharedstrings_df `data.frame` - The content data.frame provided by parse_sharedstrings(). Must contain 'value' and 'index_excel' columns
#' @param styles_df `data.frame` - The data.frame provided by parse_styles.xml_sheet(). Must contain 'styles_index' and 'numFmtId' columns
#' @returns - Return a `data.frame` similar to the one passed by the user (`cells_df` parameter), but the column 'raw_content' contain the 'good' values, according to the sharedstyle `data.frame` (`sharedstrings_df` parameter)
#' @examples
#' \dontrun{
#' content <- read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#'
#' cells_df = parse_raw_cells_values(content$sheet)
#' shstrings_df = parse_sharedstrings(text = content$sharedstrings)
#' styles_df = parse_styles.xml_sheet(content$styles))
#'
#' index_df <- replace_values_with_types(cells_df, shstrings_df, styles_df)
#'
#' str(index_df)
#' }
#' @details
#' XML entities such as '&amp;' '&lt;' are not transleted and returned as they are '&amp' : the user have to post-process with a real XML parser
replace_values_with_types <- function(cells_df, sharedstrings_df, styles_df) {

  # 1. the inline values : we deal with them here
  is_inline <- cells_df$types == "inlineStr" & !is.na(cells_df$types)

  t_nodes <- gregexpr("<t[^>]*>([^<]*)</t>", cells_df$raw_content[is_inline], perl = TRUE)

  cells_df$raw_value[is_inline] <- vapply(
    seq_along(t_nodes),
    function(i) {
      if (t_nodes[[i]][1] == -1) return(NA_character_)
      paste(
        sub("^<t[^>]*>|</t>$", "",
            regmatches(cells_df$raw_content[is_inline][i], t_nodes[[i]])
        ),
        collapse = ""
      )
    },
    character(1)
  )

  # 2. sharedstrings values
  is_shared <- cells_df$types == "s" & !is.na(cells_df$types) & !is.na(cells_df$raw_value)

  cells_df$raw_value[is_shared] <- sharedstrings_df$value[
    match(as.integer(cells_df$raw_value[is_shared])
          , as.integer(sharedstrings_df$index_excel)
    )
  ]

  # 3. logical values : if there is a '1' its TRUE
  is_bool <- cells_df$types == "b" & !is.na(cells_df$types)

  cells_df$raw_value[is_bool] <- as.logical(as.integer(cells_df$raw_value[is_bool]))

  # 4.  numeric values

  is_numeric <-  cells_df$types == "n" |  is.na( cells_df$types )

  cells_df$raw_value[is_numeric] <- as.numeric(  cells_df$raw_value[is_numeric] )

  # 5. date values
  cells_df$numFmtId <- styles_df$numFmtId[
    match(cells_df$styles, styles_df$styles_index)
  ]

  excel_date_numFmt <- c(
    14, 15, 16, 17, 18, 19, 20, 21, 22,
    27, 28, 29, 30, 31, 32, 33, 34,
    35, 36, 45, 46, 47
  )

  is_date <- cells_df$numFmtId %in% excel_date_numFmt & !is.na(cells_df$raw_value)

  cells_df$raw_value[is_date] <- suppressWarnings(as.Date(as.numeric(cells_df$raw_value[is_date])
                                             , origin = "1899-12-30"))

  # return for now... but we must catch error, result of func, etc. to be complete
  return( cells_df )
}
