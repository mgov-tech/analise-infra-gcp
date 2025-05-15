# Inventário de Recursos - Projeto movva-splitter

## Data da Análise: 14/05/2025

## 1. VMs Desligadas (TERMINATED)

**Observação:** Foram encontradas 2 VMs em estado TERMINATED no projeto movva-splitter. A verificação foi realizada em 14/05/2025.

| Nome da VM | Zona | Estado | Discos Associados | IPs Estáticos | Última Utilização | Observações |
|------------|------|--------|-------------------|---------------|-------------------|-------------|
| splitter-prod-v1 | us-central1-a | TERMINATED | splitter-prod-v1, splitter-prod-v1-data | 34.72.45.89 | N/A | Aparentemente versão antiga do serviço, substituida por v2 |
| splitter-stage-v1 | us-central1-a | TERMINATED | splitter-stage-v1 | 34.72.46.90 | N/A | Ambiente de staging desativado |

## 2. Discos Persistentes

**Observação:** Foram encontrados 5 discos persistentes no projeto movva-splitter. 3 estão associados a VMs em estado TERMINATED e 2 estão em uso pela VM atual (v2). A verificação foi realizada em 14/05/2025.

| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Última Utilização | Status | Snapshot Criado | Data Remoção |
|---------------|------|--------------|--------------|-------------------|--------|----------------|--------------|  
| splitter-prod-v1 | us-central1-a | 30 | splitter-prod-v1 (TERMINATED) | N/A | READY | Sim | N/A |
| splitter-prod-v1-data | us-central1-a | 100 | splitter-prod-v1 (TERMINATED) | N/A | READY | Sim | N/A |
| splitter-stage-v1 | us-central1-a | 30 | splitter-stage-v1 (TERMINATED) | N/A | READY | Não | N/A |
| splitter-prod-v2 | us-central1-a | 50 | splitter-prod-v2 (RUNNING) | Ativo | READY | Não | N/A |
| splitter-prod-v2-data | us-central1-a | 150 | splitter-prod-v2 (RUNNING) | Ativo | READY | Não | N/A |
| | | | | | | | |

## 3. Snapshots Antigos

**Observação:** Foram encontrados 3 snapshots no projeto movva-splitter. Todos estão associados a discos de VMs em estado TERMINATED, sugerindo que estes são backups feitos antes da migração para a nova versão. A verificação foi realizada em 14/05/2025.

| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Data de Criação | Idade (dias) | Status | Data Remoção |
|------------------|--------------|-----------------|-----------------|--------------|--------|--------------|  
| splitter-prod-v1-backup-2023 | 30 | splitter-prod-v1 | N/A | >700 | READY | N/A |
| splitter-prod-v1-data-backup | 100 | splitter-prod-v1-data | N/A | >700 | READY | N/A |
| splitter-migration-20230715 | 130 | splitter-prod-v1-data | 2023-07-15 | ~670 | READY | N/A |
| | | | | | | |

## 4. IPs Estáticos

**Observação:** Foram encontrados 4 IPs estáticos no projeto movva-splitter. 2 deles estão associados a VMs em estado TERMINATED e 2 estão em uso. A verificação foi realizada em 14/05/2025.

| Nome do IP | Endereço | Região | Recurso Associado | Status | Data Remoção |
|------------|----------|--------|-------------------|--------|--------------|  
| splitter-prod-v1 | 34.72.45.89 | us-central1 | splitter-prod-v1 (TERMINATED) | RESERVED | N/A |
| splitter-stage-v1 | 34.72.46.90 | us-central1 | splitter-stage-v1 (TERMINATED) | RESERVED | N/A |
| splitter-prod-v2 | 34.72.50.120 | us-central1 | splitter-prod-v2 | IN_USE | N/A |
| splitter-lb | 34.72.60.200 | us-central1 | splitter-lb-frontend | IN_USE | N/A |
| | | | | | |

## 5. Versões de App Engine

**Observação:** Foram encontradas 7 versões de App Engine no projeto movva-splitter, sendo 5 versões antigas sem tráfego (STOPPED) e 2 versões atuais com tráfego (SERVING). A verificação foi realizada em 14/05/2025.

| Serviço | Versão | Data de Deploy | Status | Tráfego | Observação |
|---------|--------|----------------|--------|---------|------------|
| splitter-api | 20230510t132045 | 2023-05-10 | STOPPED | 0.00 | Versão antiga sem tráfego |
| splitter-api | 20230715t091230 | 2023-07-15 | STOPPED | 0.00 | Versão antiga sem tráfego |
| splitter-api | 20240305t114523 | 2024-03-05 | STOPPED | 0.00 | Versão antiga sem tráfego |
| splitter-api | 20250212t151233 | 2025-02-12 | SERVING | 1.00 | Versão atual com tráfego |
| splitter-frontend | 20230520t082510 | 2023-05-20 | STOPPED | 0.00 | Versão antiga sem tráfego |
| splitter-frontend | 20240125t110845 | 2024-01-25 | STOPPED | 0.00 | Versão antiga sem tráfego |
| splitter-frontend | 20250305t143022 | 2025-03-05 | SERVING | 1.00 | Versão atual com tráfego |
| | | | | | |

## Resumo de Economia

| Recurso | Quantidade | Economia Mensal Estimada (R$) | Observações |
|---------|------------|-------------------------------|-------------|
| VMs Desligadas (TERMINATED) | 2 | R$ 100,00 | VMs da versão antiga do serviço (v1) |
| Discos Persistentes | 3 | R$ 40,00 | Discos associados às VMs em estado TERMINATED |
| Snapshots | 3 | R$ 30,00 | Snapshots antigos de 2023 |
| IPs Estáticos | 2 | R$ 60,00 | IPs associados às VMs em estado TERMINATED |
| Versões App Engine | 5 | R$ 75,00 | Versões antigas sem tráfego |
| **Total** | | **R$ 305,00** | |
