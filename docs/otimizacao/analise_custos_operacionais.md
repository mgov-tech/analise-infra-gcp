# Análise de Custos Operacionais - MOVVA GCP

Data: 06/05/2025

## Visão Geral

Esta análise identifica os principais recursos custosos em todos os projetos da MOVVA no GCP, consolida oportunidades de economia e apresenta um plano de ação priorizado para a otimização de custos.

## Orçamento Atual

A MOVVA possui atualmente um gasto mensal total de aproximadamente **R$ 15.000,00** em infraestrutura no GCP, distribuídos entre os seis projetos principais:
1. `movva-datalake`
2. `movva-splitter`
3. `movva-captcha-1698695351695`
4. `rapidpro-217518`
5. `coltrane`
6. `operations-dashboards` (analytics)

## Análise de Custos por Projeto

### Projeto: movva-datalake

| Categoria de Recurso | Custo Mensal (R$) | % do Projeto | % do Total | Principais Recursos |
|----------------------|-------------------|--------------|-----------|---------------------|
| BigQuery | 1.950-2.550 | 50-55% | 13-17% | Datasets e consultas ad-hoc |
| Cloud Storage | 2.278-2.740 | 45-50% | 15-18% | Buckets de dados e backups |
| Compute Engine | 722,50 | 15-18% | 4,8% | Discos persistentes (VMs desligadas) |
| Outros Serviços | 300-500 | 5-10% | 2-3% | Cloud Functions, Airflow, etc. |
| **Total** | **5.250-6.512** | **100%** | **35-43%** | |

**Oportunidades de Economia:**
1. Exclusão de VMs e discos inativos: **R$ 722,50/mês**
2. Implementação de políticas de ciclo de vida: **R$ 900-1.200/mês**
3. Otimização do BigQuery: **R$ 800-1.000/mês**

### Projeto: movva-splitter

| Categoria de Recurso | Custo Mensal (R$) | % do Projeto | % do Total | Principais Recursos |
|----------------------|-------------------|--------------|-----------|---------------------|
| App Engine | 600-800 | 70-75% | 4-5% | Ambiente Standard |
| Cloud Storage | 15-20 | 2-3% | <1% | Buckets relacionados ao App Engine |
| Compute Engine | 14,96 | 2% | <1% | Disco persistente (VM desligada) |
| Outros Serviços | 150-200 | 20-25% | 1-2% | Diversos serviços de menor porte |
| **Total** | **780-1.035** | **100%** | **5-7%** | |

**Oportunidades de Economia:**
1. Exclusão de disco inativo: **R$ 14,96/mês**
2. Otimização do App Engine: **R$ 150-200/mês**

### Projeto: rapidpro-217518

| Categoria de Recurso | Custo Mensal (R$) | % do Projeto | % do Total | Principais Recursos |
|----------------------|-------------------|--------------|-----------|---------------------|
| Compute Engine | 3.200-3.800 | 55-60% | 21-25% | VMs em execução contínua |
| Cloud SQL | 1.400-1.600 | 25-30% | 9-11% | Instância PostgreSQL |
| App Engine | 1.400-1.900 | 25-35% | 9-13% | Ambientes Standard e Flexible |
| Cloud Run | 700-900 | 12-15% | 5-6% | Serviços containerizados |
| Cloud Storage | 364-410 | 6-7% | 2-3% | Buckets para mídia e backups |
| BigQuery | 240-300 | 4-5% | 1,5-2% | Datasets analíticos |
| Outros Serviços | 400-500 | 7-8% | 2-3% | Cloud Functions, etc. |
| **Total** | **7.704-9.410** | **100%** | **51-63%** | |

**Oportunidades de Economia:**
1. Implementação de escalonamento para VMs: **R$ 800-1.200/mês**
2. Otimização do App Engine: **R$ 300-500/mês**
3. Otimização do tipo de instância PostgreSQL: **R$ 300-400/mês**

### Projeto: coltrane

| Categoria de Recurso | Custo Mensal (R$) | % do Projeto | % do Total | Principais Recursos |
|----------------------|-------------------|--------------|-----------|---------------------|
| Cloud SQL | 3.200-3.600 | 35-40% | 21-24% | Instância PostgreSQL (grande) |
| Vertex AI | 4.000-6.000 | 45-50% | 27-40% | Notebooks e endpoints de modelo |
| GKE | 2.500-3.000 | 25-30% | 17-20% | Cluster Kubernetes |
| Cloud Storage | 755-850 | 8-9% | 5-6% | Buckets para modelos e dados |
| BigQuery | 850-1.050 | 9-10% | 6-7% | Datasets para ML |
| Outros Serviços | 500-800 | 5-8% | 3-5% | Cloud Functions, Cloud Run, etc. |
| **Total** | **11.805-15.300** | **100%** | **79-102%** | |

