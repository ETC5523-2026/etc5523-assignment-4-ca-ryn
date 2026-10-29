#' Summarise Trash Wheel collections
#'
#' Calculates the total estimated rubbish count for each
#' Trash Wheel, year and rubbish category.
#' 
#' Missing counts are excluded from totals, but the number
#' of missing observations is reported separately.
#' Groups with no reported counts receive NA.
#'
#' @param data A data frame containing `name`, `year`,
#'   `trash_type`, and `count.`
#' @return A data frame with the Trash Wheel name,
#'   year, rubbish category, total estimated count,
#'   number of collections, and number of missing counts.
#' @examples
#' summarise_trash(trash_collections)
#' # Total estimated rubbish counts by Trash Wheel,
#' # and rubbish type.
#' 
#' summarise_trash(trash_collections) |>
#'   dplyr::filter(trash_type == "plastic_bottles") |>
#'   dplyr::slice_max(total_estimated, n=3, with_ties=FALSE)
#' # The three Trash Wheel-year combinations with the
#' # highest estimated plastic bottle counts.
#' 
#' summarise_trash(trash_collections) |>
#'   dplyr::filter(missing_counts > 0)
#' # Identify groups with missing rubbish counts
#' @export

summarise_trash <- function(data) {
  
  required <- c("name", "year", "trash_type", "count")
  
  if (!all(required %in% names(data))) {
    stop("The dataset is missing the required columns.")
  }
  
  data |>
    dplyr::group_by(name, year, trash_type) |>   # groups the data by Trash Wheel, year, & rubbish category
    dplyr::summarise(
      total_estimated = if (all(is.na(count))) { NA_real_ } 
      else { sum(count, na.rm = TRUE) },   # calculates the total available estimated rubbish counts
      n_collections = dplyr::n(),   # counts collection records in each group
      missing_counts = sum(is.na(count)),   # counts how many records have missing rubbish counts
      .groups = "drop") |>
    dplyr::arrange(year, name, trash_type)   # organise the table
}
