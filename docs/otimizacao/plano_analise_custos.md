# Plano de Análise de Custos e Recursos Subutilizados

Data: 06/05/2025

## Objetivos

1. Identificar os recursos mais custosos na infraestrutura GCP da MOVVA
2. Detectar recursos não utilizados ou subutilizados
3. Priorizar oportunidades de otimização com base no potencial de economia
4. Criar recomendações específicas para redução de custos

## Etapas de Análise

### 1. Preparação e Coleta de Dados (1-2 dias)

- [x] Obter permissões para acessar dados de faturamento do Cloud Billing
- [ ] Verificar acesso aos projetos a serem analisados
- [ ] Preparar ferramentas de análise (BigQuery, Data Studio)
- [ ] Definir período de análise (recomendado: últimos 3 meses)
- [ ] Exportar dados de faturamento para BigQuery
- [ ] Criar script para monitoramento de recursos ociosos

### 2. Análise de Custos por Categoria (2-3 dias)

- [ ] **Análise de Computação**:
  - [ ] Identificar VMs com utilização média de CPU abaixo de 10%
  - [ ] Listar VMs desligadas há mais de 30 dias
  - [ ] Identificar funções com execuções pouco frequentes
  - [ ] Analisar custos de rede relacionados a computação

- [ ] **Análise de Armazenamento**:
  - [ ] Listar buckets por tamanho e última modificação
  - [ ] Identificar buckets com dados acessados raramente
  - [ ] Verificar possibilidade de migração para classes mais econômicas
  - [ ] Analisar custos de operações de armazenamento (listagem, leitura)

- [ ] **Análise de Banco de Dados**:
  - [ ] Analisar custos de BigQuery por consulta
  - [ ] Identificar consultas caras e frequentes
  - [ ] Verificar possibilidade de otimização de tabelas
  - [ ] Analisar utilização de slots reservados vs. sob demanda

- [ ] **Análise de Serviços Gerenciados**:
  - [ ] Listar serviços com uso mínimo e alto custo
  - [ ] Verificar APIs cobradas mas pouco utilizadas
  - [ ] Analisar ambientes de staging/QA e possível consolidação

### 3. Consultas Específicas para BigQuery (exemplos)

```sql
-- Top 10 recursos mais caros
SELECT 
  service.description,
  sku.description,
  SUM(cost) AS total_cost,
  SUM(usage.amount) AS usage_amount,
  usage.unit
FROM `PROJECT_ID.DATASET.gcp_billing_export_*`
WHERE DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
GROUP BY service.description, sku.description, usage.unit
ORDER BY total_cost DESC
LIMIT 10;

-- VMs potencialmente ociosas
SELECT 
  resource.name,
  resource.type,
  SUM(cost) AS total_cost,
  AVG(system_labels.value) AS avg_utilization
FROM `PROJECT_ID.DATASET.gcp_billing_export_*`
LEFT JOIN UNNEST(system_labels) AS system_labels
  ON system_labels.key = 'cpu_utilization'
WHERE 
  DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) 
  AND resource.type = 'compute.googleapis.com/Instance'
GROUP BY resource.name, resource.type
HAVING avg_utilization < 0.1
ORDER BY total_cost DESC;
```

### 4. Comandos CLI para Análise de Recursos (exemplos)

```bash
# Identificar VMs desligadas por mais de 30 dias
gcloud compute instances list --filter="status:TERMINATED" --format="table(name, zone, status, lastStartTimestamp)"

# Listar buckets por tamanho
gsutil du -s gs://BUCKET_NAME

# Listar buckets por última modificação
gsutil ls -L gs://BUCKET_NAME | grep "Update time"

# Verificar jobs de BigQuery custosos
bq query --format=pretty 'SELECT creation_time, user_email, total_bytes_processed, query FROM `region-us.INFORMATION_SCHEMA.JOBS` WHERE total_bytes_processed > 1000000000 ORDER BY total_bytes_processed DESC LIMIT 10'
```

### 5. Análise de Recomendações Automáticas (1 dia)

- [ ] Extrair recomendações do Recommender API:
  - [ ] VM Rightsizing
  - [ ] Disco Persistente Idle
  - [ ] Snapshots Desnecessários
  - [ ] Endereços IP Não Utilizados

```bash
# Exemplo de comando para extrair recomendações
gcloud recommender recommendations list --project=PROJECT_ID --location=LOCATION --recommender=google.compute.instance.MachineTypeRecommender
```

### 6. Compilação e Análise de Resultados (1-2 dias)

- [ ] Consolidar resultados em uma única planilha
- [ ] Calcular economia potencial para cada recomendação
- [ ] Classificar recomendações por:
  - [ ] Economia potencial (alta, média, baixa)
  - [ ] Facilidade de implementação (fácil, média, difícil)
  - [ ] Risco (baixo, médio, alto)
- [ ] Identificar dependências entre recursos a serem otimizados

### 7. Criação do Plano de Otimização (1 dia)

- [ ] Criar documento com recomendações priorizadas
- [ ] Definir cronograma de implementação
- [ ] Calcular ROI para cada conjunto de recomendações
- [ ] Definir métricas de sucesso e monitoramento contínuo

## Ferramentas Necessárias

1. **Google Cloud Billing**:
   - Acesso à API Cloud Billing
   - Permissão para exportar dados para BigQuery

2. **BigQuery**:
   - Dataset para análise de dados de faturamento
   - Permissões para consultas em datasets do sistema

3. **Data Studio** (Looker Studio):
   - Modelos de dashboard para visualização de custos
   - Conexão com BigQuery para relatórios dinâmicos

4. **gcloud CLI**:
   - Configurado com permissões adequadas
   - Utilização de scripts para automatizar análises

5. **Cloud Scheduler**:
   - Para automação de análises periódicas
   - Notificações de desvios significativos

## Permissões Requeridas

- `billing.accounts.getSpendingInformation`
- `bigquery.jobs.create`
- `compute.instances.list`
- `recommender.computeInstanceMachineTypeRecommendations.get`
- `storage.buckets.getIamPolicy`
- `monitoring.timeSeries.list`

## Produtos Recomendados para Análise Automática

- **Google Cloud Cost Management**
- **Google Cloud Recommender**
- **Google Cloud Monitoring**
- **Active Assist**

## Próximos Passos Imediatos

1. Solicitar permissões adicionais para acessar dados de faturamento
2. Configurar exportação de dados de faturamento para BigQuery
3. Executar as consultas iniciais de análise de custos
4. Criar relatório preliminar com os 10 recursos mais custosos

Este plano de análise deve ser executado em aproximadamente 7-10 dias úteis, dependendo da disponibilidade de dados e permissões.
