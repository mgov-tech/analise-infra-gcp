# Inventário de Recursos para Remoção - Projeto movva-datalake

Data de início: 14/05/2025
Responsável: Arquiteto Cloud

## 1. Discos Persistentes

**Observação:** Não foram encontrados discos persistentes no projeto movva-datalake, apesar das VMs desligadas. A verificação foi realizada em 14/05/2025.

| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Última Utilização | Status | Snapshot Criado | Data Remoção |
|---------------|------|--------------|--------------|-------------------|--------|----------------|--------------|
| | | | | | | | |

## 2. Snapshots Antigos

| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Data de Criação | Idade (dias) | Status | Data Remoção |
|------------------|--------------|-----------------|-----------------|--------------|--------|--------------|  
| airbyte-recovery--2023-06-23--14h43 | 30 | airbyte-prod | 2023-06-23 | 691 | A remover | |
| | | | | | | |

## 3. IPs Estáticos

| Nome do IP | Endereço | Região | Recurso Associado | Status | Data Remoção |
|------------|----------|--------|-------------------|--------|--------------|  
| airbyte-prod | 34.23.150.23 | us-east1 | airbyte-prod (VM TERMINATED) | IN_USE | |
| | | | | | |

## 4. Versões de App Engine

**Observação:** Não foi encontrada nenhuma instância de App Engine no projeto movva-datalake. A verificação foi realizada em 14/05/2025.

| Serviço | Versão | Data de Deploy | Última Utilização | Status | Data Remoção |
|---------|--------|----------------|-------------------|--------|--------------|
| | | | | | |

## Resumo de Economia

| Tipo de Recurso | Quantidade Removida | Economia Mensal Estimada (R$) |
|-----------------|---------------------|-------------------------------|
| Discos Persistentes | | |
| Snapshots | | |
| IPs Estáticos | | |
| Versões App Engine | | |
| **Total** | | |
