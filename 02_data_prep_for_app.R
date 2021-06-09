library(tidyverse)
library(lubridate)
library(here)
library(janitor)

source(here("my_data_functions.R"))

source(here("drager_functions.R"))


# load and sort data ------------------------------------------------------

data_list <- data_import(list_of_files)

data_summaries <- map(data_list, data_summarise)

data_summaries <- map(data_summaries, basic_calculations)

data_monthly <- map(data_summaries, monthly_summary)
