#!/bin/bash
# Script para remoção de snapshots obsoletos no projeto movva-datalake
# Data: 14/05/2025

# Configurar o projeto
gcloud config set project movva-datalake

# Criar log da execução
LOG_FILE="./log-remocao-snapshots-$(date +%Y%m%d-%H%M%S).txt"
echo "Início da execução: $(date)" > $LOG_FILE

# Remover snapshot antigo
echo "Removendo snapshot: airbyte-recovery--2023-06-23--14h43" | tee -a $LOG_FILE
gcloud compute snapshots delete airbyte-recovery--2023-06-23--14h43 --quiet 2>&1 | tee -a $LOG_FILE

# Verificar se a remoção foi bem-sucedida
if [ $? -eq 0 ]; then
  echo "Snapshot removido com sucesso" | tee -a $LOG_FILE
else
  echo "ERRO: Falha ao remover o snapshot" | tee -a $LOG_FILE
fi

# Verificar se o snapshot ainda existe
echo "Verificando se o snapshot ainda existe..." | tee -a $LOG_FILE
SNAPSHOT_EXISTE=$(gcloud compute snapshots list --filter="name=airbyte-recovery--2023-06-23--14h43" --format="value(name)")

if [ -z "$SNAPSHOT_EXISTE" ]; then
  echo "Confirmado: snapshot não existe mais no sistema" | tee -a $LOG_FILE
else
  echo "ALERTA: O snapshot ainda existe no sistema!" | tee -a $LOG_FILE
fi

echo "Fim da execução: $(date)" | tee -a $LOG_FILE
