library(shiny)
library(tidyverse)
library(DT)

# Load the verified high-priority candidate dataset directly
ldlr_data <- read_tsv("high_priority_vus_candidates.tsv")

ui <- fluidPage(
  titlePanel("Multi-Gene Variant Explorer & ACMG Reclassification Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_genes", "Select Target Genes:",
                  choices = c("LDLR", "APOB", "PCSK9"),
                  selected = c("LDLR", "APOB", "PCSK9"),
                  multiple = TRUE),
      sliderInput("caddFilter", "Minimum CADD PHRED Score:",
                  min = 25, max = 35, value = 25, step = 0.5),
      checkboxGroupInput("tierFilter", "Select ACMG Tiers:",
                         choices = c("VUS"),
                         selected = c("VUS"))
    ),
    mainPanel(
      plotOutput("distPlot"),
      DTOutput("table")
    )
  )
)

server <- function(input, output, session) {

  filteredData <- reactive({
    if (is.null(input$selected_genes)) return(NULL)

    # Filter directly from the loaded dataframe
    gene_subset <- ldlr_data %>%
      filter(Gene_Symbol %in% input$selected_genes)

    if (nrow(gene_subset) == 0) return(NULL)

    gene_subset %>%
      filter(
        CADD_PHRED >= input$caddFilter,
        ACMG_Tier %in% input$tierFilter
      )
  })

  output$table <- renderDT({
    df <- filteredData()

    if (is.null(df) || nrow(df) == 0) {
      return(datatable(data.frame(Message = "No variants found for the selected filters.")))
    }

    datatable(df, options = list(pageLength = 10, scrollX = TRUE))
  })

  output$distPlot <- renderPlot({
    df <- filteredData()

    if (is.null(df) || nrow(df) == 0) return(NULL)

    ggplot(df, aes(x = CADD_PHRED, fill = ClinicalSignificance)) +
      geom_histogram(binwidth = 1, color = "black", alpha = 0.8) +
      theme_minimal() +
      labs(title = "CADD Score Distribution of High-Priority Candidates",
           x = "CADD PHRED Score",
           y = "Variant Count")
  })
}

shinyApp(ui = ui, server = server)
