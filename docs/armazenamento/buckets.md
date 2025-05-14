# Buckets Cloud Storage

Data da análise: 06/05/2025

## Projeto: movva-datalake

Foram identificados 19 buckets de armazenamento:

| Nome do Bucket | Provável Função |
|----------------|-----------------|
| backup-recoveries | Backups e recuperações de dados |
| cloud-ai-platform-2fe0d508-611e-459b-8d25-e33f5c288acf | Associado a serviços de IA |
| databricks-4138051524165097 | Armazenamento Databricks |
| databricks-4138051524165097-system | Sistema Databricks |
| databricks-851498650456327 | Armazenamento Databricks (secundário) |
| databricks-851498650456327-system | Sistema Databricks (secundário) |
| databricks_bigquery_temp_storage | Armazenamento temporário para integração Databricks-BigQuery |
| dataprep-staging-4d1e8ff0-d09e-4a93-a525-44a24abffb53 | Staging para preparação de dados |
| gcf-sources-490115063341-us-east1 | Código-fonte para Cloud Functions |
| movva-datalake | Bucket principal de dados |
| movva-datalake-us-notebooks | Notebooks para análise de dados |
| movva-legacy | Dados legados/históricos |
| movva-sandbox | Ambiente de teste/desenvolvimento |
| movva_datalake_bigquery_backup | Backups do BigQuery |
| poc-razoes-pra-ficar | POC para aplicação "razões pra ficar" |
| razoes-pra-ficar | Dados para aplicação "razões pra ficar" |
| us-east1-movva-airflow-0c63c8d9-bucket | Airflow/Cloud Composer |
| us-east1-movva-airflow-b52650f7-bucket | Airflow/Cloud Composer (secundário) |
| us.artifacts.movva-datalake.appspot.com | Artefatos de aplicações |

### Detalhes e Observações

- **Ecossistema Databricks**: Múltiplos buckets dedicados ao Databricks indicam uso significativo desta plataforma para processamento de dados
- **Orquestração Airflow**: Buckets dedicados ao Airflow sugerem uso de DAGs para automação de fluxos de dados
- **BigQuery Integration**: Buckets para backups e armazenamento temporário integrado ao BigQuery
- **Aplicação "razões pra ficar"**: Buckets específicos sugerem que esta é uma aplicação importante
- **Ambiente de Desenvolvimento**: Existência de bucket sandbox para testes

### Recomendações de Otimização

- **Políticas de ciclo de vida**: Implementar políticas para migrar dados acessados com menos frequência para classes de armazenamento mais econômicas (Nearline, Coldline)
- **Revisão de buckets POC/sandbox**: Avaliar se os buckets de POC e sandbox ainda são necessários
- **Consolidação de buckets legados**: Considerar consolidação de dados legados e aplicar políticas de ciclo de vida para reduzir custos

## Projeto: movva-splitter

Foram identificados 4 buckets de armazenamento:

| Nome do Bucket | Provável Função |
|----------------|-----------------|
| artifacts.movva-splitter.appspot.com | Artefatos App Engine |
| movva-splitter.appspot.com | Bucket principal App Engine |
| staging.movva-splitter.appspot.com | Ambiente de staging App Engine |
| us.artifacts.movva-splitter.appspot.com | Artefatos regionais App Engine |

### Detalhes e Observações

- Todos os buckets estão vinculados ao serviço App Engine
- A nomenclatura indica que existe uma aplicação hospedada no App Engine
- Estrutura padrão criada pelo Google para aplicações App Engine

### Recomendações de Otimização

- **Verificar uso ativo**: Se o App Engine não estiver em uso ativo, considerar limpeza dos buckets ou encerramento do serviço
- **Revisão de políticas de retenção**: Verificar configurações de retenção para evitar armazenamento desnecessário de versões antigas

## Projeto: movva-captcha-1698695351695

Não foram analisados buckets neste projeto devido ao foco específico em reCAPTCHA Enterprise.
