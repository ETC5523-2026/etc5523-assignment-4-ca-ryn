# Summarise Trash Wheel collections

Calculates the total estimated rubbish count for each Trash Wheel, year
and rubbish category.

## Usage

``` r
summarise_trash(data)
```

## Arguments

- data:

  A data frame containing `name`, `year`, `trash_type`, and `count.`

## Value

A data frame with the Trash Wheel name, year, rubbish category, total
estimated count, number of collections, and number of missing counts.

## Details

Missing counts are excluded from totals, but the number of missing
observations is reported separately. Groups with no reported counts
receive NA.

## Examples

``` r
summarise_trash(trash_collections)
#> # A tibble: 182 × 6
#>    name             year trash_type total_estimated n_collections missing_counts
#>    <chr>           <dbl> <chr>                <dbl>         <int>          <int>
#>  1 Mister Trash W…  2014 cigarette…         4162000            44              0
#>  2 Mister Trash W…  2014 glass_bot…            2057            44              0
#>  3 Mister Trash W…  2014 plastic_b…           38730            44              0
#>  4 Mister Trash W…  2014 plastic_b…           82590            44              0
#>  5 Mister Trash W…  2014 polystyre…          102909            44              0
#>  6 Mister Trash W…  2014 sports_ba…             266            44              0
#>  7 Mister Trash W…  2014 wrappers             70849            44              0
#>  8 Mister Trash W…  2015 cigarette…         2856000            71              0
#>  9 Mister Trash W…  2015 glass_bot…            2327            71              0
#> 10 Mister Trash W…  2015 plastic_b…           98840            71              0
#> # ℹ 172 more rows
# Total estimated rubbish counts by Trash Wheel,
# and rubbish type.

summarise_trash(trash_collections) |>
  dplyr::filter(trash_type == "plastic_bottles") |>
  dplyr::slice_max(total_estimated, n=3, with_ties=FALSE)
#> # A tibble: 3 × 6
#>   name              year trash_type total_estimated n_collections missing_counts
#>   <chr>            <dbl> <chr>                <dbl>         <int>          <int>
#> 1 Gwynnda Trash W…  2023 plastic_b…          151870            86              0
#> 2 Mister Trash Wh…  2016 plastic_b…          151670            51              0
#> 3 Professor Trash…  2017 plastic_b…          147922            18              0
# The three Trash Wheel-year combinations with the
# highest estimated plastic bottle counts.

summarise_trash(trash_collections) |>
  dplyr::filter(missing_counts > 0)
#> # A tibble: 38 × 6
#>    name             year trash_type total_estimated n_collections missing_counts
#>    <chr>           <dbl> <chr>                <dbl>         <int>          <int>
#>  1 Professor Tras…  2017 sports_ba…              NA            18             18
#>  2 Captain Trash …  2018 glass_bot…              NA             6              6
#>  3 Captain Trash …  2018 sports_ba…              NA             6              6
#>  4 Captain Trash …  2018 wrappers                NA             6              6
#>  5 Professor Tras…  2018 sports_ba…              NA            24             24
#>  6 Captain Trash …  2019 glass_bot…              NA             5              5
#>  7 Captain Trash …  2019 sports_ba…              NA             5              5
#>  8 Captain Trash …  2019 wrappers                NA             5              5
#>  9 Professor Tras…  2019 sports_ba…              NA            15             15
#> 10 Captain Trash …  2020 glass_bot…              NA             6              6
#> # ℹ 28 more rows
# Identify groups with missing rubbish counts
```
