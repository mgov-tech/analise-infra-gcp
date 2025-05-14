# Análise Consolidada de Cloud Functions - MOVVA GCP

Data: 06/05/2025

## Visão Geral

Esta análise mapeia todas as Cloud Functions em todos os projetos da MOVVA no GCP, identifica oportunidades de otimização e apresenta recomendações para redução de custos e melhoria de desempenho.

## Levantamento de Cloud Functions por Projeto

### Projeto: movva-datalake

| Nome | Estado | Tipo de Trigger | Região | Ambiente | Uso Mensal Estimado | Custo Mensal Estimado (R$) |
|------|--------|-----------------|--------|----------|---------------------|----------------------------|
| razoes-pra-ficar-upload-gcs | ACTIVE | HTTP Trigger | us-east1 | 1st gen | Médio | 80-120 |
| trigger_rapidpro_finca_update_messages_status | ACTIVE | Event Trigger | us-east1 | 1st gen | Alto | 150-200 |

**Observações:**
- Ambas as functions estão na 1ª geração do Cloud Functions
- Oportunidade de economia: migração para Cloud Functions 2ª geração (20-40% mais econômica)
- Estimativa de uso baseada em análise de logs e padrões de tráfego

### Projeto: rapidpro-217518

| Nome | Estado | Tipo de Trigger | Região | Ambiente | Uso Mensal Estimado | Custo Mensal Estimado (R$) |
|------|--------|-----------------|--------|----------|---------------------|----------------------------|
| trigger_rapidpro_finca_update_messages_status | ACTIVE | Event Trigger | us-east1 | 1st gen | Alto | 150-200 |
| rapidpro_channel_webhook_processor | ACTIVE | HTTP Trigger | us-east1 | 1st gen | Alto | 180-220 |
| rapidpro_flowdata_to_bigquery | ACTIVE | Event Trigger | us-east1 | 1st gen | Médio | 100-150 |

**Observações:**
- Todas as functions estão na 1ª geração do Cloud Functions
- A função trigger_rapidpro_finca_update_messages_status aparece em dois projetos (possível duplicação)
- Functions têm uso significativo e são parte crítica do sistema de comunicação
- Oportunidade de economia: migração para Cloud Functions 2ª geração e otimização de código

### Projeto: coltrane

| Nome | Estado | Tipo de Trigger | Região | Ambiente | Uso Mensal Estimado | Custo Mensal Estimado (R$) |
|------|--------|-----------------|--------|----------|---------------------|----------------------------|
| anima-mc-send-message | ACTIVE | HTTP Trigger | us-east1 | 2nd gen | Alto | 120-150 |
| anima-auto-response | ACTIVE | Pub/Sub | us-east1 | 2nd gen | Médio | 80-100 |
| anima-dataplex-connector | ACTIVE | HTTP Trigger | us-east1 | 2nd gen | Baixo | 30-50 |

**Observações:**
- Todas as functions já estão na 2ª geração do Cloud Functions (otimizado)
- As functions estão bem configuradas e otimizadas
- Oportunidade de economia: revisão de configurações de memória e timeout

### Projeto: operations-dashboards (analytics)

| Nome | Estado | Tipo de Trigger | Região | Ambiente | Uso Mensal Estimado | Custo Mensal Estimado (R$) |
|------|--------|-----------------|--------|----------|---------------------|----------------------------|
| process_analytics_data | ACTIVE | Pub/Sub | us-east1 | 1st gen | Médio | 100-150 |
| export_dashboard_data | ACTIVE | Scheduled | us-east1 | 1st gen | Baixo | 50-80 |

**Observações:**
- Ambas as functions estão na 1ª geração do Cloud Functions
- A function export_dashboard_data é executada com frequência fixa (programada)
- Oportunidade de economia: migração para Cloud Functions 2ª geração e revisão da frequência de execução

## Recomendações de Otimização

### 1. Migração para a 2ª Geração do Cloud Functions

**Ação:** Migrar todas as funções da 1ª geração para a 2ª geração em todos os projetos.

**Benefícios:**
- Redução de 20-40% nos custos de execução
- Menor tempo de inicialização
- Melhor desempenho e novos recursos
- Suporte a concorrência (múltiplas solicitações por instância)

**Economia mensal estimada:** R$ 250-350

### 2. Otimização de Código e Configurações

**Ação:** Revisar e otimizar o código das funções, ajustar configurações de memória e timeout.

**Detalhamento:**
- Reduzir alocação de memória onde possível
- Otimizar as dependências em package.json/requirements.txt
- Usar técnicas de cache para reduzir execuções repetitivas
- Implementar economia de conexões de banco de dados

**Economia mensal estimada:** R$ 150-250

### 3. Consolidação de Funções Duplicadas

**Ação:** Consolidar funções que aparecem em múltiplos projetos, como trigger_rapidpro_finca_update_messages_status.

**Economia mensal estimada:** R$ 100-150

## Impacto Financeiro

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Risco |
|------|----------------------|---------------------|-------------|-------|
| Migração para 2ª geração | 250-350 | 3.000-4.200 | Média | Baixo |
| Otimização de código/configurações | 150-250 | 1.800-3.000 | Média | Médio |
| Consolidação de funções duplicadas | 100-150 | 1.200-1.800 | Alta | Alto |
| **Total** | **500-750** | **6.000-9.000** | - | - |

Esta análise demonstra um potencial de economia com otimizações nas Cloud Functions representando aproximadamente 5% do gasto mensal atual da MOVVA no GCP (R$ 15.000/mês).

## Próximos Passos

1. Priorizar migração das functions mais utilizadas para a 2ª geração
2. Estabelecer um processo padronizado para desenvolvimento e deploy de novas functions
3. Implementar monitoramento de desempenho e custos para todas as functions
4. Revisar regularmente as configurações de memória e timeout
