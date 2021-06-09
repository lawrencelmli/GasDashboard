# drager analysis functions


### march 2021 functions#####################




# create function that trims off the start and ends of the dataframe - only data between and during cases present
drager_trimmer <- function(df){
  
  
  
  
  df <- df %>% 
    mutate(date_time = dmy_hms(Date...Time), 
           .keep = "unused",
           .before = "Label")
  
  first_case_start <-  min(
    subset(df,
           Label == "Start of therapy", 
           select = date_time)[[1]]) # identifies start of first case by some base-hot-shit
  
  last_case_start <- max(
    subset(df,
           Current.value == "Standby", 
           select = date_time)[[1]])
  
  df <- df %>% 
    filter(date_time >= first_case_start,
           date_time <= last_case_start)
  
  
  return(df)
  
}


# drager_sweeper - clears up data between cases
drager_sweeper <- function(df) {
  
  #df <- short_original
  
  start_times <- subset(df, Label == "Start of therapy",  select = date_time)[[1]]
  end_times <- subset(df, Current.value == "Standby" & Old.value == "Operation",select = date_time)[[1]]
  
  case_times <- bind_cols(start_times, end_times)
  case_times$intervals <- interval(case_times$...1, case_times$...2)
  
  df <- df %>% 
    rowwise() %>% 
    filter(any(date_time %within% case_times$intervals)) %>% 
    ungroup()
  
  
}


# drager_machine_case UID, creates UID for each machine in the analysis and numbers the cases
case_machine_id <-  function(df){
  
  #df <- head(my_example, n = 3000) # function plug
  
  ## generate uid for machine
  uid <- as.character(as.hexmode(round(runif(1, min = 1, max = 1000000),0)))
  df$machine_id <- uid
  
  
  ## generate uid for patient - nb when machine stopped mid case! 

  # ensure 'start of therapy' always comes first in block of date_times
  df$Label <- as_factor(df$Label)
  fct_relevel(df$Label, "Start of therapy")
  
  df <- df %>% 
    arrange(date_time,Label) 

  # identify start of new cases (logical) - when 'start of therapy' and more than 2 minutes from previous case
  df <- df %>% 
    mutate(inter_action_interval = as.duration(interval(
      lag(date_time), date_time)), .before = Label) %>% 
    mutate(new_case = Label == "Start of therapy" & (inter_action_interval > 120 | is.na(inter_action_interval)))
   
  # number the cases, create case UID, tidy up 
  df$case_id <- cumsum(df$new_case)

  df <- df %>% 
    mutate(machine_case_id = paste0(machine_id, "-", case_id), .before = Label) %>% 
    select(-inter_action_interval, -new_case, -machine_id, -case_id)
  
  return(df)
}


# drager summary collapser - aggregates cases with same ID into one summary
summary_collapser <- function(df) {
  
  #df <- case_summary
  
  df <- df %>% 
    group_by(machine_case_id) %>% 
    mutate(date_time = last(date_time),
           `Case duration` = sum(`Case duration`),
           `Consumption O2` = sum(`Consumption O2`),
           `Consumption Air` = sum(`Consumption Air`),
           `Consumption Des` = sum(`Consumption Des`),
           `Consumption Sev` = sum(`Consumption Sev`),
           `Uptake Des` = sum(`Uptake Des`),
           `Uptake Sev` = sum(`Uptake Sev`),
           `Consumption N2O` = sum(`Consumption N2O`)) %>% 
    mutate(`Case duration` = as.duration(`Case duration`)) %>% 
    distinct() %>% 
    ungroup()
  
  
  return(df)
  
}


