#!/bin/bash
# Script para liberação de IPs estáticos não utilizados no projeto movva-datalake
# Data: 14/05/2025

# Configurar o projeto
gcloud config set project movva-datalake

# Criar log da execução
LOG_FILE="./log-liberacao-ip-$(date +%Y%m%d-%H%M%S).txt"
echo "Início da execução: $(date)" > $LOG_FILE

# Verificar status atual do IP
echo "Status atual do IP 'airbyte-prod':" | tee -a $LOG_FILE
gcloud compute addresses describe airbyte-prod --region=us-east1 --format="yaml(name,address,status,users)" 2>&1 | tee -a $LOG_FILE

# Liberar IP estático
echo "Liberando IP estático: airbyte-prod (34.23.150.23)" | tee -a $LOG_FILE
gcloud compute addresses delete airbyte-prod --region=us-east1 --quiet 2>&1 | tee -a $LOG_FILE

# Verificar se a liberação foi bem-sucedida
if [ $? -eq 0 ]; then
  echo "IP estático liberado com sucesso" | tee -a $LOG_FILE
else
  echo "ERRO: Falha ao liberar o IP estático" | tee -a $LOG_FILE
fi

# Verificar se o IP ainda existe
echo "Verificando se o IP ainda existe..." | tee -a $LOG_FILE
IP_EXISTE=$(gcloud compute addresses list --filter="name=airbyte-prod" --format="value(name)")

if [ -z "$IP_EXISTE" ]; then
  echo "Confirmado: IP não existe mais no sistema" | tee -a $LOG_FILE
else
  echo "ALERTA: O IP ainda existe no sistema!" | tee -a $LOG_FILE
fi

echo "Fim da execução: $(date)" | tee -a $LOG_FILE
