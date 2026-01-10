testthat::test_that("apply_type_sharedstrings works correctly", {
  # --- input values ---
  values <- list("0", "hello", "2", "3", "world", NA,  123)
  types  <- c("s", NA, "s", "s", NA, "s", NA)  # type "s" for shared string
  indexed_shared_values <- c("first", "second", "third", "fourth")
# indexed from '0' so 'first' is the 0 values, and fourth is associated with 3 fourth (=3)
  # --- apply function ---
  out <- apply_type_sharedstrings(values, types, indexed_shared_values)

  # --- expected output ---
  expected <- list("first", "hello", "third", "fourth", "world", NA, 123)

  # check equality
  testthat::expect_equal(out, expected)

  # --- edge cases ---
  # 1. No shared string cells
  out2 <- apply_type_sharedstrings(values, rep(NA, length(values)), indexed_shared_values)
  testthat::expect_equal(out2, values)

  # 2. Invalid indices (too large, negative, NA)
  values_bad <- list("10", "hello", NA, "-1", -1)
  types_bad  <- c("s", NA, "s", "s", NA)
  out3 <- apply_type_sharedstrings(values_bad, types_bad, indexed_shared_values)
  # only index 1 is out-of-bounds (10) and index 4 (-1), index 3 is NA -> ignored
  testthat::expect_equal(out3, list("10", "hello", NA, "-1", -1))

  # 3. types as list
  types_list <- as.list(types)
  out4 <- apply_type_sharedstrings(values, types_list, indexed_shared_values)
  testthat::expect_equal(out4, expected)
})
