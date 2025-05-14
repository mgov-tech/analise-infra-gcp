# Recursos de Dados e Analytics

Esta seção documenta todos os recursos de dados encontrados na infraestrutura GCP da MOVVA.

## Índice de Recursos

- [BigQuery](./bigquery.md) - Data warehouse e análise
- [Cloud SQL](./cloud_sql.md) - Bancos de dados relacionais (PostgreSQL)
- [Orquestração de Dados](./orquestracao.md) - Cloud Composer, Dataflow, Data Catalog

## Resumo por Projeto

### movva-datalake

- **BigQuery APIs** habilitadas:
  - BigQuery API
  - BigQuery Data Transfer API
  - BigQuery Migration API
  - BigQuery Reservation API
  - BigQuery Storage API
- **Cloud SQL**: Nenhum instância encontrada
- **Data Transfer**: **SEM PERMISSÃO** para verificar configurações
- **Cloud Composer/Airflow**: Não encontrado nas regiões verificadas
- **Dataflow**: Nenhum job ativo encontrado
- **Data Catalog**: **SEM PERMISSÃO** - API não habilitada

### movva-splitter

- **Cloud SQL**: **SEM PERMISSÃO** - API não habilitada
- **BigQuery**: Não verificado - foco provável em App Engine

### movva-captcha-1698695351695

- **Cloud SQL**: **SEM PERMISSÃO** - API não habilitada
- **BigQuery**: Não aplicável - projeto focado em reCAPTCHA

## Recomendações de Otimização

Veja o documento completo de recomendações em [Otimização de Dados](../otimizacao/dados.md).
