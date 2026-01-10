#' Read .xml files from - unzipped - .xlsx and return raw content
#'
#' @param file `character` - Path to a .xlsx file to read
#' @param sheet `numeric` - Number of the sheet to extract, default = 1
#' @param url `character` - url to a .xlsx file to read (link with no waiting page only)
#' @param ... - Parameters passed to `utils::download.file()`
#' @examples
#' \dontrun{
#' content <-  read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")
#' str(content)
#' }
#'
#' @return `list` - Return the raw .xml content (unparsed) for several entries within the "xl/" subfolder :
#'   - `sheet` - raw data for one of the sheet, default is the first sheet (i.e. "xl/sheet1.xml"). This entry already offers the numeric values but the others values are a sharedStrings-index numeric value (the next `'sharedstrings'` entry of the `list` of results is the mapping file)
#'   - `sharedstrings` - sharedStrings.xml raw data (mapping file for characters and special values)
#'   - `workbook` - workbook.xml raw data (overall informations)
#'   - `styles` - styles.xml raw data
read_xlsx_raw_content <- function(file = NULL, sheet = 1, url = NULL, ...){

  if(is.null(file) & is.null(url)) {
    warning("No path or URL to an .xlsx file was provided to read_unzipped_xlsx(); returning NA.")
    return(NA)}

  if(!is.null(file) ) if(!file.exists(file)){
    warning("The .xlsx file does not exist: ", file)
    return(NA)}

  file <- unzip_xlsx(file = file, url = url, ...)

  xlpath <- file.path(file, "xl")

  # we return several informations + one sheet

  necessary_files <- list(sheet = paste0("sheet", sheet, ".xml$")
                          , sharedstrings = "sharedStrings.xml$"
                          , workbook = "workbook.xml$"
                          , styles = "styles.xml$"
  )

  # for each keyword hereabove, search the real file url :
  necessary_files <-  lapply(necessary_files, FUN = function(file){

    path_real_file <- normalizePath( list.files(xlpath, recursive = T, pattern = file, full.names = T) )
    # read raw content for each file, roughly equivalent of :
    # raw_content <- readLines(path_real_file, warn = FALSE)
    raw_content <-  readBin(path_real_file, "raw", n = file.info(path_real_file)$size)
    raw_content <- rawToChar(raw_content)
    raw_content <- enc2utf8(raw_content)
    # deal with BOM UTF-8 invisible-pollution
    raw_content <- sub("^\ufeff", "", raw_content)

    return( raw_content )
  })
  # return that list : raw content for several sheets
  return( necessary_files )
}
