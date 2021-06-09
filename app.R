library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(knitr)
library(kableExtra)

Th2 <- readRDS("Th2.RDA")
Th2_gas <- readRDS("Th2_gas.RDA")
Th2_case_summary <- readRDS("Th2_case_summary.RDA")
Th2_monthly <- readRDS("Th2_monthly.RDA")

period_of_records <- paste(min(as.Date(Th2_monthly$date_time_2)), "to", max(as.Date(Th2_monthly$date_time_2)))

ui <- dashboardPage(
  
  dashboardHeader(
    
    title = "Volatile Dashboard"
    
  ),
  
  dashboardSidebar(
    
    sidebarMenu(
      
      menuItem("Introduction",
               tabName = "intro",
               icon = icon("book-open")
               ),
      
      menuItem("Theatre 1",
               tabName = "Th01",
               icon = icon("industry")
      ),
      
      menuItem("Theatre 2",
               tabName = "Th02",
               icon = icon("industry")
      ),
      
      menuItem("Theatre 3",
                 tabName = "Th03",
                 icon = icon("industry")
      ),
      
      menuItem("Theatre 4",
                 tabName = "Th04",
                 icon = icon("industry")
      ),
      
      menuItem("Theatre 5",
                 tabName = "Th05",
                 icon = icon("industry")
      ),
      
      menuItem("Theatre 6",
                 tabName = "Th06",
                 icon = icon("industry")
      ),
      
      menuItem("Theatre 7",
                 tabName = "Th07",
                 icon = icon("industry")
      ),
      
      menuItem("Theatre 8",
                 tabName = "Th08",
                 icon = icon("industry")
      ),
      
      
      menuItem("Theatre 9",
               tabName = "Th09",
               icon = icon("industry")
               ),
      
      menuItem("Theatre 10",
               tabName = "Th10",
               icon = icon("industry")
      )
      
    )
    
    
  ), #/sidebar
  
  dashboardBody(
    
    tags$style("@import url(https://use.fontawesome.com/releases/v5.15.2/css/all.css);"), # to use the latest fontawesome icons
    
    tabItems(
      tabItem(tabName = "intro",
              
              h2("Introduction"),
              
              p("This dashboard displays the data extracted from each anaesthetic machine in the corresponding theatres"),
              
              p("The data do not include anaesthetic machines in the anaesthetic rooms"),
              
              p("Please note that due to inconsistency of the data, cases of duration less than 30 minutes were discarded")
              
              ),
      
      
      tabItem(tabName = "Th02",
              h3("Theatre 2 Perseus A500"),
              
              textOutput("period"),
              
              fluidRow(
                
                box(title = "Total Consumption",
                    collapsible = T,
                    solidHeader = T,
                    status = "success",
                    width = 4,
                    
                    fluidRow(
                      infoBoxOutput("th2Sevo",
                                    width = 6),
                      
                      infoBoxOutput("th2n2o",
                                    width = 6)
                    ),
                    
                    fluidRow(
                      infoBoxOutput("th2O2",
                                    width = 6),
                      
                      infoBoxOutput("th2air",
                                    width = 6)
                    )
                    
                    
                    ),
                
                box(title = "Fresh Gas Flow",
                    collapsible = T,
                    solidHeader = T,
                    status = "success",
                    width = 4,
                    
                    fluidRow(
                      infoBoxOutput("th2FGF_nonTIVA", 
                                    width = 6),
                      
                      infoBoxOutput("th2FGF_TIVA", 
                                    width = 6),
                    )
                  
                    
                    ),
                
                
                
                ),
              
              fluidRow(
                
                box(title = "Carbon Dioxide Equivalents over Entire Period",
                    collapsible = T,
                    solidHeader = T,
                    status = "danger",
                    width = 6,
                    
                    fluidRow(
                      valueBoxOutput("th2SevoCO2", 
                                     width = 6),
                      
                      valueBoxOutput("th2N2OCO2",
                                     width = 6)
                      
                      
                    )
                    
                ),
                
                box(title = "Overall Sevo Efficiency",
                    collapsible = T,
                    solidHeader = T,
                    status = "warning",
                    width = 3,
                    
                    fluidRow(
                      valueBoxOutput("th2efficiency", 
                                     width = 6)
                      
                      
                    )
                    ),
                
              ),
              
              fluidRow(
                
                box(title = "Monthly Consumption per case",
                    collapsible = T,
                    solidHeader = T,
                    width = 6,
                    status = "info",
                    
                    plotOutput("th2_monthly_cons")
                    
                    ),
                
                box(title = "Monthly CO2 Equivalents per case",
                    collapsible = T,
                    solidHeader = T,
                    width = 6,
                    status = "info",
                    
                    plotOutput("th2_monthly_co2e")
                    
                ),
                
                box(title = "Monthly FGF",
                    collapsible = T,
                    solidHeader = T,
                    width = 6,
                    status = "info",
                    
                    plotOutput("th2_monthly_FGF")
                    
                )
                
              )
              )
    )
  ) #/Body
  
  
  
) #/dashboardPage





server <- function(input, output){
  
  output$period <- renderText({
    
    period_of_records
    
  })
  
  output$th2Sevo <- renderInfoBox({
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th2_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th2n2o <-  renderInfoBox({
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th2_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th2O2 <-  renderInfoBox({
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th2_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th2air <-  renderInfoBox({
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th2_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th2FGF_nonTIVA <- renderInfoBox({
    
    mean_Th2 <- Th2_case_summary %>% 
      filter(TIVA == FALSE) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T))
     
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th2[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
    })
  
  output$th2FGF_TIVA <- renderInfoBox({
    
    mean_Th2 <- Th2_case_summary %>% 
      filter(TIVA == TRUE) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T))
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th2[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
    })
  
  output$th2SevoCO2 <- renderValueBox({
    
    valueBox(
      value = paste("Sevo", round(sum(Th2_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th2efficiency <- renderValueBox({
    
    valueBox(
      value = round(mean(Th2_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th2N2OCO2 <- renderValueBox({
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th2_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th2_monthly_cons <- renderPlot({
    
    Th2_case_summary %>% 
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
           y = "Average Consumption (mL per Case Sevo; L per case N2O)") +
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
  
  output$th2_monthly_co2e <- renderPlot({
    
    Th2_case_summary %>% 
      mutate(sevo_co2e = ifelse(is.na(sevo_co2e), 0, sevo_co2e),
             n2o_co2e = ifelse(is.na(n2o_co2e), 0, n2o_co2e)) %>% 
      group_by(year_m) %>% 
      summarise(mean_sevo = mean(sevo_co2e, na.rm = T),
                mean_n20 = mean(n2o_co2e, na.rm = T)) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = mean_sevo, colour = "Sevo"), size = 2) +
      geom_line(aes(y = mean_n20, colour = "Nitrous"), size = 2) +
      labs(x = "Time",
           y = "Average Carbon Dioxide Equivalents (Kg) per Case for  Sevo and N2O)") +
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
  
  output$th2_monthly_FGF <- renderPlot({
    
    Th2_case_summary %>% 
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
                         values = c('TRUE' = '#8ec07c','FALSE' = '#693a7c'),
                         labels = c("Volatile","TIVA")) +
      theme_minimal()
      
      
    
  })
  
}



# Run the application 
shinyApp(ui = ui, server = server)