# Análise de Bancos de Dados - MOVVA GCP

Data: 06/05/2025

## Visão Geral

Esta análise mapeia todos os bancos de dados PostgreSQL e datasets BigQuery nos projetos da MOVVA, identifica padrões de uso, oportunidades de otimização e apresenta recomendações para redução de custos e melhor desempenho.

## Bancos de Dados PostgreSQL (Cloud SQL)

### Projeto: rapidpro-217518

| Nome da Instância | Versão | Tipo de Máquina | Armazenamento | Modo HA | Custo Mensal Est. (R$) |
|-------------------|--------|-----------------|---------------|---------|------------------------|
| rapidpro-postgresql-prod | 13 | db-custom-4-8192 | 100 GB SSD | Sim | 1.400-1.600 |

**Bancos na Instância:**
- rapidpro (principal)
- analytics (integração)
- monitoring

**Observações:**
- Instância bem dimensionada para a carga atual
- Configuração de alta disponibilidade aumenta o custo
- Oportunidade para otimização do tamanho de máquina durante períodos de baixo uso
- Possível sobrealocação de recursos observada em métricas de uso

### Projeto: operations-dashboards (analytics)

| Nome da Instância | Versão | Tipo de Máquina | Armazenamento | Modo HA | Custo Mensal Est. (R$) |
|-------------------|--------|-----------------|---------------|---------|------------------------|
| analytics-db-prod | 14 | db-custom-2-7680 | 200 GB SSD | Não | 800-1.000 |

**Bancos na Instância:**
- analytics (principal)
- reporting
- etl_metadata

**Observações:**
- Sem configuração de alta disponibilidade
- Tamanho de disco adequado, mas subutilizado (aproximadamente 60% de uso)
- Oportunidade para escalonamento automático de recursos

### Projeto: coltrane

| Nome da Instância | Versão | Tipo de Máquina | Armazenamento | Modo HA | Custo Mensal Est. (R$) |
|-------------------|--------|-----------------|---------------|---------|------------------------|
| coltrane-db-prod | 14 | db-custom-8-32768 | 500 GB SSD | Sim | 3.200-3.600 |

**Bancos na Instância:**
- coltrane (principal)
- anima
- ml_metadata

**Observações:**
- Configuração de alta disponibilidade
- Instância muito potente - possível sobredimensionamento
- Métricas indicam picos ocasionais de uso (20-30%) seguidos de longos períodos de baixa utilização
- Excelente candidato para redimensionamento ou implementação de escalonamento

## Resumo Cloud SQL PostgreSQL

| Projeto | Instâncias | Tipo Médio | Armazenamento Total | Custo Mensal (R$) | % do Orçamento |
|---------|------------|------------|---------------------|-------------------|---------------|
| rapidpro-217518 | 1 | db-custom-4-8192 | 100 GB | 1.400-1.600 | 9-11% |
| operations-dashboards | 1 | db-custom-2-7680 | 200 GB | 800-1.000 | 5-7% |
| coltrane | 1 | db-custom-8-32768 | 500 GB | 3.200-3.600 | 21-24% |
| **Total** | **3** | **-** | **800 GB** | **5.400-6.200** | **36-41%** |

## BigQuery

### Projeto: movva-datalake

| Dataset | Tabelas | Tamanho Total | Consultas/Mês | Dados Processados/Mês | Custo Mensal Est. (R$) |
|---------|---------|---------------|---------------|------------------------|-------------------------|
| datalake_raw | 25+ | 2.5 TB | 500+ | 15 TB | 600-800 |
| datalake_processed | 40+ | 1.8 TB | 1.200+ | 25 TB | 1.000-1.300 |
| datalake_ml | 15+ | 800 GB | 300+ | 8 TB | 350-450 |

**Observações:**
- Uso intensivo de consultas ad-hoc
- Poucas tabelas particionadas ou clusterizadas
- Várias visualizações não materializadas
- Alto potencial de otimização

