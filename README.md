
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xlsxread

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/xlsxread)](https://CRAN.R-project.org/package=xlsxread)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R build
status](https://github.com/Clement-LVD/xlsxread/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Clement-LVD/xlsxread/actions)
[![R
coverage](https://codecov.io/gh/Clement-LVD/xlsxread/branch/main/graph/badge.svg)](https://codecov.io/gh/Clement-LVD/xlsxread)
<!-- badges: end -->

`xlsxread::` is an R package. The goal of `xlsxread::` is to import an
Excel .xlsx sheet within the R environnement with
`xlsxread::readxlsx()`.

> - 🌍 Read file from an URL or a file path 🌍
> - 🚀 Maximal performance for read a sheet 🚀
> - ℛ `base::` R with no dependencies ℛ

## Installation

You can install the development version of xlsxread from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("Clement-LVD/xlsxread")
```

## Example

Import a sheet from a .xlsx file online :

``` r

datas <- xlsxread::readxlsx(url = "https://go.microsoft.com/fwlink/?LinkID=521962", sheet = 1)
#> Warning in as.Date(as.numeric(raw_cells_df$raw_value[is_date]), origin =
#> "1899-12-30"): NAs introduits lors de la conversion automatique

str(datas)
#> 'data.frame':    701 obs. of  16 variables:
#>  $ A: chr  "Segment" "Government" "Government" "Midmarket" ...
#>  $ B: chr  "Country" "Canada" "Germany" "France" ...
#>  $ C: chr  "Product" "Carretera" "Carretera" "Carretera" ...
#>  $ D: chr  "Discount Band" "None" "None" "None" ...
#>  $ E: chr  "Units Sold" "1618.5" "1321" "2178" ...
#>  $ F: chr  "Manufacturing Price" "3" "3" "3" ...
#>  $ G: chr  "Sale Price" "20" "20" "15" ...
#>  $ H: chr  "Gross Sales" "32370" "26420" "32670" ...
#>  $ I: chr  "Discounts" "0" "0" "0" ...
#>  $ J: chr  " Sales" "32370" "26420" "32670" ...
#>  $ K: chr  "COGS" "16185" "13210" "21780" ...
#>  $ L: chr  "Profit" "16185" "13210" "10890" ...
#>  $ M: chr  NA "16071" "16071" "16222" ...
#>  $ N: chr  "Month Number" "1" "1" "6" ...
#>  $ O: chr  "Month Name" "January" "January" "June" ...
#>  $ P: chr  "Year" "2014" "2014" "2014" ...
#>  - attr(*, "styles")='data.frame':   10 obs. of  2 variables:
#>   ..$ numFmtId    : int [1:10] 0 44 49 164 14 44 14 49 1 1
#>   ..$ styles_index: int [1:10] 0 1 2 3 4 5 6 7 8 9
#>  - attr(*, "url")= chr "https://go.microsoft.com/fwlink/?LinkID=521962"
#>  - attr(*, "sheet")= num 1
```

Or import from a local file path :

``` r

datas <- xlsxread::readxlsx(filepath =  "C:/me/fake_datas.xlsx", sheet = 1)
#> Warning in read_xlsx_raw_content(file = filepath, url = url, sheet = sheet, :
#> The .xlsx file does not exist: C:/me/fake_datas.xlsx
```
