#!/bin/bash
# Script para remoção de VM em estado TERMINATED e recursos associados no projeto movva-captcha
# Data: 14/05/2025

# Definição de variáveis
PROJETO="movva-captcha"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-vm-terminated-$DATA.txt"
VM_NOME="captcha-dev"
ZONA="us-central1-a"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Verificar o estado atual da VM
STATUS=$(gcloud compute instances describe $VM_NOME --zone=$ZONA --format="value(status)" 2>/dev/null)

if [ "$STATUS" == "TERMINATED" ]; then
    log "VM $VM_NOME está no estado TERMINATED. Prosseguindo com a remoção."
    
    # Fazer backup dos metadados da VM
    log "Fazendo backup dos metadados da VM $VM_NOME"
    gcloud compute instances describe $VM_NOME --zone=$ZONA > "backup-vm-$VM_NOME-$DATA.json" 2>/dev/null
    
    # Remover VM
    log "Removendo VM: $VM_NOME (zona: $ZONA)"
    gcloud compute instances delete $VM_NOME --zone=$ZONA --quiet
    
    if [ $? -eq 0 ]; then
        log "SUCESSO: VM $VM_NOME removida com sucesso."
    else
        log "FALHA: Não foi possível remover a VM $VM_NOME."
        exit 1
    fi
else
    if [ -z "$STATUS" ]; then
        log "VM $VM_NOME não encontrada. Pulando etapa de remoção da VM."
    else
        log "VM $VM_NOME não está no estado TERMINATED. Estado atual: $STATUS. Abortando remoção."
        log "Para evitar problemas, só devem ser removidas VMs no estado TERMINATED."
        exit 1
    fi
fi

log "Processo de remoção da VM concluído."
log "Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