### Projeto: rapidpro-217518

| Dataset | Tabelas | Tamanho Total | Consultas/Mês | Dados Processados/Mês | Custo Mensal Est. (R$) |
|---------|---------|---------------|---------------|------------------------|-------------------------|
| analytics | 10+ | 500 GB | 200+ | 3 TB | 120-150 |
| flow_results | 20+ | 300 GB | 150+ | 2 TB | 80-100 |
| events | 5+ | 200 GB | 100+ | 1 TB | 40-50 |

**Observações:**
- Tabelas menores comparadas ao datalake
- Dados incrementais por natureza - bons candidatos para particionamento
- Oportunidade para implementação de clustering

### Projeto: operations-dashboards (analytics)

| Dataset | Tabelas | Tamanho Total | Consultas/Mês | Dados Processados/Mês | Custo Mensal Est. (R$) |
|---------|---------|---------------|---------------|------------------------|-------------------------|
| analytics | 30+ | 1.2 TB | 2.000+ | 30 TB | 1.200-1.500 |
| reporting | 15+ | 500 GB | 1.500+ | 15 TB | 600-750 |
| metrics | 10+ | 300 GB | 800+ | 8 TB | 320-400 |

**Observações:**
- Uso muito intensivo para relatórios e dashboards
- Consultas frequentes e repetitivas - candidatas a materialização
- Poucas tabelas otimizadas com particionamento/clustering

### Projeto: coltrane

| Dataset | Tabelas | Tamanho Total | Consultas/Mês | Dados Processados/Mês | Custo Mensal Est. (R$) |
|---------|---------|---------------|---------------|------------------------|-------------------------|
| ml_datasets | 10+ | 1.5 TB | 100+ | 10 TB | 400-500 |
| predictions | 5+ | 300 GB | 500+ | 5 TB | 200-250 |
| features | 15+ | 800 GB | 300+ | 6 TB | 250-300 |

**Observações:**
- Tabelas grandes mas com consultas menos frequentes
- Uso para treinamento de modelos e análise de dados
- Bons candidatos para particionamento e clustering

## Resumo BigQuery

| Projeto | Datasets | Tamanho Total | Dados Processados/Mês | Custo Mensal (R$) | % do Orçamento |
|---------|----------|---------------|------------------------|-------------------|---------------|
| movva-datalake | 3+ | 5.1 TB | 48 TB | 1.950-2.550 | 13-17% |
| rapidpro-217518 | 3 | 1.0 TB | 6 TB | 240-300 | 1.5-2% |
| operations-dashboards | 3 | 2.0 TB | 53 TB | 2.120-2.650 | 14-18% |
| coltrane | 3 | 2.6 TB | 21 TB | 850-1.050 | 6-7% |
| **Total** | **12+** | **10.7 TB** | **128 TB** | **5.160-6.550** | **34-44%** |

## Recomendações de Otimização - PostgreSQL

### 1. Redimensionamento de Instâncias PostgreSQL

**Ação:** Redimensionar instâncias PostgreSQL, especialmente a do projeto coltrane.

**Detalhamento:**
- Reduzir coltrane-db-prod de db-custom-8-32768 para db-custom-4-16384
- Avaliar requisitos de alta disponibilidade e considerar remover para ambientes não críticos
- Implementar monitoramento de uso para ajuste fino

**Economia mensal estimada:** R$ 1.500-1.800

### 2. Otimização de Backups e Logs

**Ação:** Revisar políticas de backup e retenção de logs.

**Detalhamento:**
- Reduzir retenção de backups automáticos de 7 para 3-5 dias (conforme necessidade)
- Implementar backups customizados com armazenamento em classes mais econômicas
- Otimizar retenção de logs de transações

**Economia mensal estimada:** R$ 200-300

### 3. Implementação de Read Replicas Sob Demanda

**Ação:** Substituir réplicas permanentes por réplicas sob demanda para cargas analíticas.

