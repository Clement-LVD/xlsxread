
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xlsxread

<!-- badges: start -->

![R](https://img.shields.io/badge/-package-steelblue?logo=r)
[![version](https://img.shields.io/github/r-package/v/clement-LVD/xlsxread?label=Version)](https://github.com/clement-LVD/xlsxread)
[![CRAN
status](https://www.r-pkg.org/badges/version/xlsxread)](https://CRAN.R-project.org/package=xlsxread)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R build
status](https://github.com/Clement-LVD/xlsxread/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Clement-LVD/xlsxread/actions)
[![codecov](https://codecov.io/gh/Clement-LVD/xlsxread/branch/main/graph/badge.svg?token=ZTMHT15VXP)](https://codecov.io/gh/Clement-LVD/xlsxread)
<!-- badges: end -->

`xlsxread::` is an R package dedicated to import an Excel `.xlsx` sheet
using `xlsxread::readxlsx()`.

> `xlsxread::` provides a lightweight XML parser within base R.

Features:

- 🚀 *Quick reading* of `.xlsx` files
  - 🌍 from a URL  
  - 💾 or from a file path  
- 𝄜 Import a `data.frame` within the R programming environment
  - 📅 Types are inferred according to Excel `.xlsx` conventions, e.g.,
    `Date`, `character`, and `numeric` values[^1]

## Installation

You can install the development version of `xlsxread::` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("Clement-LVD/xlsxread")
```

## Examples

Import a datasheet from .xlsx file with `xlsxread::readxlsx()`.

- Import from an URL :

``` r

datas <- xlsxread::readxlsx(url = "https://go.microsoft.com/fwlink/?LinkID=521962"
, sheet = 1, remove_first_row_as_header = TRUE)

str(datas)
#> 'data.frame':    700 obs. of  16 variables:
#>  $ Segment            : chr  "Government" "Government" "Midmarket" "Midmarket" ...
#>  $ Country            : chr  "Canada" "Germany" "France" "Germany" ...
#>  $ Product            : chr  "Carretera" "Carretera" "Carretera" "Carretera" ...
#>  $ Discount Band      : chr  "None" "None" "None" "None" ...
#>  $ Units Sold         : num  1618 1321 2178 888 2470 ...
#>  $ Manufacturing Price: num  3 3 3 3 3 3 5 5 5 5 ...
#>  $ Sale Price         : num  20 20 15 15 15 350 15 12 20 12 ...
#>  $ Gross Sales        : num  32370 26420 32670 13320 37050 ...
#>  $ Discounts          : num  0 0 0 0 0 0 0 0 0 0 ...
#>  $  Sales             : num  32370 26420 32670 13320 37050 ...
#>  $ COGS               : num  16185 13210 21780 8880 24700 ...
#>  $ Profit             : num  16185 13210 10890 4440 12350 ...
#>  $ Date               : Date, format: "2014-01-01" "2014-01-01" ...
#>  $ Month Number       : num  1 1 6 6 6 12 3 6 6 6 ...
#>  $ Month Name         : chr  "January" "January" "June" "June" ...
#>  $ Year               : chr  "2014" "2014" "2014" "2014" ...
#>  - attr(*, "url")= chr "https://go.microsoft.com/fwlink/?LinkID=521962"
#>  - attr(*, "sheet")= num 1

student <- xlsxread::readxlsx(url = "https://www.exceldemy.com/wp-content/uploads/2023/12/Project-Management-Sample-Data.xlsx"
, skip_rows = 1:4, remove_first_row_as_header = TRUE)

str(student)
#> 'data.frame':    46 obs. of  7 variables:
#>  $ Project Management Data: chr  "Progress" "Progress" "Progress" "Progress" ...
#>  $ Project Name           : chr  "Marketing" "Alice" "Bob" "Charlie" ...
#>  $ Task Name              : chr  "Market Research" "Content Creation" "Social Media Planning" "Campaign Analysis" ...
#>  $ Assigned to            : num  45292 45305 45319 45340 45293 ...
#>  $ Start Date             : num  13 14 22 25 18 10 25 22 25 30 ...
#>  $ Days Required          : num  45305 45319 45341 45365 45311 ...
#>  $ End Date               : num  0.78 1 0.45 0 1 0.78 0 1 1 0 ...
#>  - attr(*, "url")= chr "https://www.exceldemy.com/wp-content/uploads/2023/12/Project-Management-Sample-Data.xlsx"
#>  - attr(*, "sheet")= num 1
```

- Import from a local file :

``` r

datas <- xlsxread::readxlsx(filepath =  "C:/me/fake_datas.xlsx", sheet = 1)
#> Warning in read_xlsx_raw_content(file = filepath, url = url, sheet = sheet, :
#> The .xlsx file does not exist: C:/me/fake_datas.xlsx
```

## Parameters

Regarding `xlsxread::readxlsx()`,

- Main parameters are :
  - `filepath` or `url` : the local path or the url of to the .xlsx file
  - `sheet` : the sheet to import (defaut to 1 for the first sheet of
    the .xlsx)
- Optional parameters are :
  - `skip_rows` : first(s) row(s) to skip, e.g., `c(1,2,3)`. Default is
    `NULL` (don’t skip rows).
  - `remove_first_row_as_header` : use the first row cells values as
    colnames. Default is `FALSE` (colnames will be ‘A’, ‘B’, ‘C’, etc.)
  - If an `url` is provided, the user have the possibility to pass
    (optionnal) parameters to `utils::download.file()` in order to
    configure the download

[^1]: Note that R `data.frame` handle a single type of value within a
    column, i.e. a vector with several types is turned into a
    `character` vector
