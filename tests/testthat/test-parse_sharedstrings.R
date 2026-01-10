testthat::test_that("parse_sharedstrings handles rich text, empty, special characters, and numeric text", {

  # XML example simulating sharedStrings.xml
  test_xml <- c(
    '<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
    # simple text
    '<si><t>Hello</t></si>',
    # multiple <t> in a single <si> (rich text)
    '<si><t>Rich</t><t> Text</t></si>',
    # integer number as text
    '<si><t>123</t></si>',
    # decimal number as text
    '<si><t>3.14</t></si>',
    # negative number as text
    '<si><t>-42</t></si>',
    # zero
    '<si><t>0</t></si>',
    # special characters and entities
    '<si><t>Special &amp; characters</t></si>',
    # empty <si>
    '<si></si>',
    # <t> with spaces and newlines
    '<si><t> Line1\nLine2 </t></si>',
    # another normal string
    '<si><t>End</t></si>',
    '</sst>'
  )

  # parse the shared strings
  ss_df <- parse_sharedstrings(test_xml)

  # check number of rows matches number of <si> nodes
  testthat::expect_equal(length(ss_df), 10)

  # check extracted values
  expected_values <- c(
    "Hello",                # simple text
    "Rich Text",            # multiple <t> concatenated
    "123",                  # integer text
    "3.14",                 # decimal text
    "-42",                  # negative number text
    "0",                    # zero
    "Special & characters", # special characters
    "",                     # empty <si>
    " Line1\nLine2 ",       # spaces and newline preserved
    "End"                   # normal string
  )
  # Note: there are 11 <si> nodes but one is empty, so total rows = 1
  testthat::expect_equal(as.character(ss_df), expected_values)


})
