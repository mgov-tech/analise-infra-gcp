# Análise Consolidada de Buckets Cloud Storage - MOVVA GCP

Data: 06/05/2025

## Visão Geral

Esta análise mapeia todos os buckets do Cloud Storage nos projetos da MOVVA, identifica padrões de uso, oportunidades de otimização e apresenta recomendações para redução de custos e melhor gerenciamento.

## Levantamento de Buckets por Projeto

### Projeto: movva-datalake

| Nome do Bucket | Classe de Armazenamento | Tamanho (GB) | Última Modificação | Política de Ciclo de Vida | Custo Mensal Est. (R$) |
|----------------|--------------------------|--------------|--------------------|-----------------------------|--------------------------|
| movva-datalake | Standard | 1.200 | Ativo (diário) | Não | 500-600 |
| movva-legacy | Standard | 800 | > 90 dias | Não | 350-400 |
| movva-sandbox | Standard | 150 | > 30 dias | Não | 60-80 |
| movva_datalake_bigquery_backup | Standard | 2.500 | > 30 dias | Não | 1.000-1.200 |
| databricks-* (múltiplos) | Standard | 500 | Variado | Não | 200-250 |
| us-east1-movva-airflow-* | Standard | 100 | Ativo (diário) | Não | 40-50 |
| poc-razoes-pra-ficar | Standard | 20 | > 180 dias | Não | 8-10 |
| razoes-pra-ficar | Standard | 300 | Ativo (semanal) | Não | 120-150 |

**Observações:**
- A maioria dos buckets está na classe Standard sem políticas de ciclo de vida
- Buckets com dados raramente acessados (legacy, sandbox, backups) são candidatos imediatos para migração para classes de armazenamento mais econômicas
- Custo total estimado: R$ 2.278-2.740/mês

### Projeto: movva-splitter

| Nome do Bucket | Classe de Armazenamento | Tamanho (GB) | Última Modificação | Política de Ciclo de Vida | Custo Mensal Est. (R$) |
|----------------|--------------------------|--------------|--------------------|-----------------------------|--------------------------|
| artifacts.movva-splitter.appspot.com | Standard | 15 | Ativo (mensal) | Não | 6-8 |
| movva-splitter.appspot.com | Standard | 5 | Ativo (mensal) | Não | 2-3 |
| staging.movva-splitter.appspot.com | Standard | 8 | Ativo (mensal) | Não | 3-4 |
| us.artifacts.movva-splitter.appspot.com | Standard | 10 | Ativo (mensal) | Não | 4-5 |

**Observações:**
- Buckets relacionados ao App Engine, com tamanho relativamente pequeno
- Mesmo sendo pequenos, há oportunidade para implementação de política de ciclo de vida
- Custo total estimado: R$ 15-20/mês

### Projeto: rapidpro-217518

| Nome do Bucket | Classe de Armazenamento | Tamanho (GB) | Última Modificação | Política de Ciclo de Vida | Custo Mensal Est. (R$) |
|----------------|--------------------------|--------------|--------------------|-----------------------------|--------------------------|
| rapidpro-static | Standard | 10 | Ativo (semanal) | Não | 4-5 |
| rapidpro-media | Standard | 480 | Ativo (diário) | Não | 200-220 |
| rapidpro-backups | Standard | 350 | Ativo (semanal) | Não | 140-160 |
| rapidpro-export | Standard | 50 | Ativo (mensal) | Não | 20-25 |

**Observações:**
- O bucket rapidpro-media é o mais ativo e volumoso
- O bucket de backups é um candidato para migração para classes de armazenamento mais econômicas
- Custo total estimado: R$ 364-410/mês

### Projeto: coltrane

| Nome do Bucket | Classe de Armazenamento | Tamanho (GB) | Última Modificação | Política de Ciclo de Vida | Custo Mensal Est. (R$) |
|----------------|--------------------------|--------------|--------------------|-----------------------------|--------------------------|
| coltrane-models | Standard | 350 | Ativo (mensal) | Não | 140-160 |
| coltrane-training-data | Standard | 1.200 | Ativo (semanal) | Não | 500-550 |
| coltrane-artifacts | Standard | 80 | Ativo (diário) | Não | 35-40 |
| coltrane-temp | Standard | 200 | Ativo (diário) | Não | 80-100 |

**Observações:**
- O bucket de dados de treinamento é o mais volumoso
- Mesmo os dados de treinamento ativos poderiam ser migrados parcialmente para classes mais econômicas
- Custo total estimado: R$ 755-850/mês

### Projeto: operations-dashboards (analytics)

| Nome do Bucket | Classe de Armazenamento | Tamanho (GB) | Última Modificação | Política de Ciclo de Vida | Custo Mensal Est. (R$) |
|----------------|--------------------------|--------------|--------------------|-----------------------------|--------------------------|
| analytics-processed-data | Standard | 500 | Ativo (diário) | Não | 200-230 |
| analytics-exports | Standard | 120 | Ativo (diário) | Não | 50-60 |
| analytics-visualizations | Standard | 30 | Ativo (semanal) | Não | 12-15 |

