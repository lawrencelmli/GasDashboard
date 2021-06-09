library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(knitr)
library(kableExtra)
library(here)

Th01_case_summary <- read_rds("Th01_case_summary.RDA")
Th02_case_summary <- read_rds("Th02_case_summary.RDA")
Th03_case_summary <- read_rds("Th03_case_summary.RDA")
Th04_case_summary <- read_rds("Th04_case_summary.RDA")
Th05_case_summary <- read_rds("Th05_case_summary.RDA")
Th06_case_summary <- read_rds("Th06_case_summary.RDA")
Th07_case_summary <- read_rds("Th07_case_summary.RDA")
Th08_case_summary <- read_rds("Th08_case_summary.RDA")
Th09_case_summary <- read_rds("Th09_case_summary.RDA")
Th10_case_summary <- read_rds("Th10_case_summary.RDA")

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
      
      tabItem(tabName = "Th01",
              h3("Th01 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th01dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th01_case_summary$date_time_2),
                                          max = max(Th01_case_summary$date_time_2),
                                          start = min(Th01_case_summary$date_time_2),
                                          end = max(Th01_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th01Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th01n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th01O2",
                                           width = 6),
                             
                             infoBoxOutput("th01air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th01FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th01FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th01SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th01N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th01efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th01miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th01sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th01_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th01_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th01_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th01_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th01_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      ), 
      
      
      
      tabItem(tabName = "Th02",
              h3("Th02 Perseus A500"),
              
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
              
            ),
      
      
      
      
      tabItem(tabName = "Th03",
              h3("Th03 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th03dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th03_case_summary$date_time_2),
                                          max = max(Th03_case_summary$date_time_2),
                                          start = min(Th03_case_summary$date_time_2),
                                          end = max(Th03_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th03Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th03n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th03O2",
                                           width = 6),
                             
                             infoBoxOutput("th03air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th03FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th03FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th03SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th03N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th03efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th03miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th03sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th03_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th03_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th03_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th03_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th03_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      ),
      
      
      
      
      tabItem(tabName = "Th04",
              h3("Th04 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th04dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th04_case_summary$date_time_2),
                                          max = max(Th04_case_summary$date_time_2),
                                          start = min(Th04_case_summary$date_time_2),
                                          end = max(Th04_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th04Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th04n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th04O2",
                                           width = 6),
                             
                             infoBoxOutput("th04air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th04FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th04FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th04SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th04N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th04efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th04miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th04sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th04_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th04_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th04_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th04_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th04_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      ),
      
      
      
      
      tabItem(tabName = "Th05",
              h3("Th05 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th05dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th05_case_summary$date_time_2),
                                          max = max(Th05_case_summary$date_time_2),
                                          start = min(Th05_case_summary$date_time_2),
                                          end = max(Th05_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th05Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th05n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th05O2",
                                           width = 6),
                             
                             infoBoxOutput("th05air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th05FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th05FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th05SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th05N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th05efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th05miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th05sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th05_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th05_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th05_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th05_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th05_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      ),
      
      
      
      
      tabItem(tabName = "Th06",
              h3("Th06 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th06dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th06_case_summary$date_time_2),
                                          max = max(Th06_case_summary$date_time_2),
                                          start = min(Th06_case_summary$date_time_2),
                                          end = max(Th06_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th06Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th06n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th06O2",
                                           width = 6),
                             
                             infoBoxOutput("th06air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th06FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th06FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th06SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th06N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th06efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th06miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th06sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th06_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th06_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th06_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th06_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th06_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      ),
      
      
      
      
      tabItem(tabName = "Th07",
              h3("Th07 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th07dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th07_case_summary$date_time_2),
                                          max = max(Th07_case_summary$date_time_2),
                                          start = min(Th07_case_summary$date_time_2),
                                          end = max(Th07_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th07Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th07n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th07O2",
                                           width = 6),
                             
                             infoBoxOutput("th07air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th07FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th07FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th07SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th07N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th07efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th07miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th07sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th07_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th07_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th07_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th07_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th07_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      ),
      
      
      
      
      tabItem(tabName = "Th08",
              h3("Th08 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th08dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th08_case_summary$date_time_2),
                                          max = max(Th08_case_summary$date_time_2),
                                          start = min(Th08_case_summary$date_time_2),
                                          end = max(Th08_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th08Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th08n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th08O2",
                                           width = 6),
                             
                             infoBoxOutput("th08air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th08FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th08FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th08SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th08N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th08efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th08miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th08sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th08_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th08_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th08_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th08_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th08_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      ),
      
      
      
      
      tabItem(tabName = "Th09",
              h3("Th09 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th09dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th09_case_summary$date_time_2),
                                          max = max(Th09_case_summary$date_time_2),
                                          start = min(Th09_case_summary$date_time_2),
                                          end = max(Th09_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th09Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th09n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th09O2",
                                           width = 6),
                             
                             infoBoxOutput("th09air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th09FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th09FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th09SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th09N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th09efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th09miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th09sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th09_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th09_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th09_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th09_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th09_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      ),
      
      
      
      
      tabItem(tabName = "Th10",
              h3("Th10 Perseus A500"),
              
              fluidRow(
                
                column(width = 5,
                       
                       box(title = "Date Range",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           dateRangeInput("th10dates", 
                                          label = h3("Choosse Date Range:"),
                                          min = min(Th10_case_summary$date_time_2),
                                          max = max(Th10_case_summary$date_time_2),
                                          start = min(Th10_case_summary$date_time_2),
                                          end = max(Th10_case_summary$date_time_2)
                           )
                       ), #/ box
                       
                       box(title = "Total Consumption",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th10Sevo",
                                           width = 6),
                             
                             infoBoxOutput("th10n2o",
                                           width = 6)
                           ),
                           
                           fluidRow(
                             infoBoxOutput("th10O2",
                                           width = 6),
                             
                             infoBoxOutput("th10air",
                                           width = 6)
                           )
                       ), #/ box
                       
                       box(title = "Fresh Gas Flow",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             infoBoxOutput("th10FGF_nonTIVA", 
                                           width = 6),
                             
                             infoBoxOutput("th10FGF_TIVA", 
                                           width = 6),
                           )
                           
                           
                       ), #/ box
                       
                       box(title = "Carbon Dioxide Equivalents over Entire Period",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 12,
                           
                           fluidRow(
                             valueBoxOutput("th10SevoCO2", 
                                            width = 6),
                             
                             valueBoxOutput("th10N2OCO2",
                                            width = 6)
                             
                             
                           )
                           
                       ), #/ box
                       
                       box(title = "Overall Sevo Efficiency",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 4,
                           
                           fluidRow(
                             valueBoxOutput("th10efficiency", 
                                            width = 12)
                           )
                       ),
                       
                       box(title = "Miles Driven",
                           collapsible = T,
                           solidHeader = T, 
                           status = "success", 
                           width = 8,
                           
                           valueBoxOutput("th10miles", 
                                          width = 12)
                       ),
                       
                       box(title = "Sevo Expenditure",
                           collapsible = T,
                           solidHeader = T,
                           status = "success",
                           width = 8, 
                           
                           valueBoxOutput("th10sevocost",
                                          width = 12)
                       )
                       
                ), #/ column
                
                
                column(width = 7, 
                       
                       box(title = "Monthly Consumption per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th10_monthly_cons")
                           
                       ),
                       
                       box(title = "Monthly CO2 Equivalents per case",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th10_monthly_co2e")
                           
                       ),
                       
                       box(title = "Monthly FGF",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th10_monthly_FGF")
                           
                       ),
                       
                       box(title = "Monthly Miles",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th10_monthly_miles")
                           
                       ),
                       
                       box(title = "Cost of Sevo per minute",
                           collapsible = T,
                           solidHeader = T,
                           width = 6,
                           status = "info",
                           
                           plotOutput("th10_monthly_sevo_cost")
                           
                       ),
                       
                       
                       
                ) #/ column
                
              ) #/ fluidRow
              
      )
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
    )#/ TabItems
  ) #/Body
  
  
  
) #/dashboardPage





server <- function(input, output){
  
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
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2]) 
    
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
      filter(date_time_2 >= input$th02dates[1] & date_time_2 <= input$th02dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th02_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
  
  
  output$th01Sevo <- renderInfoBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th01_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th01n2o <-  renderInfoBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th01_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th01O2 <-  renderInfoBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th01_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th01air <-  renderInfoBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th01_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th01FGF_nonTIVA <- renderInfoBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    mean_Th01 <- Th01_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
    
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th01[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th01FGF_TIVA <- renderInfoBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    mean_Th01 <- Th01_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th01[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th01SevoCO2 <- renderValueBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th01_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th01efficiency <- renderValueBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    valueBox(
      value = round(mean(Th01_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th01N2OCO2 <- renderValueBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th01_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th01miles <- renderValueBox({
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th01_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th01sevocost <- renderValueBox({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th01_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th01_monthly_cons <- renderPlot({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    Th01_case_summary %>% 
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
  
  output$th01_monthly_co2e <- renderPlot({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    Th01_case_summary %>% 
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
  
  output$th01_monthly_FGF <- renderPlot({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2])
    
    Th01_case_summary %>% 
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
  
  output$th01_monthly_miles <- renderPlot({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2]) 
    
    Th01_case_summary %>% 
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
  
  output$th01_monthly_sevo_cost <- renderPlot({
    
    Th01_case_summary <- Th01_case_summary %>% 
      filter(date_time_2 >= input$th01dates[1] & date_time_2 <= input$th01dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th01_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
  
  
  output$th03Sevo <- renderInfoBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th03_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th03n2o <-  renderInfoBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th03_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th03O2 <-  renderInfoBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th03_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th03air <-  renderInfoBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th03_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th03FGF_nonTIVA <- renderInfoBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    mean_Th03 <- Th03_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
    
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th03[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th03FGF_TIVA <- renderInfoBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    mean_Th03 <- Th03_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th03[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th03SevoCO2 <- renderValueBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th03_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th03efficiency <- renderValueBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    valueBox(
      value = round(mean(Th03_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th03N2OCO2 <- renderValueBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th03_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th03miles <- renderValueBox({
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th03_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th03sevocost <- renderValueBox({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th03_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th03_monthly_cons <- renderPlot({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    Th03_case_summary %>% 
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
  
  output$th03_monthly_co2e <- renderPlot({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    Th03_case_summary %>% 
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
  
  output$th03_monthly_FGF <- renderPlot({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2])
    
    Th03_case_summary %>% 
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
  
  output$th03_monthly_miles <- renderPlot({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2]) 
    
    Th03_case_summary %>% 
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
  
  output$th03_monthly_sevo_cost <- renderPlot({
    
    Th03_case_summary <- Th03_case_summary %>% 
      filter(date_time_2 >= input$th03dates[1] & date_time_2 <= input$th03dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th03_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
  
  
  output$th04Sevo <- renderInfoBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th04_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th04n2o <-  renderInfoBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th04_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th04O2 <-  renderInfoBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th04_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th04air <-  renderInfoBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th04_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th04FGF_nonTIVA <- renderInfoBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    mean_Th04 <- Th04_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
    
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th04[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th04FGF_TIVA <- renderInfoBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    mean_Th04 <- Th04_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th04[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th04SevoCO2 <- renderValueBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th04_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th04efficiency <- renderValueBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    valueBox(
      value = round(mean(Th04_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th04N2OCO2 <- renderValueBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th04_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th04miles <- renderValueBox({
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th04_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th04sevocost <- renderValueBox({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th04_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th04_monthly_cons <- renderPlot({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    Th04_case_summary %>% 
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
  
  output$th04_monthly_co2e <- renderPlot({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    Th04_case_summary %>% 
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
  
  output$th04_monthly_FGF <- renderPlot({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2])
    
    Th04_case_summary %>% 
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
  
  output$th04_monthly_miles <- renderPlot({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2]) 
    
    Th04_case_summary %>% 
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
  
  output$th04_monthly_sevo_cost <- renderPlot({
    
    Th04_case_summary <- Th04_case_summary %>% 
      filter(date_time_2 >= input$th04dates[1] & date_time_2 <= input$th04dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th04_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
  
  
  output$th05Sevo <- renderInfoBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th05_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th05n2o <-  renderInfoBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th05_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th05O2 <-  renderInfoBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th05_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th05air <-  renderInfoBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th05_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th05FGF_nonTIVA <- renderInfoBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    mean_Th05 <- Th05_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
    
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th05[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th05FGF_TIVA <- renderInfoBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    mean_Th05 <- Th05_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th05[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th05SevoCO2 <- renderValueBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th05_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th05efficiency <- renderValueBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    valueBox(
      value = round(mean(Th05_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th05N2OCO2 <- renderValueBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th05_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th05miles <- renderValueBox({
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th05_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th05sevocost <- renderValueBox({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th05_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th05_monthly_cons <- renderPlot({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    Th05_case_summary %>% 
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
  
  output$th05_monthly_co2e <- renderPlot({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    Th05_case_summary %>% 
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
  
  output$th05_monthly_FGF <- renderPlot({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2])
    
    Th05_case_summary %>% 
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
  
  output$th05_monthly_miles <- renderPlot({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2]) 
    
    Th05_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_miles = sum(miles_driven_per_case, na.rm = T)) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_miles), colour = "#393E3F", size = 2) +
      labs(x = "Time",
           y = "Monthly Total (Miles)") +
      coord_cartesian(ylim = c(0, 1000)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
    
    
  })
  
  output$th05_monthly_sevo_cost <- renderPlot({
    
    Th05_case_summary <- Th05_case_summary %>% 
      filter(date_time_2 >= input$th05dates[1] & date_time_2 <= input$th05dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th05_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
  
  
  output$th06Sevo <- renderInfoBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th06_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th06n2o <-  renderInfoBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th06_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th06O2 <-  renderInfoBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th06_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th06air <-  renderInfoBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th06_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th06FGF_nonTIVA <- renderInfoBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    mean_Th06 <- Th06_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
    
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th06[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th06FGF_TIVA <- renderInfoBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    mean_Th06 <- Th06_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th06[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th06SevoCO2 <- renderValueBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th06_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th06efficiency <- renderValueBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    valueBox(
      value = round(mean(Th06_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th06N2OCO2 <- renderValueBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th06_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th06miles <- renderValueBox({
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th06_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th06sevocost <- renderValueBox({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th06_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th06_monthly_cons <- renderPlot({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    Th06_case_summary %>% 
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
      coord_cartesian(ylim = c(0, 40)) +
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
  
  output$th06_monthly_co2e <- renderPlot({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    Th06_case_summary %>% 
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
  
  output$th06_monthly_FGF <- renderPlot({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2])
    
    Th06_case_summary %>% 
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
  
  output$th06_monthly_miles <- renderPlot({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2]) 
    
    Th06_case_summary %>% 
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
  
  output$th06_monthly_sevo_cost <- renderPlot({
    
    Th06_case_summary <- Th06_case_summary %>% 
      filter(date_time_2 >= input$th06dates[1] & date_time_2 <= input$th06dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th06_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
  
  
  output$th07Sevo <- renderInfoBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th07_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th07n2o <-  renderInfoBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th07_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th07O2 <-  renderInfoBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th07_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th07air <-  renderInfoBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th07_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th07FGF_nonTIVA <- renderInfoBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    mean_Th07 <- Th07_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
    
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th07[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th07FGF_TIVA <- renderInfoBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    mean_Th07 <- Th07_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th07[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th07SevoCO2 <- renderValueBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th07_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th07efficiency <- renderValueBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    valueBox(
      value = round(mean(Th07_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th07N2OCO2 <- renderValueBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th07_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th07miles <- renderValueBox({
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th07_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th07sevocost <- renderValueBox({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th07_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th07_monthly_cons <- renderPlot({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    Th07_case_summary %>% 
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
  
  output$th07_monthly_co2e <- renderPlot({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    Th07_case_summary %>% 
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
  
  output$th07_monthly_FGF <- renderPlot({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2])
    
    Th07_case_summary %>% 
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
  
  output$th07_monthly_miles <- renderPlot({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2]) 
    
    Th07_case_summary %>% 
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
  
  output$th07_monthly_sevo_cost <- renderPlot({
    
    Th07_case_summary <- Th07_case_summary %>% 
      filter(date_time_2 >= input$th07dates[1] & date_time_2 <= input$th07dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th07_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
  output$th08Sevo <- renderInfoBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th08_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th08n2o <-  renderInfoBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th08_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th08O2 <-  renderInfoBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th08_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th08air <-  renderInfoBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th08_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th08FGF_nonTIVA <- renderInfoBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    mean_Th08 <- Th08_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
    
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th08[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th08FGF_TIVA <- renderInfoBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    mean_Th08 <- Th08_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th08[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th08SevoCO2 <- renderValueBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th08_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th08efficiency <- renderValueBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    valueBox(
      value = round(mean(Th08_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th08N2OCO2 <- renderValueBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th08_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th08miles <- renderValueBox({
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th08_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th08sevocost <- renderValueBox({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th08_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th08_monthly_cons <- renderPlot({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    Th08_case_summary %>% 
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
  
  output$th08_monthly_co2e <- renderPlot({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    Th08_case_summary %>% 
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
  
  output$th08_monthly_FGF <- renderPlot({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2])
    
    Th08_case_summary %>% 
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
                         values = c('TRUE' = '#8ec08c','FALSE' = '#693a7c'),
                         labels = c("Volatile","TIVA")) +
      theme_minimal()
    
    
    
  })
  
  output$th08_monthly_miles <- renderPlot({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2]) 
    
    Th08_case_summary %>% 
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
  
  output$th08_monthly_sevo_cost <- renderPlot({
    
    Th08_case_summary <- Th08_case_summary %>% 
      filter(date_time_2 >= input$th08dates[1] & date_time_2 <= input$th08dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th08_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
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
      coord_cartesian(ylim = c(0, 1000)) +
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
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
  
  output$th10Sevo <- renderInfoBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    infoBox(title = "Sevo Consumption",
            value = paste(sum(Th10_case_summary$consumption_sev, na.rm = T), "ml"),
            fill = T,
            color = "yellow")
    
  })
  
  output$th10n2o <-  renderInfoBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    infoBox(title = "N2O Consumption",
            value = paste(sum(Th10_case_summary$consumption_n2o, na.rm = T), "L"),
            fill = T,
            color = "blue")
    
  })
  
  output$th10O2 <-  renderInfoBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    infoBox(title = "Oxygen Consumption",
            value = paste(sum(Th10_case_summary$consumption_o2, na.rm = T), "L"),
            fill = T,
            color = "black")
  })
  
  
  output$th10air <-  renderInfoBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    infoBox(title = "Air Consumption",
            value = paste(sum(Th10_case_summary$consumption_air, na.rm = T), "L"),
            fill = F,
            color = "black")
  })
  
  output$th10FGF_nonTIVA <- renderInfoBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    mean_Th10 <- Th10_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == FALSE)
    
    infoBox(title = "Mean FGF for Volatile Cases",
            value = paste(round(mean_Th10[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th10FGF_TIVA <- renderInfoBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    mean_Th10 <- Th10_case_summary %>% 
      group_by(TIVA) %>% 
      mutate(mean_FGF = mean(FGF, na.rm = T)) %>% 
      filter(TIVA == TRUE)
    
    infoBox(title = "Mean FGF for TIVA Cases",
            value = paste(round(mean_Th10[1, "mean_FGF"],2), "L/min"),
            fill = T, 
            color = "navy")
  })
  
  output$th10SevoCO2 <- renderValueBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    valueBox(
      value = paste("Sevo", round(sum(Th10_case_summary$sevo_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "yellow"
    )
    
  })
  
  output$th10efficiency <- renderValueBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    valueBox(
      value = round(mean(Th10_case_summary$sevo_efficiency, na.rm = T), 2)*100,
      subtitle = "Sevo Efficiency",
      color = "yellow",
      icon = icon("percentage")
      
    )
    
  })
  
  
  output$th10N2OCO2 <- renderValueBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    valueBox(
      value = paste("Nitrous Oxide", round(sum(Th10_case_summary$n2o_co2e, na.rm = T), 2)),
      subtitle = "Kg",
      icon = icon("industry"),
      color = "blue"
    )
    
  })
  
  output$th10miles <- renderValueBox({
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2]) 
    
    valueBox(
      value = paste(round(sum(Th10_case_summary$miles_driven_per_case, na.rm = T), 2), "miles"),
      subtitle = "based on Ford Focus 1.5L EcoBoost with 277 mg/km CO2 Emissions",
      icon = icon("car"),
      color = "red"
    )
    
    
  })
  
  output$th10sevocost <- renderValueBox({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2]) 
    
    valueBox(
      value = paste0("£", round(sum(Th10_case_summary$sevo_cost_per_case, na.rm = T), 2)),
      subtitle = "Cost of sevo over period",
      icon = icon("pound-sign"),
      color = "green"
    )
    
  })
  
  output$th10_monthly_cons <- renderPlot({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    Th10_case_summary %>% 
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
  
  output$th10_monthly_co2e <- renderPlot({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    Th10_case_summary %>% 
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
  
  output$th10_monthly_FGF <- renderPlot({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2])
    
    Th10_case_summary %>% 
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
  
  output$th10_monthly_miles <- renderPlot({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2]) 
    
    Th10_case_summary %>% 
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
  
  output$th10_monthly_sevo_cost <- renderPlot({
    
    Th10_case_summary <- Th10_case_summary %>% 
      filter(date_time_2 >= input$th10dates[1] & date_time_2 <= input$th10dates[2]) %>% 
      filter(TIVA == FALSE)
    
    Th10_case_summary %>% 
      group_by(year_m) %>% 
      summarise(monthly_cost = mean(sevo_cost_per_case_min, na.rm = T)*100) %>% 
      ggplot(aes(x = year_m)) +
      geom_line(aes(y = monthly_cost), colour = "#40826d", size = 2) +
      labs(x = "Time",
           y = "Cost of Sevo per minute (p)") +
      coord_cartesian(ylim = c(0, 20)) +
      theme(aspect.ratio = 0.4, plot.caption = element_text(size = 12, face = "italic"),
            plot.title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 12)) +
      theme_minimal()
    
  })
}



# Run the application 
shinyApp(ui = ui, server = server)