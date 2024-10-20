library(ape)
library(tidyverse)
library(stringr)

# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/levenshtein_single_files")

words <- c("ameise", "begräbnis", "deichsel", "elster", "fledermaus", "gurke", "hagebutte", "hebamme", "kartoffel", "maulwurf", "pflaume", "stecknadel", "ziege", "zimmerfliege")

# csv einlesen
for (word in words){
  df <- read.csv(str_glue("{word}.csv"), sep = "\t")
  
  item <- df %>%
    filter(Levenshtein.Item.Min != "999")
  item$Item.cat <- ifelse(item$Levenshtein.Item.Min > 0, 1, 0)
  
  item.dists <- as.matrix(dist(cbind(item$Longitude, item$Latitude)))
  item.dists.inv <- 1/item.dists
  diag(item.dists.inv) <- 0
  
  moran_item <- Moran.I(item$Item.cat, item.dists.inv)
  print(moran_item)
  cat(str_glue("\n\n{word} item\n
               observed\t{moran_item$observed}\n
               expected\t{moran_item$expected}\n
               sd\t{moran_item$sd}\n
               p.value\t{moran_item$p.value}\n"), file = "//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/doku/meta/morans_I.txt", append=TRUE)
  #lapply(moran_item, write, "//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/doku/meta/morans_I.txt", append=TRUE)

  
  phontype <- df %>%
    filter(Levenshtein.Phontype.Min != "999")
  phontype$Phontype.cat <- ifelse(phontype$Levenshtein.Phontype.Min > 0, 1, 0)
  
  phontype.dists <- as.matrix(dist(cbind(phontype$Longitude, phontype$Latitude)))
  phontype.dists.inv <- 1/phontype.dists
  diag(phontype.dists.inv) <- 0
  
  moran_phon <- Moran.I(phontype$Phontype.cat, phontype.dists.inv)
  cat(str_glue("\n\n{word} phontype\n
               observed\t{moran_phon$observed}\n
               expected\t{moran_phon$expected}\n
               sd\t{moran_phon$sd}\n
               p.value\t{moran_phon$p.value}\n"), file = "//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/doku/meta/morans_I.txt", append=TRUE)
  #lapply(moran_phon, write, "//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/doku/meta/morans_I.txt", append=TRUE)
  
  
  lextype <- df %>%
    filter(Levenshtein.Lextype.Min != "999")
  lextype$Lextype.cat <- ifelse(lextype$Levenshtein.Lextype.Min > 0, 1, 0)
  
  lextype.dists <- as.matrix(dist(cbind(lextype$Longitude, lextype$Latitude)))
  lextype.dists.inv <- 1/lextype.dists
  diag(lextype.dists.inv) <- 0
  
  moran_lex <- Moran.I(lextype$Lextype.cat, lextype.dists.inv)
  cat(str_glue("\n\n{word} lextype\n
               observed\t{moran_lex$observed}\n
               expected\t{moran_lex$expected}\n
               sd\t{moran_lex$sd}\n
               p.value\t{moran_lex$p.value}\n"), file = "//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/doku/meta/morans_I.txt", append=TRUE)
  #lapply(moran_lex, write, "//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/doku/meta/morans_I.txt", append=TRUE)
}