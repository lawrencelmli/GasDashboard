output$th09Sevo <- renderInfoBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  infoBox(title = "Sevo Consumption",
          value = paste(sum(Th09_case_summary$consumption_sev, na.rm = T), "ml"),
          fill = T,
          color = "yellow")
  
})

output$th09n2o <-  renderInfoBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  infoBox(title = "N2O Consumption",
          value = paste(sum(Th09_case_summary$consumption_n2o, na.rm = T), "L"),
          fill = T,
          color = "blue")
  
})

output$th09O2 <-  renderInfoBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  infoBox(title = "Oxygen Consumption",
          value = paste(sum(Th09_case_summary$consumption_o2, na.rm = T), "L"),
          fill = T,
          color = "black")
})


output$th09air <-  renderInfoBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  infoBox(title = "Air Consumption",
          value = paste(sum(Th09_case_summary$consumption_air, na.rm = T), "L"),
          fill = F,
          color = "black")
})

output$th09FGF_nonTIVA <- renderInfoBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  mean_Th09 <- Th09_case_summary %>% 
    group_by(TIVA) %>% 
    mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
    filter(TIVA == FALSE)
  
  infoBox(title = "Mean FGF for Volatile Cases",
          value = paste(round(mean_Th09[1, "mean_FGF"],2), "L/min"),
          fill = T, 
          color = "navy")
})

output$th09FGF_TIVA <- renderInfoBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  mean_Th09 <- Th09_case_summary %>% 
    group_by(TIVA) %>% 
    mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
    filter(TIVA == TRUE)
  
  infoBox(title = "Mean FGF for TIVA Cases",
          value = paste(round(mean_Th09[1, "mean_FGF"],2), "L/min"),
          fill = T, 
          color = "navy")
})

output$th09SevoCO2 <- renderValueBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  valueBox(
    value = paste("Sevo", round(sum(Th09_case_summary$sevo_co2e, na.rm = T), 2)),
    subtitle = "Kg",
    icon = icon("industry"),
    color = "yellow"
  )
  
})

output$th09efficiency <- renderValueBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  valueBox(
    value = round(mean(Th09_case_summary$sevo_efficiency, na.rm = T), 2)*100,
    subtitle = "Sevo Efficiency",
    color = "yellow",
    icon = icon("percentage")
    
  )
  
})


output$th09N2OCO2 <- renderValueBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  valueBox(
    value = paste("Nitrous Oxide", round(sum(Th09_case_summary$n2o_co2e, na.rm = T), 2)),
    subtitle = "Kg",
    icon = icon("industry"),
    color = "blue"
  )
  
})

output$th09miles <- renderValueBox({
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2]) 
  
  valueBox(
    value = paste(round(sum(Th09_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
    subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
    icon = icon("car"),
    color = "red"
  )
  
  
})

output$th09sevocost <- renderValueBox({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2]) 
  
  valueBox(
    value = paste0("£", round(sum(Th09_case_summary$sevo_cost_per_case, na.rm = T), 2)),
    subtitle = "Cost of sevo over period",
    icon = icon("pound-sign"),
    color = "green"
  )
  
})

output$th09_monthly_cons <- renderPlot({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  Th09_case_summary %>% 
    filter(TIVA == F) %>% 
    mutate(consumption_sev = ifelse(is.na(consumption_sev), 0, consumption_sev),
           consumption_n2o = ifelse(is.na(consumption_n2o), 0, consumption_n2o)) %>% 
    group_by(year_m) %>% 
    summarise(mean_sevo = mean(consumption_sev, na.rm = T),
              mean_n20 = mean(consumption_n2o, na.rm = T)) %>% 
    ggplot(aes(x = year_m)) +
    geom_line(aes(y = mean_sevo, colour = "Sevo"), size = 2) +
    geom_line(aes(y = mean_n20, colour = "Nitrous"), size = 2) +
    labs(x = "Time",
         y = "Average Consumption per case (mL Sevo; L N2O)") +
    coord_cartesian(ylim = c(0, 30)) +
    theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
          plot.title = element_text(size = 16),
          axis.title = element_text(size = 14),
          axis.text = element_text(size = 12)) +
    scale_colour_manual(name = "Agent",
                        values = c("Sevo" = "#FABD2F",
                                   "Nitrous" = "#0095E6"),
                        labels = c("Nitrous", "Sevo")) +
    theme_minimal()
  
  
})

