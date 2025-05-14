# Plano de Análise de Gastos GCP via CLI

## Checagem Inicial

- [x] Verificar acesso à conta de faturamento do GCP
- [x] Identificar ID da conta de faturamento
- [x] Verificar permissões necessárias (billing.viewer ou billing.admin)
- [x] Criar diretório para armazenar resultados das análises
- [x] Verificar disponibilidade do BigQuery para exportação

## Extração de Dados de Billing

- [ ] Configurar exportação dos dados de faturamento para BigQuery
- [ ] Criar dataset dedicado para análise de custos
- [ ] Verificar se a exportação está funcionando corretamente
- [ ] Aguardar população inicial dos dados (24-48h para dados históricos)

### Limitações Encontradas

- [x] Não foi possível configurar a exportação para BigQuery via CLI devido a limitações de permissão
- [x] Adaptamos a abordagem para extrair informações diretamente dos projetos

## Análise por Projeto

- [x] Extrair informações básicas por projeto
- [x] Comparar projetos associados à conta de faturamento
- [x] Identificar serviços ativos em cada projeto
- [x] Validar valores com os apresentados no documento de infraestrutura

## Análise por Serviço

- [x] Extrair lista de serviços ativos por projeto
- [x] Identificar os principais serviços em cada projeto
- [x] Comparar com estimativas atuais no documento
- [ ] Gerar gráficos de distribuição de custos por serviço

### Limitações Encontradas

- [x] Não foi possível extrair dados de custos detalhados por serviço devido à falta de exportação para BigQuery

## Análise por Recurso

- [x] Identificar recursos específicos (buckets, VMs, functions)
- [ ] Analisar padrões de uso e gasto de recursos críticos
- [ ] Validar estimativas de economia potencial
- [ ] Identificar outliers e gastos anormais

### Limitações Encontradas

- [x] Acesso limitado a recursos específicos devido a restrições de permissão
- [x] Apenas um bucket foi identificado no projeto seduc-sp

## Análise Temporal

- [ ] Extrair tendência de gastos dos últimos 6 meses
- [ ] Identificar padrões sazonais ou picos de utilização
- [ ] Correlacionar eventos de negócio com variações de custo
- [ ] Projetar gastos futuros baseados em tendências

### Limitações Encontradas

- [x] Não foi possível realizar análise temporal devido à falta de dados históricos de faturamento

## Validação e Correção

- [x] Comparar dados do billing com os apresentados no documento
- [x] Identificar discrepâncias significativas
- [ ] Atualizar valores no documento de infraestrutura consolidada
- [ ] Ajustar estimativas de economia baseadas em dados reais

### Principais Discrepâncias

- [x] Documento menciona 15 buckets de armazenamento, mas apenas 1 foi encontrado
- [x] Documento menciona VMs e Cloud Functions que não foram possíveis identificar devido a limitações de acesso

## Scripts Desenvolvidos

- [x] setup_ambiente.sh - Configuração inicial e verificação de acesso
- [x] extract_billing_data.sh - Extração de dados básicos dos projetos
- [x] generate_analysis_report.sh - Geração de relatório consolidado

## Resultados Obtidos

- [x] Relatório de análise de recursos gerado em resultados_analise_billing/relatorio_analise_recursos_gcp.md
- [x] Informações de serviços ativos por projeto
- [x] Comparativo com documento de infraestrutura consolidada

## Recomendações Futuras

1. Solicitar permissões billing.admin para configurar exportação para BigQuery
2. Implementar etiquetas de recursos para melhorar rastreabilidade de custos
3. Configurar alertas de orçamento para projetos críticos
4. Revisar e atualizar documentação de infraestrutura com base nos recursos atualmente ativos

### 1. Configuração Inicial

```bash
#!/bin/bash
# setup_billing_analysis.sh

# Variáveis
ACCOUNT_ID="BILLING_ACCOUNT_ID"
DATASET="billing_analysis"
BILLING_TABLE="gcp_billing_export"
RESULTS_DIR="./resultados_analise_billing"

# Criar diretório para resultados
mkdir -p $RESULTS_DIR

# Listar contas de faturamento disponíveis
echo "Contas de faturamento disponíveis:"
gcloud billing accounts list | tee $RESULTS_DIR/contas_faturamento.txt

# Verificar projetos associados à conta
echo "Projetos associados à conta de faturamento $ACCOUNT_ID:"
gcloud billing projects list --billing-account=$ACCOUNT_ID | tee $RESULTS_DIR/projetos_conta.txt

# Configurar exportação para BigQuery (se necessário)
# gcloud billing accounts export billing-data \
#    --billing-account=$ACCOUNT_ID \
#    --dataset=$DATASET \
#    --table-name=$BILLING_TABLE

echo "Configuração inicial concluída!"
```