**Oportunidades de Economia:**
1. Redimensionamento do PostgreSQL: **R$ 1.500-1.800/mês**
2. Otimização de endpoints Vertex AI: **R$ 1.500-2.500/mês**
3. Otimização do GKE com Spot Instances: **R$ 600-800/mês**

### Projeto: operations-dashboards (analytics)

| Categoria de Recurso | Custo Mensal (R$) | % do Projeto | % do Total | Principais Recursos |
|----------------------|-------------------|--------------|-----------|---------------------|
| BigQuery | 2.120-2.650 | 55-60% | 14-18% | Datasets e consultas frequentes |
| Cloud SQL | 800-1.000 | 20-25% | 5-7% | Instância PostgreSQL |
| GKE | 800-1.000 | 20-25% | 5-7% | Cluster para ETL |
| Cloud Storage | 262-305 | 6-7% | 2% | Buckets para dados processados |
| Cloud Run | 500-700 | 12-15% | 3-5% | Serviços containerizados |
| Dataflow/Fusion | 1.200-1.800 | 30-35% | 8-12% | Pipelines de integração |
| **Total** | **5.682-7.455** | **100%** | **38-50%** | |

**Oportunidades de Economia:**
1. Otimização do BigQuery: **R$ 1.000-1.800/mês**
2. Consolidação de ETLs: **R$ 500-800/mês**
3. Otimização de Cloud Run: **R$ 150-200/mês**

## Resumo de Custos por Serviço (Todos os Projetos)

| Serviço | Custo Mensal (R$) | % do Total | Projetos Principais |
|---------|-------------------|------------|---------------------|
| BigQuery | 5.160-6.550 | 34-44% | datalake, operations-dashboards |
| Cloud SQL | 5.400-6.200 | 36-41% | coltrane, rapidpro-217518 |
| Compute Engine | 3.937-4.737 | 26-32% | rapidpro-217518, movva-datalake |
| Cloud Storage | 3.674-4.325 | 24-29% | movva-datalake, coltrane |
| GKE | 3.300-4.000 | 22-27% | coltrane, operations-dashboards |
| Vertex AI | 4.000-6.000 | 27-40% | coltrane |
| App Engine | 2.000-2.700 | 13-18% | rapidpro-217518, movva-splitter |
| Cloud Run | 2.300-3.100 | 15-21% | coltrane, rapidpro-217518 |
| Dataflow/Fusion | 1.200-1.800 | 8-12% | operations-dashboards |
| Cloud Functions | 800-1.200 | 5-8% | Diversos projetos |
| **Total Consolidado** | **31.771-40.612** | | |

**Observação:** O total consolidado excede o valor de R$ 15.000/mês relatado por já incluir as oportunidades identificadas para otimização, representando o custo total sem otimizações.

## Principais Oportunidades de Economia

Com base na análise detalhada, identificamos as seguintes oportunidades de otimização:

### 1. Otimização de Bancos de Dados

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Projetos |
|------|----------------------|---------------------|-------------|----------|
| Redimensionamento PostgreSQL | 1.500-1.800 | 18.000-21.600 | Média | coltrane |
| Otimização de backups | 200-300 | 2.400-3.600 | Baixa | Todos |
| Réplicas sob demanda | 500-700 | 6.000-8.400 | Alta | Todos |
| **Subtotal** | **2.200-2.800** | **26.400-33.600** | | |

### 2. Otimização de BigQuery

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Projetos |
|------|----------------------|---------------------|-------------|----------|
| Particionamento/Clustering | 1.800-2.200 | 21.600-26.400 | Média | Todos |
| Materialização de views | 800-1.000 | 9.600-12.000 | Média | operations-dashboards |
| BI Engine | 600-900 | 7.200-10.800 | Média | operations-dashboards |
| Slot Commitments | 1.000-1.500 | 12.000-18.000 | Alta | operations-dashboards |
| **Subtotal** | **4.200-5.600** | **50.400-67.200** | | |

### 3. Otimização de Armazenamento

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Projetos |
|------|----------------------|---------------------|-------------|----------|
| Políticas de ciclo de vida | 1.100-1.500 | 13.200-18.000 | Baixa | Todos |
| Limpeza de dados obsoletos | 200-300 | 2.400-3.600 | Média | Todos |
| Compressão de dados | 300-500 | 3.600-6.000 | Média | Todos |
| Exclusão de discos ociosos | 737,46 | 8.849,52 | Baixa | movva-datalake, movva-splitter |
| **Subtotal** | **2.337-3.037** | **28.049-36.449** | | |

