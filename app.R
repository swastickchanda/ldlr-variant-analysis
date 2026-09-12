library(shiny)
library(tidyverse)
library(DT)

# Load the processed 59-variant dataset
ldlr_data <- read_tsv("cadd_ready_ldlr.tsv")

ui <- fluidPage(
  titlePanel("LDLR Variant Explorer & ACMG Reclassification Dashboard"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("caddFilter", "Minimum CADD PHRED Score:",
                  min = 0, max = 40, value = 15, step = 1),
      checkboxGroupInput("tierFilter", "Select ACMG Tiers:",
                         choices = c("Pathogenic", "Likely Pathogenic", "VUS"),
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
    ldlr_data %>%
      filter(CADD_PHRED >= input$caddFilter,
             ACMG_Tier %in% input$tierFilter)
  })

  output$table <- renderDT({
    datatable(filteredData(), options = list(pageLength = 10))
  })

  output$distPlot <- renderPlot({
    ggplot(filteredData(), aes(x = CADD_PHRED, fill = ACMG_Tier)) +
      geom_histogram(binwidth = 2, color = "black", alpha = 0.8) +
      theme_minimal() +
      labs(title = "CADD Score Distribution by ACMG Tier",
           x = "CADD PHRED Score",
           y = "Variant Count")
  })
}

shinyApp(ui = ui, server = server)
