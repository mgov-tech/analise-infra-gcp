# Recursos de Armazenamento GCP

Esta seção documenta todos os recursos de armazenamento encontrados na infraestrutura GCP da MOVVA.

## Índice de Recursos

- [Buckets Cloud Storage](./buckets.md) - Armazenamento de objetos
- [Discos Persistentes](./discos_persistentes.md) - Discos associados a VMs
- [Snapshots](./snapshots.md) - Backups de discos (a verificar - sem permissão)

## Resumo por Projeto

### movva-datalake

- **19 Buckets** identificados, incluindo:
  - Buckets primários de dados (`movva-datalake`)
  - Buckets para frameworks de processamento (`databricks-*`)
  - Buckets para Airflow (`us-east1-movva-airflow-*`)
  - Buckets para aplicações específicas (`razoes-pra-ficar`, `poc-razoes-pra-ficar`)
  - Buckets para armazenamento temporário e de backup

### movva-splitter

- **4 Buckets** identificados, principalmente relacionados ao App Engine:
  - `artifacts.movva-splitter.appspot.com/`
  - `movva-splitter.appspot.com/`
  - `staging.movva-splitter.appspot.com/`
  - `us.artifacts.movva-splitter.appspot.com/`

### movva-captcha-1698695351695

- Sem recursos de armazenamento identificados (sem permissão completa)

## Recomendações de Otimização

Veja o documento completo de recomendações em [Otimização de Armazenamento](../otimizacao/armazenamento.md).
