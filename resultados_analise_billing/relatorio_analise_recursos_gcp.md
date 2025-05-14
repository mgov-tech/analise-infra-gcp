# Relatório de Análise de Recursos GCP

Data: 06/05/2025

## Visão Geral de Projetos

Projetos analisados na conta de faturamento MGov (01C8EE-D5051C-C120BC):

- **seduc-sp** - Faturamento ativo: True
- **mgov-infra** - Faturamento ativo: True
- **mgov-demos** - Faturamento ativo: True
- **projeto-cariacica** - Faturamento ativo: True
- **costa-marfim** - Faturamento ativo: True

## Análise de Recursos por Projeto

### Projeto: seduc-sp

#### Informações Básicas

```
createTime: '2020-08-19T19:06:31.172Z'
lifecycleState: ACTIVE
name: SEDUC-SP
parent:
  id: '328745535106'
  type: folder
projectId: seduc-sp
projectNumber: '1065748619203'
```

#### Serviços Ativos

Total de serviços ativos: 35

Principais serviços de computação e armazenamento:

bigquery.googleapis.com             BigQuery API
bigquerystorage.googleapis.com      BigQuery Storage API
bigtable.googleapis.com             Cloud Bigtable API
bigtableadmin.googleapis.com        Cloud Bigtable Admin API
cloudfunctions.googleapis.com       Cloud Functions API
compute.googleapis.com              Compute Engine API
container.googleapis.com            Kubernetes Engine API
containerregistry.googleapis.com    Container Registry API
datastore.googleapis.com            Cloud Datastore API
storage-api.googleapis.com          Google Cloud Storage JSON API
storage-component.googleapis.com    Cloud Storage
storage.googleapis.com              Cloud Storage API

#### Recursos de Armazenamento

Buckets Cloud Storage:

gs://seduc-data/

#### Recursos de Computação

Nenhuma instância VM encontrada ou sem permissão para listar.

Nenhuma Cloud Function encontrada ou sem permissão para listar.

### Projeto: mgov-infra

#### Informações Básicas

```
createTime: '2018-06-29T13:42:23.289Z'
lifecycleState: ACTIVE
name: mgov-infra
parent:
  id: '653442176651'
  type: folder
projectId: mgov-infra
projectNumber: '636709821770'
```

#### Serviços Ativos

Total de serviços ativos: 37

Principais serviços de computação e armazenamento:

bigquery.googleapis.com             BigQuery API
bigquerystorage.googleapis.com      BigQuery Storage API
cloudfunctions.googleapis.com       Cloud Functions API
compute.googleapis.com              Compute Engine API
container.googleapis.com            Kubernetes Engine API
containerregistry.googleapis.com    Container Registry API
datastore.googleapis.com            Cloud Datastore API
firestore.googleapis.com            Cloud Firestore API
run.googleapis.com                  Cloud Run Admin API
runtimeconfig.googleapis.com        Cloud Runtime Configuration API
storage-api.googleapis.com          Google Cloud Storage JSON API
storage-component.googleapis.com    Cloud Storage

#### Recursos de Armazenamento

Nenhum bucket Cloud Storage encontrado ou sem permissão para listar.

#### Recursos de Computação

Nenhuma instância VM encontrada ou sem permissão para listar.

Nenhuma Cloud Function encontrada ou sem permissão para listar.

### Projeto: mgov-demos

#### Informações Básicas

```
createTime: '2018-07-12T15:20:38.278Z'
lifecycleState: ACTIVE
name: mgov-demos
parent:
  id: '653442176651'
  type: folder
projectId: mgov-demos
projectNumber: '652859191266'
```

#### Serviços Ativos

Total de serviços ativos: 37

Principais serviços de computação e armazenamento:

