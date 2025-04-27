######
### Haremos la misma prueba de raiz unitaria en panel con las series observadas de desapariciones
#####
#### Cargamos los datos
## Nota usese los datos de metformina
rm(list = ls())
ls()

setwd("C:/Users/oliva/OneDrive/Escritorio/Datos")
library(tidyverse)
library(purrr)
library(plm)
library(stargazer)
library(ggplot2)


metformina <- read.csv("base_metformina.csv")%>%
  group_by(cvegeo)

metformina$cvegeo <- ifelse(metformina$cvegeo<10, paste(0,metformina$cvegeo,sep=""), metformina$cvegeo)

for(i in unique(metformina$cvegeo)){
  print(i)
  print(nrow(subset(metformina, metformina$cvegeo== i)))
}


metformina$date<-as.Date(metformina$Fecha, format= "%d/%m/%y")
metformina <- metformina[,c("date","Estado","cvegeo","precio_prom_def")]
metformina_p <- pdata.frame(metformina, index=c("Estado", "date"))
metformina_p$precio_prom_num<- as.numeric(metformina_p$precio_prom_def)

#### Pesaran (2007)

## cipstest: Cross-sectionally Augmented IPS Test for Unit Roots in Panel Models
## description : Cross-sectionally augmented Im, Pesaran and Shin (IPS) test for unit roots in panel models.
## details : This cross-sectionally augmented version of the IPS unit root test (H0: the pseries has a unit root)
## is a so-called second-generation panel unit root test: 
##      it is in fact robust against cross-sectional dependence, provided that the default type="cmg" is calculated.
##      Else one can obtain the standard (model="mg") or cross-sectionally demeaned (model="dmg") versions of the IPS test.
## Realizamos el test de Pesaran(2007) con trend

test_var<-c("precio_prom_def")

resultados <-data.frame(c(0,0))

for (i in c(4)) {
  for (tipo in c("trend", "drift", "none")) {
    resultados_tipo <-vector()
    for (lag in c(0,1)) {
      print(paste(i,tipo,lag))
      prueba <-cipstest(metformina_p[,i],lags=lag, type = tipo, model ="dmg")
      resultados_tipo[lag+1]<-prueba$statistic[[1]]
    }    
    print("Se ejecutaron las pruebas")
    resultados_df<-as.data.frame(resultados_tipo)
    colnames(resultados_df)<-paste(test_var[i-3],tipo,sep = "_")
    resultados<-cbind.data.frame(resultados,resultados_df)
  }
}

resultados <- round(resultados[,-1],2)

ggplot(metformina_p, aes(x=date, y=precio_prom_num))+
  geom_line(aes(color= factor(Estado)))
