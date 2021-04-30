#Teste inicial de uso do script
#Felipe Mello - 30/04/2021
library(devtools)
library(Rocc)


lista <- read_excel(file=file.choose())
lista=read.table(file=file.choose())
lista=read_excel("REGUA")
getwd()
setwd("C:/Users/fdias/Documents/R")
getwd()
rgbif2(dir = "results/", filename = "output", species = "Accipiter bicolor")
rgbif2(dir = "results/", filename = "output2", species = "spp", force = TRUE)
rgbif2(dir = "results/", filename = "output2", species = "REGUA", force = TRUE)
attach(REGUA)
detach(REGUA)
attach(spp)
View(spp)
View(REGUA)

spp=c(especies)
