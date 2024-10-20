# Bibliotheken laden
library(tidyverse)
library(gridExtra)
library(sf)
library(giscoR)
#library(stringr)

# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/teacher")

# Sprache
gisco_attributions(lang = "en")

# Länder Shape Files Europa
europe <- gisco_get_countries(country = c("France", "Switzerland", "Austria", "Luxembourg", "Belgium"), year = 2020, resolution = 1)
# Shape File Deutschland
germany <- gisco_get_countries(country = "Germany", year = 2020, resolution = 1)

# csv einlesen
teacher <- read.csv("teacher_with_words.csv", sep = "\t")

# csv bereinigen
teacher <- teacher %>%
  filter(Levenshtein_item_ameise != "999")
teacher$Item.cat <- ifelse(teacher$Levenshtein_item_ameise > 0, "False", "True")

# Speicherort
png("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_items/1_teacher_bool/ameise_teacher_bool.png", width=1250, height = 1250)

g <-  ggplot(mapping = aes(col = Item.cat)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = teacher, x = teacher$LONG, y = teacher$LAT, size = 4) +
    scale_color_manual(values = c("True" = "palegreen", "False" = "red"), 
                       name = "Übereinstimmung Items\nTrue/False") + 
    theme_bw() +
    ggtitle(label = "ameise item Übereinstimmung\nLehrer Subset") +
    theme(legend.position = "bottom", 
          legend.title = element_text(face = "bold", size = 30),
          legend.text = element_text(size = 20),
          legend.key = element_rect(fill = "white", colour = "black"),
          axis.text = element_text(size = 20),
          legend.key.height = unit(2, "cm"),
          legend.key.width = unit(2, "cm"),
          plot.title = element_text(hjust = 0.5, size = 40))
print(g)
dev.off()

# Speicherort
png("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_items/1_teacher_levenshtein/ameise_teacher_levenshtein.png", width=1250, height = 1250)
  
g <-  ggplot(mapping = aes(col = z_score_item_ameise)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = teacher, x = teacher$LONG, y = teacher$LAT, size = 4) +
  scale_color_steps2(low = "blue", mid = "white",
                     high="red", space ="Lab",
                     name = "Levenshtein Distanz",
                     midpoint = 0, 
                     breaks = c(-1.96,0, 1.96)) +
    theme_bw() +
    ggtitle(label = "ameise item Levenshtein Distanz\nLehrer Subset") +
    theme(legend.position = "bottom", 
          legend.title = element_text(face = "bold", size = 30),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          legend.key.height = unit(1, "cm"),
          legend.key.width = unit(2, "cm"),
          plot.title = element_text(hjust = 0.5, size = 40))
print(g)
dev.off()