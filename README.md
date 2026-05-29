Big Data CrashCourse [MX] – Módulo 2
Descripción
En este módulo del curso de SoftServe se trabajó con generación y procesamiento de datos tipo PII (información personal).
Se generaron datos sintéticos en formato CSV usando Python y posteriormente se cargaron en PostgreSQL para su consulta en la capa golden_layer. También se realizaron validaciones de calidad como revisión de nulos y duplicados.

Tecnologías usadas

Python
PostgreSQL
pgAdmin
Git / GitHub


## Capas utilizadas

- public
- bronze_layer
- silver_layer
- golden_layer


charpet_2/
│
├── batch_generator.py
├── batch_2026-05-19.csv
├── pii_data.csv
│
├── golden_layer-create_tables.sql
├── golden_layer-payment_data.sql
├── validaciones-nulls_duplicados.sql
│
├── general.png
├── estructura-contenido.png
├── pii_data-1.png
├── pii_data-2.png


## Evidencia

### Resultado de la query (parte 2)
![Resultado](charpet_2/pii_data-1.png)

### Resultado de la query (parte 2)
![Resultado 2](charpet_2/pii_data-2.png)

### Vista general
![General](charpet_2/general.png)

### Estructura
![Estructura](charpet_2/estructura-contenido.png)
