library(shiny)
library(bslib)
library(ggplot2)

# load the data set in our R package
trash <- trashwheelexplorer::trash_collections

# choices for the filters
wheels <- sort(unique(trash$name))
trash_types <- sort(unique(trash$trash_type))
type_choices <- setNames(trash_types, gsub("_", " ", trash_types))

# user interface
ui <- page_sidebar(
  title = "Baltimore Trash Wheel Explorer",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  fillable = FALSE,
  sidebar = sidebar(
    title = "Explore the data",
    checkboxGroupInput(
      inputId = "wheels",
      label = "Select Trash Wheels",
      choices = wheels,
      selected = wheels
    ),
    sliderInput(
      "years",
      "Select year range",
      min = min(trash$year, na.rm=TRUE),
      max = max(trash$year, na.rm=TRUE),
      value = range(trash$year, na.rm=TRUE),
      step = 1,
      sep = ""
    ),
    selectInput(
      "trash_type",
      "Select rubbish category",
      choices = type_choices,
      selected = "plastic_bottles"
    ),
    hr(),
    p("Item counts are estimates rather than exact measurements.",
      "Missing values do not necessarily mean 0 rubbish.")
    ),
  
  # card 1: collection summary
  card(
    card_header(tags$strong("About this dashboard")),
    p(tags$strong("Intended user: "),
      "Environmental officers working with Baltimore's Healthy Habour initiative."),
    p(tags$strong("Research question: "),
      "How have the types and estimated quantities of rubbish collected",
      "by Baltimore's Trash Wheels varied across locations and over time?"),
    p("Use this dashboard to compare collection patterns between Trash Wheels,",
      "investigate changes across years, and identify differences between rubbish types."),
    hr(),
    h4("How to use the dashboard"),
    tags$ul(
      tags$li("Select Trash Wheels to compare location(s)."),
      tags$li("Adjust the year slider to investigate a specific period."),
      tags$li("Choose a rubbish category to update the charts and table."),
      hr(),
      h4("Understanding the data"),
      p(tags$strong("Trash Wheel: "),
        "The collection device associated with each record."),
      p(tags$strong("Rubbish category: "),
        "The type of item collected (e.g. plastic bottles, cigarette butts)."),
      p(tags$strong("Average per reported collection: "),
        "The estimated number of selected items divided by the number",
        "of collection records with reported counts."),
      hr(),
      textOutput("selection_info"),
      card_footer("Item counts are estimates. Missing observations are not treated as zero.")
    )
  ),
  
  # card 2: changes over time
  card(
    full_screen = TRUE,
    card_header(tags$strong(textOutput("trend_title"))),
    p("This chart shows the average estimated number of selected",
      "rubbish items per reported collection each year. Higher",
      "values indicate more items collected on average."),
    plotOutput("trend_plot", height = "320px"),
    card_footer("Each point represents the average estimated item count",
                "per reported collection in that year. Compare patterns over",
                "time rather than assuming that higher values prove an increase",
                "in pollution. Missing observations are excluded.")
  ),
  # card 3: comparison b/w Trash Wheels
  card(
    full_screen = TRUE,
    card_header(tags$strong(textOutput("comparison_title"))),
    p("This chart compares the average estimated number of selected",
      "rubbish items per recorded collection across Trash Wheels.",
      "Longer bars indicate higher average counts."),
    plotOutput("comparison_plot", height = "300px"),
    card_footer("Longer bars indicate higher average estimated item counts",
                "per reported collection. These comparisons do not account for",
                "differences in collection conditions or operating periods.")
  ),
  
  # card 4: detailed summary
  card(
    full_screen = TRUE,
    card_header(tags$strong("Detailed collection summary")),
    p("The table provides estimated item totals, collection counts",
      "missing observations and average counts for the selected category."),
    tableOutput("summary_table"),
    card_footer("Source: ", 
                tags$a("TidyTuesday (2024)",
                href = paste0("ttps://github.com/rfordatascience/tidytuesday/tree/main/data/2024/2024-03-05"),
                target = "_blank",
                rel = "noopener noreferrer"),
                ".Original source: Baltimore's Healthy Harbor Initiative.")
  )
)

