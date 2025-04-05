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
#cargar el archivo shp de la INEGI
Mapa= read_sf("DATA/conjunto_de_datos/00ent.shp")%>% 
  janitor::clean_names()

# Mapa insulina --------------------------------------------------------
#Cargar el archivo correspondiente a insulina y filtrarlo por los que contienen 100ui 
pp= read.csv(file.choose()) %>% 
  filter(str_detect(tolower(dosis), "100 ui|100 u"))
#Agregar los ceros que puedan faltar en el cvegeo
pp$cvegeo <- ifelse(pp$cvegeo<10, paste(0,pp$cvegeo,sep=""), pp$cvegeo)


#Creamos un resumen de los datos para sacar el promedio
resumen1=pp%>% 
  mutate(cvegeo = as.character(cvegeo)) %>% 
  group_by(cvegeo, anio) %>% 
  summarise(valor_promedio= mean(valor_unitario_real,na.rm=TRUE), cantidad_promedio= mean(cantidad,na.rm=TRUE))

#Unimos los DF en uno solo que contenga info del shp y del csv 
mapa_data1 <- left_join(Mapa,resumen1,by="cvegeo")

#Ponemos el modo del mapa en plot
tmap_mode("plot")

str(mapa_data)

#Creamos el mapa con información de los DF que creamos
PP_A<-Mapa %>%
  tm_shape()+
  tm_borders("grey25", alpha=.5)+
  tm_shape(mapa_data1)+
  tm_fill("valor_promedio", id= "nomgeo", palette= "Oranges", style = "quantile",
          title= "Precios promedio")+
  tm_borders("grey25", alpha=.05)+
  tm_layout(main.title="Precio anual promedio de insulina (100UI) por entidad en MXN",
            main.title.position = "center",
            main.title.size = 1.4,
            bg.color= "grey91",
            legend.position = c("right", "top"))+
  tm_scale_bar(position = c("left", "bottom"), width = 0.30)+
  tm_compass(position = c("left", "center"), size = 1)+
  tm_view(view.legend.position = c("left","bottom"))+ 
  tm_facets(by="anio")

#Guardamos el mapa en una imagen .png
tmap_save(PP_A, filename = "Precios anuales promedio de insulina por entidad .png")

# Mapa metformina --------------------------------------------------------
#Cargamos los datos de metformina solo para aquellos con 850 mg
ps= read.csv(file.choose())%>% 
  janitor::clean_names() %>% 
  filter(str_detect(tolower(dosis), "850 mg|50/850 mg|12.5 mg/850 mg| 50 mg/850 mg|5 mg/850 mg| 2.5 mg/850 mg"))
ps$cvegeo <- ifelse(ps$cvegeo<10, paste(0,ps$cvegeo,sep=""), ps$cvegeo)


#Creamos un resumen que saque el promedio de los datos
resumen2=ps%>% 
  mutate(cvegeo = as.character(cvegeo)) %>% 
  group_by(cvegeo, ano) %>% 
  summarise(valor_promedio= mean(unitario_def,na.rm=TRUE), cantidad_promedio= mean(cantidad,na.rm=TRUE))

#Combinamos los datos en un DF
mapa_data2 <- left_join(Mapa,resumen2,by="cvegeo")

#Ponemos el modo del mapa en plot
tmap_mode("plot")


#Creación del mapa con los datos de nuestro Df
PP_S<-Mapa %>%
  tm_shape()+
  tm_borders("grey25", alpha=.5)+
  tm_shape(mapa_data2)+
  tm_fill("valor_promedio", id= "nomgeo", palette= "Oranges", 
          breaks= c(0,8,13,30,50,13439),
          labels = c("0 a 8", "8 a 13", "13 a 30","30 a 50","50 a más"),
          title= "Precios promedio")+
  tm_borders("grey25", alpha=.05)+
  tm_layout(main.title="Precio anual promedio de metformina (850 mg) por entidad en MXN",
            main.title.position = "center",
            main.title.size = 1.2,
            bg.color= "grey91",
            legend.position = c("right", "top"))+
  tm_scale_bar(position = c("left", "bottom"), width = 0.30)+
  tm_compass(position = c("left", "center"), size = 1)+
  tm_view(view.legend.position = c("left","bottom"))+ 
  tm_facets(by="ano")

#Guardamos el mapa en un .png
tmap_save(PP_S, filename = "Precios anuales promedio de metformina (850) por entidad .png")