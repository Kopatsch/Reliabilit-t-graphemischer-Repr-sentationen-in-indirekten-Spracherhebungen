# Bibliotheken laden
library(tidyverse)
library(grid)
library(gridExtra)
library(sf)
library(giscoR)
library(Polychrome)
library(ggrepel)
library(dplyr)
library(stringr)

# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/levenshtein_single_files")

# Sprache
gisco_attributions(lang = "en")

# Karten Shapes für Länder um Deutschland herum
europe <- gisco_get_countries(country = c("Switzerland", "Austria", "Luxembourg", "Belgium", "France"), year = 2020, resolution = 1)
# Karten Shape Deutschland
germany <- gisco_get_countries(country = c("Germany"), year = 2020, resolution = 1)

# csv einlesen
zimmerfliege <- read.csv(str_glue("zimmerfliege.csv"), sep = "\t")
teacher <- read.csv("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/teacher/teacher_with_words.csv", sep = "\t")
zimmerfliege_lex <- read.csv(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/lexem_gesamt/all_levenshtein_lexem_added_zimmerfliege.csv"), sep = "\t")

# csv bereinigen
zimmerfliege_item <- zimmerfliege %>%
  filter(Levenshtein.Item.Min != "999")
zimmerfliege_item$Item.cat <- ifelse(zimmerfliege_item$Levenshtein.Item.Min > 0, 1, 0)
zimmerfliege_item$Item.cat.str <- ifelse(zimmerfliege_item$Levenshtein.Item.Min > 0, "False", "True")
str(zimmerfliege_item)
sf_zimmerfliege_item <- st_as_sf(zimmerfliege_item, coords = c("Longitude", "Latitude"), crs = 4326)
# Berechnen der Nachbarschaft (k-nearest neighbors)
nb_item <- knn2nb(knearneigh(st_coordinates(sf_zimmerfliege_item), k = 8))
# Umwandlung in eine Gewichtungsmatrix
lw_item <- nb2listw(nb_item, style = "W")
# Berechnung des Getis-Ord Gi* Statistik
gi_star_item_bool <- localG(sf_zimmerfliege_item$Item.cat, lw_item)
gi_star_item_levenshtein <- localG(sf_zimmerfliege_item$z_score_item, lw_item)
# Hinzufügen der Ergebnisse zu den ursprünglichen Daten
sf_zimmerfliege_item$gi_star_item_bool <- as.numeric(gi_star_item_bool)
sf_zimmerfliege_item$gi_star_item_levenshtein <- as.numeric(gi_star_item_levenshtein)
sf_zimmerfliege_item_bool <- sf_zimmerfliege_item %>%
  filter(gi_star_item_bool <= -1.96 | gi_star_item_bool >= 1.96)
sf_zimmerfliege_item_bool$Item.cat.str <- ifelse(sf_zimmerfliege_item_bool$gi_star_item_bool >= 1.96 , "Hotspot", "Coldspot")
sf_zimmerfliege_item_levenshtein <- sf_zimmerfliege_item %>%
  filter(gi_star_item_levenshtein < -1.96 | gi_star_item_levenshtein > 1.96)
sf_zimmerfliege_item_levenshtein$Item.cat.str <- ifelse(sf_zimmerfliege_item_levenshtein$gi_star_item_levenshtein >= 1.96 , "Hotspot", "Coldspot")
length_item <- length(zimmerfliege_item$Ort)
true_item <- zimmerfliege_item %>%
  filter(Levenshtein.Item.Min == 0)
length_true_item <- length(true_item$Ort)
prozent_item <- round(length_true_item/length_item*100,2)
label_item <- str_glue("zimmerfliege items\n(Original)\nAnzahl Orte: {length_item}\n{prozent_item}% Übereinstimmung")

teacher <- teacher %>%
  filter(Levenshtein_item_zimmerfliege != "999")
teacher$Teacher.cat <- ifelse(teacher$Levenshtein_item_zimmerfliege > 0, 1, 0)
teacher$Teacher.cat.str <- ifelse(teacher$Levenshtein_item_zimmerfliege > 0, "False", "True")
str(teacher)
sf_teacher <- st_as_sf(teacher, coords = c("LONG", "LAT"), crs = 4326)
# Berechnen der Nachbarschaft (k-nearest neighbors)
nb_teacher <- knn2nb(knearneigh(st_coordinates(sf_teacher), k = 8))
# Umwandlung in eine Gewichtungsmatrix
lw_teacher <- nb2listw(nb_teacher, style = "W")
# Berechnung des Getis-Ord Gi* Statistik
gi_star_teacher_bool <- localG(sf_teacher$Teacher.cat, lw_teacher)
gi_star_teacher_levenshtein <- localG(sf_teacher$z_score_item_zimmerfliege, lw_teacher)
# Hinzufügen der Ergebnisse zu den ursprünglichen Daten
sf_teacher$gi_star_teacher_bool <- as.numeric(gi_star_teacher_bool)
sf_teacher$gi_star_teacher_levenshtein <- as.numeric(gi_star_teacher_levenshtein)
sf_teacher_bool <- sf_teacher %>%
  filter(gi_star_teacher_bool <= -1.96 | gi_star_teacher_bool >= 1.96)
sf_teacher_bool$Teacher.cat.str <- ifelse(sf_teacher_bool$gi_star_teacher_bool >= 1.96 , "Hotspot", "Coldspot")
sf_teacher_levenshtein <- sf_teacher %>%
  filter(gi_star_teacher_levenshtein < -1.96 | gi_star_teacher_levenshtein > 1.96)
sf_teacher_levenshtein$Teacher.cat.str <- ifelse(sf_teacher_levenshtein$gi_star_teacher_levenshtein >= 1.96 , "Hotspot", "Coldspot")
length_teacher <- length(teacher$Ort)
true_teacher <- teacher %>%
  filter(Levenshtein_item_zimmerfliege == 0)
length_true_teacher <- length(true_teacher$Ort)
prozent_teacher <- round(length_true_teacher/length_teacher*100,2)
label_teacher <- str_glue("zimmerfliege items\n(Lehrer Subset)\nAnzahl Orte: {length_teacher}\n{prozent_teacher}% Übereinstimmung")

zimmerfliege_lex <- zimmerfliege_lex %>%
  filter(Levenshtein_item != "999")
zimmerfliege_lex$Lex.cat <- ifelse(zimmerfliege_lex$Levenshtein_item > 0, 1, 0)
zimmerfliege_lex$Lex.cat.str <- ifelse(zimmerfliege_lex$Levenshtein_item > 0, "False", "True")
str(zimmerfliege_lex)
sf_zimmerfliege_lex <- st_as_sf(zimmerfliege_lex, coords = c("Longitude", "Latitude"), crs = 4326)
# Berechnen der Nachbarschaft (k-nearest neighbors)
nb_zimmerfliege_lex <- knn2nb(knearneigh(st_coordinates(sf_zimmerfliege_lex), k = 8))
# Umwandlung in eine Gewichtungsmatrix
lw_zimmerfliege_lex <- nb2listw(nb_zimmerfliege_lex, style = "W")
# Berechnung des Getis-Ord Gi* Statistik
gi_star_zimmerfliege_lex_bool <- localG(sf_zimmerfliege_lex$Lex.cat, lw_zimmerfliege_lex)
gi_star_zimmerfliege_lex_levenshtein <- localG(sf_zimmerfliege_lex$z_score_item, lw_zimmerfliege_lex)
# Hinzufügen der Ergebnisse zu den ursprünglichen Daten
sf_zimmerfliege_lex$gi_star_zimmerfliege_lex_bool <- as.numeric(gi_star_zimmerfliege_lex_bool)
sf_zimmerfliege_lex$gi_star_zimmerfliege_lex_levenshtein <- as.numeric(gi_star_zimmerfliege_lex_levenshtein)
sf_zimmerfliege_lex_bool <- sf_zimmerfliege_lex %>%
  filter(gi_star_zimmerfliege_lex_bool <= -1.96 | gi_star_zimmerfliege_lex_bool >= 1.96)
sf_zimmerfliege_lex_bool$Lex.cat.str <- ifelse(sf_zimmerfliege_lex_bool$gi_star_zimmerfliege_lex_bool >= 1.96 , "Hotspot", "Coldspot")
sf_zimmerfliege_lex_levenshtein <- sf_zimmerfliege_lex %>%
  filter(gi_star_zimmerfliege_lex_levenshtein < -1.96 | gi_star_zimmerfliege_lex_levenshtein > 1.96)
sf_zimmerfliege_lex_levenshtein$Lex.cat.str <- ifelse(sf_zimmerfliege_lex_levenshtein$gi_star_zimmerfliege_lex_levenshtein >= 1.96 , "Hotspot", "Coldspot")
length_lex <- length(zimmerfliege_lex$Ort)
true_lex <- zimmerfliege_lex %>%
  filter(Levenshtein_item == 0)
length_true_lex <- length(true_lex$Ort)
prozent_lex <- round(length_true_lex/length_lex*100,2)
label_lex <- str_glue("zimmerfliege items\n(Lexembereinigung)\nAnzahl Orte: {length_lex}\n{prozent_lex}% Übereinstimmung")


# Speicherort
png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_items/zimmerfliege_item.png"), width=5000, height = 3500)

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
    geom_text(label = str_glue("Übereinstimmung True/False"), aes(x = 3, y = 3), size = 20, color= "black") +
    theme_void(),
  ggplot() + 
    geom_rect(aes(xmin = 1, xmax = 5, ymin = 1.5, ymax = 4.5), 
              fill = "white", color = "white") + 
    geom_rect(aes(xmin = 1, xmax = 5, ymin = 2, ymax = 4), 
              fill = "seashell3", color = "white") +
    geom_text(label = str_glue("Getis-Ord Hotspot Analyse"), aes(x = 3, y = 3), size = 20, color= "black") +
    theme_void(),
  ggplot() + 
    geom_rect(aes(xmin = 1, xmax = 5, ymin = 1.5, ymax = 4.5), 
              fill = "white", color = "white") + 
    geom_rect(aes(xmin = 1, xmax = 5, ymin = 2, ymax = 4), 
              fill = "seashell3", color = "white") +
    geom_text(label = str_glue("Levenshtein Distanzen"), aes(x = 3, y = 3), size = 20, color= "black") +
    theme_void(),
  
  
  # Graphik 3
  ggplot() + 
    geom_rect(aes(xmin = 1, xmax = 5, ymin = 1, ymax = 5), 
              fill = "white", color = "white") + 
    geom_rect(aes(xmin = 1.25, xmax = 4.75, ymin = 2, ymax = 4), 
              fill = "seashell3", color = "white") +
    geom_text(label = label_item, aes(x = 3, y = 3), size = 20, color= "black") +
    theme_void(),
  
  # Graphik 1
  ggplot(mapping = aes(col = zimmerfliege_item$Item.cat.str)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = zimmerfliege_item, x = zimmerfliege_item$Longitude, y = zimmerfliege_item$Latitude, size = 4) +
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
  
  ggplot(sf_zimmerfliege_item_bool) +
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

  # Graphik 2
  ggplot(mapping = aes(col = zimmerfliege_item$z_score_item)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = zimmerfliege_item, x = zimmerfliege_item$Longitude, y = zimmerfliege_item$Latitude, size = 4) +
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
  
  

  # Graphik 6
  ggplot() + 
    geom_rect(aes(xmin = 1, xmax = 5, ymin = 1, ymax = 5), 
              fill = "white", color = "white") + 
    geom_rect(aes(xmin = 1.25, xmax = 4.75, ymin = 2, ymax = 4), 
              fill = "seashell3", color = "white") +
    geom_text(label = label_teacher, aes(x = 3, y = 3), size = 20, color= "black") +
    theme_void(),
  
  # Graphik 4
  ggplot(mapping = aes(col = teacher$Teacher.cat.str)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = teacher, x = teacher$LONG, y = teacher$LAT, size = 4) +
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
  
  ggplot(sf_teacher_bool) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_sf(aes(color = Teacher.cat.str, size = 4)) +
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
  
  # Graphik 5
  ggplot(mapping = aes(col = teacher$z_score_item_zimmerfliege)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = teacher, x = teacher$LONG, y = teacher$LAT, size = 4) +
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
  
  
  

  # Graphik 9
  ggplot() + 
    geom_rect(aes(xmin = 1, xmax = 5, ymin = 1, ymax = 5), 
              fill = "white", color = "white") + 
    geom_rect(aes(xmin = 1.25, xmax = 4.75, ymin = 2, ymax = 4), 
              fill = "seashell3", color = "white") +
    geom_text(label = label_lex, aes(x = 3, y = 3), size = 20, color= "black") +
    theme_void(),

  # Graphik 7
  ggplot(mapping = aes(col = zimmerfliege_lex$Lex.cat.str)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = zimmerfliege_lex, x = zimmerfliege_lex$Longitude, y = zimmerfliege_lex$Latitude, size = 4) +
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
  
  ggplot(sf_zimmerfliege_lex_bool) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_sf(aes(color = Lex.cat.str, size = 4)) +
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

  # Graphik 8
  ggplot(mapping = aes(col = zimmerfliege_lex$z_score_item)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = zimmerfliege_lex, x = zimmerfliege_lex$Longitude, y = zimmerfliege_lex$Latitude, size = 4) +
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
  
  
  
  ncol = 4,
  nrow = 4,
  heights=c(0.25,1,1,1),
  layout_matrix = cbind(c(1,5,9,13), c(2,6,10,14), c(3,7,11,15), c(4,8,12,16))
)
# Graphikerstellung beenden
dev.off()
