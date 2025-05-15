#!/bin/bash

# Script para aplicar políticas de ciclo de vida nos buckets GCP via CLI
# Data: 15/05/2025

# Função para aplicar política em um bucket
apply_lifecycle_policy() {
    local BUCKET_NAME=$1
    local POLICY_FILE=$2
    
    echo "Aplicando política de ciclo de vida no bucket: $BUCKET_NAME"
    echo "Arquivo de política: $POLICY_FILE"
    
    # Verifica se o bucket existe
    if ! gsutil ls -b gs://$BUCKET_NAME &> /dev/null; then
        echo "Erro: Bucket $BUCKET_NAME não encontrado ou sem permissões de acesso"
        return 1
    fi
    
    # Aplica a política de ciclo de vida
    gsutil lifecycle set $POLICY_FILE gs://$BUCKET_NAME
    
    if [ $? -eq 0 ]; then
        echo "✅ Política aplicada com sucesso no bucket $BUCKET_NAME"
        return 0
    else
        echo "❌ Falha ao aplicar política no bucket $BUCKET_NAME"
        return 1
    fi
}

# Aplicação das políticas nos buckets

# 1. movva-datalake (Produção - 30/90 dias)
echo -e "\n=== Aplicando política em movva-datalake ==="
apply_lifecycle_policy "movva-datalake" "config-movva-datalake.json"

# 2. movva-datalake-us-notebooks (Desenvolvimento - 15/45 dias)
echo -e "\n=== Aplicando política em movva-datalake-us-notebooks ==="
apply_lifecycle_policy "movva-datalake-us-notebooks" "config-movva-datalake-us-notebooks.json"

# 3. movva-sandbox (Desenvolvimento - 15/45 dias)
echo -e "\n=== Aplicando política em movva-sandbox ==="
apply_lifecycle_policy "movva-sandbox" "config-movva-sandbox.json"

# 4. razoes-pra-ficar (Produção - 30/90 dias)
echo -e "\n=== Aplicando política em razoes-pra-ficar ==="
apply_lifecycle_policy "razoes-pra-ficar" "config-razoes-pra-ficar.json"

# 5. poc-razoes-pra-ficar (Desenvolvimento - 15/45 dias)
echo -e "\n=== Aplicando política em poc-razoes-pra-ficar ==="
apply_lifecycle_policy "poc-razoes-pra-ficar" "config-poc-razoes-pra-ficar.json"

echo -e "\n=== Processo de aplicação de políticas concluído ==="
