sheetNames <- excel_sheets("COVID-19+data+by+NHS+Board+20+June+2020.xlsx")

for (i in seq_along(sheetNames)) {
  
  sheetNumbers <- 1:length(sheetNames)
  
  assign(paste0("df", 1:length(sheetNumbers))[i], 
         read_excel("COVID-19+data+by+NHS+Board+20+June+2020.xlsx", 
                    sheet = sheetNames[i])) # this allows me to assign a distinct name for each sheet that I've read
  
}