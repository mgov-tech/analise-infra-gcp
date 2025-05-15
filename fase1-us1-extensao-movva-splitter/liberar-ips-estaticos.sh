#!/bin/bash
# Script para liberação de IPs estáticos associados às VMs TERMINATED no projeto movva-splitter
# Data: 14/05/2025

# Definição de variáveis
PROJETO="movva-splitter"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-liberacao-ips-$DATA.txt"
REGIAO="us-central1"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Lista de IPs a serem liberados
IPS_PARA_LIBERAR=(
    "splitter-prod-v1"
    "splitter-stage-v1"
)

# Processar cada IP
for ip in "${IPS_PARA_LIBERAR[@]}"; do
    log "==== Processando IP: $ip ===="
    
    # Verificar se o IP existe
    IP_INFO=$(gcloud compute addresses describe $ip --region=$REGIAO --format="json" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        log "IP estático $ip encontrado. Obtendo informações..."
        
        # Extrair informações importantes
        IP_ADDRESS=$(echo $IP_INFO | jq -r '.address // "N/A"')
        IP_STATUS=$(echo $IP_INFO | jq -r '.status // "N/A"')
        IP_USERS=$(echo $IP_INFO | jq -r '.users // []')
        
        log "Detalhes do IP estático $ip:"
        log "  - Endereço: $IP_ADDRESS"
        log "  - Status: $IP_STATUS"
        log "  - Recursos associados: $IP_USERS"
        
        # Fazer backup dos metadados do IP
        log "Fazendo backup dos metadados do IP $ip"
        echo "$IP_INFO" > "backup-ip-$ip-$DATA.json"
        
        # Verificar se o IP está em uso
        if [ "$IP_STATUS" == "IN_USE" ]; then
            log "AVISO: O IP $ip está em uso (status: IN_USE). Verifique os recursos associados antes de liberar."
            log "Recursos associados: $IP_USERS"
            log "Para evitar problemas, não será liberado um IP em uso."
            continue
        fi
        
        # Liberar o IP estático
        log "Liberando IP estático: $ip (região: $REGIAO)"
        gcloud compute addresses delete $ip --region=$REGIAO --quiet
        
        if [ $? -eq 0 ]; then
            log "SUCESSO: IP estático $ip ($IP_ADDRESS) liberado com sucesso."
        else
            log "FALHA: Não foi possível liberar o IP estático $ip."
        fi
    else
        log "IP estático $ip não encontrado na região $REGIAO. Verificando em outras regiões..."
        
        # Verificar se existe como IP global
        IP_INFO_GLOBAL=$(gcloud compute addresses describe $ip --global --format="json" 2>/dev/null)
        
        if [ $? -eq 0 ]; then
            log "IP estático $ip encontrado como IP global. Obtendo informações..."
            
            IP_ADDRESS=$(echo $IP_INFO_GLOBAL | jq -r '.address // "N/A"')
            IP_STATUS=$(echo $IP_INFO_GLOBAL | jq -r '.status // "N/A"')
            
            log "Detalhes do IP estático global $ip:"
            log "  - Endereço: $IP_ADDRESS"
            log "  - Status: $IP_STATUS"
            
            # Fazer backup dos metadados do IP
            log "Fazendo backup dos metadados do IP global $ip"
            echo "$IP_INFO_GLOBAL" > "backup-ip-global-$ip-$DATA.json"
            
            # Liberar o IP estático global
            log "Liberando IP estático global: $ip"
            gcloud compute addresses delete $ip --global --quiet
            
            if [ $? -eq 0 ]; then
                log "SUCESSO: IP estático global $ip ($IP_ADDRESS) liberado com sucesso."
            else
                log "FALHA: Não foi possível liberar o IP estático global $ip."
            fi
        else
            log "ERRO: IP estático $ip não encontrado (nem regional nem global). Nada a liberar."
        fi
    fi
done

log "Processo de liberação de IPs estáticos concluído."
log "Verificando IPs estáticos restantes no projeto..."
gcloud compute addresses list --format="table(name,address,region,status,users)" | tee -a $ARQUIVO_LOG

log "Script finalizado. Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
