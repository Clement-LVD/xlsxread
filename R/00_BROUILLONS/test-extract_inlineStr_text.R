test_that("extract_inlineStr_text handles all realistic inlineStr cases from XLSX", {

  raw <- c(
    # 1. simple <t>
    "<is><t>Hello</t></is>",

    # 2. <t> attribut
    "<is><t xml:space=\"preserve\">World</t></is>",

    # 3. several <t> (rich text direct)
    "<is><t>Hel</t><t>lo</t></is>",

    # 4. rich text with <r> wrapping
    "<is><r><t>Rich</t></r><r><t>Text</t></r></is>",

    # 5. <t> empty
    "<is><t></t></is>",

    # 6. empty cell
    "<is/>",

    # 7. empty cell
    "<is></is>",

    # 8. NA
    NA,

    # 9. <t> with space and linebreak
    "<is><t xml:space=\"preserve\">  Hello\nWorld  </t></is>",

    # 10. <t> with special char
    "<is><t>100% &amp; OK</t></is>"
  )

  res <- extract_inlineStr_text(raw)

  # Vérifications
  expect_equal(res[1], "Hello")                             # simple
  expect_equal(res[2], "World")                             # attribut
  expect_equal(res[3], "Hello")                             # concat multiple <t>
  expect_equal(res[4], "RichText")                          # rich text <r>
  expect_equal(res[5], "")                                  # vide <t>
  expect_true(is.na(res[6]))                                # <is/>
  expect_true(is.na(res[7]))                                # <is></is>
  expect_true(is.na(res[8]))                                # NA
  expect_equal(res[9], "  Hello\nWorld  ")                  # espace + newline préservé
  expect_equal(res[10], "100% &amp; OK")                    # caractères spéciaux
})
