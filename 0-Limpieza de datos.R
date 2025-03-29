#limpiamos el envirmoment
rm(list = ls())
ls()

#fijar directorio de trabajo
setwd("C:/Users/jiace/OneDrive/Escritorio/Proyecto INEGI")

# cargar librerias --------------------------------------------------------
library(tidyverse)
library(purrr)


# Cargar Datos ------------------------------------------------------------
Diabetes_PASOP16= read_csv("DATA/PAAASOP_2016.csv", locale=locale(encoding="latin1")) %>% 
  janitor::clean_names() %>%
  select(-porcentaje_trimestre1, -porcentaje_trimestre2,
         -porcentaje_trimestre3, -porcentaje_trimestre4, -plurianual,-anos_plurianuales, -tipo_contratacion, -clave_programa_federal) %>% 
  rename(ente_publico=dependencia_entidad) %>% 
  mutate(año=2016,
         clave_cucop= as.numeric(clave_cucop)) %>% 
  filter(str_detect(tolower(producto), "insulina|metformina"),
         !str_detect(tolower(producto), "jeringa|aguja"))


Diabetes_PASOP17= read_csv("DATA/PAAASOP_2017.csv", locale=locale(encoding="latin1")) %>% 
  janitor::clean_names() %>%
  select(-porcentaje_trimestre1, -porcentaje_trimestre2,
         -porcentaje_trimestre3, -porcentaje_trimestre4, -plurianual,-anos_plurianuales, -tipo_contratacion, -clave_programa_federal) %>%
  mutate(año=2017,
         clave_cucop= as.numeric(clave_cucop)) %>% 
  filter(str_detect(tolower(producto), "insulina|metformina"),
         !str_detect(tolower(producto), "jeringa|aguja"))


#Cargar los datos de la PAAASOP
Diabetes_PASOP18= read_csv("DATA/PAAASOP_2018.csv", locale=locale(encoding="latin1"))%>% 
#Limieza de nomgres columnas
    janitor::clean_names() %>%
#seleccionar todas las columnas excepto...
  select(-porcentaje_trimestre1, -porcentaje_trimestre2,
         -porcentaje_trimestre3, -porcentaje_trimestre4, -plurianual,-anos_plurianuales, -tipo_contratacion, -clave_programa_federal) %>%
#crear una columna que contenga el a?o que estamos usando y convertir a valor num?rico la clave cucop  
  mutate(año=2018,
         clave_cucop= as.numeric(clave_cucop)) %>% 
#Hacer un filtro en la columna producto que busque insulina y metformina; adem?s quitar cualquiera que contenga las palabras jeringa y aguja   
  filter(str_detect(tolower(producto), "insulina|metformina"),
         !str_detect(tolower(producto), "jeringa|aguja"))


Diabetes_PASOP19= read_csv("DATA/PAAASOP_2019.csv", locale=locale(encoding="latin1"))%>% 
  janitor::clean_names() %>% 
  select(-porcentaje_trimestre1, -porcentaje_trimestre2,
         -porcentaje_trimestre3, -porcentaje_trimestre4, -plurianual,-anos_plurianuales, -tipo_contratacion, -clave_programa_federal 
  ) %>%
  mutate(año=2019,
         clave_cucop= as.numeric(clave_cucop)) %>%  
  filter(str_detect(tolower(producto), "insulina|metformina"),
         !str_detect(tolower(producto), "jeringa|aguja"))



Diabetes_PASOP20= read_csv("DATA/PAAASOP_2020.csv", locale=locale(encoding="latin1"))%>% 
  janitor::clean_names() %>% 
  select(-ramo_id,-nombre_ramo,-ur, -partida_especifica, -porcentaje_trimestre1, -porcentaje_trimestre2,
         -porcentaje_trimestre3, -porcentaje_trimestre4, -plurianual, 
         -clave_ur, -anios_plurianuales, -valor_total_plurianual) %>% 
  rename(producto=concepto,tipo_procedimiento=nombre,clave_programa_federal=cve_prog_federal) %>%
  mutate(año=2020,
         clave_cucop= as.numeric(clave_cucop)) %>% 
  filter(str_detect(tolower(producto), "insulina|metformina"),
         !str_detect(tolower(producto), "jeringa|aguja"))




