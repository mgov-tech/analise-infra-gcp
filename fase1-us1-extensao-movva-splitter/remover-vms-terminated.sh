#!/bin/bash
# Script para remoção de VMs em estado TERMINATED e recursos associados no projeto movva-splitter
# Data: 14/05/2025

# Definição de variáveis
PROJETO="movva-splitter"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-vms-terminated-$DATA.txt"
ZONA="us-central1-a"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Lista de VMs a serem removidas
VMS=(
    "splitter-prod-v1"
    "splitter-stage-v1"
)

# Processar cada VM
for vm in "${VMS[@]}"; do
    log "==== Processando VM: $vm ===="
    
    # Verificar o estado atual da VM
    STATUS=$(gcloud compute instances describe $vm --zone=$ZONA --format="value(status)" 2>/dev/null)
    
    if [ "$STATUS" == "TERMINATED" ]; then
        log "VM $vm está no estado TERMINATED. Prosseguindo com a remoção."
        
        # Fazer backup dos metadados da VM
        log "Fazendo backup dos metadados da VM $vm"
        gcloud compute instances describe $vm --zone=$ZONA > "backup-vm-$vm-$DATA.json" 2>/dev/null
        
        # Remover VM
        log "Removendo VM: $vm (zona: $ZONA)"
        gcloud compute instances delete $vm --zone=$ZONA --quiet
        
        if [ $? -eq 0 ]; then
            log "SUCESSO: VM $vm removida com sucesso."
        else
            log "FALHA: Não foi possível remover a VM $vm."
        fi
    else
        if [ -z "$STATUS" ]; then
            log "VM $vm não encontrada. Pulando etapa de remoção da VM."
        else
            log "VM $vm não está no estado TERMINATED. Estado atual: $STATUS. Abortando remoção."
            log "Para evitar problemas, só devem ser removidas VMs no estado TERMINATED."
            continue
        fi
    fi
done

log "Processo de remoção de VMs concluído."
log "Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
