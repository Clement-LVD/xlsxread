
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xlsxread

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/xlsxread)](https://CRAN.R-project.org/package=xlsxread)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R build
status](https://github.com/Clement-LVD/xlsxread/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Clement-LVD/xlsxread/actions)
[![codecov](https://codecov.io/gh/Clement-LVD/xlsxread/branch/main/graph/badge.svg?token=ZTMHT15VXP)](https://codecov.io/gh/Clement-LVD/xlsxread)
<!-- badges: end -->

`xlsxread::` is an R package. The goal of `xlsxread::` is to import an
Excel .xlsx sheet within the R environnement with
`xlsxread::readxlsx()`.

> Dependencies are kept as low as possible and quick reading is
> expected.

> - 🌍 Read .xlsx file from an URL or a file path
> - 🚀 Maximal performance for quick reading
> - ℛ `base::` R with no dependencies

## Installation

You can install the development version of `xlsxread::` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("Clement-LVD/xlsxread")
```

## Examples

Import a sheet from .xlsx file with `xlsxread::readxlsx()`

- online :

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

- from a local file :

``` r

datas <- xlsxread::readxlsx(filepath =  "C:/me/fake_datas.xlsx", sheet = 1)
#> Warning in read_xlsx_raw_content(file = filepath, url = url, sheet = sheet, :
#> The .xlsx file does not exist: C:/me/fake_datas.xlsx
```
