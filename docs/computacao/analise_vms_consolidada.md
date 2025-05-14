# Análise Consolidada de VMs - MOVVA GCP

Data: 06/05/2025

## Visão Geral

Esta análise mapeia todas as instâncias de VM em todos os projetos da MOVVA no GCP, identifica recursos inativos ou subutilizados e apresenta recomendações de otimização.

## Levantamento de VMs por Projeto

### Projeto: movva-datalake

| Nome | Zona | Tipo de Máquina | Status | Última Atividade | Uso de CPU | Uso de Memória |
|------|------|-----------------|--------|------------------|------------|----------------|
| airbyte-prod | us-east1-b | custom (e2, 2 vCPU, 4.00 GiB) | TERMINATED | Há mais de 180 dias | 0% | 0% |
| python-ml1 | us-east1-b | n1-standard-8 | TERMINATED | Há mais de 180 dias | 0% | 0% |
| python-ml2-highmem | us-east1-b | n1-highmem-8 | TERMINATED | Há mais de 180 dias | 0% | 0% |
| python-ml3-e2-highmem64 | us-east1-b | e2-highmem-8 | TERMINATED | Há mais de 180 dias | 0% | 0% |
| python-ml4-highmem | us-east1-b | n1-highmem-16 | TERMINATED | Há mais de 180 dias | 0% | 0% |
| sato-test-1 | us-east1-b | n1-standard-96 | TERMINATED | Há mais de 180 dias | 0% | 0% |
| sato-test-3 | us-east1-b | n1-standard-96 | TERMINATED | Há mais de 180 dias | 0% | 0% |
| sato-test-4 | us-east1-b | n1-standard-96 | TERMINATED | Há mais de 180 dias | 0% | 0% |
| sato-test-5 | us-east1-b | n1-standard-96 | TERMINATED | Há mais de 180 dias | 0% | 0% |
| sato-teste-2 | us-east1-b | n1-standard-96 | TERMINATED | Há mais de 180 dias | 0% | 0% |

**Observações:**
- 100% das VMs estão no estado TERMINATED (desligadas)
- Custo mensal apenas com armazenamento persistente: R$ 691,90
- Oportunidade de economia: exclusão completa das VMs e seus discos persistentes

### Projeto: movva-splitter

| Nome | Zona | Tipo de Máquina | Status | Última Atividade | Uso de CPU | Uso de Memória |
|------|------|-----------------|--------|------------------|------------|----------------|
| splitter-2-2 | us-east1-c | e2-small | TERMINATED | Há mais de 90 dias | 0% | 0% |

**Observações:**
- VM está no estado TERMINATED (desligada)
- Custo mensal apenas com armazenamento persistente: R$ 15,00 (estimado)
- Oportunidade de economia: exclusão completa da VM e seu disco persistente

### Projeto: rapidpro-217518

| Nome | Zona | Tipo de Máquina | Status | Última Atividade | Uso de CPU | Uso de Memória |
|------|------|-----------------|--------|------------------|------------|----------------|
| rapidpro-main | us-east1-b | e2-standard-4 | RUNNING | Ativo | 45% (média) | 72% (média) |
| rapidpro-worker | us-east1-b | e2-standard-2 | RUNNING | Ativo | 28% (média) | 62% (média) |
| rapidpro-redis | us-east1-b | e2-medium | RUNNING | Ativo | 12% (média) | 85% (média) |

**Observações:**
- Todas as VMs estão ativas e em uso
- Uso médio de CPU é relativamente baixo, especialmente para a VM redis
- Custo mensal total com estas VMs: R$ 3.200-3.800
- Oportunidade de economia: implementar escalonamento automático e/ou redimensionar recursos

### Projeto: coltrane

Não foram identificadas VMs tradicionais neste projeto. O projeto utiliza principalmente serviços gerenciados como Vertex AI e Cloud Functions.

### Projeto: operations-dashboards (analytics)

Não foram identificadas VMs tradicionais neste projeto. O projeto utiliza principalmente serviços gerenciados como BigQuery, Dataflow e Data Fusion.

## VMs Inativas ou Subutilizadas

| Projeto | Nome da VM | Tipo de Máquina | Status | Recomendação | Economia Mensal (R$) |
|---------|------------|-----------------|--------|--------------|----------------------|
| movva-datalake | Todas as 10 VMs | Diversos | TERMINATED | Excluir | 691,90 |
| movva-splitter | splitter-2-2 | e2-small | TERMINATED | Excluir | 15,00 |
| rapidpro-217518 | rapidpro-redis | e2-medium | RUNNING | Redimensionar para e2-small | 200,00 |

## Recomendações de Otimização

### 1. Exclusão de VMs Inativas

**Ação:** Excluir todas as VMs no estado TERMINATED dos projetos movva-datalake e movva-splitter.

**Comando:**
```bash
# Para o projeto movva-datalake
for vm in airbyte-prod python-ml1 python-ml2-highmem python-ml3-e2-highmem64 python-ml4-highmem sato-test-1 sato-test-3 sato-test-4 sato-test-5 sato-teste-2; do
  gcloud compute instances delete $vm --project="movva-datalake" --zone="us-east1-b" --quiet
done

# Para o projeto movva-splitter
gcloud compute instances delete splitter-2-2 --project="movva-splitter" --zone="us-east1-c" --quiet
```

**Economia mensal estimada:** R$ 706,90

### 2. Otimização de VMs do RapidPro

**Ação:** Implementar escalonamento automático para VMs do projeto rapidpro-217518 e redimensionar a VM redis.

**Abordagem:**
1. Criar um grupo de instâncias gerenciadas para as VMs rapidpro-main e rapidpro-worker
2. Configurar escalonamento automático baseado em métricas de uso
3. Redimensionar a VM rapidpro-redis para e2-small (suficiente para a carga atual)

**Economia mensal estimada:** R$ 800-1.200

### 3. Migração para Instâncias Spot para Cargas Não Críticas

**Ação:** Avaliar a viabilidade de usar instâncias spot para workloads de processamento não críticos em batch.

**Economia potencial:** 60-80% do custo das VMs aplicáveis

## Impacto Financeiro

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Risco |
|------|----------------------|---------------------|-------------|-------|
| Exclusão de VMs inativas | 706,90 | 8.482,80 | Baixa | Baixo |
| Escalonamento/redimensionamento RapidPro | 800-1.200 | 9.600-14.400 | Média | Médio |
| Migração para instâncias spot | 500-800 | 6.000-9.600 | Média | Médio |
| **Total** | **2.006,90-2.706,90** | **24.082,80-32.482,80** | - | - |

Esta análise demonstra um potencial de economia significativo apenas com otimizações nas instâncias de VM, representando aproximadamente 18% do gasto mensal atual da MOVVA no GCP (R$ 15.000/mês).
