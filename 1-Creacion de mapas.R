rm(list = ls())
ls()

#fijar directorio de trabajo
setwd("C:/Users/jiace/OneDrive/Escritorio/Proyecto INEGI")

# cargar librerias --------------------------------------------------------
library(tidyverse)
library(sf)
library(tmap)

Mapa= read_sf(file.choose()) %>% 
  janitor::clean_names()

centros_salud_pub = read_sf(file.choose()) %>% 
  janitor::clean_names() %>%
  mutate(cvegeo=cve_ent, año=2021 ) %>% 
  filter(nombre_act != "Hospitales generales del sector privado")
  
pp= read.csv(file.choose())
pp$cvegeo <- ifelse(pp$cvegeo<10, paste(0,pp$cvegeo,sep=""), pp$cvegeo)


#filter(str_detect(tolower(año),"2018"))

resumen=pp%>% 
  mutate(cvegeo = as.character(cvegeo),
         valor_unitario = as.numeric(str_remove_all(valor_unitario, "[^[:digit:]]"))/100) %>% 
  group_by(cvegeo, año) %>% 
  summarise(valor_promedio= mean(valor_unitario,na.rm=TRUE), cantidad_promedio= mean(cantidad,na.rm=TRUE))


mapa_data <- left_join(Mapa,resumen,by="cvegeo")
tmap_mode("plot")

str(mapa_data)

Mapa %>% 
  tm_shape()+
  tm_borders()+
  tm_shape(mapa_data)+
  tm_fill("valor_promedio", id= "nomgeo", palette= "Oranges", style= "quantile",title= "Precios promedio")+
  tm_borders("grey25", alpha=.05)+
  tm_layout(title=c("Precio promedio insulina por entidad en 2018","Precio promedio insulina por entidad en 2019","Precio promedio insulina por entidad en 2020","Precio promedio insulina por entidad en 2021"),
            main.title.position = "center") + tm_view(view.legend.position = c("left","bottom"))+ #esto sirve para bajar la leyenda y que no estorbe con el t?tulo 
  tm_facets(by="año")+
  tm_shape(centros_salud_pub)+
  tm_dots(size = 0.003)


glimpse(Mapa)
