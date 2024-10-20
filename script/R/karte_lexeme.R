# Bibliotheken laden
library(tidyverse)
library(gridExtra)
library(sf)
library(giscoR)
library(Polychrome)
library(ggrepel)
library(dplyr)
library(stringr)


# working directory
setwd("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/data/csv")

words <- c("Ameise", "Begräbnis", "Deichsel", "Elster", "Fledermaus", "Gurke", "Hagebutte", "Hebamme", "Kartoffel", "Maulwurf", "Pflaume", "Stecknadel", "Ziege", "Zimmerfliege")

# Sprache
gisco_attributions(lang = "en")

# Karten Shapes für Länder um Deutschland herum
europe <- gisco_get_countries(country = c("France", "Switzerland", "Austria", "Luxembourg", "Belgium"), year = 2020, resolution = 1)
# Karten Shape Deutschland
germany <- gisco_get_countries(country = c("Germany"), year = 2020, resolution = 1)

for (word in words){
  # csv einlesen
  csv <- read.csv(str_glue("DWA_Maurer_{word}.csv"), sep = "\t")
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
  
  
  # Speicherort
  png(str_glue("//wsl.localhost/Ubuntu/home/kopatsch/Masterarbeit/MA/masterarbeit/visual/maps/map_words/1_lexeme/{word}_lexems.png"), width=1250, height = 1250)
  
  # Grafik erstellen
  g <- ggplot(data = df) +
    geom_sf(data = europe, fill = "ghostwhite", color = "#887e6a") +
    geom_sf(data = germany, fill = "grey96", color = "#887e6a") +
    geom_tile(aes(x = LONG, y = LAT, fill = lextype), colour = "black") +
    scale_fill_manual(values = c(unname(glasbey.colors(32)))) +
    coord_sf(xlim = c(6,10), ylim = c(47.4, 49.8)) +
    theme_bw() +
    ggtitle(label = str_glue("{word} Lexemverteilung")) +
    theme(legend.position = "bottom",
          plot.title = element_text(hjust = 0.5, size = 40),
          legend.title = element_blank(),
          legend.text = element_text(size = 20),
          axis.text = element_text(size = 20),
          axis.title.x = element_blank(),
          axis.title.y = element_blank())
  
  print(g)
  
  # Graphikerstellung beenden
  dev.off()
}