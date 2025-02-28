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

new_list_of_files <- list.files(path = here("data", "2021_07_26"),
                                pattern = "\\.txt$",
                                full.names = TRUE) # enter new folder with date

# These are the basic elements of the function

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

new_data_import <- function(file_list) {
  
  df_names <- file_list %>% 
    map_chr(~ str_sub(.x, start = 103, end = 106))  
  
  data_list <- map(file_list, read.csv)
  
  # data_list <- map(data_list, clean_names)
  
  names(data_list) <- df_names
  
  return(data_list)
  
}



# Merging Data ------------------------------------------------------------

rbind_df <- function(old, new) {
  
  new <- new %>% 
    filter(!date_time_2 %in% old$date_time_2)
  
  merged_df <- rbind(old, new)
  
  return(merged_df)
  
}


# Sorting and Analying Data -----------------------------------------------


data_summarise <- function(df) {
  
  df <- clean_names(df)
  
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
    mutate(total_co2 = sevo_co2e + n2o_co2e) %>% 
    mutate(miles_driven_per_case = total_co2*1000/277 * 0.62137) %>% 
    mutate(sevo_cost_per_case = consumption_sevo*0.192) %>% 
    mutate(sevo_cost_per_case_min = sevo_cost_per_case/case_duration_min)
  
  return(df)
  
}


monthly_summary <- function(df) {
  
  df_monthly <- df %>% 
    group_by(year_m, TIVA) %>% 
    mutate(monthly_minutes = sum(case_duration_min, na.rm = T)) %>% 
    mutate(monthly_sevo_co2e = consumption_sev/1000*1.522*130,
           monthly_sevo_co2t = sevo_co2e/1000,
           monthly_n2o_co2e = consumption_n2o*0.00183*298) %>% 
    mutate(monthly_mean_FGF = mean(FGF, na.rm = T)) %>% 
    mutate(sevo_co2e_per_min = monthly_sevo_co2e/monthly_minutes,
           n2o_co2e_per_min = monthly_n2o_co2e/monthly_minutes)
  
  return(df_monthly)
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

new_extract_df_from_list <- function(list_of_dfs, envir = .GlobalEnv) {
  
  for (i in 1:length(list_of_dfs)) {
    paste0("new_", assign(names(list_of_dfs[i]),
           list_of_dfs[[i]],
           envir = envir))
    
  }
}



writeRDA_summaries <- function(list_of_dfs, envir = .GlobalEnv){
  
  for (i in 1:length(list_of_dfs)) {
    assign(names(list_of_dfs[i]),
           write_rds(list_of_dfs[[i]], 
                     file = paste0(names(list_of_dfs[i]), "_case_summary.RDA")
                     ),
           envir = envir)
  
  }
}



