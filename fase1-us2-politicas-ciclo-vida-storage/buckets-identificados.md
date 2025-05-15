# Buckets Identificados no GCP

Data: 14/05/2025

## Resumo dos Buckets Encontrados

Total de buckets identificados: 19

## Detalhamento por Nome de Bucket

| Nome do Bucket | Projeto (Provável) | Localização | Classe de Armazenamento | Data de Criação | Observações |
|----------------|---------------------|------------|----------------------|-----------------|-------------|
| backup-recoveries | A determinar | US | COLDLINE | 28/11/2022 | Já em classe econômica |
| cloud-ai-platform-2fe0d508-611e-459b-8d25-e33f5c288acf | coltrane (provável) | US-CENTRAL1 | REGIONAL | 13/08/2021 | Bucket do Vertex AI |
| databricks-4138051524165097 | movva-datalake (provável) | US-EAST1 | STANDARD | 21/10/2021 | Databricks |
| databricks-4138051524165097-system | movva-datalake (provável) | US-EAST1 | STANDARD | 21/10/2021 | Sistema Databricks |
| databricks-851498650456327 | movva-datalake (provável) | US-EAST1 | STANDARD | 22/03/2023 | Databricks |
| databricks-851498650456327-system | movva-datalake (provável) | US-EAST1 | STANDARD | 22/03/2023 | Sistema Databricks |
| databricks_bigquery_temp_storage | operations-dashboards (provável) | US | STANDARD | 03/04/2023 | Armazenamento temporário |
| dataprep-staging-4d1e8ff0-d09e-4a93-a525-44a24abffb53 | operations-dashboards (provável) | US | MULTI_REGIONAL | 25/04/2022 | Dataprep |
| gcf-sources-490115063341-us-east1 | A determinar | US-EAST1 | STANDARD | 02/09/2021 | Cloud Functions |
| movva-datalake | movva-datalake | US | STANDARD | 10/06/2021 | Bucket principal |
| movva-datalake-us-notebooks | movva-datalake | US | STANDARD | 04/05/2022 | Notebooks |
| movva-legacy | A determinar | US-EAST1 | NEARLINE | 19/07/2021 | Dados legados, já em Nearline |
| movva-sandbox | A determinar | US | STANDARD | 08/06/2021 | Ambiente de sandbox |
| movva_datalake_bigquery_backup | movva-datalake | US-EAST1 | NEARLINE | 04/09/2024 | Backup do BigQuery, já em Nearline |
| poc-razoes-pra-ficar | rapidpro-217518 (provável) | US-EAST1 | STANDARD | 27/04/2022 | POC |
| razoes-pra-ficar | rapidpro-217518 (provável) | US | STANDARD | 05/04/2022 | |
| us-east1-movva-airflow-0c63c8d9-bucket | movva-datalake | US-EAST1 | STANDARD | 22/05/2023 | Airflow |
| us-east1-movva-airflow-b52650f7-bucket | movva-datalake | US-EAST1 | STANDARD | 19/05/2023 | Airflow |
| us.artifacts.movva-datalake.appspot.com | movva-datalake | US | STANDARD | 02/09/2021 | App Engine artifacts |

## Análise Preliminar

- **14 buckets** estão na classe **STANDARD** (73.7%)
- **2 buckets** estão na classe **NEARLINE** (10.5%)
- **1 bucket** está na classe **COLDLINE** (5.3%)
- **1 bucket** está na classe **MULTI_REGIONAL** (5.3%)
- **1 bucket** está na classe **REGIONAL** (5.3%)

## Candidatos Prioritários para Políticas de Ciclo de Vida

1. **Candidatos Prioritários** (classe STANDARD):
   - movva-datalake
   - movva-datalake-us-notebooks
   - movva-sandbox
   - razoes-pra-ficar
   - poc-razoes-pra-ficar

2. **Candidatos Secundários** (buckets de sistema que precisam de análise específica):
   - Buckets Databricks
   - Buckets Airflow
   - Outros buckets de sistema

## Próximos Passos

1. Confirmar o projeto correto de cada bucket
2. Obter detalhes sobre tamanho, quantidade de objetos e data de último acesso
3. Classificar buckets por padrão de acesso para definir políticas adequadas
