# Bibliotheken laden
library(tidyverse)
library(gridExtra)
library(sf)
library(giscoR)
library(Polychrome)
library(ggrepel)
library(dplyr)
library(stringr)
library(spdep)
library(dplyr)
library(ggnewscale)

# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/levenshtein_single_files")

words <- c("Ameise", "Begräbnis", "Deichsel", "Elster", "Fledermaus", "Gurke", "Hagebutte", "Hebamme", "Kartoffel", "Maulwurf", "Pflaume", "Stecknadel", "Ziege", "Zimmerfliege")

# Sprache
gisco_attributions(lang = "en")

# Karten Shapes für Länder um Deutschland herum
europe <- gisco_get_countries(country = c("France", "Switzerland", "Austria", "Luxembourg", "Belgium"), year = 2020, resolution = 1)
# Karten Shape Deutschland
germany <- gisco_get_countries(country = c("Germany"), year = 2020, resolution = 1)


for (word in words){
  # csv einlesen
  csv <- read.csv(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/csv/DWA_Maurer_{word}.csv"), sep = "\t")
  word <- tolower(word)
  # ungültige Werte filtern
  csv <- csv %>%
    filter(lextype != "na")
  # Lextypes, die weniger als 5 Mal im Datenvorkommen, werden entfernt
  csv <- csv %>% group_by(lextype) %>% mutate(n=n()) %>% filter(n>5) %>% ungroup() %>% select(-n) 
  
  # DataFrame für geom_tile()
  df <- as.data.frame(csv, xy = TRUE)
  # LONG und LAT auf 1 Nachkommastelle beschränken, um Grid Berechnung möglich zu machen
  df <- df %>% mutate(across(c(LAT, LONG), round, digits = 1))
  
  # csv einlesen
  data <- read.csv(str_glue("{word}.csv"), sep = "\t", as.is=T)
  
  data_item <- data %>%
    filter(Levenshtein.Item.Min != "999")
  data_item$Item.cat <- ifelse(data_item$Levenshtein.Item.Min > 0, 1, 0)
  data_item$Item.cat.str <- ifelse(data_item$Levenshtein.Item.Min > 0, "False", "True")
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
  sf_data_item_bool <- sf_data_item %>%
    filter(gi_star_item_bool <= -1.96 | gi_star_item_bool >= 1.96)
  sf_data_item_bool$Item.cat.str <- ifelse(sf_data_item_bool$gi_star_item_bool >= 1.96 , "Hotspot", "Coldspot")
  sf_data_item_levenshtein <- sf_data_item %>%
    filter(gi_star_item_levenshtein < -1.96 | gi_star_item_levenshtein > 1.96)
  sf_data_item_levenshtein$Item.cat.str <- ifelse(sf_data_item_levenshtein$gi_star_item_levenshtein >= 1.96 , "Hotspot", "Coldspot")
  
  data_phontype <- data %>%
    filter(Levenshtein.Phontype.Min != "999")
  data_phontype$Phontype.cat <- ifelse(data_phontype$Levenshtein.Phontype.Min > 0, 1, 0)
  data_phontype$Phontype.cat.str <- ifelse(data_phontype$Levenshtein.Phontype.Min > 0, "False", "True")
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
  sf_data_phontype_bool <- sf_data_phontype %>%
    filter(gi_star_phontype_bool < -1.96 | gi_star_phontype_bool > 1.96)
  sf_data_phontype_bool$Phontype.cat.str <- ifelse(sf_data_phontype_bool$gi_star_phontype_bool >= 1.96 , "Hotspot", "Coldspot")
  sf_data_phontype_levenshtein <- sf_data_phontype %>%
    filter(gi_star_phontype_levenshtein < -1.96 | gi_star_phontype_levenshtein > 1.96)
  sf_data_phontype_levenshtein$Phontype.cat.str <- ifelse(sf_data_phontype_levenshtein$gi_star_phontype_levenshtein >= 1.96 , "Hotspot", "Coldspot")
  
  data_lextype <- data %>%
    filter(Levenshtein.Lextype.Min != "999")
  data_lextype$Lextype.cat <- ifelse(data_lextype$Levenshtein.Lextype.Min > 0, 1, 0)
  data_lextype$Lextype.cat.str <- ifelse(data_lextype$Levenshtein.Lextype.Min > 0, "False", "True")
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
  sf_data_lextype_bool <- sf_data_lextype %>%
    filter(gi_star_lextype_bool < -1.96 | gi_star_lextype_bool > 1.96)
  sf_data_lextype_bool$Lextype.cat.str <- ifelse(sf_data_lextype_bool$gi_star_lextype_bool >= 1.96 , "Hotspot", "Coldspot")
  sf_data_lextype_levenshtein <- sf_data_lextype %>%
    filter(gi_star_lextype_levenshtein < -1.96 | gi_star_lextype_levenshtein > 1.96)
  sf_data_lextype_levenshtein$Lextype.cat.str <- ifelse(sf_data_lextype_levenshtein$gi_star_lextype_levenshtein >= 1.96 , "Hotspot", "Coldspot")
  
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_items_hotspot_und_lexeme/hotspot_lexeme_{word}_item.png"), width=1250, height = 1250)
  # Grafik erstellen
  g <- ggplot(data = df) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_tile(aes(x = LONG, y = LAT, fill = lextype, alpha = 0.3), colour = "black") +
    scale_fill_manual(values = c(unname(glasbey.colors(32)))) +
    new_scale("fill") +
    geom_sf(data = sf_data_item_bool, aes(color = Item.cat.str, fill = Item.cat.str), shape = 24, size = 6) +
    scale_fill_manual(values = c("Coldspot" = "white", "Hotspot" = "black")) +
    scale_color_manual(values = c("Coldspot" = "black", "Hotspot" = "white"),
                       name = "\n") + 
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    theme_bw() +
    ggtitle(label = str_glue("{word} item - Hotspots und Lexemverteilung")) +
    theme(legend.position = "bottom",
          plot.title = element_text(hjust = 0.5, size = 40),
          legend.title = element_blank(),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          axis.title.x = element_blank(),
          axis.title.y = element_blank()) +
    guides(alpha = "none", size = "none", color = "none")
  
  print(g)
  # Graphikerstellung beenden
  dev.off()
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_phontypes_hotspot_und_lexeme/hotspot_lexeme_{word}_phontype.png"), width=1250, height = 1250)
  # Grafik erstellen
  g <- ggplot(data = df) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_tile(aes(x = LONG, y = LAT, fill = lextype, alpha = 0.3), colour = "black") +
    scale_fill_manual(values = c(unname(glasbey.colors(32)))) +
    new_scale("fill") +
    geom_sf(data = sf_data_phontype_bool, aes(color = Phontype.cat.str, fill = Phontype.cat.str), shape = 24, size = 6) +
    scale_fill_manual(values = c("Coldspot" = "white", "Hotspot" = "black")) +
    scale_color_manual(values = c("Coldspot" = "black", "Hotspot" = "white"),
                       name = "\n") + 
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    theme_bw() +
    ggtitle(label = str_glue("{word} phontype - Hotspots und Lexemverteilung")) +
    theme(legend.position = "bottom",
          plot.title = element_text(hjust = 0.5, size = 40),
          legend.title = element_blank(),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          axis.title.x = element_blank(),
          axis.title.y = element_blank()) +
    guides(alpha = "none", size = "none", color = "none")
  
  print(g)
  # Graphikerstellung beenden
  dev.off()
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_lextypes_hotspot_und_lexeme/hotspot_lexeme_{word}_lextype.png"), width=1250, height = 1250)
  # Grafik erstellen
  g <- ggplot(data = df) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_tile(aes(x = LONG, y = LAT, fill = lextype, alpha = 0.3), colour = "black") +
    scale_fill_manual(values = c(unname(glasbey.colors(32)))) +
    new_scale("fill") +
    geom_sf(data = sf_data_lextype_bool, aes(color = Lextype.cat.str, fill = Lextype.cat.str), shape = 24, size = 6) +
    scale_fill_manual(values = c("Coldspot" = "white", "Hotspot" = "black")) +
    scale_color_manual(values = c("Coldspot" = "black", "Hotspot" = "white"),
                       name = "\n") + 
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    theme_bw() +
    ggtitle(label = str_glue("{word} lextype - Hotspots und Lexemverteilung")) +
    theme(legend.position = "bottom",
          plot.title = element_text(hjust = 0.5, size = 40),
          legend.title = element_blank(),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          axis.title.x = element_blank(),
          axis.title.y = element_blank()) +
    guides(alpha = "none", size = "none", color = "none")
  
  print(g)
  # Graphikerstellung beenden
  dev.off()
}

