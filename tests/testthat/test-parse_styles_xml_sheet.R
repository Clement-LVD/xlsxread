testthat::test_that("parse_styles_xml_sheet parses minimal styles.xml", {

  # XML minimal simulant styles.xml
  styles_raw <- paste0(
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
    '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
    '  <numFmts count="2">',
    '    <numFmt numFmtId="164" formatCode="yyyy-mm-dd"/>',
    '    <numFmt numFmtId="165" formatCode="hh:mm:ss"/>',
    '  </numFmts>',
    '  <cellXfs count="2">',
    '    <xf numFmtId="164"/>',
    '    <xf numFmtId="165"/>',
    '  </cellXfs>',
    '</styleSheet>'
  )

  res <- parse_styles_xml_sheet(styles_raw)

  # Structured data ?
  testthat::expect_equal(length(res), 2)

  # content ?
  testthat::expect_equal(res, c(164, 165))
})
