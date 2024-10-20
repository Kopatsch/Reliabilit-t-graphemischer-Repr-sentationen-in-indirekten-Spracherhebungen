# Bibliotheken laden
library(tidyverse)
library(gridExtra)
library(sf)
library(giscoR)
library(stringr)

# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/levenshtein_gesamt")

# Sprache
gisco_attributions(lang = "en")

# Karten Shapes für Länder um Deutschland herum
europe <- gisco_get_countries(country = c("France", "Switzerland", "Austria", "Luxembourg", "Belgium"), year = 2020, resolution = 1)
# Karten Shape Deutschland
germany <- gisco_get_countries(country = c("Germany"), year = 2020, resolution = 1)

# csv einlesen
gesamt <- read.csv("levenshtein_gesamt.csv", sep = "\t")
z_score <- read.csv("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/z_scores/z_scores_words_added.csv", sep = "\t")


### Item
# ungültige Werte filtern
gesamt <- gesamt %>%
  filter(Levenshtein.Item.Min != "999")
# True/False Werte
gesamt$Item.cat <- ifelse(gesamt$Levenshtein.Item.Min > 0, "False", "True")

# Speicherort
png("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/map_all/gesamt_item.png", width=1692, height = 712)

# zwei Graphiken nebeneinander erstellen
grid.arrange(
  # Graphik 1 mit True/False Werten
  ggplot(mapping = aes(col = Item.cat)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = gesamt, x = gesamt$Longitude, y = gesamt$Latitude, size = 2) +
    scale_color_manual(values = c("True" = "palegreen", "False" = "darkred"), 
                       name = "Übereinstimmung\nItems\nTrue/False") + 
    theme(legend.position = "bottom"),
  
  # Graphik 2 mit Levenshtein Werten mit Farbskala
  ggplot(mapping = aes(col = z_score_item)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = gesamt, x = gesamt$Longitude, y = gesamt$Latitude, size = 2) +
    scale_color_gradient2(midpoint = mean(z_score$z_score),
                          low = "white", mid = "red",
                          high="darkblue", space ="Lab",
                          name = "Levenshtein\nItem") +
    theme(legend.position = "bottom"),
  
  ncol = 2,
  top = "gesamt item"
)
# Graphikerstellung beenden
dev.off()


### Phontype
gesamt <- gesamt %>%
  filter(Levenshtein.Phontype.Min != "999")
gesamt$Phontype.cat <- ifelse(gesamt$Levenshtein.Phontype.Min > 0, "False", "True")

png("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/map_all/gesamt_phontype.png", width=1692, height = 712)

grid.arrange(
  ggplot(mapping = aes(col = Phontype.cat)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = gesamt, x = gesamt$Longitude, y = gesamt$Latitude, size = 2) +
    scale_color_manual(values = c("True" = "palegreen", "False" = "red"), 
                       name = "Übereinstimmung\nPhontypes\nTrue/False") + 
    theme(legend.position = "bottom"),
  
  ggplot(mapping = aes(col = z_score_phontype)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = gesamt, x = gesamt$Longitude, y = gesamt$Latitude, size = 2) +
    scale_color_gradient2(midpoint = mean(z_score$z_score),
                          low = "white", mid = "red",
                          high="darkblue", space ="Lab",
                          name = "Levenshtein\nPhontype") +
    theme(legend.position = "bottom"),
  
  ncol = 2,
  top = "gesamt phontype"
)

dev.off()


### Lextype
gesamt <- gesamt %>%
  filter(Levenshtein.Lextype.Min != "999")
gesamt$Lextype.cat <- ifelse(gesamt$Levenshtein.Lextype.Min > 0, "False", "True")

png("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/map_all/gesamt_lextype.png", width=1692, height = 712)

grid.arrange(
  ggplot(mapping = aes(col = Lextype.cat)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = gesamt, x = gesamt$Longitude, y = gesamt$Latitude, size = 2) +
    scale_color_manual(values = c("True" = "palegreen", "False" = "darkred"), 
                       name = "Übereinstimmung\nLextypes\nTrue/False") + 
    theme(legend.position = "bottom"),
  
  ggplot(mapping = aes(col = z_score_lextype)) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    geom_point(data = gesamt, x = gesamt$Longitude, y = gesamt$Latitude, size = 2) +
    scale_color_gradient2(midpoint = mean(z_score$z_score),
                          low = "white", mid = "red",
                          high="darkblue", space ="Lab",
                          name = "Levenshtein\nLextype") +
    theme(legend.position = "bottom"),
  
  ncol = 2,
  top = "gesamt lextype"
)

dev.off()

