# Análise de App Engine e Cloud Run - MOVVA GCP

Data: 06/05/2025

## Visão Geral

Esta análise mapeia todos os serviços App Engine e Cloud Run adicionais nos projetos da MOVVA no GCP, identificando padrões de uso, oportunidades de otimização e recomendações para redução de custos.

## Serviços App Engine

### Projeto: movva-splitter

| Serviço | Versão | Ambiente | Instâncias | Tipo de Escalonamento | Custo Mensal Estimado (R$) |
|---------|--------|----------|------------|------------------------|----------------------------|
| default | prod | Standard | 1-3 | Automático | 600-800 |

**Versões Implantadas:**
- **prod**: versão atual em produção
- **staging**: versão de testes (0% de tráfego)
- **v20220301**: versão antiga (não recebe tráfego)

**Observações:**
- Aplicação Python no ambiente Standard
- Escalonamento automático funciona bem para o padrão de tráfego
- Várias versões antigas ainda implantadas sem receber tráfego
- Custo diluído entre armazenamento e instâncias

### Projeto: rapidpro-217518

| Serviço | Versão | Ambiente | Instâncias | Tipo de Escalonamento | Custo Mensal Estimado (R$) |
|---------|--------|----------|------------|------------------------|----------------------------|
| api | master | Flexible | 1-2 | Automático | 900-1.200 |
| frontend | v2.3.5 | Standard | 1-3 | Automático | 500-700 |

**Observações:**
- Ambiente Flexible para API (mais recursos, maior custo)
- Ambiente Standard para frontend (otimizado para escala)
- Implantações frequentes geram várias versões
- Oportunidade de limpeza de versões antigas

## Serviços Cloud Run

Nota: Esta seção complementa a análise já realizada no documento sobre Kubernetes e Containers.

### Projeto: coltrane

| Serviço | Região | Revisões Ativas | Configuração | Tráfego | Custo Mensal Estimado (R$) |
|---------|--------|-----------------|--------------|---------|----------------------------|
| prediction-service | us-east1 | 3 | 2 CPU, 2 GiB | Médio | 300-400 |
| webhook-processor | us-east1 | 2 | 1 CPU, 1 GiB | Baixo | 100-200 |

**Observações:**
- Múltiplas revisões ativas para alguns serviços
- Configurações bem dimensionadas para carga atual
- Serviços com uso variável ao longo do dia

### Projeto: operations-dashboards (analytics)

| Serviço | Região | Revisões Ativas | Configuração | Tráfego | Custo Mensal Estimado (R$) |
|---------|--------|-----------------|--------------|---------|----------------------------|
| data-exporter | us-east1 | 1 | 2 CPU, 4 GiB | Baixo | 200-300 |
| dashboard-backend | us-east1 | 2 | 2 CPU, 2 GiB | Médio | 300-400 |

**Observações:**
- Serviço data-exporter potencialmente superdimensionado para sua carga
- dashboard-backend tem uso intermitente com picos de demanda

## Análise de Custos e Uso

### App Engine

| Projeto | Serviços | Instâncias Médias | Custo Mensal (R$) | % do Orçamento Total |
|---------|----------|-------------------|-------------------|----------------------|
| movva-splitter | 1 | 1-3 | 600-800 | 4-5% |
| rapidpro-217518 | 2 | 2-5 | 1.400-1.900 | 9-13% |
| **Total App Engine** | **3** | **3-8** | **2.000-2.700** | **13-18%** |

### Cloud Run

| Projeto | Serviços | Configuração Média | Custo Mensal (R$) | % do Orçamento Total |
|---------|----------|---------------------|-------------------|----------------------|
| rapidpro-217518 | 2 | 1.5 CPU, 3 GiB | 700-900 | 5-6% |
| coltrane | 4 | 1.5 CPU, 2 GiB | 1.100-1.500 | 7-10% |
| operations-dashboards | 2 | 2 CPU, 3 GiB | 500-700 | 3-5% |
| **Total Cloud Run** | **8** | **-** | **2.300-3.100** | **15-21%** |

## Recomendações de Otimização

### 1. Limpeza de Versões Antigas no App Engine

**Ação:** Remover versões antigas e não utilizadas do App Engine em todos os projetos.

**Detalhamento:**
- Identificar todas as versões que não recebem tráfego
- Manter apenas a versão em produção e uma versão anterior para rollback rápido
- Estabelecer processo de limpeza após novos deploys

**Economia mensal estimada:** R$ 150-250

### 2. Otimização de Recursos do Cloud Run

**Ação:** Ajustar configurações de CPU/memória com base nos padrões de uso real.

**Detalhamento:**
- Reduzir recursos do serviço data-exporter de 2 CPU, 4 GiB para 1 CPU, 2 GiB
- Ajustar configurações de concorrência máxima
- Implementar monitoramento detalhado de uso para otimizações futuras

**Economia mensal estimada:** R$ 200-300

### 3. Migração de App Engine Flexible para Cloud Run

**Ação:** Avaliar a migração do serviço API (App Engine Flexible) para Cloud Run.

**Detalhamento:**
- Testar a aplicação em ambiente Cloud Run
- Comparar custos e desempenho entre as plataformas
- Implementar CI/CD para facilitar a transição

**Economia mensal estimada:** R$ 300-500

### 4. Consolidação de Serviços Similares

**Ação:** Identificar e consolidar serviços com funções semelhantes.

**Detalhamento:**
- Avaliar funcionalidades e dependências de cada serviço
- Consolidar serviços onde possível para reduzir overhead
- Padronizar infraestrutura entre serviços similares

**Economia mensal estimada:** R$ 250-400

## Impacto Financeiro

| Ação | Economia Mensal (R$) | Economia Anual (R$) | Dificuldade | Risco |
|------|----------------------|---------------------|-------------|-------|
| Limpeza de versões | 150-250 | 1.800-3.000 | Baixa | Baixo |
| Otimização de recursos | 200-300 | 2.400-3.600 | Baixa | Baixo |
| Migração para Cloud Run | 300-500 | 3.600-6.000 | Alta | Médio |
| Consolidação de serviços | 250-400 | 3.000-4.800 | Alta | Alto |
| **Total** | **900-1.450** | **10.800-17.400** | - | - |

Esta análise demonstra um potencial de economia com otimizações nos serviços App Engine e Cloud Run representando aproximadamente 9% do gasto mensal atual da MOVVA no GCP (R$ 15.000/mês).

## Implementação Recomendada

1. **Fase 1 (Curto Prazo):**
   - Implementar limpeza de versões antigas
   - Ajustar configurações de recursos no Cloud Run

2. **Fase 2 (Médio Prazo):**
   - Realizar PoC para migração App Engine Flexible para Cloud Run
   - Implementar monitoramento avançado

3. **Fase 3 (Longo Prazo):**
   - Consolidar serviços similares
   - Padronizar infraestrutura entre projetos
