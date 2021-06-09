library(tidyverse)
library(lubridate)
library(readxl)
library(janitor)

Th2 <- read.csv(file = "data/Logbook A500 ASML-0062 2021-06-01 9_26_42 PerseusTh2.txt", sep = ",")

Th2 <- clean_names(Th2)

Th2 <- Th2 %>% 
  mutate(date_time.2 = dmy_hms(date_time))

distinct(Th2, label)

# gas <- c("Measurements", 
#              "Case duration", 
#              "Consumption 02", 
#              "Consumption Air", 
#              "Consumption Sev", 
#              "Uptake Sev")

case_summary <- c("Case duration", 
                  "Consumption O2", 
                  "Consumption Air", 
                  "Consumption N2O",
                  "Consumption Sev",
                  "Uptake Sev")

Th2_gas <- Th2 %>% 
  filter(label == "Measurements")

Th2_case_summary <- Th2 %>% 
  filter(label %in% case_summary) %>% 
  select(c("label", "current_value", "date_time.2"))


Th2_case_summary <- Th2_case_summary %>% 
  pivot_wider(names_from = "label",
              values_from = "current_value") %>% 
  clean_names() %>% 
  mutate(case_duration.2 = lubridate::hm(case_duration)) %>% 
  mutate(case_duration_min = as.period(case_duration.2, unit = "minutes")) %>% 
  filter(case_duration_min$minute > 30) %>% 
  mutate_if(is.character, as.numeric)

# write.csv(Th2_case_summary, file = "th2_case_summary.csv")

Th2_case_summary$case_duration_min <- as.numeric(Th2_case_summary$case_duration_min$minute)

Th2_case_summary <- Th2_case_summary %>% 
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

Th2_monthly <- Th2_case_summary %>% 
  group_by(year_m, TIVA) %>% 
  mutate(monthly_sevo_co2e = consumption_sev/1000*1.522*130,
         monthly_sevo_co2t = sevo_co2e/1000,
         monthly_n2o_co2e = consumption_n2o*0.00183*298) %>% 
  mutate(monthly_mean_FGF = mean(FGF, na.rm = T))

saveRDS(Th2, "Th2.RDA")
saveRDS(Th2_case_summary, "Th2_case_summary.RDA")
saveRDS(Th2_gas, "Th2_gas.RDA")
saveRDS(Th2_monthly, "Th2_monthly.RDA")


