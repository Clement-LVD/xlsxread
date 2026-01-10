#' Apply types to parsed list of results
#'
#' @param values `list` - Cells contents
#' @param types `character` or `list` - Cells types ("s", "b", "str", or NA for numeric)
#' @param styles `list` of cell styles ("1", "2", "3", or NA)
#' @param indexed_shared_values `character` - The sharedstrings.xml values, e.g., returned by `parse_sharedstrings()`
#' @param styles_numFmtId `numeric` - Ordered list of the styles within the *styles.xml* file (numFmtId). They will be associated with some xml styles expressed within a cell of the sheet.xml.
#' @param ... - Other parameters passed to `apply_type_excel_dates()`, i.e. tweak the values considered as Excel-Date styles with the parameter `date_numFmtId`
#' @returns Return the `values` provided as a `list`, with some proper `logical` and `NA` (Excel error) values.
#' @examples
#' \dontrun{
#' url = "https://go.microsoft.com/fwlink/?LinkID=521962"
#' content <- read_xlsx_raw_content(url = url, sheet = 1)
#' cells_list  <- parse_sheet_xml_into_cells_list(content$sheet)
#' shared_values <- parse_sharedstrings( content$sharedstrings )
#' styles_numFmtId <- parse_styles_xml_sheet(content$styles)
#'
#' final_content <- apply_types_to_sheet_xml_cells_list(values = cells_list$values
#' , types = cells_list$types
#' , styles = cells_list$styles
#' , indexed_shared_values = shared_values
#' , styles_numFmtId = styles_numFmtId)
#' }
#'
apply_types_to_sheet_xml_cells_list <- function(values, types, styles
                                                , indexed_shared_values
                                                , styles_numFmtId
                                                , ...){


   values <- apply_type_bool_and_error(values = values , types = types )

   values <- apply_type_numeric(values = values , types = types )

  values <- apply_type_sharedstrings(values = values
                                     , types = types
                                     , indexed_shared_values = indexed_shared_values)

  values <- apply_type_excel_dates( values = values
                                    , styles = styles
                                    ,  style_numFmtId = styles_numFmtId
                                    , ...)
  return(values)
   }

#' Within a list of TODO
#' @param values `list` of cell contents
#' @param types `character` or `list` of cell types ("s", "b", "str", or NA for numeric)
#' @returns Return a `list` of the values provided,  some values are turned into `logical` or `NA` (Excel error).
#' @examples
#' \dontrun{
#' url = "https://go.microsoft.com/fwlink/?LinkID=521962"
#' content <- read_xlsx_raw_content(url = url, sheet = 1)
#' cells_list  <- parse_sheet_xml_into_cells_list(content$sheet)
#' cells_list$values <- apply_type_bool_and_error(values = cells_list$values
#'                                              , types = cells_list$types )
#' }
#'
apply_type_bool_and_error <-  function(values, types) {

  if(is.list(types)) types <- unlist(types)

  # 1. Boolean cells (t="b") in Excel: 0 = FALSE, 1 = TRUE
  idx_bool <- which( types == "b")
  if (length(idx_bool) > 0) {

    values[idx_bool] <- as.logical(as.integer(values[idx_bool]))

    }

 # 2. Error cells (t="e") : convert into NA (Excel errors are not data)
  idx_err <- which( types == "e")
  if (length(idx_err) > 0) {values[idx_err] <- NA}

  return(values)
}


#' Convert Excel numeric cells from character to numeric
#'
#' @param values `list` of cell contents
#' @param types `character` vector of cell types ("s", "b", "str", or NA for numeric)
#' @return Return a `list` of the values, numeric cells are converted to numeric and others unchanged
#' @examples
#' \dontrun{
#' apply_type_numeric(c("42", "TRUE", "hello", "123"), c(NA, "b", "str", NA))
#' # Return the same return as : list(42, "TRUE", "hello", 123)
#'
#' Other examples within the xlsxread pipeline :
#' xmls <-  read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#' xml_text <- xmls$sheet
#' cells_list  <- parse_sheet_xml_into_cells_list(xml_text)
#' cells_list$values <- apply_type_bool_and_error(values = cells_list$values
#' , types = cells_list$types )
#'
#' cells_list$values <- apply_type_numeric(values = cells_list$values
#' , types = cells_list$types)
#' }
apply_type_numeric <- function(values, types) {
  if (length(values) != length(types)) {
    stop("values and types must have the same length")
  }

  if(is.list(types)) types <- unlist(types)
  # if it's not already a numeric
  idx_to_convert <- which(sapply(values, FUN = function(x) !is.numeric(x) & !is.double(x) & !is.numeric.Date(x)))
  # index of numeric Excel cells: types is NA
  idx_numeric <- which(is.na(types[idx_to_convert]))

  if (length(idx_numeric) == 0) { return(values) }

  # or try to convert, suppress warnings for NA coercion
  converted <- suppressWarnings(as.numeric(values[idx_numeric]))
  values[idx_numeric] <- as.list(converted)


  return(values)
}

