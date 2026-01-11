testthat::test_that("readxlsx works correctly", {

datas <- readxlsx(url = "https://go.microsoft.com/fwlink/?LinkID=521962"
                              , sheet = 1, remove_first_row_as_header = TRUE)

testthat::expect_s3_class(datas, "data.frame")

expected_columns <- c( "Segment"                ,  "Country" ,  "Product", "Discount Band"
,"Units Sold" , "Manufacturing Price" , "Sale Price"
, "Gross Sales" , "Discounts",     "Sales",   "COGS"  ,  "Profit",       "Date"
, "Month Number" , "Month Name" , "Year" )

testthat::expect_equal(colnames(datas), expected_columns)

testthat::expect_true(nrow(datas) > 1)

# next we will skip rows so we kept the lines number and first cells for testing hereafter
first_cell <- datas[1, ]
n_lines <- nrow(datas)

datas2 <- readxlsx(url = "https://go.microsoft.com/fwlink/?LinkID=521962"
                  , sheet = 1, remove_first_row_as_header = F, skip_rows = 1:20)



testthat::expect_s3_class(datas2, "data.frame")
# colnames are letters ?
testthat::expect_equal(colnames(datas2), LETTERS[1:ncol(datas2)])
# lines skipped ?
# 20 lines skipped vs. one line skipped (the header of previous example)
testthat::expect_true(nrow(datas2) == ( n_lines - 19))

}
)
