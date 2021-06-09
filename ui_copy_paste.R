


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


