#' Parse styles.xls sheet from an .xlsx Workbook into a data.frame
#' @param styles_raw `character` - The style raw text content as returned by `read_xlsx_sheet_raw_content()`
#' @returns - Return a `data.frame` with 2 columns : `numFmtId` and `styles_index`
#' @examples
#'  parse_styles.xml_sheet(styles_raw = read_xlsx_sheet_raw_content(
#'  url = "https://go.microsoft.com/fwlink/?LinkID=521962")$styles)
#' @export
parse_styles.xml_sheet <- function(styles_raw){

    if (length(styles_raw) > 1L) {
      styles_raw <- paste(styles_raw, collapse = "")
    }

    # isolate cellXfs
    cellxfs <- sub(
      ".*<cellXfs[^>]*>(.*?)</cellXfs>.*",
      "\\1",
      styles_raw,
      perl = TRUE
    )

    # extract  xf styles
    xfs <- regmatches(
      cellxfs,
      gregexpr("<xf[^>]*/>", cellxfs, perl = TRUE)
    )[[1]]

    # extract numFmtId (NA si absent)
    numFmtId <- sub(
      '.*numFmtId="([^"]*)".*',
      '\\1',
      xfs,
      perl = TRUE
    )

    numFmtId[numFmtId == xfs] <- NA_character_

    results <- data.frame( numFmtId     = as.integer(numFmtId)
                           , styles_index =  seq_along(numFmtId) - 1L
                           ,  stringsAsFactors = FALSE )

    return(results)
}
