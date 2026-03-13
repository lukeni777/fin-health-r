format_percent_1 <- function(x) {
  if (is.na(x)) return("N/A")
  sprintf("%.1f%%", x)
}

format_percent_2 <- function(x) {
  if (is.na(x)) return("N/A")
  sprintf("%.2f%%", x)
}

format_number_2 <- function(x) {
  if (is.na(x)) return("N/A")
  sprintf("%.2f", x)
}

format_money_m <- function(x) {
  if (is.na(x)) return("N/A")
  paste0("$", format(round(x, 0), big.mark = ","), "M")
}

financial_status <- function(value, metric) {
  if (is.na(value)) return("N/A")

  if (metric == "Net Profit Margin") {
    if (value >= 10) return("Healthy")
    if (value >= 0) return("Warning")
    return("Danger")
  }

  if (metric == "ROE") {
    if (value >= 15) return("Healthy")
    if (value >= 0) return("Warning")
    return("Danger")
  }

  if (metric == "Current Ratio") {
    if (value >= 1.5) return("Healthy")
    if (value >= 1.0) return("Warning")
    return("Danger")
  }

  if (metric == "Debt/Equity Ratio") {
    if (value <= 1.0) return("Healthy")
    if (value <= 2.0) return("Warning")
    return("Danger")
  }

  "N/A"
}