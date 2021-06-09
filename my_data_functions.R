# writing function for importing multiple files

library(tidyverse)
library(lubridate)
library(here)
library(janitor)


# Importing Data ----------------------------------------------------------


# Get list of files (remember to rename them with Theatre names and remove the time stamp):

list_of_files <- list.files(path = here("data"), 
                        pattern = "\\.txt$", 
                        full.names = TRUE)

# These are the basic elements of the functionly

# file_names <- file_list %>%
#   map_chr(~ str_sub(.x, start = 92, end = 95))
# 
# data.list <- map(file_list, read.csv)
# 
# 
# names(data.list) <- file_names

data_import <- function(file_list) {
  
  df_names <- file_list %>% 
    map_chr(~ str_sub(.x, start = 92, end = 95))  

  data_list <- map(file_list, read.csv)
  
  # data_list <- map(data_list, clean_names)
  
  names(data_list) <- df_names
  
  return(data_list)

}


# Sorting and Analying Data -----------------------------------------------


data_summarise <- function(df) {
  
  case_summary <- c("Case duration", 
                    "Consumption O2", 
                    "Consumption Air", 
                    "Consumption N2O",
                    "Consumption Sev",
                    "Uptake Sev")
  
  
  data_list <- df %>% 
    mutate(date_time.2 = dmy_hms(date_time),
           .before = "label") %>% 
    filter(label %in% case_summary) %>% 
    select(c("label", "current_value", "date_time.2")) %>% 
    pivot_wider(names_from = "label",
                values_from = "current_value") %>% 
    clean_names() %>% 
    mutate(case_duration.2 = lubridate::hm(case_duration)) %>% 
    mutate(case_duration_min = as.period(case_duration.2, unit = "minutes")) %>% 
    filter(case_duration_min$minute > 30) %>% 
    mutate_if(is.character, as.numeric) 
  
  data_list$case_duration_min <- as.numeric(data_list$case_duration_min$minute)
  

  return(data_list)
  
}


basic_calculations <- function(df) {
  
  df <- df %>% 
    mutate(consumption_n2o = ifelse(is.na(consumption_n2o), 0, consumption_n2o),
           consumption_air = ifelse(is.na(consumption_air), 0, consumption_air),
           consumption_sevo = ifelse(is.na(consumption_sev), 0, consumption_sev)
           ) %>% 
    mutate(total_consumption = consumption_o2 + consumption_air) %>% 
    mutate(FGF = total_consumption/case_duration_min) %>% 
    mutate(TIVA = ifelse(is.na(consumption_sev), TRUE, FALSE)) %>% 
    mutate(sevo_efficiency = uptake_sev/consumption_sev) %>% 
    mutate(year_m = cut(date_time_2, breaks = "month")) %>% 
    mutate(year_m = ymd(year_m)) %>% 
    mutate(sevo_co2e = consumption_sev/1000*1.522*130,
           sevo_co2t = sevo_co2e/1000,
           n2o_co2e = consumption_n2o*0.00183*298) %>% 
    mutate(mean_FGF = mean(FGF, na.rm = T))
  
  return(df)
  
}

# Tring to use Nick's functions on flows:










# Separating the list for the app in various forms ------------------------


extract_df_from_list <- function(list_of_dfs, envir = .GlobalEnv) {
  
  for (i in 1:length(list_of_dfs)) {
    assign(names(list_of_dfs[i]),
           list_of_dfs[[i]],
           envir = envir)
    
  }
}



writeRDA_list <- function(list_of_dfs, envir = .GlobalEnv){
  
  for (i in 1:length(list_of_dfs)) {
    assign(names(list_of_dfs[i]),
           write_rds(list_of_dfs[[i]], 
                     file = paste0(names(list_of_dfs[i]), ".RDA")
                     ),
           envir = envir)
  
  }
}


