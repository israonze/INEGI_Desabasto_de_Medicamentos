# Limpiamos el environment para evitar que se cuelen datos no deseados

rm(list = ls())

# Fijamos el directorio de trabajo

setwd("C:/Users/oliva/OneDrive/Escritorio/Datos")

# Cargamos las librerias

library(tidyverse)
library(sf)
library(tmap)

# Cargamos el shapefile el cual contiene el mapa

Mapa_i= read_sf("conjunto_de_datos/00ent.shp") %>% 
  janitor::clean_names()

# Cargamos la base de datos que mapearemos

pp_metf_850= read.csv("base_metformina.csv")%>%
  filter(str_detect(tolower(cantidad_tipo),"30"))%>%
  filter(str_detect(tolower(cantidad_dosis),"850"))%>%
  filter(str_detect(tolower(unidad_dosis),"mg"))

# Se le agrega a la variable cvegeo un 0 a los datos menores que 10 para poder unirlos con el mapa

pp_metf_850$cvegeo <- ifelse(pp_metf_850$cvegeo<10, paste(0,pp_metf_850$cvegeo,sep=""), pp_metf_850$cvegeo)

# Creamos un resumen con los precios promedio por Estado

resumen_850 = pp_metf_850 %>%
  mutate(cvegeo = as.character(cvegeo)) %>%
  group_by(cvegeo, anio, tipo) %>%
  summarise(precio_prom_def= mean(precio_prom_def,na.rm=TRUE))

# Generamos una variable uniendo el mapa y el resumen

mapa_data_metf_850 <- inner_join(Mapa_i,resumen_850,by="cvegeo")
tmap_mode("plot")

# Creamos el mapa con las especificaciones necesarias y asignamos una variable nueva que contenga el mapa

a<-Mapa_i %>% 
  tm_shape()+
  tm_borders("grey25", alpha=.5)+
  tm_shape(mapa_data_metf_850)+
  tm_fill("precio_prom_def", id= "nomgeo", palette= "Oranges", style = "quantile",
          title= "Precios promedio")+
  tm_borders("grey25", alpha=.05)+
  tm_layout(main.title="Precio anual de metformina (850 mg) por entidad en MXN ",
            main.title.position = "center",
            main.title.size = 1.4,
            bg.color= "grey91",
            legend.position = c("right", "top"))+
  tm_scale_bar(position = c("left", "bottom"), width = 0.30)+
  tm_compass(position = c("left", "center"), size = 1)+
  tm_view(view.legend.position = c("left","bottom"))+ 
  tm_facets(by="anio")

# Guardamos el mapa con nombre en formato png en el directorio

tmap_save(a, filename = "metformina_850_mg.png")

#Realizamos lo mismo para el resto de mapas que ocuparemos

############## Insulina

pp_insulina= read.csv("Base_Insulina.csv")%>%
  filter(str_detect(tolower(unidad_dosis),"ml|ui"))
  

pp_insulina$cvegeo <- ifelse(pp_insulina$cvegeo<10, paste(0,pp_insulina$cvegeo,sep=""), pp_insulina$cvegeo)

resumen = pp_insulina%>%
  mutate(cvegeo = as.character(cvegeo)) %>%
  group_by(cvegeo, anio, tipo) %>%
  summarise(precio_prom_def= mean(precio_prom_def,na.rm=TRUE))

mapa_data_insulina <- inner_join(Mapa_i,resumen,by="cvegeo")
tmap_mode("plot")

b<-Mapa_i %>% 
  tm_shape()+
  tm_borders("grey25", alpha=.5)+
  tm_shape(mapa_data_insulina)+
  tm_fill("precio_prom_def", id= "nomgeo", palette= "Oranges", style = "quantile",
          title= "Precios promedio")+
  tm_borders("grey25", alpha=.05)+
  tm_layout(main.title="Precio anual deflactado promedio de insulina (100 ui) por entidad en MXN ",
            main.title.position = "center",
            main.title.size = 1.4,
            bg.color= "grey91",
            legend.position = c("right", "top"))+
  tm_scale_bar(position = c("left", "bottom"), width = 0.30)+
  tm_compass(position = c("left", "center"), size = 1)+
  tm_view(view.legend.position = c("left","bottom"))+ 
  tm_facets(by="anio")

tmap_save(b, filename = "insulina.png")

############## Metformina 500 mg

pp_metf_500= read.csv("base_metformina.csv")%>%
  filter(str_detect(tolower(cantidad_tipo),"60"))%>%
  filter(str_detect(tolower(cantidad_dosis),"500"))%>%
  filter(str_detect(tolower(unidad_dosis),"mg"))

pp_metf_500$cvegeo <- ifelse(pp_metf_500$cvegeo<10, paste(0,pp_metf_500$cvegeo,sep=""), pp_metf_500$cvegeo)


resumen_500 = pp_metf_500 %>%
  mutate(cvegeo = as.character(cvegeo)) %>%
  group_by(cvegeo, anio, tipo) %>%
  summarise(precio_prom_def= mean(precio_prom_def,na.rm=TRUE))


mapa_data_metf_500 <- inner_join(Mapa_i,resumen_500,by="cvegeo")
tmap_mode("plot")

d<-Mapa_i %>% 
  tm_shape()+
  tm_borders("grey25", alpha=.5)+
  tm_shape(mapa_data_metf_500)+
  tm_fill("precio_prom_def", id= "nomgeo", palette= "Oranges", style = "quantile",
          title= "Precios promedio")+
  tm_borders("grey25", alpha=.05)+
  tm_layout(main.title="Precio anual de metformina (60 pzas. de 500 mg) por entidad ",
            main.title.position = "center",
            main.title.size = 1.4,
            bg.color= "grey91",
            legend.position = c("right", "top"))+
  tm_scale_bar(position = c("left", "bottom"), width = 0.30)+
  tm_compass(position = c("left", "center"), size = 1)+
  tm_view(view.legend.position = c("left","bottom"))+ 
  tm_facets(by="anio")

tmap_save(d, filename = "metformina_500_mg.png")