# server
server <- function(input, output, session) {
  
  # filter data using the user's selections
  filtered_data <- reactive({
    req(input$years, input$trash_type)
    trash[trash$name %in% input$wheels &
            trash$year >= input$years[1] &
            trash$year <= input$years[2] &
            trash$trash_type == input$trash_type,
          ,
          drop = FALSE]
  })
  
  # apply the exported package summary function above
  summary_data <- reactive({
    df <- filtered_data()
    if (nrow(df) == 0) {
      return(NULL)
    }
    result <- trashwheelexplorer::summarise_trash(df)
    result$n_reported <- (
      result$n_collections - result$missing_counts
    )
    result$mean_per_collection <- ifelse(
      result$n_reported > 0,
      result$total_estimated / result$n_reported,
      NA_real_
    )
    result
  })
  
  # display titles
  output$trend_title <- renderText({
    paste("Annual trends in", gsub("_", " ", input$trash_type), "collection")
  })
  
  output$comparison_title <- renderText({
    paste("Comparison of", gsub("_", " ", input$trash_type), "between Trash Wheels")
  })
  
  # display info about the selected data
  output$selection_info <- renderText({
    
    if (length(input$wheels) == 0) {
      return("No Trash Wheels excluded. Select at least one Trash Wheel.")
    }
    
    df <- filtered_data()
    if (nrow(df) == 0) {
      return("No collection records match these filters. Try a wider year range.")
    }
    
    n_reported <- sum(!is.na(df$count))
    if (n_reported == 0) {
      return("The selected records have no reported item counts. Try another category or year range.")
    }
    
    paste0(nrow(df), " collection records selected; ",
           n_reported, " have reported item counts.")
  })
  
  # line chart of the average estimated items over time
  output$trend_plot <- renderPlot({
    df <- summary_data()
    validate(
      need(
        !is.null(df) && any(is.finite(df$mean_per_collection)),
        "No reported counts for this selection."
      )
    )
    df <- df[is.finite(df$mean_per_collection), , drop = FALSE]
    
    ggplot(df, 
           aes(x = year, y = mean_per_collection, 
               colour = name, group = name)) +
      geom_line(linewidth = 1) +
      geom_point(size = 2) +
      scale_x_continuous(breaks = sort(unique(df$year))) +
      labs(x = "Year",
           y = "Average estimated items per collection",
           colour = "Trash Wheel") +
      theme_minimal() +
      theme(legend.position = "bottom")
  })
  
  # bar chart of comparison b/w Trash Wheels
  output$comparison_plot <- renderPlot({
    df <-  summary_data()
    validate(
      need(!is.null(df), "No collections match the filters.")
    )
    overall <- df |>
      dplyr::group_by(name) |>
      dplyr::summarise(
        total_reported = sum(total_estimated, na.rm=TRUE),
        n_reported = sum(n_reported),
        .groups = "drop") |>
      dplyr::mutate(mean_per_collection = ifelse(
        n_reported > 0,
        total_reported / n_reported,
        NA_real_
      ))
    overall <- overall[is.finite(overall$mean_per_collection), , drop = FALSE]
    validate(
      need(nrow(overall) > 0, "No reported counts for this selection.")
    )
    
    ggplot(overall,
           aes(x = reorder(name, mean_per_collection),
               y = mean_per_collection,
               fill = name)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      labs(x = "Trash Wheel", y = "Average estimated items per collection") +
      theme_minimal()
  })
  
  # summary table
  output$summary_table <- renderTable({
    df <- summary_data()
    validate(need(!is.null(df), "No collections match the filters."))
    result <- df[ , c("name", "year", "total_estimated", "n_collections", 
                      "missing_counts", "mean_per_collection")]
    names(result) <- c("Trash Wheel", "Year", "Estimated total", "Collections",
                       "Missing counts", "Average per reported collection")
    # display years without decimal places
    result$Year <- as.character(result$Year)
    
    result
  },
  striped = TRUE,
  hover = TRUE,
  digits = 1)
}

shinyApp(ui, server)