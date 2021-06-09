library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(knitr)
library(kableExtra)
library(here)

Th02_case_summary <- Th02

ui <- dashboardPage(
  
  dashboardHeader(
    
    title = "Gas Use Dashboard"
    
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
              
              p("Please note that due to inconsistency of the data, cases of duration less than 30 minutes were discarded"),
              
              # strong(p("Acknowledgements:")),
              # 
              # p("Many thanks to Dr Cathy Lawson for providing the formulae for CO2 Eq calculations and tips for QIP; 
              #   and Dr Nick Lown for coding help.")
              # 
              ),
      
      
      tabItem(tabName = "Th02",
              h3("Theatre 2 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                
                box(title = "Date Range",
                    collapsible = T,
                    solidHeader = T,
                    status = "success",
                    width = 12,
                    
                    dateRangeInput("th02dates", 
                                   label = h3("Choosse Date Range:"),
                                   min = min(Th02_case_summary$date_time_2),
                                   max = max(Th02_case_summary$date_time_2),
                                   start = min(Th02_case_summary$date_time_2),
                                   end = max(Th02_case_summary$date_time_2)
                                   )
                    ), #/ box
                
                box(title = "Total Consumption",
                    collapsible = T,
                    solidHeader = T,
                    status = "success",
                    width = 12,
                    
                    fluidRow(
                      infoBoxOutput("th02Sevo",
                                    width = 6),
                      
                      infoBoxOutput("th02n2o",
                                    width = 6)
                      ),
                    
                    fluidRow(
                      infoBoxOutput("th02O2",
                                    width = 6),
                      
                      infoBoxOutput("th02air",
                                    width = 6)
                      )
                    ), #/ box
                
                box(title = "Fresh Gas Flow",
                    collapsible = T,
                    solidHeader = T,
                    status = "success",
                    width = 12,
                    
                    fluidRow(
                      infoBoxOutput("th02FGF_nonTIVA", 
                                    width = 6),
                      
                      infoBoxOutput("th02FGF_TIVA", 
                                    width = 6),
                    )
                    
                    
                  ), #/ box
                
                box(title = "Carbon Dioxide Equivalents over Entire Period",
                    collapsible = T,
                    solidHeader = T,
                    status = "success",
                    width = 12,
                    
                    fluidRow(
                      valueBoxOutput("th02SevoCO2", 
                                     width = 6),
                      
                      valueBoxOutput("th02N2OCO2",
                                     width = 6)
                      
                      
                    )
                    
                  ), #/ box
                
                box(title = "Overall Sevo Efficiency",
                    collapsible = T,
                    solidHeader = T,
                    status = "success",
                    width = 4,
                    
                    fluidRow(
                      valueBoxOutput("th02efficiency", 
                                     width = 12)
                    )
                ),
                
                box(title = "Miles Driven",
                    collapsible = T,
                    solidHeader = T, 
                    status = "success", 
                    width = 8,
                    
                    valueBoxOutput("th02miles", 
                                   width = 12)
                    ),
                
                box(title = "Sevo Expenditure",
                    collapsible = T,
                    solidHeader = T,
                    status = "success",
                    width = 8, 
                    
                    valueBoxOutput("th02sevocost",
                                   width = 12)
                    )
                
                ), #/ column
                
             
             column(width = 7, 
                
                box(title = "Monthly Consumption per case",
                    collapsible = T,
                    solidHeader = T,
                    width = 6,
                    status = "info",
                    
                    plotOutput("th02_monthly_cons")
                    
                    ),
                
                box(title = "Monthly CO2 Equivalents per case",
                    collapsible = T,
                    solidHeader = T,
                    width = 6,
                    status = "info",
                    
                    plotOutput("th02_monthly_co2e")
                    
                ),
                
                box(title = "Monthly FGF",
                    collapsible = T,
                    solidHeader = T,
                    width = 6,
                    status = "info",
                    
                    plotOutput("th02_monthly_FGF")
                    
                ),
                
                box(title = "Monthly Miles",
                    collapsible = T,
                    solidHeader = T,
                    width = 6,
                    status = "info",
                    
                    plotOutput("th02_monthly_miles")
                    
                ),
                
                box(title = "Cost of Sevo per minute",
                    collapsible = T,
                    solidHeader = T,
                    width = 6,
                    status = "info",
                    
                    plotOutput("th02_monthly_sevo_cost")
                    
                    ),
                
                
                
              ) #/ column
             
             ) #/ fluidRow
              )
    )
  ) #/Body
  
  
  
) #/dashboardPage





server <- function(input, output){
  
  
  
  # output$period <- renderText({
  #   
  #   period_of_records
  #   
  # })
  
  output$th02Sevo <- renderInfoBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th02_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th02n2o <-  renderInfoBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th02_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th02O2 <-  renderInfoBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th02_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th02air <-  renderInfoBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th02_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th02FGF_nonTIVA <- renderInfoBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    mean_Th02 <- Th02_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
     
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th02[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
    })
  
  output$th02FGF_TIVA <- renderInfoBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    mean_Th02 <- Th02_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th02[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
    })
  
  output$th02SevoCO2 <- renderValueBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th02_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th02efficiency <- renderValueBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    valueBox(
      value = round(mean(Th02_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th02N2OCO2 <- renderValueBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th02_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th02miles <- renderValueBox({
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th02_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th02sevocost <- renderValueBox({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th02_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th02_monthly_cons <- renderPlot({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    Th02_case_summary %>% 
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
  
  output$th02_monthly_co2e <- renderPlot({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    Th02_case_summary %>% 
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
  
  output$th02_monthly_FGF <- renderPlot({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2])
    
    Th02_case_summary %>% 
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
  
  output$th02_monthly_miles <- renderPlot({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th02_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_miles = sum(miles_driven_per_case, na.rm = T)) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_miles), colour = "#393E3F", size = 2) +
      labs(x = "Time",
           y = "Monthly Total (Miles)") +
      coord_cartesian(ylim = c(0, 750)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
    
    
  })
  
  output$th02_monthly_sevo_cost <- renderPlot({
    
    Th02_case_summary <- Th02_case_summary %>% 
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2]) 
    
    Th02_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 30)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
}



# Run the application 
shinyApp(ui = ui, server = server)