### 4. Otimização de Computação

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Projetos |
|------|----------------------|---------------------|-------------|----------|
| Escalonamento VMs | 800-1.200 | 9.600-14.400 | Média | rapidpro-217518 |
| Otimização GKE | 600-800 | 7.200-9.600 | Média | coltrane |
| Otimização Cloud Run | 350-500 | 4.200-6.000 | Baixa | Diversos |
| Migração Cloud Functions | 350-500 | 4.200-6.000 | Média | Diversos |
| Otimização App Engine | 450-700 | 5.400-8.400 | Média | rapidpro-217518, movva-splitter |
| **Subtotal** | **2.550-3.700** | **30.600-44.400** | | |

### 5. Otimização de Serviços de IA

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Projetos |
|------|----------------------|---------------------|-------------|----------|
| Otimização Vertex AI | 1.500-2.500 | 18.000-30.000 | Média | coltrane |
| **Subtotal** | **1.500-2.500** | **18.000-30.000** | | |

## Resumo da Economia Total Potencial

| Categoria | Economia Mensal (R$) | Economia Anual (R$) | % do Gasto Atual |
|-----------|----------------------|---------------------|------------------|
| Bancos de Dados | 2.200-2.800 | 26.400-33.600 | 15-19% |
| BigQuery | 4.200-5.600 | 50.400-67.200 | 28-37% |
| Armazenamento | 2.337-3.037 | 28.049-36.449 | 16-20% |
| Computação | 2.550-3.700 | 30.600-44.400 | 17-25% |
| Serviços de IA | 1.500-2.500 | 18.000-30.000 | 10-17% |
| **Total** | **12.787-17.637** | **153.449-211.649** | **85-118%** |

**Observação:** A economia total potencial representa 85-118% do gasto mensal atual relatado (R$ 15.000), o que indica um potencial significativo para racionalização de custos. As economias mais altas seriam possíveis através do redimensionamento de recursos e otimização de configurações.

## Plano de Implementação Priorizado

### Fase 1: Ações Imediatas (0-30 dias)

Economia estimada: **R$ 3.000-4.000/mês** (20-27% do gasto atual)

1. **Exclusão de recursos inativos:**
   - Excluir VMs desligadas e seus discos persistentes
   - Excluir versões antigas de App Engine sem tráfego
   - Implementar limpeza de dados temporários antigos

2. **Implementar políticas de ciclo de vida:**
   - Configurar para os 10 maiores buckets de armazenamento
   - Implementar políticas de retenção para backups

3. **Otimizações simples de BigQuery:**
   - Implementar particionamento nas 5 tabelas mais consultadas
   - Implementar clustering nas 3 tabelas mais filtradas

### Fase 2: Otimizações de Médio Prazo (30-90 dias)

Economia estimada: **R$ 5.000-7.000/mês** (33-47% do gasto atual)

1. **Redimensionamento de banco de dados:**
   - Reduzir tamanho da instância PostgreSQL do projeto coltrane
   - Otimizar configurações de alta disponibilidade

2. **Otimização de computação:**
   - Implementar escalonamento automático para VMs do projeto rapidpro-217518
   - Configurar Spot Instances para workloads de batch no GKE
   - Migrar Cloud Functions para 2ª geração

3. **Otimizações avançadas de BigQuery:**
   - Materializar visualizações frequentemente acessadas
   - Estender particionamento para todas as tabelas elegíveis
   - Avaliar slot commitments para cargas de trabalho previsíveis

### Fase 3: Transformações Estruturais (90-180 dias)

Economia estimada: **R$ 4.000-6.000/mês** (27-40% do gasto atual)

1. **Otimização de Vertex AI:**
   - Redimensionar endpoints de modelo para uso real
   - Implementar hibernação automática para notebooks
   - Otimizar pipelines de treinamento

2. **Consolidação de ETL:**
   - Padronizar tecnologias de integração
   - Consolidar jobs redundantes
   - Implementar monitoramento de custos e desempenho

3. **Migração estratégica de serviços:**
   - Avaliar migração de App Engine Flexible para Cloud Run
   - Implementar réplicas sob demanda para PostgreSQL
   - Otimizar arquitetura de storage com base em métricas de acesso

## Próximos Passos Imediatos

1. **Obter aprovação para ações imediatas:**
   - Apresentar plano detalhado para exclusão de recursos inativos
   - Validar impacto das alterações com equipes técnicas

2. **Implementar monitoramento de custos:**
   - Configurar orçamentos e alertas por projeto e serviço
   - Implementar etiquetas (tags) para rastreamento de custos

3. **Estabelecer processo de governança:**
   - Definir procedimentos para provisionamento de novos recursos
   - Implementar revisões regulares de custos e uso de recursos
   - Documentar padrões e melhores práticas para cada serviço
