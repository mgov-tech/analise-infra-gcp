#!/bin/bash
# Script para remoção de snapshot antigo no projeto movva-captcha
# Data: 14/05/2025

# Definição de variáveis
PROJETO="movva-captcha"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-snapshot-$DATA.txt"
SNAPSHOT_NOME="captcha-app-prod-20230510"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Verificar se o snapshot existe
SNAPSHOT_INFO=$(gcloud compute snapshots describe $SNAPSHOT_NOME --format="json" 2>/dev/null)

if [ $? -eq 0 ]; then
    log "Snapshot $SNAPSHOT_NOME encontrado. Obtendo informações..."
    
    # Extrair informações importantes
    SNAPSHOT_DISK=$(echo $SNAPSHOT_INFO | jq -r '.sourceDisk // "N/A"')
    SNAPSHOT_SIZE=$(echo $SNAPSHOT_INFO | jq -r '.diskSizeGb // "N/A"')
    SNAPSHOT_CREATE=$(echo $SNAPSHOT_INFO | jq -r '.creationTimestamp // "N/A"')
    
    log "Detalhes do snapshot $SNAPSHOT_NOME:"
    log "  - Disco de origem: $SNAPSHOT_DISK"
    log "  - Tamanho: $SNAPSHOT_SIZE GB"
    log "  - Data de criação: $SNAPSHOT_CREATE"
    
    # Fazer backup dos metadados do snapshot
    log "Fazendo backup dos metadados do snapshot $SNAPSHOT_NOME"
    echo "$SNAPSHOT_INFO" > "backup-snapshot-$SNAPSHOT_NOME-$DATA.json"
    
    # Remover snapshot
    log "Removendo snapshot: $SNAPSHOT_NOME"
    gcloud compute snapshots delete $SNAPSHOT_NOME --quiet
    
    if [ $? -eq 0 ]; then
        log "SUCESSO: Snapshot $SNAPSHOT_NOME removido com sucesso."
    else
        log "FALHA: Não foi possível remover o snapshot $SNAPSHOT_NOME."
    fi
else
    log "Snapshot $SNAPSHOT_NOME não encontrado. Nada a fazer."
fi

log "Processo de remoção de snapshot concluído."
log "Verificando snapshots restantes no projeto..."
gcloud compute snapshots list --format="table(name,diskSizeGb,sourceDisk,creationTimestamp,status)" | tee -a $ARQUIVO_LOG

log "Script finalizado. Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
