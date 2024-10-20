# Bibliotheken laden
library(tidyverse)
library(gridExtra)
library(sf)
library(giscoR)
library(stringr)

# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/lexem_gesamt")

words <- c("ameise", "begräbnis", "deichsel", "elster", "fledermaus", "gurke", "hagebutte", "hebamme", "kartoffel", "maulwurf", "pflaume", "stecknadel", "ziege", "zimmerfliege")

# Sprache
gisco_attributions(lang = "en")

# Karten Shapes für Länder um Deutschland herum
europe <- gisco_get_countries(country = c("France", "Switzerland", "Austria", "Luxembourg", "Belgium"), year = 2020, resolution = 1)
# Karten Shape Deutschland
germany <- gisco_get_countries(country = c("Germany"), year = 2020, resolution = 1)

for (word in words){
  # csv einlesen
  csv <- read.csv(str_glue("all_levenshtein_lexem_added_{word}.csv"), sep = "\t")
  # ungültige Werte filtern
  csv <- csv %>%
    filter(Levenshtein_item != "999")
  # True/False Werte
  csv$Item.cat <- ifelse(csv$Levenshtein_item > 0, "False", "True")
  
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_items/1_lexems_bool/{word}_lexems_bool.png"), width=1250, height = 1250)
  # Graphik 1 mit True/False Werten
  g <-  ggplot(mapping = aes(col = Item.cat)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = csv, x = csv$Longitude, y = csv$Latitude, size = 4) +
      scale_color_manual(values = c("True" = "palegreen", "False" = "red"), 
                         name = "Übereinstimmung Items\nTrue/False") + 
      theme_bw() +
      ggtitle(label = str_glue("{word} item Übereinstimmung\nLexembereinigung")) +
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
  
  
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_items/1_lexems_levenshtein/{word}_lexems_levenshtein.png"), width=1250, height = 1250)
  # Graphik 2 mit Levenshtein Werten
  g <-  ggplot(mapping = aes(col = z_score_item)) +
      geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
      geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
      coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
      geom_point(data = csv, x = csv$Longitude, y = csv$Latitude, size = 4) +
      scale_color_steps2(low = "blue", mid = "white",
                         high="red", space ="Lab",
                         name = "Levenshtein Distanz",
                         midpoint = 0, 
                         breaks = c(-1.96,0, 1.96)) + 
      theme_bw() +
      ggtitle(label = str_glue("{word} item Levenshtein Distanz\nLexembereinigung")) +
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