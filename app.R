library(shiny)
library(bslib)
library(tidyverse)
library(DT)

source("R/data_prep.R")
source("R/helpers.R")
source("R/plots.R")

df <- load_financial_data()

sector_choices <- get_sector_choices(df)

ui <- page_sidebar(
  title = "fin-health (R Shiny)",
  theme = bs_theme(version = 5, bootswatch = "flatly"),

  sidebar = sidebar(
    selectInput(
      inputId = "category",
      label = "Industry",
      choices = sector_choices,
      selected = sector_choices[1]
    ),
    uiOutput("company_ui"),
    uiOutput("year_ui")
  ),

  layout_column_wrap(
    width = 1/2,
    card(
      card_header("Net Profit Margin"),
      h3(textOutput("npm_value")),
      p(textOutput("npm_status")),
      plotOutput("npm_plot", height = "260px")
    ),
    card(
      card_header("Return on Equity (ROE)"),
      h3(textOutput("roe_value")),
      p(textOutput("roe_status")),
      plotOutput("roe_plot", height = "260px")
    ),
    card(
      card_header("Selected Company Details"),
      tableOutput("detail_table")
    ),
    card(
      card_header("Financial Summary"),
      verbatimTextOutput("summary_text")
    )
  )
)

server <- function(input, output, session) {

  company_choices <- reactive({
    get_company_choices(df, input$category)
  })

  output$company_ui <- renderUI({
    selectInput(
      inputId = "company",
      label = "Company",
      choices = company_choices(),
      selected = company_choices()[1]
    )
  })

  company_data <- reactive({
    req(input$company)
    df |>
      filter(Company == input$company) |>
      arrange(Year)
  })

  output$year_ui <- renderUI({
    req(nrow(company_data()) > 0)

    year_min <- min(company_data()$Year, na.rm = TRUE)
    year_max <- max(company_data()$Year, na.rm = TRUE)

    sliderInput(
      inputId = "year",
      label = "Year",
      min = year_min,
      max = year_max,
      value = year_max,
      step = 1,
      sep = ""
    )
  })

  filtered_data <- reactive({
    req(input$category, input$company, input$year)

    df |>
      filter(
        Category == input$category,
        Company == input$company,
        Year == input$year
      )
  })

  output$npm_value <- renderText({
    row <- filtered_data()
    req(nrow(row) > 0)
    format_percent_1(row$`Net Profit Margin`[[1]])
  })

  output$npm_status <- renderText({
    row <- filtered_data()
    req(nrow(row) > 0)
    financial_status(row$`Net Profit Margin`[[1]], "Net Profit Margin")
  })

  output$roe_value <- renderText({
    row <- filtered_data()
    req(nrow(row) > 0)
    format_percent_2(row$ROE[[1]])
  })

  output$roe_status <- renderText({
    row <- filtered_data()
    req(nrow(row) > 0)
    financial_status(row$ROE[[1]], "ROE")
  })

  output$npm_plot <- renderPlot({
    req(nrow(company_data()) > 0)
    plot_metric_over_time(company_data(), input$company, "Net Profit Margin")
  })

  output$roe_plot <- renderPlot({
    req(nrow(company_data()) > 0)
    plot_metric_over_time(company_data(), input$company, "ROE")
  })

  output$detail_table <- renderTable({
    row <- filtered_data()
    req(nrow(row) > 0)

    row |>
      select(
        Company,
        Category,
        Year,
        Revenue,
        `Net Income`,
        `Net Profit Margin`,
        ROE,
        `Current Ratio`,
        `Debt/Equity Ratio`
      )
  }, striped = TRUE, bordered = TRUE, spacing = "m")

  output$summary_text <- renderText({
    row <- filtered_data()
    req(nrow(row) > 0)

    paste(
      "Revenue:", format_money_m(row$Revenue[[1]]),
      "| Net Income:", format_money_m(row$`Net Income`[[1]]),
      "| Current Ratio:", format_number_2(row$`Current Ratio`[[1]]),
      "| Debt/Equity Ratio:", format_number_2(row$`Debt/Equity Ratio`[[1]])
    )
  })
}

shinyApp(ui, server)