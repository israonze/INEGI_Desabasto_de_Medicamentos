######
### Haremos la prueba de raiz unitaria en panel
#####
#### Cargamos los datos y limpiamos el environment
## Nota usese los datos de insulina
rm(list = ls())
ls()

setwd("C:/Users/oliva/OneDrive/Escritorio/Datos")
library(tidyverse)
library(purrr)
library(plm)
library(stargazer)
library(ggplot2)


insulina <- read.csv("Base_Insulina.csv")%>%
  group_by(cvegeo)

# Agregamos 0 a los datos de cvegeo menores a 10
insulina$cvegeo <- ifelse(insulina$cvegeo<10, paste(0,insulina$cvegeo,sep=""), insulina$cvegeo)

# Vemos el tamaño de cvegeo para poder ordenarlos de manera correcta
for(i in unique(insulina$cvegeo)){
  print(i)
  print(nrow(subset(insulina, insulina$cvegeo== i)))
}

#Generamos la variable Date como una fecha con el formato establecido y dejamos las variables importantes a usar

insulina$date<-as.Date(insulina$Fecha, format= "%d/%m/%Y")
insulina <- insulina[,c("date","Estado","cvegeo","precio_prom_def")]

#Creamos un data frame con un indice que una el estado y la fecha
insulina_p <- pdata.frame(insulina, index=c("Estado", "date"))
insulina_p$precio_prom_num<- as.numeric(insulina_p$precio_prom_def)

#### Pesaran (2007)

## cipstest: Cross-sectionally Augmented IPS Test for Unit Roots in Panel Models
## description : Cross-sectionally augmented Im, Pesaran and Shin (IPS) test for unit roots in panel models.
## details : This cross-sectionally augmented version of the IPS unit root   test (H0: the pseries has a unit root)
## is a so-called second-generation panel unit root test: 
##      it is in fact robust against cross-sectional dependence, provided that the default type="cmg" is calculated.
##      Else one can obtain the standard (model="mg") or cross-sectionally demeaned (model="dmg") versions of the IPS test.
## Realizamos el test de Pesaran(2007) con trend

test_var<-c("precio_prom_def")

resultados <-data.frame(c(0,0,0))

for (i in c(4)) {
  for (tipo in c("trend", "drift", "none")) {
    resultados_tipo <-vector()
    for (lag in c(0,1,2)) {
      prueba <-cipstest(insulina_p[,i],lags=lag, type = tipo, model ="dmg")
      resultados_tipo[lag+1]<-prueba$statistic[[1]]
    }    
    resultados_df<-as.data.frame(resultados_tipo)
    colnames(resultados_df)<-paste(test_var[i-3],tipo,sep = "_")
    resultados<-cbind.data.frame(resultados,resultados_df)
  }
}

resultados <- round(resultados[,-1],2)

ggplot(insulina_p, aes(x=date, y=precio_prom_num))+
  geom_line(aes(color= factor(Estado)))
