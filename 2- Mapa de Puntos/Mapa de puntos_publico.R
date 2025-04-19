#limpieza del environment
rm(list = ls())
ls()

#fijar directorio de trabajo
setwd("C:/Users/jiace/OneDrive/Escritorio/Proyecto INEGI")

# cargar librerias --------------------------------------------------------
library(tidyverse)
library(sf)
library(tmap)

# cargar datos --------------------------------------------------------

#Cargar mapa de la INEGI
Mapa= read_sf("DATA/conjunto_de_datos/00ent.shp") %>% 
  janitor::clean_names()

#cargar los centros de salud p+ublica de la DENUE 
centros_salud_pub = read_sf("DATA/INEGI_DENUE_14112022.shp") %>% 
  janitor::clean_names() %>%
  mutate(cvegeo=cve_ent, año=2021 ) %>% 
  filter(nombre_act != "Hospitales generales del sector privado")

#cargar los centros de salud privada de la DENUE
centros_salud_priv = read_sf("DATA/INEGI_DENUE_14112022.shp") %>% 
  janitor::clean_names() %>%
  mutate(cvegeo=cve_ent, año=2021 ) %>% 
  filter(nombre_act == "Hospitales generales del sector privado")

#Cargar losdatos de prevalencia de diabtes
pp= read.csv("DATA/por_estado_diabetes.csv", fileEncoding = "Latin1", check.names = F) %>% 
  janitor::clean_names() %>%
  mutate(cvegeo=enti)

#Agregamos 0 a los valores de cvegeo para poder hacer la unión de los datos 
pp$cvegeo <- ifelse(pp$cvegeo<10, paste(0,pp$cvegeo,sep=""), pp$cvegeo)

#Unimos los datos en un  DF
mapa_data <- left_join(Mapa,pp,by="cvegeo")

#Especificamos el modo de mapa a plot
tmap_mode("plot")

# Creación de mapa con datos públicos --------------------------------------------------------

CSP_PD<-Mapa %>% 
  tm_shape()+
  tm_borders()+
  tm_shape(mapa_data)+
  tm_fill("porcentaje_diabeticos_ensanut", id= "nomgeo", palette= "Blues", style= "quantile",
          title= "Porcentaje de prevalencia de diabetes por estado")+
  tm_layout(main.title = "Distribución estatal de centros de salud pública con prevalecia de diabetes ",
            main.title.position = "center",
            main.title.size = 1.4,
            bg.color= "grey91",
            legend.position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"), width = 0.30)+
  tm_compass(position = c("left", "center"), size = 2)+
  tm_borders("grey25", alpha=.5)+
  tm_shape(centros_salud_pub)+
  tm_dots(size = 0.04,
          col= "orangered4")

#Guardamos el mapa en un .png
tmap_save(CSP_PD, filename = "Distribución estatal de centros de salud pública con prevalecia de diabetes.png")


# Creación de mapa con datos privados --------------------------------------------------------

CSP2_PD<-Mapa %>% 
  tm_shape()+
  tm_borders()+
  tm_shape(mapa_data)+
  tm_fill("porcentaje_diabeticos_ensanut", id= "nomgeo", palette= "Blues", style= "quantile",
          title= "Porcentaje de prevalencia de diabetes por estado")+
  tm_layout(main.title = "Distribución estatal de centros de salud privada con prevalecia de diabetes ",
            main.title.position = "center",
            main.title.size = 1.4,
            bg.color= "grey91",
            legend.position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"), width = 0.30)+
  tm_compass(position = c("left", "center"), size = 2)+
  tm_borders("grey25", alpha=.5)+
  tm_shape(centros_salud_priv)+
  tm_dots(size = 0.04,
          col = "forestgreen" )

#Guardamos el mapa en un .png
tmap_save(CSP2_PD, filename = "Distribución estatal de centros de salud privada con prevalecia de diabetes.png")