Diabetes_PASOP21= read_csv("DATA/PAAASOP_2021.csv", locale=locale(encoding="latin1"))%>% 
  janitor::clean_names() %>% 
  select(-id_ramo,-nombre_ramo, -folio_paaasop, -fecha_de_actualizac_io_n, -id_ur, -ur, -grupo, 
         -partida_espe_ci_fica, -fecha_inicio_obra, -fecha_fin_de_obra, -justificac_io_n_tipo_procedimiento,-x33,
         -porcentaje_trimestre_1_enero_marzo, -porcentaje_trimestre_2_abril_junio,-porcentaje_trimestre_3_julio_septiembre,
         -porcentaje_trimestre_4_octubre_diciembre, -aa_os_en_compras_plurianuales, -valor_total_de_la_compra_plurianual,
         -a_es_plurianual) %>%
  rename(ente_publico=dependencia_entidad_o_ente_pu_blico,clave_cucop=cucop,descripcion_cucop=contratac_io_n, 
         producto=descripc_io_n_espe_ci_fica, valor_mipymes=valor_mipyme,
         valor_nctlc=valor_no_cubierto_en_tratados, caracter_procedimiento=ca_ra_cter_procedimiento,
         clave_programa_federal=programa_federal) %>%
  mutate(año=2021, 
         clave_cucop= as.numeric(clave_cucop)) %>% 
  filter(str_detect(tolower(producto), "insulina|metformina"),
         !str_detect(tolower(producto), "jeringa|aguja"))

#Cargar los datos de prevalencia de diabtes
Prevalencia_diab= read.csv("DATA/por_estado_diabetes.csv", fileEncoding = "Latin1", check.names = F) %>% 
  janitor::clean_names() %>%
  rename(cvegeo=enti) %>% 
  select(cvegeo, porcentaje_diabeticos_ensanut,diab)
Prevalencia_diab$cvegeo <- ifelse(Prevalencia_diab$cvegeo<10, paste(0,Prevalencia_diab$cvegeo,sep=""), Prevalencia_diab$cvegeo)

#cargar los centros de salud privada de la DENUE
centros_salud= read.csv("DATA/INEGI_DENUE_14112022.csv", fileEncoding = "Latin1", check.names = F) %>% 
  janitor::clean_names() %>% 
  rename(cvegeo=clave_entidad) %>%
  group_by(cvegeo, nombre_de_clase_de_la_actividad) %>% 
  summarise(n()) %>% 
  rename(no_m="n()") %>% 
  mutate(nombre_de_clase_de_la_actividad= case_when(
    nombre_de_clase_de_la_actividad== "Hospitales generales del sector privado"~ "priv",
    nombre_de_clase_de_la_actividad== "Hospitales generales del sector público"~ "pub"
  )) %>% 
  as.data.frame()

centros_salud<- reshape(data=centros_salud,idvar="cvegeo",
                        v.names = "no_m",
                        timevar = "nombre_de_clase_de_la_actividad",
                        direction= "wide")
  
  
centros_salud$cvegeo <- ifelse(centros_salud$cvegeo<10, paste(0,centros_salud$cvegeo,sep=""), centros_salud$cvegeo)

#cargar los datos de pobreza por entidad  
Pobreza_lab= read.csv("DATA/ITLP_estatal_1T22.csv", fileEncoding = "UTF-8", check.names = F) %>% 
  janitor::clean_names() %>% 
  filter(str_detect(tolower(ano), "2016|2017|2018|2019|2020|2021")) %>% 
  rename(cvegeo=clave_ent,
         año=ano) %>% 
  select(año, cvegeo, itlp_is)

Pobreza_lab$cvegeo <- ifelse(Pobreza_lab$cvegeo<10, paste(0,Pobreza_lab$cvegeo,sep=""), Pobreza_lab$cvegeo)




# Crear una base que contenga todos los datos que usaremos ------------------------------------------------------------

