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

# Extrair custos por recurso (SKU)
echo "Extraindo custos por recurso (SKU)..."
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

# Extrair custos por VM (caso haja labels identificando VMs)
echo "Extraindo custos por recurso de VM..."
bq query --use_legacy_sql=false --format=csv > $RESULTS_DIR/custos_por_vm.csv << EOF
SELECT
  project.id as projeto,
  labels.key as chave_label,
  labels.value as valor_label,
  SUM(cost) as custo_total,
  SUM(CASE WHEN currency = 'BRL' THEN cost ELSE cost * 5.0 END) as custo_BRL
FROM \`$DATASET.$BILLING_TABLE\`, UNNEST(labels) as labels
WHERE 
  DATE(_PARTITIONTIME) >= DATE_SUB(CURRENT_DATE(), INTERVAL $MESES MONTH)
  AND service.description LIKE '%Compute%'
GROUP BY projeto, chave_label, valor_label
HAVING custo_total > 0
ORDER BY custo_total DESC
LIMIT 500
EOF

echo "Análise de custos por recurso concluída!"