### 2. Análise de Custos por Projeto

```bash
#!/bin/bash
# analyze_project_costs.sh

# Variáveis
DATASET="billing_analysis"
BILLING_TABLE="gcp_billing_export"
RESULTS_DIR="./resultados_analise_billing"
MESES=3

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Extrair custos por projeto dos últimos X meses
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_por_projeto.csv << EOF
SELECT
  invoice.month as mes,
  project.id as projeto,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY mes, projeto
ORDER BY mes DESC, custo_total DESC
EOF

# Extrair custos totais agregados por projeto
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_totais_projeto.csv << EOF
SELECT
  project.id as projeto,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY projeto
ORDER BY custo_total DESC
EOF

echo "Análise de custos por projeto concluída!"
```

### 3. Análise de Custos por Serviço

```bash
#!/bin/bash
# analyze_service_costs.sh

# Variáveis
DATASET="billing_analysis"
BILLING_TABLE="gcp_billing_export"
RESULTS_DIR="./resultados_analise_billing"
MESES=3

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Extrair custos por serviço para todos os projetos
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_por_servico.csv << EOF
SELECT
  service.description as servico,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY servico
ORDER BY custo_total DESC
EOF

# Extrair custos por serviço para cada projeto
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_servico_por_projeto.csv << EOF
SELECT
  project.id as projeto,
  service.description as servico,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY projeto, servico
ORDER BY projeto, custo_total DESC
EOF

echo "Análise de custos por serviço concluída!"
```

### 4. Análise de Recursos Específicos

```bash
#!/bin/bash
# analyze_resource_costs.sh

# Variáveis
DATASET="billing_analysis"
BILLING_TABLE="gcp_billing_export"
RESULTS_DIR="./resultados_analise_billing"
MESES=3

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Extrair custos por recurso (SKU)
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_por_sku.csv << EOF
SELECT
  project.id as projeto,
  service.description as servico,
  sku.description as recurso,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY projeto, servico, recurso
HAVING custo_total > 0
ORDER BY custo_total DESC
LIMIT 1000
EOF

# Extrair custos de VMs por tipo e projeto
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_vms.csv << EOF
SELECT
  project.id as projeto,
  sku.description as tipo_vm,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE 
  service.description = 'Compute Engine'
  AND sku.description LIKE '%Instance%'
  AND DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY projeto, tipo_vm
ORDER BY custo_total DESC
EOF

# Extrair custos de armazenamento
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_storage.csv << EOF
SELECT
  project.id as projeto,
  service.description as servico,
  sku.description as tipo_storage,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE 
  (service.description = 'Cloud Storage' OR
   service.description LIKE '%SQL%' OR
   service.description = 'BigQuery')
  AND DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY projeto, servico, tipo_storage
ORDER BY custo_total DESC
EOF

echo "Análise de custos por recurso concluída!"
```

### 5. Análise Temporal e Tendências

```bash
#!/bin/bash
# analyze_cost_trends.sh

# Variáveis
DATASET="billing_analysis"
BILLING_TABLE="gcp_billing_export"
RESULTS_DIR="./resultados_analise_billing"
MESES=6

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Extrair tendência de gastos mensais
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/tendencia_mensal.csv << EOF
SELECT
  FORMAT_DATE('%Y-%m', usage_start_time) as mes,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY mes
ORDER BY mes
EOF

# Extrair tendência de gastos semanais
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/tendencia_semanal.csv << EOF
SELECT
  FORMAT_DATE('%Y-%U', usage_start_time) as semana,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY semana
ORDER BY semana
EOF

# Extrair tendência por serviço principal ao longo do tempo
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/tendencia_servicos.csv << EOF
SELECT
  FORMAT_DATE('%Y-%m', usage_start_time) as mes,
  service.description as servico,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY mes, servico
ORDER BY mes, custo_total DESC
EOF

echo "Análise de tendências de custo concluída!"
```

### 6. Script para Validação e Atualização

