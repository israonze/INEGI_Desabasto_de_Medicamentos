library(data.table)
library(sp)
library(rgdal)
library(ggplot2)
library(sf)
library(raster)
library(tidyverse)
library(tmap)

centros_salud = read_sf(file.choose())
privado = centros_salud %>% 
  filter(nombre_act == "Hospitales generales del sector privado")
publico = centros_salud %>% 
  filter(nombre_act != "Hospitales generales del sector privado")

centros_priv = as.data.table(privado)
coordinates(centros_priv) = c("longitud","latitud")
crs.geo1 = CRS("+proj=longlat") 
proj4string(centros_priv) = crs.geo1 

centros_pub = as.data.table(publico)
coordinates(centros_pub) = c("longitud","latitud")
crs.geo2 = CRS("+proj=longlat") 
proj4string(centros_pub) = crs.geo2


mexico = readOGR(dsn = "/Users/palomavila/Desktop/destdv1gw", layer = "destdv1gw")
plot(mexico)
points(centros_priv, pch = 20, col = "steelblue")

plot(mexico)
points(centros_pub, pch = 20, col = "orange")
