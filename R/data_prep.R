library(tidyverse)

load_financial_data <- function(path = "data/financial_statement.csv") {
  df <- read_csv(path, show_col_types = FALSE)

  names(df) <- names(df) |> stringr::str_trim()
  df <- df |>
    mutate(Category = toupper(Category))

  return(df)
}

get_sector_choices <- function(df) {
  df |>
    distinct(Category) |>
    arrange(Category) |>
    pull(Category)
}

get_company_choices <- function(df, selected_sector) {
  df |>
    filter(Category == selected_sector) |>
    distinct(Company) |>
    arrange(Company) |>
    pull(Company)
}