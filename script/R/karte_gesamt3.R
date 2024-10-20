# Bibliotheken laden
library(gridExtra)
library(grid)
library(stringr)
library(sf)
library(tidyverse)
library(giscoR)
library(spdep)
library(dplyr)
library(ape)

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
  #Moran's I
  data_item.dists <- as.matrix(dist(cbind(data_item$Longitude, data_item$Latitude)))
  data_item.dists.inv <- 1/data_item.dists
  diag(data_item.dists.inv) <- 0
  moran_item <- Moran.I(data_item$Item.cat, data_item.dists.inv)
  #Übereinstimmung Prozent
  length_item <- length(data_item$Ort)
  true_item <- data_item %>%
    filter(Levenshtein.Item.Min == 0)
  length_true_item <- length(true_item$Ort)
  prozent_item <- round(length_true_item/length_item*100,2)
  
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
  #Moran's I
  data_phontype.dists <- as.matrix(dist(cbind(data_phontype$Longitude, data_phontype$Latitude)))
  data_phontype.dists.inv <- 1/data_phontype.dists
  diag(data_phontype.dists.inv) <- 0
  moran_phon <- Moran.I(data_phontype$Phontype.cat, data_phontype.dists.inv)
  #Übereinstimmung Prozent
  length_phontype <- length(data_phontype$Ort)
  true_phontype <- data_phontype %>%
    filter(Levenshtein.Phontype.Min == 0)
  length_true_phontype <- length(true_phontype$Ort)
  prozent_phontype <- round(length_true_phontype/length_phontype*100,2)
  
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
  #Moran's I
  data_lextype.dists <- as.matrix(dist(cbind(data_lextype$Longitude, data_lextype$Latitude)))
  data_lextype.dists.inv <- 1/data_lextype.dists
  diag(data_lextype.dists.inv) <- 0
  moran_lex <- Moran.I(data_lextype$Lextype.cat, data_lextype.dists.inv)
  #Übereinstimmung Prozent
  length_lextype <- length(data_lextype$Ort)
  true_lextype <- data_lextype %>%
    filter(Levenshtein.Lextype.Min == 0)
  length_true_lextype <- length(true_lextype$Ort)
  prozent_lextype <- round(length_true_lextype/length_lextype*100,2)
  
  
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/{word}3.png"), width=5000, height = 3500)
  
  # Graphiken nebeneinander und untereinander erstellen
  grid.arrange(
    ggplot() + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 1.5, ymax = 4.5), 
                fill = "white", color = "white") +
      theme_void(),
    ggplot() + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 1.5, ymax = 4.5), 
                fill = "white", color = "white") + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 2, ymax = 4), 
                fill = "seashell3", color = "white") +
      geom_text(label = str_glue("Übereinstimmung True/False\n"), aes(x = 3, y = 3), size = 20, color= "black") +
      theme_void(),
    ggplot() + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 1.5, ymax = 4.5), 
                fill = "white", color = "white") + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 2, ymax = 4), 
                fill = "seashell3", color = "white") +
      geom_text(label = str_glue("Getis-Ord Hotspot Analyse\nzu True/False Werten"), aes(x = 3, y = 3), size = 20, color= "black") +
      theme_void(),
    ggplot() + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 1.5, ymax = 4.5), 
                fill = "white", color = "white") + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 2, ymax = 4), 
                fill = "seashell3", color = "white") +
      geom_text(label = str_glue("Levenshtein Distanzen"), aes(x = 3, y = 3), size = 20, color= "black") +
      theme_void(),
    
    
    ggplot() + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 1, ymax = 5), 
                fill = "white", color = "white") + 
      geom_rect(aes(xmin = 1.25, xmax = 4.75, ymin = 2, ymax = 4), 
                fill = "seashell3", color = "white") +
      geom_text(label = str_glue("{word} items\nAnzahl Orte: {length_item}\np.value: {round(moran_item$p.value, 3)}\n{prozent_item}% Übereinstimmung"), aes(x = 3, y = 3), size = 20, color= "black") +
      theme_void(),
    
    # Graphik: True/False Werte items
    ggplot(mapping = aes(col = Item.cat.str)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = data_item, x = data_item$Longitude, y = data_item$Latitude, size = 4) +
      scale_color_manual(values = c("True" = "palegreen", "False" = "red"),
                         name = "\n") + 
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(size = 30),
            legend.text = element_text(face = "bold", size = 40),
            legend.key = element_rect(fill = "white", colour = "black"),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank()) +
      guides(colour = guide_legend(override.aes = list(size=10)), size = "none"),
    
    ggplot(sf_data_item_bool) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      geom_sf(aes(color = Item.cat.str, size = 4)) +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      scale_color_manual(values = c("Coldspot" = "blue", "Hotspot" = "red"),
                         name = "\n") + 
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(size = 30),
            legend.text = element_text(face = "bold", size = 40),
            legend.key = element_rect(fill = "white", colour = "black"),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank()) +
      guides(colour = guide_legend(override.aes = list(size=10)), size = "none"),
    
    # Graphik: Levenshtein Werte items
    ggplot(mapping = aes(col = z_score_item)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = data_item, x = data_item$Longitude, y = data_item$Latitude, size = 4) +
      scale_color_steps2(low = "white", mid = "white",
                         high = "red", space ="Lab",
                         name = "z-score",
                         midpoint = 0, 
                         breaks = c(-1.96,0, 1.96)) +
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 40),
            legend.text = element_text(size = 30),
            legend.key.height = unit(1, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank()),
    
    
    
    ggplot() + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 1, ymax = 5), 
                fill = "white", color = "white") + 
      geom_rect(aes(xmin = 1.25, xmax = 4.75, ymin = 2, ymax = 4), 
                fill = "seashell3", color = "white") +
      geom_text(label = str_glue("{word} phontypes\nAnzahl Orte: {length_phontype}\np.value: {round(moran_phon$p.value, 3)}\n{prozent_phontype}% Übereinstimmung"), aes(x = 3, y = 3), size = 20, color= "black") +
      theme_void(),
    
    ggplot(mapping = aes(col = Phontype.cat.str)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = data_phontype, x = data_phontype$Longitude, y = data_phontype$Latitude, size = 4) +
      scale_color_manual(values = c("True" = "palegreen", "False" = "red"),
                         name = "\n") + 
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(size = 30),
            legend.text = element_text(face = "bold", size = 40),
            legend.key = element_rect(fill = "white", colour = "black"),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank()) +
      guides(colour = guide_legend(override.aes = list(size=10)), size = "none"),
    
    ggplot(sf_data_phontype_bool) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      geom_sf(aes(color = Phontype.cat.str, size = 4)) +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      scale_color_manual(values = c("Coldspot" = "blue", "Hotspot" = "red"),
                         name = "\n") + 
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(size = 30),
            legend.text = element_text(face = "bold", size = 40),
            legend.key = element_rect(fill = "white", colour = "black"),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank()) +
      guides(colour = guide_legend(override.aes = list(size=10)), size = "none"),
    
    ggplot(mapping = aes(col = z_score_phontype)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = data_phontype, x = data_phontype$Longitude, y = data_phontype$Latitude, size = 4) +
      scale_color_steps2(low = "white", mid = "white",
                         high="red", space ="Lab",
                         name = "z-score",
                         midpoint = 0, 
                         breaks = c(-1.96,0, 1.96)) +
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 40),
            legend.text = element_text(size = 30),
            legend.key.height = unit(1, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank()),

    
    
    
    ggplot() + 
      geom_rect(aes(xmin = 1, xmax = 5, ymin = 1, ymax = 5), 
                fill = "white", color = "white") + 
      geom_rect(aes(xmin = 1.25, xmax = 4.75, ymin = 2, ymax = 4), 
                fill = "seashell3", color = "white") +
      geom_text(label = str_glue("{word} lextypes\nAnzahl Orte: {length_lextype}\np.value: {round(moran_lex$p.value, 3)}\n{prozent_lextype}% Übereinstimmung"), aes(x = 3, y = 3), size = 20, color= "black") +
      theme_void(),
    
    ggplot(mapping = aes(col = Lextype.cat.str)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = data_lextype, x = data_lextype$Longitude, y = data_lextype$Latitude, size = 4) +
      scale_color_manual(values = c("True" = "palegreen", "False" = "red"),
                         name = "\n") + 
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(size = 30),
            legend.text = element_text(face = "bold", size = 40),
            legend.key = element_rect(fill = "white", colour = "black"),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank()) +
      guides(colour = guide_legend(override.aes = list(size=10)), size = "none"),
    
    ggplot(sf_data_lextype_bool) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      geom_sf(aes(color = Lextype.cat.str, size = 4)) +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      scale_color_manual(values = c("Coldspot" = "blue", "Hotspot" = "red"),
                         name = "\n") + 
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(size = 30),
            legend.text = element_text(face = "bold", size = 40),
            legend.key = element_rect(fill = "white", colour = "black"),
            legend.key.height = unit(2, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank())  +
      guides(colour = guide_legend(override.aes = list(size=10)), size = "none"),
    
    ggplot(mapping = aes(col = z_score_lextype)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = data_lextype, x = data_lextype$Longitude, y = data_lextype$Latitude, size = 4) +
      scale_color_steps2(low = "white", mid = "white",
                         high="red", space ="Lab",
                         name = "z-score",
                         midpoint = 0, 
                         breaks = c(-1.96,0, 1.96)) +
      theme_bw() +
      theme(legend.position = "bottom", 
            legend.title = element_text(face = "bold", size = 40),
            legend.text = element_text(size = 30),
            legend.key.height = unit(1, "cm"),
            legend.key.width = unit(2, "cm"),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank()),
    
    
    # Layout
    ncol = 4,
    nrow = 4,
    heights=c(0.25,1,1,1),
    layout_matrix = cbind(c(1,5,9,13), c(2,6,10,14), c(3,7,11,15), c(4,8,12,16))
  )
  
  # Graphikerstellung beenden
  dev.off()
}

