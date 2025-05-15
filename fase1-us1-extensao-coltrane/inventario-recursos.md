# Inventário de Recursos para Remoção - Projeto coltrane

Data de início: 14/05/2025
Responsável: Arquiteto Cloud

## 1. VMs Desligadas (TERMINATED)

**Observação:** Não foram encontradas VMs em estado TERMINATED no projeto coltrane. A verificação foi realizada em 14/05/2025.

| Nome da VM | Zona | Estado | Discos Associados | IPs Estáticos | Última Utilização | Observações |
|------------|------|--------|-------------------|---------------|-------------------|-------------|
| N/A | N/A | N/A | N/A | N/A | N/A | Não foram encontradas VMs desligadas |
| | | | | | | |

## 2. Discos Persistentes

**Observação:** Foi encontrado 1 disco persistente no projeto coltrane. Este disco parece estar associado a um cluster GKE (prefixo 'gke-') e está com status READY, o que sugere que está em uso. A verificação foi realizada em 14/05/2025.

| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Última Utilização | Status | Snapshot Criado | Data Remoção |
|---------------|------|--------------|--------------|-------------------|--------|----------------|---------------|
| gke-us-central1-airflo-pvc-4a2af010-42c3-4233-9ca0-4d1b0c87b7e7 | us-central1-c | 2 | GKE | - | READY | N/A | N/A |
| | | | | | | | |

## 3. Snapshots Antigos

**Observação:** Não foram encontrados snapshots no projeto coltrane. A verificação foi realizada em 14/05/2025.

| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Data de Criação | Idade (dias) | Status | Data Remoção |
|------------------|--------------|-----------------|-----------------|--------------|--------|--------------|  
| N/A | N/A | N/A | N/A | N/A | N/A | N/A |
| | | | | | | |

## 4. IPs Estáticos

**Observação:** Foram encontrados 7 IPs estáticos no projeto coltrane. 4 deles estão em uso por balanceadores de carga e 3 estão reservados. Não foram identificados IPs estáticos ociosos para liberação. A verificação foi realizada em 14/05/2025.

| Nome do IP | Endereço | Região | Recurso Associado | Status | Data Remoção |
|------------|----------|--------|-------------------|--------|--------------|  
| coltrane-loadbalancer-ip | 34.96.115.167 | - | coltrane-loadbalancer-frontend, coltrane-http | IN_USE | N/A |
| coltrane-loadbalancer-ip-br | 34.117.207.199 | - | coltrane-loadbalancer-frontend-br, coltrane-http-br | IN_USE | N/A |
| coltrane-loadbalancer-stage-ip | 34.120.43.118 | - | coltrane-loadbalancer-stage-frontend, coltrane-stage-http-frontend | IN_USE | N/A |
| coltrane-loadbalancer-stage-ip-br | 34.117.71.73 | - | coltrane-loadbalancer-stage-frontend-br, coltrane-stage-http-frontend-br | IN_USE | N/A |
| coltrane-loadbalancer-demo-ip | 34.120.47.139 | - | - | RESERVED | N/A |
| coltrane-loadbalancer-demo-ip-br | 34.96.87.123 | - | - | RESERVED | N/A |
| google-managed-services-default | 10.50.32.0 | - | - | RESERVED | N/A |
| | | | | | |

## 5. Versões de App Engine

**Observação:** Foram encontradas mais de 100 versões de App Engine no projeto coltrane, sendo a maioria delas antigas e sem tráfego (mais de 27 versões STOPPED). Existe um grande potencial para otimização através da remoção das versões mais antigas, especialmente as de 2023 e início de 2024. A verificação foi realizada em 14/05/2025.

| Serviço | Versão | Data de Deploy | Status | Tráfego | Observação |
|---------|--------|----------------|--------|---------|-------------|
| default | 20230320t171012 a 20241127t212410 | 2023-03-20 a 2024-11-27 | STOPPED | 0.00 | 27 versões antigas sem tráfego |
| default | 20241128t151206 | 2024-11-28 | SERVING | 1.00 | Versão atual com tráfego |
| stage | 20241122t113731 a 20241128t145440 | 2024-11-22 a 2024-11-28 | STOPPED | 0.00 | 5 versões sem tráfego |
| stage | 20250206t125425 | 2025-02-06 | SERVING | 1.00 | Versão atual com tráfego |
| webapp-stage | Múltiplas versões | 2023-05-04 a 2025-02-26 | SERVING | 0.00 | +50 versões sem tráfego |
| webapp | Múltiplas versões | 2023-02-10 a 2025-02-26 | SERVING | 0.00 | +30 versões sem tráfego |

## Resumo de Economia

| Recurso | Quantidade | Economia Mensal Estimada (R$) | Observações |
|---------|------------|-------------------------------|-------------|
| Versões App Engine | 100+ | R$ 150,00 | As versões antigas de App Engine consomem recursos de armazenamento. A remoção das versões anteriores a 2025 pode gerar economia significativa. |
| IPs Estáticos não utilizados | 2 | R$ 60,00 | Os IPs "coltrane-loadbalancer-demo-ip" e "coltrane-loadbalancer-demo-ip-br" estão reservados, mas não associados a nenhum recurso. |
| **Total** | | **R$ 210,00** | |
