#!/bin/bash
# Script para liberação de IP estático no projeto operations-dashboards
# Data: 14/05/2025

# Definição de variáveis
PROJETO="operations-dashboards"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-liberacao-ip-estatico-$DATA.txt"
IP_NOME="dashboards-vm-test"
REGIAO="us-central1"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Verificar se o IP existe
IP_INFO=$(gcloud compute addresses describe $IP_NOME --region=$REGIAO --format="json" 2>/dev/null)

if [ $? -eq 0 ]; then
    log "IP estático $IP_NOME encontrado. Obtendo informações..."
    
    # Extrair informações importantes
    IP_ADDRESS=$(echo $IP_INFO | jq -r '.address // "N/A"')
    IP_STATUS=$(echo $IP_INFO | jq -r '.status // "N/A"')
    IP_USERS=$(echo $IP_INFO | jq -r '.users // []')
    
    log "Detalhes do IP estático $IP_NOME:"
    log "  - Endereço: $IP_ADDRESS"
    log "  - Status: $IP_STATUS"
    log "  - Recursos associados: $IP_USERS"
    
    # Fazer backup dos metadados do IP
    log "Fazendo backup dos metadados do IP $IP_NOME"
    echo "$IP_INFO" > "backup-ip-$IP_NOME-$DATA.json"
    
    # Verificar se o IP está em uso
    if [ "$IP_STATUS" == "IN_USE" ]; then
        log "AVISO: O IP $IP_NOME está em uso (status: IN_USE). Verifique os recursos associados antes de liberar."
        log "Recursos associados: $IP_USERS"
        log "Abortando liberação por segurança."
        exit 1
    fi
    
    # Liberar o IP estático
    log "Liberando IP estático: $IP_NOME (região: $REGIAO)"
    gcloud compute addresses delete $IP_NOME --region=$REGIAO --quiet
    
    if [ $? -eq 0 ]; then
        log "SUCESSO: IP estático $IP_NOME ($IP_ADDRESS) liberado com sucesso."
    else
        log "FALHA: Não foi possível liberar o IP estático $IP_NOME."
    fi
else
    log "IP estático $IP_NOME não encontrado na região $REGIAO. Verificando em outras regiões..."
    
    # Verificar se existe como IP global
    IP_INFO_GLOBAL=$(gcloud compute addresses describe $IP_NOME --global --format="json" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        log "IP estático $IP_NOME encontrado como IP global. Obtendo informações..."
        
        IP_ADDRESS=$(echo $IP_INFO_GLOBAL | jq -r '.address // "N/A"')
        IP_STATUS=$(echo $IP_INFO_GLOBAL | jq -r '.status // "N/A"')
        
        log "Detalhes do IP estático global $IP_NOME:"
        log "  - Endereço: $IP_ADDRESS"
        log "  - Status: $IP_STATUS"
        
        # Fazer backup dos metadados do IP
        log "Fazendo backup dos metadados do IP global $IP_NOME"
        echo "$IP_INFO_GLOBAL" > "backup-ip-global-$IP_NOME-$DATA.json"
        
        # Liberar o IP estático global
        log "Liberando IP estático global: $IP_NOME"
        gcloud compute addresses delete $IP_NOME --global --quiet
        
        if [ $? -eq 0 ]; then
            log "SUCESSO: IP estático global $IP_NOME ($IP_ADDRESS) liberado com sucesso."
        else
            log "FALHA: Não foi possível liberar o IP estático global $IP_NOME."
        fi
    else
        log "ERRO: IP estático $IP_NOME não encontrado (nem regional nem global). Nada a liberar."
    fi
fi

log "Processo de liberação de IP estático concluído."
log "Verificando IPs estáticos restantes no projeto..."
gcloud compute addresses list --format="table(name,address,region,status,users)" | tee -a $ARQUIVO_LOG

log "Script finalizado. Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
