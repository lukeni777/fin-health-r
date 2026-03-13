# fin-health-r

## Overview
fin-health-r is an R Shiny dashboard that recreates the core company health functionality from the original fin-health group project. It allows users to explore the financial health of publicly traded companies by filtering by industry, company, and year.

## Features
- Industry filter
- Company filter
- Year filter
- Reactive KPI outputs for Net Profit Margin and ROE
- Trend plots over time
- Company details table

## Data
This app uses the financial_statement.csv dataset adapted from the original group project.

## Install packages
Open R and run:

```r
install.packages(c("shiny", "bslib", "tidyverse", "DT"))