#' Convert character values accordingly to sharedstyles.xml
#'
#' @param values `list` of cell contents
#' @param types `character` vector of cell types ("s", "b", "str", or NA for numeric)
#' @param indexed_shared_values `character` vector of the sharedstrings.xml values
#' @returns Return a `list` of the values, some `character` values are converted accordingly to the sharedstyles.xml file.
#' @examples
#' \dontrun{
#' xmls <-  read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#' xml_text <- xmls$sheet
#' cells_list  <- parse_sheet_xml_into_cells_list(xml_text)
#' shared_values <- parse_sharedstrings( xmls$sharedstrings )
#'
#'  cells_list$values <- apply_type_sharedstrings(values = cells_list$values
#' , types = cells_list$types
#' , indexed_shared_values = shared_values)
#'
#' cells_list$values <- apply_type_numeric(values = cells_list$values, types = cells_list$types)
#' }
#'
apply_type_sharedstrings <- function(values, types, indexed_shared_values) {

  if (is.list(types)) types <- unlist(types)

  # cells of type "s"
  idx_s <- which(types == "s")
  if (length(idx_s) == 0) return(values)

  # convert indices - expressed within the values - as integer
  shared_idx <- as.integer(values[idx_s])

  # Excel shared strings are 0-based, R is 1-based
  if(min(shared_idx, na.rm = T) == 0) shared_idx <- shared_idx + 1L

  # filter invalid indices
  valid <- !is.na(shared_idx) & shared_idx >= 1 & shared_idx <= length(indexed_shared_values)

  # replace by correct values
  values[idx_s[valid]] <- indexed_shared_values[shared_idx[valid]]

  return(values)
}

# Apply Excel-Date styles to values
#'
#' The 'style' value of a cell within a 'sheet.xml' need to be matched with the 'styles.xml' file : the value within the 'style' xml of a cell is expressing a position within the 'styles.xml'.
#'  Once replaced, some of these styles are matched with a `date_numFmtId` parameters that is supposed - by default - to list the Excel-Date styles, i.e. styles from 14 to 22.
#' @param values `list` of cell contents
#' @param styles `list` of cell styles ("1", "2", "3", or NA)
#' @param style_numFmtId `numeric` - Ordered list of the styles within the *styles.xml* file (numFmtId). They will be associated with some xml styles expressed within a cell of the sheet.xml.
#' @param date_numFmtId `numeric` - List of the styles id that are `Date`.
#' @returns Return a `list` of the values, some are turned into `Date` accordingly to their styles and the styles.xml file.
#' @examples
#' \dontrun{
#' xmls <-  read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#' xml_text <- xmls$sheet
#' cells_list  <- parse_sheet_xml_into_cells_list(xml_text)
#' cells_list$values <- apply_type_excel_dates(values = cells_list$values , styles = cells_list$styles
#' ,  style_numFmtId = parse_styles_xml_sheet(xmls$styles))
#'
#' }
#'
apply_type_excel_dates <- function(values
                                   , styles
                                   , style_numFmtId
                                   , date_numFmtId = c(
                                     14, # m/d/yyyy
                                     15, # d-mmm-yy
                                     16, # d-mmm
                                     17, # mmm-yy
                                     18, # h:mm AM/PM
                                     19, # h:mm:ss AM/PM
                                     20, # h:mm
                                     21, # h:mm:ss
                                     22  # m/d/yyyy h:mm
                                   )
) {
  # Identify cells having a style (unstyled cells cannot be dates)

  styled_idx <- which(!is.na(styles))
  #With several list of same length we will filter only some of the entries (according to styled_idx)
  if (length(styled_idx) == 0L) return(values)

  # Map Excel styleId -> numFmtId
  # styleId is 0-based in Excel, hence the +1 offset
  numFmtId <- style_numFmtId[as.numeric(styles[styled_idx]) + 1L]

  #Keep only Excel date formats (14–22) w/o custom format
  date_idx <- styled_idx[numFmtId %in% date_numFmtId]
  if (length(date_idx) == 0L) return(values)

  # Ignore empty cells (safety)
  date_idx <- date_idx[nchar(values[date_idx]) > 0L]
  if (length(date_idx) == 0L) return(values)

  # Convert Excel numeric to R Date
  # Keep original value if conversion fails
  original_values <- as.list(values[date_idx])

  converted_values <- as.Date(
    suppressWarnings(as.numeric(original_values)),
    origin = "1899-12-30"
  )
  # some of the entries of 'date_idx' (saved into 'original_values') are valid
  valid_conversion <- !is.na(converted_values)
  values[date_idx[valid_conversion]] <- as.list(converted_values[valid_conversion])

  return(values)

}
