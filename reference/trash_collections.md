# Trash Wheel Collection Data

Data on rubbish collected by four Trash Wheels operating in Baltimore's
waterways.

## Usage

``` r
trash_collections
```

## Format

A data frame with 6,951 rows and 11 variables:

- id:

  Trash wheel identifier

- name:

  Trash Wheel name

- dumpster:

  Dumpster collection number

- month:

  Month of collection

- year:

  Year of collection

- date:

  Date of collection

- weight:

  Height collected in US tonnes

- volume:

  Volume collected in cubic yards

- homes_powered:

  Estimated number of homes that could be powered using energy from the
  rubbish

- trash_type:

  Category of rubbish collected

- count:

  Estimated number of items collected

## Source

TidyTuesday,
<https://github.com/rfordatascience/tidytuesday/blob/main/data/2024/2024-03-05/readme.md>
Baltimore's Healthy Harbor initiative, <https://www.mrtrashwheel.com/>

## Details

Each row represents one rubbish category recorded for one dumpster
collection. Item counts are estimates rather than estimates rather than
exact counts. Missing counts do not mean zero rubbish.
