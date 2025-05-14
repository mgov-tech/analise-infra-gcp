# Análise de Volumes de Armazenamento Persistente - MOVVA GCP

Data: 06/05/2025

## Visão Geral

Esta análise mapeia todos os volumes de armazenamento persistente (discos) nos projetos da MOVVA, identifica recursos inativos ou subutilizados e apresenta recomendações para otimização de custos.

## Levantamento de Discos por Projeto

### Projeto: movva-datalake

| Nome do Disco | Tipo | Tamanho (GB) | Zona | Status | VM Associada | Custo Mensal Est. (R$) |
|---------------|------|--------------|------|--------|--------------|-------------------------|
| airbyte-prod | pd-standard | 100 | us-east1-b | Idle | airbyte-prod | 18,70 |
| python-ml1 | pd-standard | 250 | us-east1-b | Idle | python-ml1 | 46,75 |
| python-ml2-highmem | pd-standard | 300 | us-east1-b | Idle | python-ml2-highmem | 56,10 |
| python-ml3-e2-highmem64 | pd-standard | 350 | us-east1-b | Idle | python-ml3-e2-highmem64 | 65,45 |
| python-ml4-highmem | pd-ssd | 200 | us-east1-b | Idle | python-ml4-highmem | 68,00 |
| sato-test-1 | pd-standard | 500 | us-east1-b | Idle | sato-test-1 | 93,50 |
| sato-test-3 | pd-standard | 500 | us-east1-b | Idle | sato-test-3 | 93,50 |
| sato-test-4 | pd-standard | 500 | us-east1-b | Idle | sato-test-4 | 93,50 |
| sato-test-5 | pd-standard | 500 | us-east1-b | Idle | sato-test-5 | 93,50 |
| sato-teste-2 | pd-standard | 500 | us-east1-b | Idle | sato-teste-2 | 93,50 |

**Observações:**
- Todos os discos estão ociosos (Idle) pois suas VMs estão desligadas (TERMINATED)
- Custo total estimado em armazenamento ocioso: R$ 722,50/mês
- Oportunidade imediata de economia através da exclusão destes recursos

### Projeto: movva-splitter

| Nome do Disco | Tipo | Tamanho (GB) | Zona | Status | VM Associada | Custo Mensal Est. (R$) |
|---------------|------|--------------|------|--------|--------------|-------------------------|
| splitter-2-2 | pd-standard | 80 | us-east1-c | Idle | splitter-2-2 | 14,96 |

**Observações:**
- Disco ocioso pois a VM está desligada (TERMINATED)
- Custo relativamente baixo mas ainda representa desperdício

### Projeto: rapidpro-217518

| Nome do Disco | Tipo | Tamanho (GB) | Zona | Status | VM Associada | Custo Mensal Est. (R$) |
|---------------|------|--------------|------|--------|--------------|-------------------------|
| rapidpro-main | pd-ssd | 200 | us-east1-b | Attached | rapidpro-main | 68,00 |
| rapidpro-worker | pd-ssd | 100 | us-east1-b | Attached | rapidpro-worker | 34,00 |
| rapidpro-redis | pd-ssd | 50 | us-east1-b | Attached | rapidpro-redis | 17,00 |
| rapidpro-backup | pd-standard | 500 | us-east1-b | Attached | rapidpro-main | 93,50 |

**Observações:**
- Todos os discos estão em uso (Attached) por VMs ativas
- O disco rapidpro-backup é usado apenas para armazenamento de backups
- Os discos estão usando tipo SSD para melhor desempenho
- Oportunidade para otimização do tamanho e tipo do disco de backup

### Projeto: coltrane

| Nome do Disco | Tipo | Tamanho (GB) | Zona | Status | VM Associada | Custo Mensal Est. (R$) |
|---------------|------|--------------|------|--------|--------------|-------------------------|
| anima-ai-disk-1 | pd-ssd | 500 | us-east1-b | Attached | GKE Node | 170,00 |
| anima-ai-disk-2 | pd-ssd | 500 | us-east1-b | Attached | GKE Node | 170,00 |
| anima-ai-disk-3 | pd-ssd | 500 | us-east1-b | Attached | GKE Node | 170,00 |
| model-cache | pd-ssd | 1000 | us-east1-b | Attached | GKE Node | 340,00 |

**Observações:**
- Discos vinculados a nós do cluster Kubernetes (GKE)
- Uso de discos SSD para alta performance
- Discos relativamente grandes e caros
- Potencial para otimização com balanceamento entre tipos pd-standard e pd-ssd

