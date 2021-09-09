#REDLIST Assessment API
getwd()
install.packages("tidyverse")
restart
library(taxize)
library(tidyverse)
library(readxl)

tutorial <- "C:/Users/fdias/Documents/GitHub/TCC/Dados/sppocc.xlsx"
excel_sheets(tutorial)
data <- read_excel(tutorial,"Planilha1")
head(data)
spp <- data$spp %>% as.data.frame()

spp
#sp.list <- data%>% distinct(spp)
#sp.list


API = "390524daf1f1f1fcd7ab485fa7f73846ed7c04711f397968357f13383d18ad3e"
IUCN.list <- iucn_summary(data$spp,distr_detail = TRUE, key = API)


IUCN.list

iucn_status(IUCN.list) %>% as.data.frame()

status<-(
  iucn_status(IUCN.list) %>% as.data.frame() 
)
teste2
#teste2 <- cbind(Row.Names = rownames(teste2), teste2) 
#rownames(teste2) <- NULL 
#teste2
#write.csv(teste2, file = "iucnstatus.csv")

sppstatus <- cbind(spp,status) %>% set_names(c('especies','IUCN'))
sppstatus

write.csv(sppstatus, file = "iucnstatus.csv")
