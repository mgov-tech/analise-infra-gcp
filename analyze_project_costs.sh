#!/bin/bash

# Adicionar binários do Google Cloud SDK ao PATH
export PATH=$PATH:/Users/pablowinter/google-cloud-sdk/bin

# Variáveis
DATASET="billing_analysis"
BILLING_TABLE="gcp_billing_export"
RESULTS_DIR="./resultados_analise_billing"
MESES=3

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Extrair custos por projeto dos últimos X meses
echo "Extraindo custos por projeto dos últimos $MESES meses..."
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_por_projeto.csv << EOF
SELECT
  invoice.month as mes,
  project.id as projeto,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY mes, projeto
ORDER BY mes DESC, custo_total DESC
EOF

# Extrair custos totais agregados por projeto
echo "Extraindo custos totais agregados por projeto..."
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_totais_projeto.csv << EOF
SELECT
  project.id as projeto,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
GROUP BY projeto
ORDER BY custo_total DESC
EOF

echo "Análise de custos por projeto concluída!"
