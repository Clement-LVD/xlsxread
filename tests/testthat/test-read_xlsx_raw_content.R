  test_that("read_xlsx_raw_content FETCH DATA", {
  content <-  read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")

  testthat::expect_equal(length(content), 4)
  testthat::expect_true( all(c("sheet", "sharedstrings", "workbook", "styles") %in% names(content) ))

 testthat::expect_true(all( sapply(content, is.character) ) )
 testthat::expect_true(all( sapply(content, nchar) > 100 ) )

})

  test_that("read_xlsx_raw_content raise error and warning", {

    testthat::expect_warning( testthat::expect_error(read_xlsx_raw_content(url = "fake_url")) )

  testthat::expect_warning( empty <- read_xlsx_raw_content()  )

  testthat::expect_true(is.na(empty))
  })
