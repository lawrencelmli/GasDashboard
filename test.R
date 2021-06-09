df <- data_list[[1]]

data_list <- df %>% 
  mutate(date_time.2 = dmy_hms(date_time)) %>% 
  filter(label %in% case_summary) %>% 
  select(c("label", "current_value", "date_time.2")) %>% 
  pivot_wider(names_from = "label",
              values_from = "current_value") %>% 
  clean_names() %>% 
  mutate(case_duration.2 = lubridate::hm(case_duration)) %>% 
  mutate(case_duration_min = as.period(case_duration.2, unit = "minutes")) %>% 
  filter(case_duration_min$minute > 30) %>% 
  mutate_if(is.character, as.numeric) %>% 
  
  data_list$case_duration_min <- as.numeric(data_list$case_duration_min$minute)
  
  distinct(df, label)
  
  
  
  
  data_list <- data_import(list_of_files)
  
  case_summaries <- map(data_list, data_summarise)
  
  case_summaries <- map(case_summaries, basic_calculations)
  
  
  data_list <- map(data_list, drager_trimmer)
  
  data_list <- map(data_list, drager_sweeper)
  
  data_list <- map(data_list, case_machine_id)

  
  fgf_profile <- data_list %>% 
    select("date_time", "machine_case_id", "Label", "Current.value", "Set.FG.flow..l.min.", "Set.Agent..Vol..", "Set.Agent.type") %>% 
    filter(Label %in% c("Start of therapy","Gas settings", "Vaporizer setting", "FG flow", "System state changed"))  

  
  fgf <- map(data_list, fgf_modal_calculator)

  
  lag(1:5)
  lead(1:5)
  
  x <- 1:5
  tibble(behind = lag(x), x, ahead = lead(x))  
  