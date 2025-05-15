#!/bin/bash
# Script para remoção de snapshots antigos no projeto movva-splitter
# Data: 14/05/2025

# Definição de variáveis
PROJETO="movva-splitter"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-snapshots-$DATA.txt"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Lista de snapshots a serem removidos
# Nota: Conforme recomendação, mantemos o snapshot de migração mais recente
SNAPSHOTS=(
    "splitter-prod-v1-backup-2023"
    "splitter-prod-v1-data-backup"
    # "splitter-migration-20230715" - mantido temporariamente para possível recuperação de dados
)

# Processar cada snapshot
for snapshot in "${SNAPSHOTS[@]}"; do
    log "==== Processando snapshot: $snapshot ===="
    
    # Verificar se o snapshot existe
    SNAPSHOT_INFO=$(gcloud compute snapshots describe $snapshot --format="json" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        log "Snapshot $snapshot encontrado. Obtendo informações..."
        
        # Extrair informações importantes
        SNAPSHOT_DISK=$(echo $SNAPSHOT_INFO | jq -r '.sourceDisk // "N/A"')
        SNAPSHOT_SIZE=$(echo $SNAPSHOT_INFO | jq -r '.diskSizeGb // "N/A"')
        SNAPSHOT_CREATE=$(echo $SNAPSHOT_INFO | jq -r '.creationTimestamp // "N/A"')
        
        log "Detalhes do snapshot $snapshot:"
        log "  - Disco de origem: $SNAPSHOT_DISK"
        log "  - Tamanho: $SNAPSHOT_SIZE GB"
        log "  - Data de criação: $SNAPSHOT_CREATE"
        
        # Fazer backup dos metadados do snapshot
        log "Fazendo backup dos metadados do snapshot $snapshot"
        echo "$SNAPSHOT_INFO" > "backup-snapshot-$snapshot-$DATA.json"
        
        # Remover snapshot
        log "Removendo snapshot: $snapshot"
        gcloud compute snapshots delete $snapshot --quiet
        
        if [ $? -eq 0 ]; then
            log "SUCESSO: Snapshot $snapshot removido com sucesso."
        else
            log "FALHA: Não foi possível remover o snapshot $snapshot."
        fi
    else
        log "Snapshot $snapshot não encontrado. Pulando remoção."
    fi
done

log "Processo de remoção de snapshots concluído."
log "Verificando snapshots restantes no projeto..."
gcloud compute snapshots list --format="table(name,diskSizeGb,sourceDisk,creationTimestamp,status)" | tee -a $ARQUIVO_LOG

log "Script finalizado. Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "Atenção: o snapshot 'splitter-migration-20230715' foi mantido propositalmente"
echo "==============================================="
