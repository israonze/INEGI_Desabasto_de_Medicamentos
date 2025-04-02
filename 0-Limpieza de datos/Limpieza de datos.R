# Limpiamos el environment

rm(list = ls())
ls()

#Fijamos el directorio de trabajo

setwd("C:/Users/oliva/OneDrive/Escritorio/Datos")

#Cargamos la libreria de trabajo

library(tidyverse)
library(purrr)


#Cargamos los datos de prevalencia de diabetes

Prevalencia_diab= read.csv("por_estado_diabetes.csv", fileEncoding = "Latin1", check.names = F) %>% 
  janitor::clean_names() %>%
  rename(cvegeo=enti) %>% 
  select(cvegeo, porcentaje_diabeticos_ensanut,diab)
Prevalencia_diab$cvegeo <- ifelse(Prevalencia_diab$cvegeo<10, paste(0,Prevalencia_diab$cvegeo,sep=""), Prevalencia_diab$cvegeo)

#cargamos los centros de salud privada de la DENUE

centros_salud= read.csv("INEGI_DENUE_14112022.csv", fileEncoding = "Latin1", check.names = F) %>% 
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

#cargamos los datos de pobreza por entidad  
Pobreza_lab= read.csv("ITLP_estatal_1T22.csv", fileEncoding = "UTF-8", check.names = F) %>% 
  janitor::clean_names() %>% 
  filter(str_detect(tolower(ano), "2018|2019|2020|2021")) %>% 
  rename(cvegeo=clave_ent,
         año=ano) %>% 
  select(año, cvegeo, itlp_is)%>%
  rename(anio = año)

Pobreza_lab$cvegeo <- ifelse(Pobreza_lab$cvegeo<10, paste(0,Pobreza_lab$cvegeo,sep=""), Pobreza_lab$cvegeo)

#Cargamos la base de medicamentos, separamos la especificación para que su tratado sea mas facil y creamos una variable con el med. genérico 

Base= read_csv("INP_PP_CAB18.csv", locale=locale(encoding="latin1"))%>%
  janitor::clean_names()%>%
  glimpse()%>%
  extract(especificaci_a3n, c("nombre", "Especificacion"), "([^,]+), ([^)]+)")%>%
  glimpse()%>%
  mutate(generico= case_when( 
    nombre== "AGLUMENT"~ "Metformina",
    nombre== "AKSPRI"~ "Metformina",
    nombre== "ANGLUCID"~ "Metformina",
    nombre== "BI-EUGLUCON M"~ "Metformina",
    nombre== "BLUCOVANCE"~ "Metformina",
    nombre== "COMPETACT"~ "Metformina",
    nombre== "DABEX"~ "Metformina",
    nombre== "DABEX METFORMINA"~ "Metformina",
    nombre== "DABEX XR"~ "Metformina",
    nombre== "DABEX-XR"~ "Metformina",
    nombre== "DIABEX"~ "Metformina",
    nombre== "DIMEFOR"~ "Metformina",
    nombre== "DIMEFOR DUAL"~ "Metformina",
    nombre== "DIMEFOR G"~ "Metformina",
    nombre== "DIMEFOR T"~ "Metformina",
    nombre== "DIMEFOR XR"~ "Metformina",
    nombre== "DIMEFOR-G"~ "Metformina",
    nombre== "DIMEFORT"~ "Metformina",
    nombre== "DINAMEL"~ "Metformina",
    nombre== "DINORAX"~ "Metformina",
    nombre== "DINORAX-C"~ "Metformina",
    nombre== "DUO-AGLUCID"~ "Metformina",
    nombre== "ESTUVINA"~ "Metformina",
    nombre== "FICONAX"~ "Metformina",
    nombre== "GLIMETAL"~ "Metformina",
    nombre== "GLIMETAL LEX"~ "Metformina",
    nombre== "GLINORBORAL"~ "Metformina",
    nombre== "GLUCOP"~ "Metformina",
    nombre== "GLUCOPHAGE"~ "Metformina",
    nombre== "GLUCOPHAGE XR"~ "Metformina",
    nombre== "GLUCOVACE"~ "Metformina",
    nombre== "GLUCOVANCE"~ "Metformina",
    nombre== "GLUCOVAC"~ "Metformina",
    nombre== "IFOR"~ "Metformina",
    nombre== "INSOGEN PLUS"~ "Metformina",
    nombre== "MAVIGLIN"~ "Metformina",
    nombre== "MELLITRON"~ "Metformina",
    nombre== "METFORMINA"~ "Metformina",
    nombre== "METFORMINA GI"~ "Metformina",
    nombre== "METFORMINA GLIBENCLAMIDA"~ "Metformina",
    nombre== "METFORMINA-GLIBENCLAMIDA"~ "Metformina",
    nombre== "METIXOR"~ "Metformina",
    nombre== "METIXTOR"~ "Metformina",
    nombre== "MEVICFOR"~ "Metformina",
    nombre== "MEVICFOR GI"~ "Metformina",
    nombre== "PREDIAL"~ "Metformina",
    nombre== "PREDIAL PLUS"~ "Metformina",
    nombre== "PRE-DIAL PLUS"~ "Metformina",
    nombre== "WADIL"~ "Metformina",
    nombre== "XIGDUO XR"~ "Metformina",
    nombre== "XILIARXS-DUO"~ "Metformina",
    nombre== "HUMALOG"~ "Insulina",
    nombre== "HUMALOG DE 100ML"~ "Insulina",
    nombre== "HUMALOG MIX"~ "Insulina",
    nombre== "HUMALOG MIX 25"~ "Insulina",
    nombre== "HUMULIN"~ "Insulina",
    nombre== "HUMULIN N"~ "Insulina",
    nombre== "HUMULIN R"~ "Insulina",
    nombre== "INSULEX"~ "Insulina",
    nombre== "INSULEX N"~ "Insulina",
    nombre== "INSULINA"~ "Insulina",
    nombre== "INSULINA GLARGINA"~ "Insulina",
    nombre== "INSULINA NPH"~ "Insulina",
    nombre== "INSULINE N P H"~ "Insulina",
    nombre== "LANTUS"~ "Insulina",
    nombre== "LANTUS SOLOSTAR"~ "Insulina",
    nombre== "UMULIN"~ "Insulina"))%>%