```bash
#!/bin/bash
# validate_and_update.sh

# Variáveis
RESULTS_DIR="./resultados_analise_billing"
DOC_INFRA="./docs/infraestrutura_consolidada.md"
DOC_RECOMENDACOES="./docs/otimizacao/recomendacoes_consolidadas.md"
REPORT_FILE="./resultados_analise_billing/relatorio_validacao.md"

# Criar relatório de validação
echo "# Relatório de Validação de Gastos GCP" > $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Data: $(date '+%d/%m/%Y')" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Adicionar dados de custo total
echo "## Custo Total GCP" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Dados do último relatório mensal vs dados atuais:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "| Fonte | Valor Mensal (R\$) |" >> $REPORT_FILE
echo "|-------|-------------------|" >> $REPORT_FILE
echo "| Documento Atual | R\$ 15.000,00 |" >> $REPORT_FILE
echo "| Billing Export | R\$ $(cat $RESULTS_DIR/tendencia_mensal.csv | tail -1 | cut -d',' -f3) |" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Adicionar dados dos principais projetos
echo "## Custos por Projeto" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "| Projeto | Documento Atual (R\$) | Billing Export (R\$) | Diferença (%) |" >> $REPORT_FILE
echo "|---------|------------------------|----------------------|---------------|" >> $REPORT_FILE

# Aqui seria necessário um processamento mais elaborado para extrair valores
# do documento atual e compará-los com os dados do billing
# Este é um placeholder que precisaria ser adaptado

# Adicionar dados dos principais serviços
echo "## Custos por Serviço" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "| Serviço | Documento Atual (R\$) | Billing Export (R\$) | Diferença (%) |" >> $REPORT_FILE
echo "|---------|------------------------|----------------------|---------------|" >> $REPORT_FILE

# Adicionar recomendações de atualização
echo "## Recomendações de Atualização" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Com base na análise dos dados de faturamento, recomendamos as seguintes atualizações nos documentos:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "1. **Atualizar custo mensal total** para R\$ $(cat $RESULTS_DIR/tendencia_mensal.csv | tail -1 | cut -d',' -f3)" >> $REPORT_FILE
echo "2. **Revisar custos por projeto** conforme dados atualizados" >> $REPORT_FILE
echo "3. **Revisar custos por serviço** conforme dados atualizados" >> $REPORT_FILE
echo "4. **Ajustar estimativas de economia** com base nos novos valores identificados" >> $REPORT_FILE

echo "Relatório de validação gerado: $REPORT_FILE"
```

## Script Principal de Execução

```bash
#!/bin/bash
# run_billing_analysis.sh

echo "=== Iniciando análise completa de billing GCP ==="

# Executar setup
echo "Configurando ambiente..."
./setup_billing_analysis.sh

# Executar análises
echo "Analisando custos por projeto..."
./analyze_project_costs.sh

echo "Analisando custos por serviço..."
./analyze_service_costs.sh

echo "Analisando custos por recurso..."
./analyze_resource_costs.sh

echo "Analisando tendências de custo..."
./analyze_cost_trends.sh

# Validar e gerar relatório
echo "Validando dados e gerando relatório..."
./validate_and_update.sh

echo "=== Análise completa finalizada ==="
echo "Verifique os resultados em ./resultados_analise_billing/"
```

## Atualização do Documento de Infraestrutura

Após a execução dos scripts acima, será necessário atualizar o arquivo `/docs/infraestrutura_consolidada.md` com os valores precisos obtidos da análise de faturamento. Isso deve incluir:

1. Atualizar o valor total mensal de gastos GCP
2. Ajustar os valores de custo por projeto
3. Revisar a tabela de custos por serviço
4. Ajustar as estimativas de economia potencial

## Problemas e Limitações Conhecidos

- A exportação de dados de faturamento para o BigQuery pode levar até 24 horas para iniciar
- Dados históricos podem não estar disponíveis para todos os períodos de análise
- Algumas informações detalhadas de recursos podem não estar disponíveis via export padrão
- Conversão de moedas pode variar conforme configuração da conta de faturamento

## Próximos Passos

1. Implementar os scripts de análise
2. Executar análise completa de faturamento
3. Validar dados com o documento atual
4. Atualizar o documento de infraestrutura consolidada
5. Revisar estimativas de economia
6. Configurar sistema de monitoramento contínuo de custos
