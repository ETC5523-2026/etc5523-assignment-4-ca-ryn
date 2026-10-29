#' Launch the Trash Wheel Explorer
#' 
#' Starts an interactive Shiny app for exploring estimated rubbish
#' counts collected by Baltimore's Trash Wheels initiative.
#' 
#' Users can select Trash Wheels, a year range, and a rubbish
#' category to compare collection patterns.
#' 
#' @return No return value; called for its side affect of launching the app.
#' @export
run_app <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Please install ggplot2 to use the Shiny app.", call. = FALSE )
  }
  app_dir <- system.file("app", package = "trashwheelexplorer")
  shiny::runApp(app_dir)
}