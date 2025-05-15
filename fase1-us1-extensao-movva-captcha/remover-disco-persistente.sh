#!/bin/bash
# Script para remoção de disco persistente associado à VM TERMINATED no projeto movva-captcha
# Data: 14/05/2025

# Definição de variáveis
PROJETO="movva-captcha"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-disco-$DATA.txt"
DISCO_NOME="captcha-dev"
ZONA="us-central1-a"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Verificar se o disco existe
DISCO_INFO=$(gcloud compute disks describe $DISCO_NOME --zone=$ZONA --format="json" 2>/dev/null)

if [ $? -eq 0 ]; then
    log "Disco $DISCO_NOME encontrado. Obtendo informações..."
    
    # Extrair informações importantes
    DISCO_SIZE=$(echo $DISCO_INFO | jq -r '.sizeGb // "N/A"')
    DISCO_USERS=$(echo $DISCO_INFO | jq -r '.users // []')
    
    log "Detalhes do disco $DISCO_NOME:"
    log "  - Tamanho: $DISCO_SIZE GB"
    log "  - Recursos associados: $DISCO_USERS"
    
    # Verificar se o disco está em uso
    if [ "$DISCO_USERS" != "[]" ] && [ ! -z "$DISCO_USERS" ]; then
        log "AVISO: O disco $DISCO_NOME está atualmente em uso por outro recurso."
        log "Recursos associados: $DISCO_USERS"
        log "Para evitar problemas, não será removido um disco em uso."
        exit 1
    fi
    
    # Fazer backup dos metadados do disco
    log "Fazendo backup dos metadados do disco $DISCO_NOME"
    echo "$DISCO_INFO" > "backup-disco-$DISCO_NOME-$DATA.json"
    
    # Verificar se já existe snapshot do disco
    SNAPSHOT_EXISTE=$(gcloud compute snapshots list --filter="sourceDisk:$DISCO_NOME" --format="value(name)" 2>/dev/null)
    
    if [ -z "$SNAPSHOT_EXISTE" ]; then
        log "Nenhum snapshot encontrado para o disco $DISCO_NOME. Verificando se é necessário criar um snapshot de segurança..."
        
        # Aqui você pode adicionar lógica para decidir se cria um snapshot antes da remoção
        # Por exemplo, verificar a idade do disco ou outras condições
        
        # Comentado por segurança - descomente se necessário criar snapshot
        # log "Criando snapshot de segurança para o disco $DISCO_NOME antes da remoção"
        # gcloud compute snapshots create "pre-delete-$DISCO_NOME-$DATA" --source-disk=$DISCO_NOME --source-disk-zone=$ZONA
    else
        log "Snapshots existentes para o disco $DISCO_NOME: $SNAPSHOT_EXISTE"
    fi
    
    # Remover disco
    log "Removendo disco: $DISCO_NOME (zona: $ZONA)"
    gcloud compute disks delete $DISCO_NOME --zone=$ZONA --quiet
    
    if [ $? -eq 0 ]; then
        log "SUCESSO: Disco $DISCO_NOME removido com sucesso."
    else
        log "FALHA: Não foi possível remover o disco $DISCO_NOME."
    fi
else
    log "Disco $DISCO_NOME não encontrado. Nada a fazer."
fi

log "Processo de remoção de disco concluído."
log "Verificando discos persistentes restantes no projeto..."
gcloud compute disks list --format="table(name,zone,sizeGb,status,users)" | tee -a $ARQUIVO_LOG

log "Script finalizado. Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
