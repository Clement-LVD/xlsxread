#' Unzip a .xlsx file into a bunch of .xml
#'
#' @importFrom utils unzip
#' @param file `character` - Path to a .xlsx file to unzip
#' @returns `character` - Return a temporary directory path : the - main - directory path of the bunch of .xml files produced
unzip_xlsx <- function(file = NULL){

  if(is.null(file)) {warning("No file path for unzip_xlsx() : returning NA value"); return(NA)}

  # temp. dir :

  tmpdir <- tempfile()
  # tmpdir <- "tests"
  dir.create( tmpdir )

  # Extraction ZIP
  utils::unzip(file, exdir = tmpdir)

return(tmpdir)
}

#' Read .xml files from - unzipped - .xlsx and return raw content
#'
#' @param file `character` - Path to a .xlsx file to read
#' @param sheet `numeric` - Number of the sheet to extract, default = 1
#' @examples
#' tmpdir <- tempfile(fileext = ".xlsx")
#' openxlsx::write.xlsx(cars, tmpdir)
#' content <- read_xlsx_sheet_raw_content(file = tmpdir)
#' str(content)
#' @return `character` - Return the raw .xml content (unparsed)
#' @export
read_xlsx_sheet_raw_content <- function(file = NULL, sheet = 1){
  # xxx une autre fonction ci ensuite : va lire une feuille donnee dans cette structure en broutant le tmpdir xxx
  if(is.null(file)) {warning("No path to an .xlsx file given to read_unzipped_xlsx() : returning NA value"); return(NA)}

  file <- unzip_xlsx(file)

    xlpath <- file.path(file, "xl")

  # availables_sheets <- list.files(xlpath, recursive = T, pattern = "sheet[0-9]+\\.xml$")

  # by default we work on sheet1 :
  sheet_path <- file.path(xlpath, "worksheets", paste0("sheet", sheet, ".xml"))

  if (!file.exists(sheet_path)) stop("Sheet number ",sheet, " don't exist !"  )

  # read the sheet XML
  xml_lines <- readLines(sheet_path, warn = FALSE)

  return(xml_lines)
  }

# utility fonction : don't repeat regmatches(text, grepexpr) ad nauseam
xml_extract <- function(text, pattern) {
  regmatches(text, gregexpr(pattern, text))[[1]]
}

read_xml_raw_content <- function(content){

  begin_and_end_of_data <- "<\\/?sheetData>"

  pos <- gregexpr(begin_and_end_of_data, content)[[1]]

  substr(content, min(pos), max(pos) )

  xml_extract(content,  "<row.*")


}

