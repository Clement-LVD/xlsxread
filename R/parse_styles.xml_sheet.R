#' Parse styles.xls sheet from an .xlsx Workbook into a data.frame
#' @param styles_raw `character` - The style raw text content as returned by `read_xlsx_sheet_raw_content()`
#' @returns - Return a `character` vector of `numFmtId`.
#' @details The .xml convention begin the index of the `numFmtId` from '0', e.g., the first numFmtId is associated with the sheet.xml values '0'.
#' Please note that R natural index begin with 1.
#' @examples
#' \dontrun{
#'  parse_styles_xml_sheet(styles_raw = read_xlsx_raw_content(
#'  url = "https://go.microsoft.com/fwlink/?LinkID=521962")$styles)
#'  }
parse_styles_xml_sheet <- function(styles_raw){

    if (length(styles_raw) > 1L) {
      styles_raw <- paste(styles_raw, collapse = "")
    }

    # isolate cellXfs
  cellxfs <- get_regex_suppress_white(styles_raw,  ".*<cellXfs[^>]*>(.*?)</cellXfs>.*")

  # extract  xf styles
  xfs <-  xml_extract(cellxfs, "<xf[^>]*/>")

  # extract numFmtId (NA si absent)
    numFmtId <-  get_regex_suppress_white(xfs, '.*numFmtId="([^"]*)".*')

    results <- as.integer(numFmtId)

    return(results)
}
