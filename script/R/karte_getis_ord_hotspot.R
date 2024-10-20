library(sf)
library(tidyverse)
library(giscoR)
library(spdep)
library(dplyr)

# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/levenshtein_single_files")

words <- c("ameise", "begräbnis", "deichsel", "elster", "fledermaus", "gurke", "hagebutte", "hebamme", "kartoffel", "maulwurf", "pflaume", "stecknadel", "ziege", "zimmerfliege")

# Sprache
gisco_attributions(lang = "en")

# Karten Shapes für Länder um Deutschland herum
europe <- gisco_get_countries(country = c("France", "Switzerland", "Austria", "Luxembourg", "Belgium"), year = 2010, resolution = 1)
# Karten Shape Deutschland
germany <- gisco_get_countries(country = c("Germany"), year = 2010, resolution = 1)

for (word in words){
  # csv einlesen
  data <- read.csv(str_glue("{word}.csv"), sep = "\t", as.is=T)
  
  data_item <- data %>%
    filter(Levenshtein.Item.Min != "999")
  data_item$Item.cat <- ifelse(data_item$Levenshtein.Item.Min > 0, 1, 0)
  str(data_item)
  sf_data_item <- st_as_sf(data_item, coords = c("Longitude", "Latitude"), crs = 4326)
  # Berechnen der Nachbarschaft (k-nearest neighbors)
  nb_item <- knn2nb(knearneigh(st_coordinates(sf_data_item), k = 8))
  # Umwandlung in eine Gewichtungsmatrix
  lw_item <- nb2listw(nb_item, style = "W")
  # Berechnung des Getis-Ord Gi* Statistik
  gi_star_item_bool <- localG(sf_data_item$Item.cat, lw_item)
  gi_star_item_levenshtein <- localG(sf_data_item$z_score_item, lw_item)
  # Hinzufügen der Ergebnisse zu den ursprünglichen Daten
  sf_data_item$gi_star_item_bool <- as.numeric(gi_star_item_bool)
  sf_data_item$gi_star_item_levenshtein <- as.numeric(gi_star_item_levenshtein)
  
  data_phontype <- data %>%
    filter(Levenshtein.Phontype.Min != "999")
  data_phontype$Phontype.cat <- ifelse(data_phontype$Levenshtein.Phontype.Min > 0, 1, 0)
  str(data_phontype)
  sf_data_phontype <- st_as_sf(data_phontype, coords = c("Longitude", "Latitude"), crs = 4326)
  # Berechnen der Nachbarschaft (k-nearest neighbors)
  nb_phontype <- knn2nb(knearneigh(st_coordinates(sf_data_phontype), k = 8))
  # Umwandlung in eine Gewichtungsmatrix
  lw_phontype <- nb2listw(nb_phontype, style = "W")
  # Berechnung des Getis-Ord Gi* Statistik
  gi_star_phontype_bool <- localG(sf_data_phontype$Phontype.cat, lw_phontype)
  gi_star_phontype_levenshtein <- localG(sf_data_phontype$z_score_phontype, lw_phontype)
  # Hinzufügen der Ergebnisse zu den ursprünglichen Daten
  sf_data_phontype$gi_star_phontype_bool <- as.numeric(gi_star_phontype_bool)
  sf_data_phontype$gi_star_phontype_levenshtein <- as.numeric(gi_star_phontype_levenshtein)
  
  data_lextype <- data %>%
    filter(Levenshtein.Lextype.Min != "999")
  data_lextype$Lextype.cat <- ifelse(data_lextype$Levenshtein.Lextype.Min > 0, 1, 0)
  str(data_lextype)
  sf_data_lextype <- st_as_sf(data_lextype, coords = c("Longitude", "Latitude"), crs = 4326)
  # Berechnen der Nachbarschaft (k-nearest neighbors)
  nb_lextype <- knn2nb(knearneigh(st_coordinates(sf_data_lextype), k = 8))
  # Umwandlung in eine Gewichtungsmatrix
  lw_lextype <- nb2listw(nb_lextype, style = "W")
  # Berechnung des Getis-Ord Gi* Statistik
  gi_star_lextype_bool <- localG(sf_data_lextype$Lextype.cat, lw_lextype)
  gi_star_lextype_levenshtein <- localG(sf_data_lextype$z_score_lextype, lw_lextype)
  # Hinzufügen der Ergebnisse zu den ursprünglichen Daten
  sf_data_lextype$gi_star_lextype_bool <- as.numeric(gi_star_lextype_bool)
  sf_data_lextype$gi_star_lextype_levenshtein <- as.numeric(gi_star_lextype_levenshtein)
  
  # Lets have fun!
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_items_hotspot_bool/hotspot_{word}_item_bool.png"), width=1250, height = 1250)
  g <- ggplot(sf_data_item) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_sf(aes(color = gi_star_item_bool, size = 4)) +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    scale_color_steps2(low = "blue", mid = "white", high = "red", midpoint = 0, breaks = c(-1.96,0, 1.96)) +
    theme_bw() +
    labs(color = "G*i value") +
    scale_size(guide = "none") +
    ggtitle(label = str_glue("{word} item Übereinstimmung\nGetis-Ord Hotspot Analyse")) +
    theme(legend.position = "bottom", 
          legend.title = element_text(face = "bold", size = 30),
          axis.text = element_text(size = 20),
          legend.text = element_text(size = 20),
          legend.key.height = unit(1, "cm"),
          legend.key.width = unit(2, "cm"),
          plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  dev.off()
  
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_items_hotspot_levenshtein/hotspot_{word}_item_levenshtein.png"), width=1250, height = 1250)
  g <- ggplot(sf_data_item) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_sf(aes(color = gi_star_item_levenshtein, size = 4)) +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    scale_color_steps2(low = "blue", mid = "white", high = "red", midpoint = 0, breaks = c(-1.96,0, 1.96)) +
    theme_bw() +
    labs(color = "G*i value") +
    scale_size(guide = "none") +
    ggtitle(label = str_glue("{word} item Levenshtein Distanz\nGetis-Ord Hotspot Analyse")) +
    theme(legend.position = "bottom", 
          legend.title = element_text(face = "bold", size = 30),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          legend.key.height = unit(1, "cm"),
          legend.key.width = unit(2, "cm"),
          plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  dev.off()
  
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_phontypes_hotspot_bool/hotspot_{word}_phontype_bool.png"), width=1250, height = 1250)
  g <- ggplot(sf_data_phontype) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_sf(aes(color = gi_star_phontype_bool, size = 4)) +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    scale_color_steps2(low = "blue", mid = "white", high = "red", midpoint = 0, breaks = c(-1.96,0, 1.96)) +
    theme_bw() +
    labs(color = "G*i value") +
    scale_size(guide = "none") +
    ggtitle(label = str_glue("{word} phontype Übereinstimmung\nGetis-Ord Hotspot Analyse")) +
    theme(legend.position = "bottom", 
          legend.title = element_text(face = "bold", size = 30),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          legend.key.height = unit(1, "cm"),
          legend.key.width = unit(2, "cm"),
          plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  dev.off()
  
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_phontypes_hotspot_levenshtein/hotspot_{word}_phontype_levenshtein.png"), width=1250, height = 1250)
  g <- ggplot(sf_data_phontype) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_sf(aes(color = gi_star_phontype_levenshtein, size = 4)) +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    scale_color_steps2(low = "blue", mid = "white", high = "red", midpoint = 0, breaks = c(-1.96,0, 1.96)) +
    theme_bw() +
    labs(color = "G*i value") +
    scale_size(guide = "none") +
    ggtitle(label = str_glue("{word} phontype Levenshtein Distanz\nGetis-Ord Hotspot Analyse")) +
    theme(legend.position = "bottom", 
          legend.title = element_text(face = "bold", size = 30),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          legend.key.height = unit(1, "cm"),
          legend.key.width = unit(2, "cm"),
          plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  dev.off()
  
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_lextypes_hotspot_bool/hotspot_{word}_lextype_bool.png"), width=1250, height = 1250)
  g <- ggplot(sf_data_lextype) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_sf(aes(color = gi_star_lextype_bool, size = 4)) +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    scale_color_steps2(low = "blue", mid = "white", high = "red", midpoint = 0, breaks = c(-1.96,0, 1.96)) +
    theme_bw() +
    labs(color = "G*i value") +
    scale_size(guide = "none") +
    ggtitle(label = str_glue("{word} lextype Übereinstimmung\nGetis-Ord Hotspot Analyse")) +
    theme(legend.position = "bottom", 
          legend.title = element_text(face = "bold", size = 30),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          legend.key.height = unit(1, "cm"),
          legend.key.width = unit(2, "cm"),
          plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  dev.off()
  
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_lextypes_hotspot_levenshtein/hotspot_{word}_lextype_levenshtein.png"), width=1250, height = 1250)
  g <- ggplot(sf_data_lextype) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_sf(aes(color = gi_star_lextype_levenshtein, size = 4)) +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    scale_color_steps2(low = "blue", mid = "white", high = "red", midpoint = 0, breaks = c(-1.96,0, 1.96)) +
    theme_bw() +
    labs(color = "G*i value") +
    scale_size(guide = "none") +
    ggtitle(label = str_glue("{word} lextype Levenshtein Distanz\nGetis-Ord Hotspot Analyse")) +
    theme(legend.position = "bottom", 
          legend.title = element_text(face = "bold", size = 30),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          legend.key.height = unit(1, "cm"),
          legend.key.width = unit(2, "cm"),
          plot.title = element_text(hjust = 0.5, size = 40))
  print(g)
  dev.off()
}