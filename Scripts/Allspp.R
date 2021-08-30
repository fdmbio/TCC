#Felipe Dias Mello - Script V.2 - 28/07/2021
#Adaptado de https://github.com/Projeto-BHRD-INMA/MNE_BHRD/blob/master/R/1_download_gbif_occurrences.R

################################################################################
###                                                                          ###
###                TUTORIAL TO DOWNLOAD OCCURRENCES FROM GGBIF               ###
###                     USING A LIST OF KNOWN NAMES OF SPECIES               ###
###https://data-blog.gbif.org/post/downloading-long-species-lists-on-gbif/   ###
###                                                                          ###
###                Modified by Danielle Moreira                              ###
###                         03 set 2020                                      ###
###                                                                          ###
################################################################################


library(dplyr)
library(purrr)
library(readr)
library(magrittr) # for %T>% pipe
library(rgbif) # for occ_download
library(taxize) # for get_gbifid_

install.packages("remotes")
remotes::install_github("ropensci/taxize")
if(!require(pacman)) install.packages("pacman")
pacman::p_load(dplyr, purrr, readr, magrittr, rgbif)
library(taxize)

#The important part here is to use rgbif::occ_download with pred_in and to fill in your gbif credentials.

# fill in your gbif.org credentials. You need to create an account at gbif if you don't have it.

user <- "" # your gbif.org username
pwd <- "" # your gbif.org password
email <- "" # your email

############################################################################# APENAS TUTORIAL NAO USAR
oc <- read.csv("./Dados/spp_lista_ALL.csv", sep = ',')
names(oc)



#Todas as listas

#gbif_taxon_keys <- 
 # read.csv("./Dados/spp_lista_ALL.csv") %>% 
  #pull("ï..spp") %>% # use fewer names if you want to just test 
  #taxize::get_gbifid_(method="backbone") %>% # match names to the GBIF backbone to get taxonkeys
  #imap(~ .x %>% mutate(original_sciname = .y)) %>% # add original name back into data.frame
  #bind_rows() %T>% # combine all data.frames into one
  #readr::write_tsv(file = "allmatches2.tsv") %>% # save as side effect for you to inspect if you want
  #filter(matchtype == "EXACT" & status == "ACCEPTED") %>% # get only accepted and matched names
  #pull(usagekey) # get the gbif taxonkeys




ocorr<- occ_download(
  pred_in("taxonKey", 212),
  pred_in("basisOfRecord", c('PRESERVED_SPECIMEN','HUMAN_OBSERVATION','MACHINE_OBSERVATION','LITERATURE','OBSERVATION')),
  pred("geometry","POLYGON((-42.245 -22.248,-43.361 -22.248,-43.361 -23.027,-42.245 -23.027,-42.245 -22.248))"),
  #pred("country", "BR"),
  #pred("continent", "South America"),
  pred("hasCoordinate", TRUE),
  pred("hasGeospatialIssue", FALSE),
  pred_gte("year", 1980),
  format = "SIMPLE_CSV",
  user=user,pwd=pwd,email=email
)
