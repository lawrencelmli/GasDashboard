# drager data analysis- version 2


#library, funcs, wd-------

library(tidyverse)
library(lubridate)
library(patchwork)

setwd("C:\\Users\\User\\Desktop\\milf")

source("C:\\Users\\User\\Desktop\\milf\\code\\drager_functions.R")
#---------

# get data and create list---------- 
# see google drive code for the google drive equivalent

list_of_files <- list.files(path = "C:\\Users\\User\\Desktop\\milf\\initital data", recursive = TRUE,
                            pattern = "\\.txt$", 
                            full.names = TRUE)


logbook.list <- map(list_of_files, read.csv) # reads them into a list object

#-------------

# tidy up the individual dataframes then combine---------

logbook.list <- lapply(logbook.list, drager_trimmer) # cuts rubbish data from start and end of dataframe

logbook.list <- lapply(logbook.list, drager_sweeper) # cuts rubbish from between cases

logbook.list <- lapply(logbook.list, case_machine_id) # gives each case a unique ID - if machine for a brief period, next 'case' retains ID



logbook <- logbook.list %>% 
  reduce(rbind, make.row.names = TRUE) 

View(logbook)
  
rm(logbook.list)
rm(list_of_files)

#-----------------










# <<<<<<<<<<<<<will need date filter in here>>>>>>>>>>>>>>>>>>>>>

# create case summaries by case -  -----

# format and pivot
case_summary <- logbook %>% 
  select("date_time", "machine_case_id", "Label","Current.value") %>% 
  filter(Label %in% c("Case duration", "Consumption O2", 
                      "Consumption Air", "Consumption Des", "Consumption Sev", "Consumption N2O",  "Uptake Des", 
                      "Uptake Sev")) %>% 
  pivot_wider(names_from = Label, values_from = Current.value) %>% 
  mutate(across(all_of(c("Consumption O2", 
                         "Consumption Air", "Consumption Des", "Consumption Sev", "Consumption N2O","Uptake Des", 
                         "Uptake Sev")), as.numeric)) %>% 
  mutate(date_time = ymd_hms(date_time)) %>% 
  mutate(`Case duration` = as.duration(hm(`Case duration`)))

# combine cases that are split by turning the machine off half way through
case_summary <- summary_collapser(case_summary)

# remove short cases without volatile

case_summary <- case_summary %>% 
  filter(`Case duration` > 180 | 
           (!is.na(`Uptake Des`) |
           !is.na(`Uptake Sev`)))

case_summary <- case_summary %>% 
  rename(end_of_case = date_time) %>% 
  relocate(machine_case_id, .before = end_of_case)



View(case_summary)
  
  
  
#------------
# create FGF profiles ---------------

# subset data for FGF - vapor profile
fgf_profile <- logbook %>% 
    select("date_time", "machine_case_id", "Label", "Current.value", "Set.FG.flow..l.min.", "Set.Agent..Vol..", "Set.Agent.type") %>% 
    filter(Label %in% c("Start of therapy","Gas settings", "Vaporizer setting", "FG flow", "System state changed"))

# create fgf -vaporiser setting pairs with duration of each setting pair
fgf_profile <- fgf_vapor_intervaliser(fgf_profile)

View(fgf_profile)

#-------------------------------
# add derived values to case summaries ----------------



## add modal fresh gas flows to summary

fgf_modes <- fgf_modal_calculator(fgf_profile)


case_summary2 <- left_join(case_summary, fgf_modes) %>%
  arrange(desc(Set.FG.flow..l.min.), desc(fgf_total_times)) %>%
  rename(modal_FGF = Set.FG.flow..l.min., modal_FGF_total_duration = fgf_total_times, modal_agent = Set.Agent.type)

rm(fgf_modes)


## add co2 equiv to summary
# https://www.rcoa.ac.uk/sites/default/files/documents/2019-09/Bulletin82-Nov2013-Pages39-41.pdf
# https://www.boconline.co.uk/en/images/medical_nitrous_oxide_tcm410-55835.pdf

case_summary2 <- case_summary2 %>% 
  mutate(sevo_co2_equiv_kg = round(`Consumption Sev` *(49/250), digits = 2),
         des_co2_equiv_kg = round(`Consumption Des` * (886/240), digits = 2),
         n20_co2_equiv_kg = round((`Consumption N2O`/1800) * 34 * 298 , digits = 2 ))
  




View(case_summary2)

