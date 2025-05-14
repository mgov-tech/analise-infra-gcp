# Análise de Kubernetes e Containers - MOVVA GCP

Data: 06/05/2025

## Visão Geral

Esta análise mapeia todos os clusters Kubernetes (GKE), serviços Cloud Run e outros recursos baseados em containers nos projetos da MOVVA no GCP, identificando oportunidades de otimização e recomendações para redução de custos.

## Clusters Kubernetes (GKE)

### Projeto: coltrane

| Nome do Cluster | Localização | Versão | Nós | Tipo de Máquina | Status | Custo Mensal Estimado (R$) |
|-----------------|-------------|--------|-----|-----------------|--------|----------------------------|
| anima-ai-cluster | us-east1 | 1.26.10-gke.1235 | 3 | e2-standard-4 | RUNNING | 2.500-3.000 |

**Node Pools:**
- **default-pool**: 1 nó, e2-standard-4, sem autoscaling
- **worker-pool**: 2 nós, e2-standard-4, autoscaling (min: 2, max: 5)

**Workloads:**
- Deployments para serviços de IA e processamento
- Jobs em batch para análise de dados
- Serviços com balanceamento de carga interno

**Observações:**
- O cluster está bem dimensionado para a carga atual
- Há margens para otimização nas configurações de autoscaling
- Uso estimado de CPU: 45-60% (média)
- Uso estimado de memória: 65-75% (média)

### Projeto: operations-dashboards (analytics)

| Nome do Cluster | Localização | Versão | Nós | Tipo de Máquina | Status | Custo Mensal Estimado (R$) |
|-----------------|-------------|--------|-----|-----------------|--------|----------------------------|
| etl-processing-cluster | us-east1 | 1.27.3-gke.100 | 2 | e2-standard-2 | RUNNING | 800-1.000 |

**Node Pools:**
- **default-pool**: 2 nós, e2-standard-2, autoscaling (min: 1, max: 3)

**Workloads:**
- Pipelines de ETL/ELT
- Serviços de processamento de dados programados
- Airflow executando em containers

**Observações:**
- O cluster está otimizado para cargas de trabalho em batch
- Uso de recursos abaixo do ideal durante certos períodos do dia
- Oportunidade de otimização com uso de Spot Instances para jobs não críticos

## Serviços Cloud Run

### Projeto: rapidpro-217518

| Nome do Serviço | Região | Instâncias | CPU/Memória | Concorrência | Custo Mensal Estimado (R$) |
|-----------------|--------|------------|------------|--------------|----------------------------|
| rapidpro-api | us-east1 | 1-5 | 1 CPU, 2 GiB | 80 | 300-400 |
| rapidpro-flow-executor | us-east1 | 1-3 | 2 CPU, 4 GiB | 50 | 400-500 |

**Observações:**
- Serviços bem configurados e dimensionados
- Configuração de concorrência adequada
- Oportunidade de otimização com ajustes finos nos limites de autoscaling

### Projeto: coltrane

| Nome do Serviço | Região | Instâncias | CPU/Memória | Concorrência | Custo Mensal Estimado (R$) |
|-----------------|--------|------------|------------|--------------|----------------------------|
| anima-api | us-east1 | 1-10 | 2 CPU, 4 GiB | 30 | 500-600 |
| dataplex-connector | us-east1 | 1-3 | 1 CPU, 2 GiB | 60 | 200-300 |

**Observações:**
- anima-api tem uso variado com picos de demanda
- Configuração de concorrência pode ser aumentada para maior eficiência
- Potencial de economia com ajustes nos parâmetros de escalonamento

## Outros Serviços Baseados em Container

### Projeto: movva-datalake

| Serviço | Tipo | Região | Status | Custo Mensal Estimado (R$) |
|---------|------|--------|--------|----------------------------|
| Airflow (Composer) | Gerenciado | us-east1 | RUNNING | 1.200-1.500 |

**Observações:**
- O ambiente Airflow (Cloud Composer) está bem dimensionado
- Oportunidade de economia com migração para Cloud Composer 2.0 ou solução auto-gerenciada no GKE

## Recomendações de Otimização

### 1. Otimização de Clusters GKE

**Ação:** Implementar Spot Instances para workloads não críticas e ajustar configurações de autoscaling.

**Detalhamento:**
- Criar node pools específicos usando Spot Instances para jobs em batch
- Configurar limites de autoscaling mais agressivos baseados em métricas de uso real
- Implementar budget alerts para monitoramento de custos

**Economia mensal estimada:** R$ 600-800

### 2. Otimização de Cloud Run

**Ação:** Ajustar configurações de CPU/memória e concorrência com base nos padrões de uso.

**Detalhamento:**
- Aumentar concorrência onde o serviço suporta
- Otimizar tamanho das imagens de container
- Implementar estratégias de cache para reduzir inicializações a frio

**Economia mensal estimada:** R$ 200-300

### 3. Migração do Cloud Composer

**Ação:** Avaliar a migração do ambiente Cloud Composer para solução auto-gerenciada no GKE.

**Detalhamento:**
- Comparar custos da solução gerenciada vs. self-managed no GKE
- Implementar CI/CD para facilitar o gerenciamento da solução
- Garantir que práticas de segurança e backup sejam mantidas

**Economia mensal estimada:** R$ 400-600

## Impacto Financeiro

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Risco |
|------|----------------------|---------------------|-------------|-------|
| Otimização de GKE | 600-800 | 7.200-9.600 | Média | Baixo |
| Otimização de Cloud Run | 200-300 | 2.400-3.600 | Baixa | Baixo |
| Migração do Cloud Composer | 400-600 | 4.800-7.200 | Alta | Alto |
| **Total** | **1.200-1.700** | **14.400-20.400** | - | - |

Esta análise demonstra um potencial de economia com otimizações nos serviços de containers e Kubernetes representando aproximadamente 11% do gasto mensal atual da MOVVA no GCP (R$ 15.000/mês).

## Próximos Passos

1. Realizar PoC com Spot Instances para cargas não críticas
2. Criar ambiente de teste para validar as alterações nas configurações de Cloud Run
3. Implementar monitoramento avançado para identificar oportunidades adicionais de otimização
4. Estabelecer processo de revisão regular das configurações dos clusters e serviços
