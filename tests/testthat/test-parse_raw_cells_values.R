test_that("parse_raw_cells_values works", {

  excel_df <- parse_raw_cells_values(read_xlsx_raw_content(url = "https://go.microsoft.com/fwlink/?LinkID=521962")$sheet )

testthat::expect_true(is.data.frame(excel_df))
testthat::expect_true(all(c("raw_content", "raw_value", "excel_index" ,"types" ,"styles_index") %in% colnames(excel_df)))

testthat::expect_true(ncol(excel_df) > 2)

testthat::expect_true(nrow(excel_df) > 2)

})

test_that("parse_raw_cells_values raise warnings and answer NA values when invalid values are given", {

 testthat::expect_warning( excel_df <-parse_raw_cells_values(NA))

 testthat::expect_true(is.na(excel_df))

 testthat::expect_warning( excel_df <- parse_raw_cells_values(NULL) )

 testthat::expect_true(is.na(excel_df))

})
test_that("parse_raw_cells_values handles various XML cell cases correctly", {

  # Simple XML lines like a minimal sheet1.xml
  test_xml_cells <- c(
    # line 1
    '<c r="A1" s="0" t="n"><v>42</v></c>',         # numeric style 0
    '<c r="B1" s="1" t="n"><v>44927</v></c>',      # date style 1
    '<c r="C1" t="s"><v>0</v></c>',                # text style implicit
    '<c r="D1"><v>Hello</v></c>',                  # text without style or type
    # line 2
    '<c r="A2" s="0" t="n"><v>3.14</v></c>',       # numeric
    '<c r="B2" s="1" t="n"><v>44000</v></c>',      # date
    '<c r="C2" t="str"><v>World</v></c>',          # explicit text
    '<c r="D2"></c>'                               # empty cell
  )

  # parse the XML
  excel_df <- parse_raw_cells_values(test_xml_cells)

  # check the output is a data.frame
  testthat::expect_s3_class(excel_df, "data.frame")

  # check number of rows matches input
  testthat::expect_equal(nrow(excel_df), length(test_xml_cells))

  # check raw_value extraction
  expected_values <- c("42", "44927", "0", "Hello", "3.14", "44000", "World", NA_character_)
  expect_equal(excel_df$raw_value, expected_values)

  # check excel_index extraction
  expected_indexes <- c("A1","B1","C1","D1","A2","B2","C2","D2")
  testthat::expect_equal(excel_df$excel_index, expected_indexes)

  # check types extraction
  expected_types <- c("n","n","s",NA,"n","n","str",NA)
  testthat::expect_equal(excel_df$types, expected_types)

  # check styles_index extraction
  expected_styles <- c("0","1",NA,NA,"0","1",NA,NA)
  testthat::expect_equal(excel_df$styles_index, expected_styles)

})
