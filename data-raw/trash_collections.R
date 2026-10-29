# Trash Wheel Collection Data
## Original source: Baltimore's Healthy Harbor initiative

url <- paste0(
  "https://raw.githubusercontent.com/rfordatascience/",
  "tidytuesday/main/data/2024/2024-03-05/trashwheel.csv"
)

trash_collections <- readr::read_csv(url, show_col_types = FALSE) |>
  janitor::clean_names() |>
  dplyr::mutate(date = lubridate::mdy(date)) |>
  tidyr::pivot_longer(
    cols = plastic_bottles:sports_balls,
    names_to = "trash_type",
    values_to = "count"
  )

usethis::use_data(trash_collections, overwrite = TRUE)