# Creamos una variable del tipo de aplicación del medicamento, otra con la cantidad y la unidad de la dosis y la separamos 
  glimpse()%>%
  mutate(tipo=str_extract(tolower(Especificacion), "tab|suspen|SUSPENSION|tabs|polvo|SUSPEN|table|tabl|suspension|ampoll|cartucho|ampolleta|ampolletas|tabletas|inyectable|jarabe|grageas|comprimidos|capsulas"),
         tipo= case_when(
           tipo== "tab"~ "tabletas",
           tipo== "suspen"~ "ampolletas",
           tipo== "tabs"~ "tabletas",
           tipo== "polvo"~ "polvo",
           tipo== "table"~ "tabletas",
           tipo== "tabl"~ "tabletas",
           tipo== "suspension"~ "ampolletas",
           tipo== "SUSPENSION"~ "ampolletas",
           tipo== "SUSPEN"~ "ampolletas",
           tipo== "ampoll"~ "ampolletas",
           tipo== "cartucho"~ "cartucho",
           tipo== "ampolleta"~ "ampolletas",
           tipo== "ampolletas"~ "ampolletas",
           tipo== "tabletas"~ "tabletas",
           tipo== "jarabe"~ "jarabe",
           tipo== "grageas"~ "grageas",
           tipo== "comprimidos"~ "comprimidos",
           tipo== "capsulas"~ "capsulas"),
         tipo1= str_extract(tolower(Especificacion),"\\d+\\d? pza|\\d+\\d? de|de \\d+\\d?|c/?\\d+\\d?|\\d+\\d? tab"),
         cantidad_tipo= str_extract(tolower (tipo1), "\\d+\\d?"),
         dosis= str_extract(tolower(Especificacion), "\\d+ mg/ ?\\d+\\.?\\d+| \\d+\\d?gr|\\d+\\d? gr|\\d+\\d?ml|\\d+\\.?\\d+\\d? mg|\\d+\\d? ui/\\d?ml| \\d+\\d? ml/\\d+\\d?ul|\\d+ui|\\d+ ?ui/ ?\\d+ ?ml|\\d+\\d?ui/\\d?ml|\\d+/\\d+\\d?ml|\\d+\\d? ui/\\d?ml|\\d+\\.?\\d+\\d? g|\\d+\\.?\\d? mg|\\d+mg/\\d+mg|\\d+mg/\\d+ mg|\\d+ mg/\\d+ mg|\\d+ mg/ ?\\d+ ?mg|\\d+\\.?\\d?mg|\\d+/\\d+\\.?\\d+\\d?mg|\\d+/\\d+\\d?mg|\\d+/\\d+\\d? mg|\\d+/\\d+\\.?\\d+\\d? mg|\\d+\\.?\\d? mg|\\d+\\.?\\d? ml"),
         cantidad_dosis=as.numeric(str_extract(dosis, "\\d+\\.?\\d?")),
         unidad_dosis= str_extract(dosis, "[ulggrmguiml]+"))%>%
