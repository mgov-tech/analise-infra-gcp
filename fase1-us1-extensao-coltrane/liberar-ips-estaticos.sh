#!/bin/bash
# Script para liberação de IPs estáticos reservados e não utilizados no projeto coltrane
# Data: 14/05/2025

# Definição de variáveis
PROJETO="coltrane"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-liberacao-ips-$DATA.txt"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Lista de IPs a serem liberados
IPS_PARA_LIBERAR=(
    "coltrane-loadbalancer-demo-ip"
    "coltrane-loadbalancer-demo-ip-br"
)

# Verificar se os IPs ainda estão reservados e não em uso
log "Verificando status atual dos IPs..."
for ip in "${IPS_PARA_LIBERAR[@]}"; do
    STATUS=$(gcloud compute addresses describe $ip --global --format="value(status)")
    if [ "$STATUS" != "RESERVED" ]; then
        log "ERRO: IP $ip não está mais no estado RESERVED. Estado atual: $STATUS. Abortando liberação deste IP."
        continue
    fi
    
    log "IP $ip está no estado RESERVED e será liberado."
    
    # Liberar o IP estático
    log "Liberando IP estático: $ip"
    gcloud compute addresses delete $ip --global --quiet
    
    if [ $? -eq 0 ]; then
        log "SUCESSO: IP $ip liberado com sucesso."
    else
        log "FALHA: Não foi possível liberar o IP $ip."
    fi
done

log "Processo de liberação de IPs concluído."
log "Verificando IPs estáticos restantes no projeto..."
gcloud compute addresses list --format="table(name,address,region,status,users)" | tee -a $ARQUIVO_LOG

log "Script finalizado. Verifique o arquivo de log $ARQUIVO_LOG para detalhes da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
