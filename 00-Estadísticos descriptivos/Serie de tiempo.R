library(ggplot2)
library(dplyr)

setwd("~/Desktop/Reto")

datos <-read.csv("Metformina2.csv")

datos %>% ggplot(aes(x=year,y=unitario_real,colour=tipo_procedimiento,shape=entidad_federativa))+
  geom_line()+
  geom_point()+
  scale_shape_manual(values = 1:32)

sum(is.na(datos$entidad_federativa))

datos2<-datos %>% group_by(entidad_federativa,tipo_procedimiento,year) %>% summarise(promedio=mean(unitario_real))

datos2 %>% ggplot(aes(x=year,y=promedio,colour=tipo_procedimiento,shape=entidad_federativa))+
  geom_line()+
  geom_point()+
  scale_shape_manual(values = 1:35)

datos2 %>%filter(entidad_federativa=="Tabasco") %>% ggplot(aes(x=year,y=promedio,colour=tipo_procedimiento,shape=entidad_federativa))+
  geom_line()+
  geom_point()+
  scale_shape_manual(values = 1:32)
