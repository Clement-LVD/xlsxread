test_that("unzip_xlsx works", {

  content <- unzip_xlsx(url = "https://go.microsoft.com/fwlink/?LinkID=521962", quiet = T)

  files <- list.files(content, recursive = T)

  files_to_have <- c("xl/sharedStrings.xml"  , "xl/styles.xml"  , "xl/tables/table1.xml"
                     , "xl/theme/theme1.xml"  , "xl/worksheets/sheet1.xml")

  testthat::expect_true(all(files_to_have %in% files) )
})