bigquery.googleapis.com              BigQuery API
bigquerystorage.googleapis.com       BigQuery Storage API
cloudfunctions.googleapis.com        Cloud Functions API
compute.googleapis.com               Compute Engine API
container.googleapis.com             Kubernetes Engine API
containerregistry.googleapis.com     Container Registry API
datastore.googleapis.com             Cloud Datastore API
firestore.googleapis.com             Cloud Firestore API
storage-api.googleapis.com           Google Cloud Storage JSON API
storage-component.googleapis.com     Cloud Storage

#### Recursos de Armazenamento

Nenhum bucket Cloud Storage encontrado ou sem permissão para listar.

#### Recursos de Computação

Nenhuma instância VM encontrada ou sem permissão para listar.

Nenhuma Cloud Function encontrada ou sem permissão para listar.

### Projeto: projeto-cariacica

#### Informações Básicas

```
createTime: '2019-09-20T15:43:39.602Z'
lifecycleState: ACTIVE
name: Projeto Cariacica
parent:
  id: '653442176651'
  type: folder
projectId: projeto-cariacica
projectNumber: '811876695559'
```

#### Serviços Ativos

Total de serviços ativos: 18

Principais serviços de computação e armazenamento:

bigquery.googleapis.com           BigQuery API
bigquerystorage.googleapis.com    BigQuery Storage API
cloudfunctions.googleapis.com     Cloud Functions API
compute.googleapis.com            Compute Engine API
datastore.googleapis.com          Cloud Datastore API
storage-api.googleapis.com        Google Cloud Storage JSON API
storage-component.googleapis.com  Cloud Storage

#### Recursos de Armazenamento

Nenhum bucket Cloud Storage encontrado ou sem permissão para listar.

#### Recursos de Computação

Nenhuma instância VM encontrada ou sem permissão para listar.

Nenhuma Cloud Function encontrada ou sem permissão para listar.

### Projeto: costa-marfim

#### Informações Básicas

```
createTime: '2018-11-01T21:27:58.127Z'
lifecycleState: ACTIVE
name: costa-marfim
parent:
  id: '653442176651'
  type: folder
projectId: costa-marfim
projectNumber: '828997537779'
```

#### Serviços Ativos

Total de serviços ativos: 30

Principais serviços de computação e armazenamento:

bigquery.googleapis.com             BigQuery API
bigquerystorage.googleapis.com      BigQuery Storage API
cloudfunctions.googleapis.com       Cloud Functions API
compute.googleapis.com              Compute Engine API
container.googleapis.com            Kubernetes Engine API
containerregistry.googleapis.com    Container Registry API
datastore.googleapis.com            Cloud Datastore API
firestore.googleapis.com            Cloud Firestore API
storage-api.googleapis.com          Google Cloud Storage JSON API
storage-component.googleapis.com    Cloud Storage

#### Recursos de Armazenamento

Nenhum bucket Cloud Storage encontrado ou sem permissão para listar.

#### Recursos de Computação

Nenhuma instância VM encontrada ou sem permissão para listar.

Nenhuma Cloud Function encontrada ou sem permissão para listar.

## Análise Comparativa com Infraestrutura Documentada

Comparação com o documento de infraestrutura consolidada:

| Tipo de Recurso | Mencionado no Documento | Encontrado na Análise |
|----------------|--------------------------|------------------------|
| Buckets Cloud Storage | 15 | 1 |
| VMs Compute Engine | 1 | 0 |
| Cloud Functions | 10 | 0 |

**Observação**: Esta é uma análise simplificada que conta menções no documento, não recursos exatos. Uma análise manual mais detalhada é recomendada.

## Recomendações

Com base na análise realizada, recomendamos:

1. **Configurar Exportação de Billing para BigQuery**: Permitirá análises mais detalhadas de custos.
2. **Revisar Permissões de IAM**: As permissões atuais limitaram o acesso a alguns recursos durante a análise.
3. **Consolidar Recursos**: Considerar a consolidação de recursos entre projetos para otimizar custos.
4. **Implementar Políticas de Economia**: Para recursos de computação, considerar o uso de preemptible VMs ou compromissos de uso.
5. **Revisar Documentação**: Atualizar a documentação de infraestrutura com base nos recursos atualmente em uso.

