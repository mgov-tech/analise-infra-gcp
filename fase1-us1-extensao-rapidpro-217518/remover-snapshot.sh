#!/bin/bash
# Script para remoção de snapshot antigo no projeto rapidpro-217518
# Data: 14/05/2025

# Configurar o projeto
gcloud config set project rapidpro-217518

# Criar log da execução
LOG_FILE="./log-remocao-snapshot-$(date +%Y%m%d-%H%M%S).txt"
echo "Início da execução: $(date)" > $LOG_FILE

# Verificar status atual do snapshot
echo "Status atual do snapshot 'snapshot-1':" | tee -a $LOG_FILE
gcloud compute snapshots describe snapshot-1 --format="yaml(name,diskSizeGb,sourceDisk,creationTimestamp)" 2>&1 | tee -a $LOG_FILE

# Remover snapshot antigo
echo "Removendo snapshot: snapshot-1" | tee -a $LOG_FILE
gcloud compute snapshots delete snapshot-1 --quiet 2>&1 | tee -a $LOG_FILE

# Verificar se a remoção foi bem-sucedida
if [ $? -eq 0 ]; then
  echo "Snapshot removido com sucesso" | tee -a $LOG_FILE
else
  echo "ERRO: Falha ao remover o snapshot" | tee -a $LOG_FILE
fi

# Verificar se o snapshot ainda existe
echo "Verificando se o snapshot ainda existe..." | tee -a $LOG_FILE
SNAPSHOT_EXISTE=$(gcloud compute snapshots list --filter="name=snapshot-1" --format="value(name)")

if [ -z "$SNAPSHOT_EXISTE" ]; then
  echo "Confirmado: snapshot não existe mais no sistema" | tee -a $LOG_FILE
else
  echo "ALERTA: O snapshot ainda existe no sistema!" | tee -a $LOG_FILE
fi

echo "Fim da execução: $(date)" | tee -a $LOG_FILE
