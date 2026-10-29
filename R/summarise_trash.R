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
#' @importFrom rlang .data
#' @export

summarise_trash <- function(data) {
  
  required <- c("name", "year", "trash_type", "count")
  
  if (!all(required %in% names(data))) {
    stop("The dataset is missing the required columns.")
  }
  
  data |>
    dplyr::group_by(.data$name, .data$year, .data$trash_type) |>
    dplyr::summarise(
      total_estimated = if (all(is.na(.data$count))) { NA_real_ } 
      else { sum(.data$count, na.rm = TRUE) },
      n_collections = dplyr::n(),
      missing_counts = sum(is.na(.data$count)),
      .groups = "drop") |>
    dplyr::arrange(.data$year, .data$name, .data$trash_type)
}