#fgf - intervaliser - creates FGF - vaporiser setting pairs and duration of each setting pain
fgf_vapor_intervaliser <- function(df) {
  
  #df <- fgf_profile
  
  df <- df %>% 
    mutate(across(all_of(c("Set.FG.flow..l.min.", "Set.Agent..Vol..")), as.numeric))
  
  
  
  #id rows
  df <- df %>% 
    rowid_to_column() 
  
  ## take out midcase standbys
  # create list of rows that represent mid-case standbys
  end_of_case_row_id <- df %>% 
    filter(Current.value == "Standby")  %>% 
    group_by(machine_case_id) %>% 
    summarise(id = max(rowid)) %>% 
    ungroup() %>% 
    select(id)
  
  # filter out midcase standbys
  df <- df %>% 
    filter(Current.value != "Standby" |
             (Current.value == "Standby" & rowid %in% end_of_case_row_id$id)) %>% 
    select(-rowid)
  
  
  ## set stand-by fgf and vaporizer to zero
  
  df <- df %>% 
    mutate(`Set.FG.flow..l.min.` = case_when(
      Current.value ==  "Standby" ~ 0,
      TRUE ~ Set.FG.flow..l.min.
    )) %>% 
    mutate(Set.Agent..Vol.. = case_when(
      Current.value == "Standby" ~ 0,
      TRUE ~ Set.Agent..Vol..
    ))
  
  
  
  ## copy down missing values - remove duplicates
  
  
  df <- df %>% 
    mutate(Set.Agent.type = na_if(Set.Agent.type, "")) %>% #changes blank space to NA
    group_by(machine_case_id) %>% 
    fill(all_of(c("Set.FG.flow..l.min.", "Set.Agent..Vol..", "Set.Agent.type" ))) %>% 
    distinct(across(all_of(c("Set.FG.flow..l.min.", "Set.Agent..Vol..", "Set.Agent.type"))), .keep_all = TRUE)%>% 
    ungroup() 
  
  
  
  # add time intervals and tidy
  df <- df %>% 
    group_by(machine_case_id) %>% 
    mutate(duration = as.duration(interval(date_time, lead(date_time)))) %>% 
    ungroup() %>% 
    select(-Current.value)
  
  
  return(df)
  
  
}


## modal-FGF - the flow rate used most in the case - highest total number of minutes spent at that rate
fgf_modal_calculator <- function(df) {
  
  #df <- fgf_profile
  
  df <- df %>% 
    filter(Set.Agent..Vol.. > 0) %>% 
    group_by(machine_case_id, Set.FG.flow..l.min., Set.Agent.type) %>% 
    summarise(fgf_total_times = sum(duration)) %>% 
    ungroup()%>% 
    group_by(machine_case_id) %>% 
    slice_max(fgf_total_times) %>% 
    mutate(fgf_total_times = as.duration(fgf_total_times)) %>%
    ungroup()
  
  return (df)
  
}


# file_checker - pass in a file path - checks 
drager_upload_checker <- function(filepath){
  

  
  df <- read.csv(filepath, stringsAsFactors = FALSE)
  file_type <- case_when(str_detect(filepath, ".txt") ~ "filetypematch-",
                         TRUE ~ "bad filetype-")
  

  
  column_names <- case_when(identical(colnames(df), c("Date...Time", "Label", "Old.value", "Current.value", "Unit.of.value", 
                                           "etCO2..kPa.", "MV..l.min.", "Pmean..cmH2O.", "PIP..cmH2O.", 
                                           "PPlat..cmH2O.", "PEEP..cmH2O.", "FiO2..Vol..", "prim..Agent.exp..Vol..", 
                                           "prim..Agent.type", "N2O.exp..Vol..", "Set.FG.O2..Vol..", "Set.FG.flow..l.min.", 
                                           "Set.Carrier.gas", "Set.Vt..ml.", "Set.PEEP..cmH2O.", "Set.dPs..cmH2O.", 
                                           "Set.Pinsp..cmH2O.", "Set.Phigh..cmH2O.", "Set.Plow..cmH2O.", 
                                           "Set.Thigh..s.", "Set.Tlow..s.", "Set.RR..breaths.min.", "Set.RRmin..breaths.min.", 
                                           "Set.Agent..Vol..", "Set.Agent.type", "Procedure.Duration..s.", 
                                           "Set.SustInfPressure..cmH2O.", "Set.SustInfDuration..s.", "Set.IncPeepMaxPinsp..cmH2O.", 
                                           "Set.IncPeepMaxPeep..cmH2O.")) ~ "columnmatch-",
                              TRUE ~ "bad column vector-")


 
  row_count <- case_when(nrow(df) > 0 ~ "data present-",
                         TRUE ~ "empty dataset-")
  
  print(paste(file_type, column_names,  row_count))
  
  
  if(paste(file_type, column_names,  row_count) == "filetypematch- columnmatch- data present-") {return("pass")} else {return("fail")}
  
  

  
}


# file cases start /end date

drager_upload_start_end <- function(filepath){
  

 date_params <- data.frame(start = NA, end = NA) 
  
  df <- read.csv(filepath, stringsAsFactors = FALSE, na.strings = c("","NA"))
  
  date_params$start <- dmy_hms(df$Date...Time) %>% min(na.rm = TRUE)
  date_params$end <- dmy_hms(df$Date...Time) %>% max(na.rm = TRUE)
  
  return(date_params)
  
}

