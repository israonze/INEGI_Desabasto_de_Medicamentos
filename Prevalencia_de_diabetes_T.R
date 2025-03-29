library(sf)
library(purrr)
library(tidyverse)
library(ggplot2)
library(readxl)

setwd("C:/Users/jiace/OneDrive/Escritorio/Proyecto INEGI")

prevalencia_diabetes= read_sf(file.choose()) %>% 
janitor::clean_names()

prev= read.csv(file.choose()) %>% 
  janitor::clean_names() %>% 
  rename(nomgeo= entidad)
  

mapa_data <- left_join(prevalencia_diabetes,prev,by="nomgeo")

ggplot(data = mapa_data) +
  geom_sf(aes(fill = porcentaje_diabeticos_ensanut)) +
  scale_fill_viridis_c("orange") +
  labs(title = "Prevalencia de diabetes por entidad federativa (2018)",
       caption = "Fuente: ENSANUT 2018
       Elaboración propia",
       x="Longitud",
       y="Latitud") +
  scale_fill_continuous(guide_legend(title = "Porcentaje de diabéticos")) 

#BARPLOT
data(prev)
attach(prev)
Diabetes =factor(Diabetes, levels = c(0,1), labels = c("pobla", "diab"))
library(plotrix)
histStack(pobla,Diabetes,legend.pos="topright")
