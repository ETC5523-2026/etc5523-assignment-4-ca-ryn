#' Trash Wheel Collection Data
#' 
#' Data on rubbish collected by four Trash Wheels
#' operating in Baltimore's waterways.
#' 
#' Each row represents one rubbish category 
#' recorded for one dumpster collection.
#' Item counts are estimates rather than estimates
#' rather than exact counts.
#' Missing counts do not mean zero rubbish.
#' 
#' @format A data frame with 6,951 rows and 11 variables:
#' \describe{
#'    \item{id}{Trash wheel identifier}
#'    \item{name}{Trash Wheel name}
#'    \item{dumpster}{Dumpster collection number}
#'    \item{month}{Month of collection}
#'    \item{year}{Year of collection}
#'    \item{date}{Date of collection}
#'    \item{weight}{Height collected in US tonnes}
#'    \item{volume}{Volume collected in cubic yards}
#'    \item{homes_powered}{Estimated number of homes that could be powered 
#'      using energy from the rubbish}
#'    \item{trash_type}{Category of rubbish collected}
#'    \item{count}{Estimated number of items collected}
#' }
#' 
#' @source
#' TidyTuesday, <https://github.com/rfordatascience/tidytuesday/blob/main/data/2024/2024-03-05/readme.md>
#' Baltimore's Healthy Harbor initiative, <https://www.mrtrashwheel.com/>
#' 
"trash_collections"