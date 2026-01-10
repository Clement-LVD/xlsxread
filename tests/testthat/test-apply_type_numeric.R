testthat::test_that("apply_type_numeric converts numeric cells correctly and preserves types", {

  # --- Inputs ---
  values <- list("42", "TRUE", "hello", "123", 214, Sys.Date(), as.Date("2025-12-12"))
  types  <- c(NA, "b", "str", NA, NA, NA, NA)  # NA = numeric, "b" = boolean, "str" = text

  # --- Expected output ---
  expected <- list(42, "TRUE", "hello", 123, 214, Sys.Date(), as.Date("2025-12-12") )

  # --- Apply function ---
  result <- apply_type_numeric(values, types)

  # --- Tests ---
  # 1. output is a list
  testthat::expect_type(result, "list")

  # 2. length unchanged
  testthat::expect_length(result, length(values))

  # 3. each element is length 1
  testthat::expect_true(all(sapply(result, length) == 1))

  # 4. numeric conversion is correct
  testthat::expect_identical(result[[1]], 42)
  testthat::expect_identical(result[[4]], 123)

  # 5. non-numeric cells are untouched
  testthat::expect_identical(result[[2]], "TRUE")
  testthat::expect_identical(result[[3]], "hello")

  # 6. works if types is a list
  result2 <- apply_type_numeric(values, as.list(types))
  testthat::expect_equal(result2, expected)

  # 7. warning suppression test: non-numeric strings do not produce errors or NAs
  values2 <- list("42", "foo", "123")
  types2  <- c(NA, NA, NA)
  result3 <- apply_type_numeric(values2, types2)
  testthat::expect_identical(result3, list(42, NA_real_, 123))
})
