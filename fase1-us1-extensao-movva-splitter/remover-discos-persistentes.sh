#!/bin/bash
# Script para remoção de discos persistentes associados às VMs TERMINATED no projeto movva-splitter
# Data: 14/05/2025

# Definição de variáveis
PROJETO="movva-splitter"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-discos-$DATA.txt"
ZONA="us-central1-a"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Lista de discos a serem removidos
DISCOS=(
    "splitter-prod-v1"
    "splitter-prod-v1-data"
    "splitter-stage-v1"
)

# Processar cada disco
for disco in "${DISCOS[@]}"; do
    log "==== Processando disco: $disco ===="
    
    # Verificar se o disco existe
    DISCO_INFO=$(gcloud compute disks describe $disco --zone=$ZONA --format="json" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        log "Disco $disco encontrado. Obtendo informações..."
        
        # Extrair informações importantes
        DISCO_SIZE=$(echo $DISCO_INFO | jq -r '.sizeGb // "N/A"')
        DISCO_USERS=$(echo $DISCO_INFO | jq -r '.users // []')
        
        log "Detalhes do disco $disco:"
        log "  - Tamanho: $DISCO_SIZE GB"
        log "  - Recursos associados: $DISCO_USERS"
        
        # Verificar se o disco está em uso
        if [ "$DISCO_USERS" != "[]" ] && [ ! -z "$DISCO_USERS" ]; then
            log "AVISO: O disco $disco está atualmente em uso por outro recurso."
            log "Recursos associados: $DISCO_USERS"
            log "Para evitar problemas, não será removido um disco em uso."
            continue
        fi
        
        # Fazer backup dos metadados do disco
        log "Fazendo backup dos metadados do disco $disco"
        echo "$DISCO_INFO" > "backup-disco-$disco-$DATA.json"
        
        # Verificar se já existe snapshot do disco
        SNAPSHOT_EXISTE=$(gcloud compute snapshots list --filter="sourceDisk:$disco" --format="value(name)" 2>/dev/null)
        
        if [ -z "$SNAPSHOT_EXISTE" ]; then
            log "Nenhum snapshot encontrado para o disco $disco. Verificando se é necessário criar um snapshot de segurança..."
            
            # Aqui você pode adicionar lógica para decidir se cria um snapshot antes da remoção
            # Por exemplo, verificar a idade do disco ou outras condições
            
            # Comentado por segurança - descomente se necessário criar snapshot
            # log "Criando snapshot de segurança para o disco $disco antes da remoção"
            # gcloud compute snapshots create "pre-delete-$disco-$DATA" --source-disk=$disco --source-disk-zone=$ZONA
        else
            log "Snapshots existentes para o disco $disco: $SNAPSHOT_EXISTE"
        fi
        
        # Remover disco
        log "Removendo disco: $disco (zona: $ZONA)"
        gcloud compute disks delete $disco --zone=$ZONA --quiet
        
        if [ $? -eq 0 ]; then
            log "SUCESSO: Disco $disco removido com sucesso."
        else
            log "FALHA: Não foi possível remover o disco $disco."
        fi
    else
        log "Disco $disco não encontrado. Pulando remoção."
    fi
done

log "Processo de remoção de discos concluído."
log "Verificando discos persistentes restantes no projeto..."
gcloud compute disks list --format="table(name,zone,sizeGb,status,users)" | tee -a $ARQUIVO_LOG

log "Script finalizado. Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