DiabetesMx= Diabetes_PASOP18 %>%
  bind_rows(Diabetes_PASOP16) %>% 
  bind_rows(Diabetes_PASOP17) %>%
  bind_rows(Diabetes_PASOP19) %>% 
  bind_rows(Diabetes_PASOP20) %>% 
  bind_rows(Diabetes_PASOP21) %>% 
  filter(str_detect(tolower(descripcion_cucop), "insulina|metformina")) %>% 
  mutate(tipo=str_extract(tolower(descripcion_cucop), "tableta|inyectable|jarabe|gragea"),
         dosis= str_extract(tolower(descripcion_cucop), "\\d+\\.?\\d? mg ?/\\d+\\.?\\d? ?mg|\\d+\\.?\\d? mg|\\d+\\.?\\d? ui|\\d+\\.?\\d? ml|\\d+\\/\\d+\\.?\\d+\\d? mg|\\d+\\.?\\d? ml\\/\\d+\\.?\\d+\\d? mg"),
         dosis= if_else(is.na(dosis),str_extract(tolower(producto),"\\d+\\.?\\d? mg ?/\\d+\\.?\\d? ?mg|\\d+\\.?\\d? mg|\\d+\\.?\\d?mg|\\d+\\.?\\d? ui|\\d+\\.?\\d? ml|\\d+\\/\\d+\\.?\\d+\\d? mg|\\d+\\.?\\d? ml\\/\\d+\\.?\\d+\\d? mg"),
                        str_extract(tolower(descripcion_cucop), "\\d+\\.?\\d? mg ?/\\d+\\.?\\d? ?mg|\\d+\\.?\\d? mg|\\d+\\.?\\d? ui|\\d+\\.?\\d? ml|\\d+\\/\\d+\\.?\\d+\\d? mg|\\d+\\.?\\d? ml\\/\\d+\\.?\\d+\\d? mg")),
         cantidad_dosis=as.numeric(str_extract(dosis, "\\d+\\.?\\d?")),
         unidad_dosis= str_extract(dosis, "[mguiml]+"),
         presentacion= str_replace(str_extract(tolower (descripcion_cucop), "\\d+\\.?\\d? tabletas|\\d+\\.?\\d? ampolletas|ampula con \\d+\\.?\\d? ml| \\d+\\.?\\d? plumas| \\d+\\.?\\d? pluma|una pluma| \\d+\\.?\\d? comprimidos| \\d+\\.?\\d? cartuchos| ampula con \\d+\\.?\\d? o \\d+\\.?\\d? ml"), "una","1"),
         cantidad_tipo= str_extract(tolower (presentacion), "\\d+\\.?\\d?" ),
         obj_tipo= str_extract(tolower (presentacion),"tabletas|ampolletas|ampula|plumas|pluma|comprimidos|"))%>%
   mutate( cantidad= round(cantidad, digits = 0),
           valor_unitario= round((valor_estimado/cantidad), digits = 2)) %>% 
  mutate(cvegeo= case_when( 
    entidad_federativa== "Aguascalientes"~ "01",
    entidad_federativa== "Baja California" ~ "02",
    entidad_federativa== "Baja California Sur" ~ "03",
    entidad_federativa== "Campeche" ~ "04",
    entidad_federativa== "Coahuila de Zaragoza" ~ "05",
    entidad_federativa== "Colima" ~ "06",
    entidad_federativa== "Chiapas" ~ "07",
    entidad_federativa== "Chihuahua" ~ "08",
    entidad_federativa== "Ciudad de México" ~ "09",
    entidad_federativa== "Ciudad de Mexico" ~ "09",
    entidad_federativa== "Durango" ~ "10",
    entidad_federativa== "Guanajuato" ~ "11",
    entidad_federativa== "Guerrero" ~ "12",
    entidad_federativa== "Hidalgo" ~ "13",
    entidad_federativa== "Jalisco"~ "14",
    entidad_federativa== "México"~ "15",
    entidad_federativa== "Mexico"~ "15",
    entidad_federativa== "Michoacán de Ocampo" ~ "16",
    entidad_federativa== "Michoacán de Ocampo" ~ "16",
    entidad_federativa== "Michoacan de Ocampo" ~ "16",
    entidad_federativa== "Morelos" ~ "17",
    entidad_federativa== "Nayarit" ~ "18",
    entidad_federativa== "Nuevo León" ~ "19",
    entidad_federativa== "Nuevo Leon" ~ "19",
    entidad_federativa== "Oaxaca" ~ "20",
    entidad_federativa== "Puebla" ~ "21",
    entidad_federativa== "Querétaro" ~ "22",
    entidad_federativa== "Queretaro" ~ "22",
    entidad_federativa== "Quintana Roo" ~ "23",
    entidad_federativa== "San Luis Potosí" ~ "24",
    entidad_federativa== "San Luis Potosi" ~ "24",
    entidad_federativa== "Sinaloa" ~ "25",
    entidad_federativa== "Sonora" ~ "26",
    entidad_federativa== "Tabasco" ~ "27",
    entidad_federativa== "Tamaulipas" ~ "28",
    entidad_federativa== "Tlaxcala" ~ "29",
    entidad_federativa== "Veracruz de Ignacio de la Llave" ~ "30",
    entidad_federativa== "Yucatán" ~ "31",
    entidad_federativa== "Yucatan" ~ "31",
    entidad_federativa== "Zacatecas" ~ "32"
    ))

  #select(-c(A,B))


DiabetesMx<- merge(DiabetesMx,Prevalencia_diab, by="cvegeo",
                   all.x = TRUE,
                   sort = F)

DiabetesMx<- merge(DiabetesMx,centros_salud, by="cvegeo",
                   all.x = TRUEall.x = TRUE,
                   sort = F)

DiabetesMx <- merge(DiabetesMx, Pobreza_lab, 
                    by =c("cvegeo","año"),
                    all.x = TRUE )

# Separar los datos en insulina y metformina ------------------------------------------------------------


  
Insulina=DiabetesMx %>% 
  filter(str_detect(tolower(producto), "insulina"))

Metformina=DiabetesMx %>% 
  filter(str_detect(tolower(producto), "metformina"))

unique(DiabetesMx$entidad_federativa)

# Guardar los tados en un csv ------------------------------------------------------------
#write.csv(DiabetesMx, "DiabetesMx1.csv")
#write.csv(Insulina, "Insulina1.csv")
#write.csv(Metformina, "Metformina1.csv")
