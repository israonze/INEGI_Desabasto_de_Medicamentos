# 📊 LA VARIACIÓN DE PRECIOS DE INSULINA Y METFORMINA  
### Reto para el tratamiento de diabetes en México debido al proceso de compras centralizado

## 🧠 Resumen

Este proyecto analiza el impacto de las decisiones gubernamentales en el mercado farmacéutico durante el actual sexenio, enfocándose específicamente en dos medicamentos esenciales para el tratamiento de la diabetes en México: la **insulina** y la **metformina**.

Se busca responder si las políticas de **compras centralizadas** han tenido implicaciones negativas en los precios de estos medicamentos, afectando su disponibilidad y accesibilidad tanto en el sector **público como privado**.

Para ello, se utilizaron herramientas de análisis como:

- Estadística descriptiva  
- Visualización de datos (gráficos y mapas)  
- Regresiones  
- Comparaciones de precios a lo largo del tiempo y entre sectores  

## 📚 Bases de datos utilizadas

El análisis se desarrolló utilizando las siguientes bases de datos públicas, seleccionadas por su relevancia en los sectores público y privado, así como en salud y economía:

- **PAAASOP (2016–2021):** Programa Anual de Adquisiciones, Arrendamientos y Servicios y Obras Públicas. Captura y actualiza acciones de adquisición realizadas por dependencias y entidades de la administración pública federal. Se utilizó para estudiar el comportamiento del sector **público**.

- **INPP (2018–2022):** Índice Nacional de Precios Productor (INEGI). Mide la variación de los precios de bienes y servicios producidos en el país, para consumo interno y exportación. Se tomó como base para el análisis del sector **privado**.

- **DENUE (2018–2021):** Directorio Estadístico Nacional de Unidades Económicas (INEGI). Proporciona información actualizada de las unidades económicas en el país.

- **ENSANUT (2021):** Encuesta Nacional de Salud y Nutrición. Ofrece información clave sobre el estado de salud y nutrición de las familias mexicanas.

- **Prevalencia de Obesidad, Hipertensión y Diabetes en Municipios (2018):** Estudio del INEGI que estima la proporción de población mayor de 20 años con estas enfermedades a nivel municipal.

📆 **Periodo de estudio:** 2018–2021/22  
Este rango temporal permite observar los cambios en las variables de interés antes y durante las decisiones tomadas en el sexenio actual, con respecto al mercado farmacéutico.

## 🧰 Herramientas utilizadas

- **R / RStudio**
- **Paquetes:** `tidyverse`, `ggplot2`, `sf`, `dplyr`, `readr`, entre otros

## 📁 Estructura del repositorio

📂0-Limpieza de datos.R 
📂00-Estadísticos descriptivos.R 
📂1-Mapa de calor.R 2-Mapa de puntos.R 
📂3-Prueba de raíz unitaria.R 
📂4-Red neuronal.R 
📂5-Regresión lineal.R 
📂6-Regresión OLS.R

## 📌 Conclusiones principales

- Se observó una **variabilidad significativa en los precios** de la insulina y la metformina a lo largo del tiempo.  
- Las políticas de **compras centralizadas** parecen haber generado disrupciones en la cadena de suministro y acceso a medicamentos.  
- Se requieren medidas que combinen eficiencia administrativa con sostenibilidad en la provisión de medicamentos esenciales.  

## ✅ Conclusiones y recomendaciones

Dado el análisis realizado, se **afirma parcialmente la hipótesis** sobre los efectos negativos de las decisiones gubernamentales en el mercado farmacéutico. Esta afirmación se ve limitada por la **falta de datos públicos suficientes**, lo que impidió aplicar métodos analíticos más robustos para ese sector.

No obstante, se identificaron varios hallazgos clave:

- Existe **mala recabación de datos por parte del gobierno**, especialmente evidente durante el sexenio actual.
- En el **sector privado**, la información fue más útil, revelando un posible **poder de mercado estatal**.
- Faltó información crítica sobre la **cadena de producción y transporte**, que suele estar restringida al ámbito privado.

Las decisiones gubernamentales, particularmente el aumento de **adjudicaciones directas** en las compras públicas, sugieren respuestas de emergencia ante los cambios institucionales. Esto se refleja en la **variación de precios** y posibles problemas de acceso.

**Recomendaciones:**

- Crear **mecanismos de control y transparencia**, incluyendo auditorías estatales mensuales y anuales.
- Enfocar las compras públicas en:
  - Las **presentaciones necesarias** de insulina y metformina.
  - Los **estados con mayor necesidad médica**.
- Evitar escasez en el sector público, que obligue a los pacientes a recurrir al sector privado con precios más altos.
- Elaborar un **manual nacional del proceso de compra**, detallando el registro y seguimiento de datos, para mejorar la toma de decisiones basada en evidencia.

---