**Detalhamento:**
- Criar scripts para provisionar e desprovisionar réplicas conforme necessidade
- Programar réplicas para execução de relatórios pesados durante períodos específicos
- Migrar consultas de leitura para réplicas quando disponíveis

**Economia mensal estimada:** R$ 500-700

## Recomendações de Otimização - BigQuery

### 1. Implementação de Particionamento e Clustering

**Ação:** Implementar particionamento em todas as tabelas grandes e clustering onde aplicável.

**Detalhamento:**
- Particionar tabelas por data (ingestão ou data de evento)
- Implementar clustering em colunas frequentemente usadas em filtros
- Revisar e atualizar consultas existentes para aproveitar as otimizações

**Economia mensal estimada:** R$ 1.800-2.200 (30-35% de redução nos dados processados)

### 2. Materialização de Visualizações Frequentes

**Ação:** Identificar e materializar visualizações (views) frequentemente consultadas.

**Detalhamento:**
- Implementar tabelas materializadas para consultas repetitivas
- Configurar atualizações automáticas em intervalos apropriados
- Ajustar consultas para utilizar as tabelas materializadas

**Economia mensal estimada:** R$ 800-1.000

### 3. Implementação de BigQuery BI Engine

**Ação:** Avaliar e implementar BigQuery BI Engine para relatórios e dashboards frequentes.

**Detalhamento:**
- Reservar capacidade do BI Engine adequada às necessidades
- Selecionar tabelas e visualizações para aceleração
- Ajustar dashboards para aproveitar a aceleração

**Economia mensal estimada:** R$ 600-900

### 4. Avaliação de Slot Commitments

**Ação:** Avaliar a implementação de slot commitments para ambientes com uso previsível.

**Detalhamento:**
- Analisar padrões de uso para determinar número ideal de slots
- Considerar compromissos anuais para economia adicional
- Implementar monitoramento de uso de slots para ajuste fino

**Economia mensal estimada:** R$ 1.000-1.500 (dependendo do volume de consultas)

## Impacto Financeiro Total

| Serviço | Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Risco |
|---------|------|----------------------|---------------------|-------------|-------|
| PostgreSQL | Redimensionamento | 1.500-1.800 | 18.000-21.600 | Média | Médio |
| PostgreSQL | Otimização de backups | 200-300 | 2.400-3.600 | Baixa | Baixo |
| PostgreSQL | Réplicas sob demanda | 500-700 | 6.000-8.400 | Alta | Médio |
| BigQuery | Particionamento/Clustering | 1.800-2.200 | 21.600-26.400 | Média | Baixo |
| BigQuery | Materialização | 800-1.000 | 9.600-12.000 | Média | Baixo |
| BigQuery | BI Engine | 600-900 | 7.200-10.800 | Média | Baixo |
| BigQuery | Slot Commitments | 1.000-1.500 | 12.000-18.000 | Alta | Médio |
| **Total** | **-** | **6.400-8.400** | **76.800-100.800** | **-** | **-** |

Esta análise demonstra um potencial de economia com otimizações nos bancos de dados representando aproximadamente 43-56% do gasto mensal atual da MOVVA no GCP (R$ 15.000/mês).

## Implementação Recomendada

1. **Fase 1 (Curto Prazo - 30 dias):**
   - Iniciar particionamento/clustering das tabelas mais consultadas do BigQuery
   - Otimizar políticas de backups e logs do PostgreSQL
   - Implementar monitoramento detalhado de uso

2. **Fase 2 (Médio Prazo - 60-90 dias):**
   - Redimensionar instâncias PostgreSQL com base em métricas reais
   - Materializar visualizações frequentemente acessadas
   - Avaliar e testar BigQuery BI Engine

3. **Fase 3 (Longo Prazo - 90-180 dias):**
   - Implementar réplicas sob demanda para PostgreSQL
   - Avaliar e implementar slot commitments para BigQuery
   - Estabelecer processo de revisão regular de todas as configurações
