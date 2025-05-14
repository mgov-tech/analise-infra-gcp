#!/bin/bash

# Adicionar binários do Google Cloud SDK ao PATH
export PATH=$PATH:/Users/pablowinter/google-cloud-sdk/bin

# Variáveis
DATASET="billing_analysis"
BILLING_TABLE="gcp_billing_export"
RESULTS_DIR="./resultados_analise_billing"
MESES=6

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Extrair tendência de gastos dos últimos X meses
echo "Extraindo tendências de gastos dos últimos $MESES meses..."
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/tendencia_gastos.csv << EOF
SELECT
  FORMAT_DATE('%Y-%m', usage_start_time) as mes,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY mes
ORDER BY mes
EOF

# Extrair tendência por projeto
echo "Extraindo tendências por projeto..."
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/tendencia_por_projeto.csv << EOF
SELECT
  FORMAT_DATE('%Y-%m', usage_start_time) as mes,
  project.id as projeto,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY mes, projeto
ORDER BY projeto, mes
EOF

# Extrair tendência por serviço
echo "Extraindo tendências por serviço..."
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/tendencia_por_servico.csv << EOF
SELECT
  FORMAT_DATE('%Y-%m', usage_start_time) as mes,
  service.description as servico,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY mes, servico
ORDER BY servico, mes
EOF

echo "Análise de tendências temporais concluída!"
