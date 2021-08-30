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
head(data) ; dim(data)


sp.list <- data %>% distinct(especies)
sp.list


API = ""
IUCN.list <- iucn_summary(sp.list$especies,distr_detail = TRUE, key = API)
IUCN.list