#!/bin/bash

# Configurar o PATH para incluir os binários do Google Cloud SDK
export PATH=$PATH:/Users/pablowinter/google-cloud-sdk/bin

# Variáveis
ACCOUNT_ID="01C8EE-D5051C-C120BC"  # ID da conta MGov
DATASET="billing_analysis"
BILLING_TABLE="gcp_billing_export"
RESULTS_DIR="./resultados_analise_billing"

# Criar diretório para resultados
mkdir -p $RESULTS_DIR

# Testar conexão e autenticação
echo "Verificando autenticação GCP..."
gcloud auth list | tee $RESULTS_DIR/autenticacao.txt

# Listar contas de faturamento disponíveis
echo "Contas de faturamento disponíveis:"
gcloud billing accounts list | tee $RESULTS_DIR/contas_faturamento.txt

# Verificar projetos associados à conta
echo "Projetos associados à conta de faturamento $ACCOUNT_ID:"
gcloud billing projects list --billing-account=$ACCOUNT_ID | tee $RESULTS_DIR/projetos_conta.txt

echo "Configuração inicial concluída!"