output$th09_monthly_co2e <- renderPlot({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  Th09_case_summary %>% 
    mutate(sevo_co2e = ifelse(is.na(sevo_co2e), 0, sevo_co2e),
           n2o_co2e = ifelse(is.na(n2o_co2e), 0, n2o_co2e)) %>% 
    group_by(year_m) %>% 
    summarise(mean_sevo = mean(sevo_co2e, na.rm = T),
              mean_n20 = mean(n2o_co2e, na.rm = T)) %>% 
    ggplot(aes(x = year_m)) +
    geom_line(aes(y = mean_sevo, colour = "Sevo"), size = 2) +
    geom_line(aes(y = mean_n20, colour = "Nitrous"), size = 2) +
    labs(x = "Time",
         y = "Average CCO2 Eq (Kg) per Case for Sevo and N2O)") +
    coord_cartesian(ylim = c(0, 10)) +
    theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
          plot.title = element_text(size = 16),
          axis.title = element_text(size = 14),
          axis.text = element_text(size = 12)) +
    scale_colour_manual(name = "Agent",
                        values = c("Sevo" = "#FABD2F",
                                   "Nitrous" = "#0095E6"),
                        labels = c("Nitrous", "Sevo")) +
    theme_minimal()
  
})

output$th09_monthly_FGF <- renderPlot({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2])
  
  Th09_case_summary %>% 
    group_by(year_m, TIVA) %>% 
    summarise(monthly_FGF = mean(FGF, na.rm = T)) %>% 
    ggplot(aes(x = year_m)) +
    geom_line(aes(y = monthly_FGF, color = TIVA), size = 2) +
    labs(x = "Time",
         y = "Average FGF (L/min)") +
    coord_cartesian(ylim = c(0, 10)) +
    theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
          plot.title = element_text(size = 16),
          axis.title = element_text(size = 14),
          axis.text = element_text(size = 12)) +
    scale_color_manual(name = "Anaesthetic Type",
                       values = c('TRUE' = '#8ec09c','FALSE' = '#693a7c'),
                       labels = c("Volatile","TIVA")) +
    theme_minimal()
  
  
  
})

output$th09_monthly_miles <- renderPlot({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2]) 
  
  Th09_case_summary %>% 
    group_by(year_m) %>% 
    summarise(monthly_miles = sum(miles_driven_per_case, na.rm = T)) %>% 
    ggplot(aes(x = year_m)) +
    geom_line(aes(y = monthly_miles), colour = "#393E3F", size = 2) +
    labs(x = "Time",
         y = "Monthly Total (Miles)") +
    coord_cartesian(ylim = c(0, 900)) +
    theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
          plot.title = element_text(size = 16),
          axis.title = element_text(size = 14),
          axis.text = element_text(size = 12)) +
    theme_minimal()
  
  
  
})

output$th09_monthly_sevo_cost <- renderPlot({
  
  Th09_case_summary <- Th09_case_summary %>% 
    filter(date_time_2 >= input$th09dates[1] & date_time_2 <= input$th09dates[2]) %>% 
    filter(TIVA == FALSE)
  
  Th09_case_summary %>% 
    group_by(year_m) %>% 
    summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
    ggplot(aes(x = year_m)) +
    geom_line(aes(y = monthly_cost), colour = "#40926d", size = 2) +
    labs(x = "Time",
         y = "Cost of Sevo per minute (p)") +
    coord_cartesian(ylim = c(0, 20)) +
    theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
          plot.title = element_text(size = 16),
          axis.title = element_text(size = 14),
          axis.text = element_text(size = 12)) +
    theme_minimal()
  
})