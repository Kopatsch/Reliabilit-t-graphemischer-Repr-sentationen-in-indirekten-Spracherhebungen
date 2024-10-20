# Bibliotheken laden
library(tidyverse)
library(gridExtra)
library(sf)
library(giscoR)
library(stringr)

# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/levenshtein_single_files")

words <- c("ameise", "begräbnis", "deichsel", "elster", "fledermaus", "gurke", "hagebutte", "hebamme", "kartoffel", "maulwurf", "pflaume", "stecknadel", "ziege", "zimmerfliege")

# Sprache
gisco_attributions(lang = "en")

# Karten Shapes für Länder um Deutschland herum
europe <- gisco_get_countries(country = c("France", "Switzerland", "Austria", "Luxembourg", "Belgium"), year = 2020, resolution = 1)
# Karten Shape Deutschland
germany <- gisco_get_countries(country = c("Germany"), year = 2020, resolution = 1)

for (word in words){
  # csv einlesen
  w <- read.csv(str_glue("{word}.csv"), sep = "\t")
  
  # ungültige Werte filtern
  item <- w %>%
    filter(Levenshtein.Item.Min != "999")
  item <- item %>%
    filter(z_score_item < 4)
  # True/False Werte
  item$Item.cat <- ifelse(item$Levenshtein.Item.Min > 0, "False", "True")
  
  phontype <- w %>%
    filter(Levenshtein.Phontype.Min != "999")
  phontype <- phontype %>%
    filter(z_score_phontype < 4)
  phontype$Phontype.cat <- ifelse(phontype$Levenshtein.Phontype.Min > 0, "False", "True")
  
  lextype <- w %>%
    filter(Levenshtein.Lextype.Min != "999")
  lextype <- lextype %>%
    filter(z_score_lextype < 4)
  lextype$Lextype.cat <- ifelse(lextype$Levenshtein.Lextype.Min > 0, "False", "True")
  
  
  ### Item
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_items_bool/{word}_item_bool.png"), width=1250, height = 1250)
  # Graphik: True/False Werte items
  g <-  ggplot(mapping = aes(col = Item.cat)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = item, x = item$Longitude, y = item$Latitude, size = 4) +
      scale_color_manual(values = c("True" = "palegreen", "False" = "red"), 
                         name = "Übereinstimmung\nTrue/False") + 
      theme_bw() +
      ggtitle(label = str_glue("{word} items Übereinstimmung")) +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 30),
            legend.text = element_text(size = 20),
            axis.text = element_text(size = 20),
            legend.key = element_rect(fill = "white", colour = "black"),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  # Graphikerstellung beenden
  dev.off()
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_items_levenshtein/{word}_item_levenshtein.png"), width=1250, height = 1250)
  # Graphik: Levenshtein Werte items
  g <-  ggplot(mapping = aes(col = z_score_item)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = item, x = item$Longitude, y = item$Latitude, size = 4) +
      scale_color_steps2(low = "blue", mid = "white",
                          high="red", space ="Lab",
                          name = "Levenshtein Distanz",
                          midpoint = 0, 
                          breaks = c(-1.96,0, 1.96)) +
      theme_bw() +
      ggtitle(label = str_glue("{word} items Levenshtein Distanz")) +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 30),
            legend.text = element_text(size = 20),
            axis.text = element_text(size = 20),
            legend.key.height = unit(1, "cm"),
            legend.key.width = unit(2, "cm"),
            plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  # Graphikerstellung beenden
  dev.off()
  
  
  
  ### Phontype
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_phontypes_bool/{word}_phontype_bool.png"), width=1250, height = 1250)
  g <-  ggplot(mapping = aes(col = Phontype.cat)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = phontype, x = phontype$Longitude, y = phontype$Latitude, size = 4) +
      scale_color_manual(values = c("True" = "palegreen", "False" = "red"), 
                         name = "Übereinstimmung\nTrue/False") + 
      theme_bw() +
      ggtitle(label = str_glue("{word} phontypes Übereinstimmung")) +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 30),
            legend.text = element_text(size = 20),
            legend.key = element_rect(fill = "white", colour = "black"),
            axis.text = element_text(size = 20),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  # Graphikerstellung beenden
  dev.off()
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_phontypes_levenshtein/{word}_phontype_levenshtein.png"), width=1250, height = 1250)
  g <-  ggplot(mapping = aes(col = z_score_phontype)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = phontype, x = phontype$Longitude, y = phontype$Latitude, size = 4) +
      scale_color_steps2(low = "blue", mid = "white",
                          high="red", space ="Lab",
                          name = "Levenshtein Distanz",
                          midpoint = 0, 
                          breaks = c(-1.96,0, 1.96)) +
      theme_bw() +
      ggtitle(label = str_glue("{word} phontypes Levenshtein Distanz")) +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 30),
            legend.text = element_text(size = 20),
            axis.text = element_text(size = 20),
            legend.key.height = unit(1, "cm"),
            legend.key.width = unit(2, "cm"),
            plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  # Graphikerstellung beenden
  dev.off()
  
  
  
  ### Lextype
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_lextypes_bool/{word}_lextype_bool.png"), width=1250, height = 1250)
  g <-  ggplot(mapping = aes(col = Lextype.cat)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = lextype, x = lextype$Longitude, y = lextype$Latitude, size = 4) +
      scale_color_manual(values = c("True" = "palegreen", "False" = "red"), 
                         name = "Übereinstimmung\nTrue/False") + 
      theme_bw() +
      ggtitle(label = str_glue("{word} lextypes Übereinstimmung")) +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 30),
            legend.text = element_text(size = 20),
            legend.key = element_rect(fill = "white", colour = "black"),
            axis.text = element_text(size = 20),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  # Graphikerstellung beenden
  dev.off()
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_lextypes_levenshtein/{word}_lextype_levenshtein.png"), width=1250, height = 1250)
  g <-  ggplot(mapping = aes(col = z_score_lextype)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = lextype, x = lextype$Longitude, y = lextype$Latitude, size = 4) +
      scale_color_steps2(low = "blue", mid = "white",
                          high="red", space ="Lab",
                          name = "Levenshtein Distanz",
                          midpoint = 0, 
                          breaks = c(-1.96,0, 1.96)) +
      theme_bw() +
      ggtitle(label = str_glue("{word} lextypes Levenshtein Distanz")) +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 30),
            legend.text = element_text(size = 20),
            axis.text = element_text(size = 20),
            legend.key.height = unit(1, "cm"),
            legend.key.width = unit(2, "cm"),
            plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  # Graphikerstellung beenden
  dev.off()
}