# renombramos la variable aa_o por anio para facilitar su uso, separamos el nombre de la ciudad en ciudad y estado y seleccionamos solo las columnas que usaremos para los procesos posteriores
  rename(anio=aa_o)%>%
  extract(nombre_ciudad, c("Ciudad", "Estado"), "([^,]+), ([^)]+)")%>%
  select(-fecha_pub_dof, -clave_ciudad, -clave_gen_a_c_rico, -divisi_a3n, -grupo, -clase, -subclase, -gen_a_c_rico, 
         -consecutivo, -cantidad, -estatus, -Ciudad, -tipo1, -unidad)%>%
  glimpse()%>%
# Creamos una variable llamada cvegeo la cual es la clave geografica del estado
  mutate(cvegeo= case_when( 
    Estado== "Ags."~ "01",
    Estado== "B.C."~ "02",
    Estado== "B.C.S."~ "03",
    Estado== "Camp."~ "04",
    Estado== "Coah."~ "05",
    Estado== "Col."~ "06",
    Estado== "Chis."~ "07",
    Estado== "Chih."~ "08",
    Estado== "Dgo." ~ "10",
    Estado== "Gto." ~ "11",
    Estado== "Gro." ~ "12",
    Estado== "Hgo." ~ "13",
    Estado== "Jal."~ "14",
    Estado== "Edo. de MÃ©x."~ "15",
    Estado== "Mich." ~ "16",
    Estado== "Mor." ~ "17",
    Estado== "Nay." ~ "18",
    Estado== "N.L." ~ "19",
    Estado== "Oax." ~ "20",
    Estado== "Pue." ~ "21",
    Estado== "Qro." ~ "22",
    Estado== "Q. Roo." ~ "23",
    Estado== "S.L.P." ~ "24",
    Estado== "Sin." ~ "25",
    Estado== "Son." ~ "26",
    Estado== "Tab." ~ "27",
    Estado== "Tamps." ~ "28",
    Estado== "Tlax." ~ "29",
    Estado== "Ver." ~ "30",
    Estado== "Yuc." ~ "31",
    Estado== "Zac." ~ "32",
    Estado== "cdmx" ~ "09"))%>%
  glimpse()

#Creamos un boxplot para cer si los datos tienen outliers que deban quitarse

boxplot(Base$cantidad_dosis)

#Unimos todas las bases
Base<- merge(Base,Prevalencia_diab, by="cvegeo",
             all.x = TRUE,
             sort = F)

Base<- merge(Base,centros_salud, by="cvegeo",
             all.x = TRUE,
             sort = F)

Base <- merge(Base, Pobreza_lab,
              by= c("cvegeo","anio"),
              all.x = TRUE,
              sort = F)

# Filtramos los datos por insulina y metformina y los guardamos por separado y juntos en un csv
Insulina=Base %>% 
  filter(str_detect(tolower(generico), "insulina"))

Metformina=Base %>% 
  filter(str_detect(tolower(generico), "metformina"))

write.csv(Base, "Diabetes.csv")
write.csv(Insulina, "Insulina.csv")
write.csv(Metformina, "Metformina.csv")

