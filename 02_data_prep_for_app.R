library(tidyverse)
library(lubridate)
library(here)
library(janitor)

source(here("my_data_functions.R"))

source(here("drager_functions.R"))


# load and sort data ------------------------------------------------------

data_list <- data_import(list_of_files) #clean_names() not applied yet so I can use Nick's functions

data_summaries <- map(data_list, data_summarise)

data_summaries <- map(data_summaries, basic_calculations)

data_summaries <- map(data_summaries, monthly_summary)


# How to add new data? ----------------------------------------------------

new_data_list <- new_data_import(new_list_of_files)

new_data_summaries <- map(new_data_list, data_summarise)

new_data_summaries <- map(new_data_summaries, basic_calculations)

new_data_summaries <- map(new_data_summaries, monthly_summary)

# new_data_summaries[[10]] <- data_summaries[[10]]

# Merging -----------------------------------------------------------------

# 
# extract_df_from_list(data_summaries)
# 
# new_extract_df_from_list(new_data_summaries)


# mergedTh02 <- merge_list(Th02, newTh02)

merged_data_summaries <- map2(data_summaries, new_data_summaries,
                               ~ rbind_df(.x, .y))




writeRDA_summaries(merged_data_summaries)






