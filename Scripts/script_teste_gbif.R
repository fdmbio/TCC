#Felipe Dias Mello - Script V.1 - 30/04/2021
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

user <- "felipedm_" # your gbif.org username
pwd <- "biologi@13" # your gbif.org password
email <- "fdiasmello.bio@gmail.com" # your email

#############################################################################
oc <- read.csv("./Dados/spp_lista.csv", sep = ',')
names(oc)

gbif_taxon_keys <-
  read.csv("./Dados/spp_lista.csv", sep = ',') %>% #For an file with a list of spp names
  pull(ï..spp) %>% #Specify the column from the list
  taxize::get_gbifid_(method="backbone") %>% # match names to the GBIF backbone to get taxonkeys
  imap(~ .x %>% mutate(original_sciname = .y)) %>% # add original name back into data.frame
  bind_rows() %T>% # combine all data.frames into one
  readr::write_tsv(file = "all_matches.tsv") %>% # save as side effect for you to inspect if you want
  filter(matchtype == "EXACT" & status == "ACCEPTED") %>% # get only accepted and matched names
  filter(kingdom == "animals") %>% # remove anything that might have matched to a non-plant
  pull(usagekey) # get the gbif taxonkeys

# gbif_taxon_keys should be a long vector like this c(2977832,2977901,2977966,2977835,2977863)
# !!very important here to use pred_in!!


# use matched gbif_taxon_keys from above
ocorr<- occ_download(
  pred_in("taxonKey", gbif_taxon_keys),
  pred_in("basisOfRecord", c('PRESERVED_SPECIMEN')),
  #pred("geometry","POLYGON((-43.86 -17.57, -43.88 -21.49, -39.79 -19.86, -39.46 -17.98, -43.86
  #     -17.57))"),
  pred("country", "BR"),
  #pred("continent", "South America"),
  pred("hasCoordinate", TRUE),
  pred("hasGeospatialIssue", FALSE),
  pred_gte("year", 2000),
  format = "SIMPLE_CSV",
  user=user,pwd=pwd,email=email
)

#Tentativa 2 (alternativa)

records_list <- list()
spp2 <- as.character(unique(oc$ï..spp))
for (i in 1:length(spp2)) {
  records_list[[i]] <- occ_search(scientificName = spp2[[i]])
}
oc$ï..spp

occ_search(
  taxonKey = NULL,
  scientificName = NULL)


#Escrever a lista
############## Bind Rows 

lista2 <- bind_rows(records_list)

############### Write table

write.csv(lista2, "final_2.csv", row.names = FALSE)

#Tentativa Final

gbif_taxon_keys <- 
  read.csv("./Dados/spp_lista.csv") %>% 
  pull("ï..spp") %>% # use fewer names if you want to just test 
  taxize::get_gbifid_(method="backbone") %>% # match names to the GBIF backbone to get taxonkeys
  imap(~ .x %>% mutate(original_sciname = .y)) %>% # add original name back into data.frame
  bind_rows() %T>% # combine all data.frames into one
  readr::write_tsv(file = "all_matches.tsv") %>% # save as side effect for you to inspect if you want
  filter(matchtype == "EXACT" & status == "ACCEPTED") %>% # get only accepted and matched names
  pull(usagekey) # get the gbif taxonkeys

ocorr<- occ_download(
  pred_in("taxonKey", gbif_taxon_keys),
  pred_in("basisOfRecord", c('PRESERVED_SPECIMEN')),
  #pred("geometry","POLYGON((-43.86 -17.57, -43.88 -21.49, -39.79 -19.86, -39.46 -17.98, -43.86
  #     -17.57))"),
  pred("country", "BR"),
  #pred("continent", "South America"),
  pred("hasCoordinate", TRUE),
  pred("hasGeospatialIssue", FALSE),
  pred_gte("year", 2000),
  format = "SIMPLE_CSV",
  user=user,pwd=pwd,email=email
)
 

#BOAAA

