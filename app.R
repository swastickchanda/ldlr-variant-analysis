library(shiny)
library(tidyverse)
library(DT)

# Load the processed variant dataset and custom functions
ldlr_data <- read_tsv("master_multigene_variants.tsv")
source("R/functions.R")

ui <- fluidPage(
  titlePanel("Multi-Gene Variant Explorer & ACMG Reclassification Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_genes", "Select Target Genes:",
                  choices = c("LDLR", "APOB", "PCSK9", "LDLRAP1"),
                  selected = "LDLR",
                  multiple = TRUE),
      sliderInput("caddFilter", "Minimum CADD PHRED Score:",
                  min = 0, max = 40, value = 15, step = 1),
      checkboxGroupInput("tierFilter", "Select ACMG Tiers:",
                         choices = c("Pathogenic", "Likely Pathogenic", "VUS", "Likely Benign", "Benign"),
                         selected = c("Pathogenic", "Likely Pathogenic", "VUS"))
    ),
    mainPanel(
      plotOutput("distPlot"),
      DTOutput("table")
    )
  )
)

server <- function(input, output, session) {

  filteredData <- reactive({
    # Safely check if inputs exist
    if (is.null(input$selected_genes)) return(NULL)

    gene_subset <- fetch_multigene_variants(input$selected_genes, ldlr_data)

    # Safely check if data was returned
    if (is.null(gene_subset) || nrow(gene_subset) == 0) return(NULL)

    # Apply existing CADD and Tier filters
    gene_subset %>%
      filter(
        CADD_PHRED >= input$caddFilter,
        ACMG_Tier %in% input$tierFilter
      )
  })

  output$table <- renderDT({
    df <- filteredData()

    # Prevent DT crash by returning an empty table structure if no data exists
    if (is.null(df) || nrow(df) == 0) {
      return(datatable(data.frame(Message = "No variants found for the selected filters.")))
    }

    datatable(df, options = list(pageLength = 10))
  })

  output$distPlot <- renderPlot({
    df <- filteredData()

    # Stop plot rendering safely if data is empty
    if (is.null(df) || nrow(df) == 0) return(NULL)

    ggplot(df, aes(x = CADD_PHRED, fill = ACMG_Tier)) +
      geom_histogram(binwidth = 2, color = "black", alpha = 0.8) +
      theme_minimal() +
      labs(title = "CADD Score Distribution by ACMG Tier",
           x = "CADD PHRED Score",
           y = "Variant Count")
  })
}

shinyApp(ui = ui, server = server)
