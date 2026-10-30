# Exploring Baltimore Trash Wheel Collections

## Introduction

The `trashwheelexplorer` package helps environmental officers
investigate rubbish collection patterns across Baltimore’s Trash Wheels.

This package includes an organised data set, a summary function, and an
interactive Shiny app.

**Intended user**: environmental officers working with Baltimore’s
Healthy Harbour initative.

**Research question**: how have the types and estimate quantities of
rubbish collected by Baltimore’s Trash Wheels varied across locations
and over time?

## Installation

Install the package from GitHub:

``` r

install.packages("remotes")

remotes::install_github("ETC5523-2026/etc5523-assignment-4-ca-ryn")
```

Load the installed package:

``` r

library(trashwheelexplorer)
```

## Exploring the data set

This package includes `trash_collections`, a prepared data set
containing collection records for four Baltimore Trash Wheels.

Each row represents a rubbish category associated with one dumpster
collection.

``` r

head(trash_collections)
```

    ##       id               name dumpster month year       date weight volume
    ## 1 mister Mister Trash Wheel        1   May 2014 2014-05-16   4.31     18
    ## 2 mister Mister Trash Wheel        1   May 2014 2014-05-16   4.31     18
    ## 3 mister Mister Trash Wheel        1   May 2014 2014-05-16   4.31     18
    ## 4 mister Mister Trash Wheel        1   May 2014 2014-05-16   4.31     18
    ## 5 mister Mister Trash Wheel        1   May 2014 2014-05-16   4.31     18
    ## 6 mister Mister Trash Wheel        1   May 2014 2014-05-16   4.31     18
    ##   homes_powered      trash_type  count
    ## 1             0 plastic_bottles   1450
    ## 2             0     polystyrene   1820
    ## 3             0 cigarette_butts 126000
    ## 4             0   glass_bottles     72
    ## 5             0    plastic_bags    584
    ## 6             0        wrappers   1162

The key variables include:

- `name`: Trash Wheel name.
- `year`: year of collection.
- `trash_type`: rubbish category.
- `count`: estimated number of collected items.

The item counts are estimates, and missing values should not be
interpreted as zero.

## Summarising rubbish collections

The exported
[`summarise_trash()`](https://etc5523-2026.github.io/etc5523-assignment-4-ca-ryn/reference/summarise_trash.md)
function calculates estimated item totals for each Trash Wheel, year,
and rubbish category.

``` r

trash_summary <- summarise_trash(trash_collections)

head(trash_summary)
```

    ## # A tibble: 6 × 6
    ##   name              year trash_type total_estimated n_collections missing_counts
    ##   <chr>            <dbl> <chr>                <dbl>         <int>          <int>
    ## 1 Mister Trash Wh…  2014 cigarette…         4162000            44              0
    ## 2 Mister Trash Wh…  2014 glass_bot…            2057            44              0
    ## 3 Mister Trash Wh…  2014 plastic_b…           38730            44              0
    ## 4 Mister Trash Wh…  2014 plastic_b…           82590            44              0
    ## 5 Mister Trash Wh…  2014 polystyre…          102909            44              0
    ## 6 Mister Trash Wh…  2014 sports_ba…             266            44              0

The summary includes total estimated counts, collection records, and
missing observations.

For instance, we can investigate plastic bottle collections:

``` r

plastic_summary <- trash_summary |>
  dplyr::filter(trash_type == "plastic_bottles") |>
  dplyr::slice_max(total_estimated, n = 5, with_ties = FALSE)

plastic_summary
```

    ## # A tibble: 5 × 6
    ##   name              year trash_type total_estimated n_collections missing_counts
    ##   <chr>            <dbl> <chr>                <dbl>         <int>          <int>
    ## 1 Gwynnda Trash W…  2023 plastic_b…          151870            86              0
    ## 2 Mister Trash Wh…  2016 plastic_b…          151670            51              0
    ## 3 Professor Trash…  2017 plastic_b…          147922            18              0
    ## 4 Mister Trash Wh…  2020 plastic_b…          138560            72              0
    ## 5 Mister Trash Wh…  2015 plastic_b…          136130            71              0

This identifies five Trash Wheel-year groups with the highest reported
estimated plastic bottle totals.

However, the number of recorded collections differs across locations and
years. Larger totals do not necessarily mean that a Trash Wheel
collected more rubbish per collection.

## Launching the Shiny app

Launch the interactive dashboard using:

``` r

run_app()
```

The app opens in the RStudio Viewer or a web browser.

## Using the interactive controls

The dashboard provides three main controls:

1.  **Select Trash Wheels**: choose Trash Wheel(s) to compare collection
    patterns across locations.
2.  **Select year range**: adjust the year slider to focus on a specific
    period; this allows users to investigate whether patterns differ
    between earlier and later years.
3.  **Select rubbish category**: choose a category such as plastic
    bottles or cigarette butts - both charts and the summary table
    automatically update information for that category.

For example, an environmental officer can select two Trash Wheels,
choose plastic bottles, and examine the years in which both were
operating.

This allows a more targeted comparison than a single static chart
showing all locations, years, and rubbish categories.

## Interpreting the outputs

### Annual trend chart

The line chart displays the average estimated number of selected items
per reported collection for each year.

A higher point indicates a higher estimated item count per reported
collection, not necessarily a greater total amount of pollution.

The chart is useful for identifying patterns over time, but differences
may reflect collection conditions, reporting patterns, and periods of
operation.

### Trash Wheel comparison chart

The bar chart compares average estimated counts per reported collections
across selected Trash Wheels.

Longer bars indicate higher averages for the chosen rubbish category.

These values are descriptive comparisons and should not be interpreted
as proof that one waterway is more polluted than the other.

### Detailed summary table

The table provides estimated totals, collection counts, missing counts,
and average estimated counts.

Users should examine the number of records and missing observations
before interpreting differences. For instance, a high total based on
many collections is not directly comparable with a lower total based on
fewer collections.

## Limitations

- The data are historical rather than live.
- Item counts are estimated and may contain missing values.
- Trash Wheels have different operating periods and collection
  frequencies, which limits direct comparisons.
- This data set describes captured rubbish, not all rubbish present in
  Baltimore’s waterways.

## Conclusion

The `trashwheelexplorer` package provides a reproducible way to
investigate collection patterns. By filtering Trash Wheels, years and
rubbish categories, environmental officers can delve into differences
that would be difficult to assess from a single static display.

The summary function and Shiny app support descriptive exploration while
highlighting important limitations.

## Data sources

- [TidyTuesday Trash Wheel Data
  (2024)](https://github.com/rfordatascience/tidytuesday/tree/main/data/2024/2024-03-05)
- [Baltimore Healthy Harbor](https://www.mrtrashwheel.com/)
