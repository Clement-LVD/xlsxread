testthat::test_that("apply_type_bool_and_error works correctly", {

  # --- Inputs ---
  values <- list("0", "1", "foo", NA, "0", "1", "bar", 1, 2 , 1)
  types  <- c("b", "b", "n", NA, "e", "b", "e", NA, "n", "b")

  # --- Expected results ---
  # 1. bools -> TRUE/FALSE
  # 2. errors -> NA
  # 3. other types untouched
  expected <- list(FALSE, TRUE, "foo", NA, NA, TRUE, NA, 1 , 2, TRUE)

  # --- Apply function ---
  result <- apply_type_bool_and_error(values, types)

  # --- Tests ---
  # 1. output is a list
  testthat::expect_type(result, "list")

  # 2. length unchanged
  testthat::expect_length(result, length(values))

  # 3. each element is a single value (length 1)
  testthat::expect_true(all(sapply(result, length) == 1))

  # 4. content is exactly what we expect
  testthat::expect_equal(result, expected)

  # 5. boolean conversion works correctly
  testthat::expect_identical(result[[1]], FALSE)
  testthat::expect_identical(result[[2]], TRUE)
  testthat::expect_identical(result[[6]], TRUE)

  # 6. error conversion works correctly
  testthat::expect_true(is.na(result[[5]]))
  testthat::expect_true(is.na(result[[7]]))

  # 7. non-bool, non-error values untouched
  testthat::expect_identical(result[[3]], "foo")
  testthat::expect_true(is.na(result[[4]]))

  # 8. mixed input as list or vector for types
  result2 <- apply_type_bool_and_error(values, as.list(types))
  testthat::expect_equal(result2, expected)

})