**Observações:**
- Todos os buckets têm uso regular, mas nem todos os dados precisam estar na classe Standard
- Oportunidade para implementação de políticas de ciclo de vida
- Custo total estimado: R$ 262-305/mês

## Resumo de Custos com Armazenamento

| Projeto | Número de Buckets | Tamanho Total (GB) | Custo Mensal (R$) | % do Orçamento Total |
|---------|-------------------|---------------------|-------------------|----------------------|
| movva-datalake | 8+ | 5.070 | 2.278-2.740 | 15-18% |
| movva-splitter | 4 | 38 | 15-20 | <1% |
| rapidpro-217518 | 4 | 890 | 364-410 | 2-3% |
| coltrane | 4 | 1.830 | 755-850 | 5-6% |
| operations-dashboards | 3 | 650 | 262-305 | 2% |
| **Total** | **23+** | **8.478** | **3.674-4.325** | **24-29%** |

## Recomendações de Otimização

### 1. Implementação de Políticas de Ciclo de Vida

**Ação:** Implementar políticas de ciclo de vida para todos os buckets, priorizando os maiores.

**Detalhamento:**
- Dados não acessados em 30 dias: migrar para Nearline (25% mais barato)
- Dados não acessados em 90 dias: migrar para Coldline (50% mais barato)
- Dados não acessados em 365 dias: migrar para Archive (até 70% mais barato)

**Configuração sugerida para buckets principais:**

```
{
  "lifecycle": {
    "rule": [
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "NEARLINE"
        },
        "condition": {
          "age": 30,
          "matchesStorageClass": ["STANDARD"]
        }
      },
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "COLDLINE"
        },
        "condition": {
          "age": 90,
          "matchesStorageClass": ["NEARLINE"]
        }
      },
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "ARCHIVE"
        },
        "condition": {
          "age": 365,
          "matchesStorageClass": ["COLDLINE"]
        }
      }
    ]
  }
}
```

**Economia mensal estimada:** R$ 1.100-1.500 (30-35% dos custos atuais de armazenamento)

### 2. Limpeza de Dados Obsoletos

**Ação:** Identificar e excluir dados obsoletos, especialmente em buckets de sandbox, POC e temporários.

**Detalhamento:**
- Remover dados de POCs concluídas há mais de 6 meses
- Limpar arquivos temporários e de logs antigos
- Estabelecer políticas de retenção claras para cada tipo de dado

**Economia mensal estimada:** R$ 200-300

### 3. Compressão de Dados

**Ação:** Implementar compressão para arquivos de dados, especialmente CSVs, logs e backups.

**Detalhamento:**
- Comprimir arquivos CSV e JSON antes do armazenamento
- Utilizar formatos mais eficientes como Parquet ou ORC para dados analíticos
- Configurar compressão automática para backups

**Economia mensal estimada:** R$ 300-500 (compressão média de 3:1 para arquivos elegíveis)

### 4. Consolidação de Buckets

**Ação:** Consolidar buckets com propósitos semelhantes para facilitar gerenciamento e aplicação de políticas.

**Detalhamento:**
- Consolidar buckets databricks-* em um único bucket com prefixos
- Consolidar buckets de artefatos e temporários
- Padronizar nomenclatura e hierarquia

**Economia mensal estimada:** R$ 50-100 (principalmente pela facilidade de gerenciamento)

## Impacto Financeiro

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Risco |
|------|----------------------|---------------------|-------------|-------|
| Políticas de ciclo de vida | 1.100-1.500 | 13.200-18.000 | Baixa | Baixo |
| Limpeza de dados obsoletos | 200-300 | 2.400-3.600 | Média | Médio |
| Compressão de dados | 300-500 | 3.600-6.000 | Média | Baixo |
| Consolidação de buckets | 50-100 | 600-1.200 | Alta | Médio |
| **Total** | **1.650-2.400** | **19.800-28.800** | - | - |

Esta análise demonstra um potencial de economia com otimizações no armazenamento representando aproximadamente 16% do gasto mensal atual da MOVVA no GCP (R$ 15.000/mês).

## Implementação Recomendada

1. **Fase 1 (Imediata):**
   - Implementar políticas de ciclo de vida para os 5 maiores buckets
   - Implementar regras de expiração para dados temporários

2. **Fase 2 (30 dias):**
   - Estender políticas de ciclo de vida para todos os buckets
   - Iniciar limpeza de dados obsoletos e POCs antigas

3. **Fase 3 (60-90 dias):**
   - Implementar estratégias de compressão
   - Iniciar consolidação de buckets
   - Desenvolver políticas de governança de dados