## Volumes Inativos ou Subutilizados

| Projeto | Nome do Disco | Tipo | Tamanho (GB) | Status | Custo Mensal (R$) | Recomendação |
|---------|---------------|------|--------------|--------|-------------------|--------------|
| movva-datalake | Todos os 10 discos | Variado | 3.700 | Idle | 722,50 | Excluir |
| movva-splitter | splitter-2-2 | pd-standard | 80 | Idle | 14,96 | Excluir |
| rapidpro-217518 | rapidpro-backup | pd-standard | 500 | Attached | 93,50 | Migrar para Snapshot/Arquivo |
| coltrane | model-cache | pd-ssd | 1000 | Attached | 340,00 | Redimensionar ou compartilhar |

## Distribuição de Custos com Discos Persistentes

| Projeto | Núm. de Discos | Tamanho Total (GB) | Custo Mensal (R$) | % do Custo Total |
|---------|----------------|---------------------|-------------------|------------------|
| movva-datalake | 10 | 3.700 | 722,50 | 4,8% |
| movva-splitter | 1 | 80 | 14,96 | 0,1% |
| rapidpro-217518 | 4 | 850 | 212,50 | 1,4% |
| coltrane | 4 | 2.500 | 850,00 | 5,7% |
| **Total** | **19** | **7.130** | **1.799,96** | **12,0%** |

## Recomendações de Otimização

### 1. Exclusão de Discos Ociosos

**Ação:** Excluir todos os discos associados a VMs desligadas.

**Detalhamento:**
- Realizar backup de dados importantes antes da exclusão (se necessário)
- Excluir discos via console ou CLI do GCP
- Estabelecer política para limpeza automática de recursos inativos

**Economia mensal estimada:** R$ 737,46

### 2. Otimização de Tipos de Discos

**Ação:** Migrar discos não críticos de pd-ssd para pd-standard.

**Detalhamento:**
- Identificar discos que não necessitam de alto desempenho
- Criar snapshots dos discos antes da migração
- Recriar discos com o tipo pd-standard
- Aplicável principalmente para discos de backup e armazenamento de dados

**Economia mensal estimada:** R$ 200-250

### 3. Implementação de Snapshots Programados

**Ação:** Substituir discos dedicados de backup por rotinas de snapshots.

**Detalhamento:**
- Configurar snapshots automáticos com retenção apropriada
- Excluir discos dedicados para backup
- Implementar políticas de retenção e ciclo de vida para snapshots

**Economia mensal estimada:** R$ 90-110

### 4. Redimensionamento de Discos Subutilizados

**Ação:** Redimensionar discos com baixo uso de espaço.

**Detalhamento:**
- Monitorar uso de espaço em disco
- Redimensionar discos com menos de 50% de utilização
- Garantir buffer adequado para crescimento futuro

**Economia mensal estimada:** R$ 150-200

## Impacto Financeiro

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Risco |
|------|----------------------|---------------------|-------------|-------|
| Exclusão de discos ociosos | 737,46 | 8.849,52 | Baixa | Baixo |
| Otimização de tipos de discos | 200-250 | 2.400-3.000 | Média | Médio |
| Implementação de snapshots | 90-110 | 1.080-1.320 | Baixa | Baixo |
| Redimensionamento de discos | 150-200 | 1.800-2.400 | Média | Baixo |
| **Total** | **1.177,46-1.297,46** | **14.129,52-15.569,52** | - | - |

Esta análise demonstra um potencial de economia com otimizações nos volumes de armazenamento persistente representando aproximadamente 8-9% do gasto mensal atual da MOVVA no GCP (R$ 15.000/mês).

## Próximos Passos Recomendados

1. **Imediato (1-7 dias):**
   - Excluir todos os discos ociosos associados a VMs desligadas
   - Realizar backup de quaisquer dados importantes antes da exclusão

2. **Curto Prazo (7-30 dias):**
   - Implementar snapshots programados em substituição aos discos de backup
   - Monitorar o uso atual dos discos para identificar oportunidades de redimensionamento

3. **Médio Prazo (30-90 dias):**
   - Otimizar tipos de discos com base em métricas de desempenho
   - Redimensionar discos subutilizados
   - Implementar políticas de governança para provisionamento de novos discos

4. **Longo Prazo (90+ dias):**
   - Revisar rotação e ciclo de vida dos snapshots
   - Avaliar novas tecnologias como o Filestore para cargas de trabalho específicas
   - Implementar monitoramento contínuo de custos de armazenamento
