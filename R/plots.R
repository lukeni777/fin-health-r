library(ggplot2)

plot_metric_over_time <- function(df, company_name, metric_name) {
  ggplot(df, aes(x = Year, y = .data[[metric_name]])) +
    geom_line(linewidth = 1) +
    geom_point(size = 2) +
    labs(
      title = paste(metric_name, "Over Time -", company_name),
      x = "Year",
      y = metric_name
    ) +
    theme_minimal(base_size = 13)
}