# BigQuery

Data da análise: 06/05/2025

## Projeto: movva-datalake

### APIs Habilitadas

| API | Descrição | Status |
|-----|-----------|--------|
| bigquery.googleapis.com | BigQuery API | Habilitada |
| bigquerydatatransfer.googleapis.com | BigQuery Data Transfer API | Habilitada |
| bigquerymigration.googleapis.com | BigQuery Migration API | Habilitada |
| bigqueryreservation.googleapis.com | BigQuery Reservation API | Habilitada |
| bigquerystorage.googleapis.com | BigQuery Storage API | Habilitada |

### Datasets

**SEM PERMISSÃO** - Não conseguimos listar os datasets do BigQuery. Necessário obter permissões adicionais para `bigquery.datasets.list`.

### Integrações Identificadas

- Buckets específicos para integração com Databricks (`databricks_bigquery_temp_storage`)
- Buckets de backup para BigQuery (`movva_datalake_bigquery_backup`)
- Possíveis integrações com Cloud Composer/Airflow baseadas nos buckets identificados

### Recomendações de Otimização

- **Tabelas Particionadas**: Implementar particionamento nas tabelas de maior volume para reduzir custos de consulta
- **Clustering**: Adicionar clustering para colunas frequentemente consultadas para melhorar desempenho
- **Análise de Consultas**: Revisar consultas mais frequentes e custosas para otimização
- **Políticas de Retenção**: Implementar políticas para dados históricos, movendo-os para armazenamento de longo prazo
- **Reservas x Sob Demanda**: Avaliar se as reservas atuais são mais econômicas que o modelo sob demanda

## Projeto: movva-splitter

Não foi realizada análise detalhada do BigQuery neste projeto devido ao foco aparente em App Engine.

## Projeto: movva-captcha-1698695351695

Não aplicável - o projeto é focado exclusivamente em reCAPTCHA Enterprise.
