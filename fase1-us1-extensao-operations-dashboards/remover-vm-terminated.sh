#!/bin/bash
# Script para remoção de VM em estado TERMINATED e recursos associados no projeto operations-dashboards
# Data: 14/05/2025

# Definição de variáveis
PROJETO="operations-dashboards"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-vm-terminated-$DATA.txt"
VM_NOME="dashboards-vm-test"
ZONA="us-central1-a"

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Fazer backup dos metadados da VM antes da remoção
log "Fazendo backup dos metadados da VM $VM_NOME"
gcloud compute instances describe $VM_NOME --zone=$ZONA > "backup-vm-$VM_NOME-$DATA.json" 2>/dev/null

if [ $? -eq 0 ]; then
    log "Backup dos metadados da VM criado com sucesso: backup-vm-$VM_NOME-$DATA.json"
else
    log "AVISO: Não foi possível criar backup completo dos metadados da VM. Continuando com o processo."
fi

# Verificar o estado atual da VM
STATUS=$(gcloud compute instances describe $VM_NOME --zone=$ZONA --format="value(status)" 2>/dev/null)

if [ "$STATUS" == "TERMINATED" ]; then
    log "VM $VM_NOME está no estado TERMINATED. Prosseguindo com a remoção."
    
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
        exit 1
    fi
fi

# Verificar e remover discos associados
DISCOS=(
    "dashboards-vm-test"
    "dashboards-vm-test-backup"
)

for disco in "${DISCOS[@]}"; do
    # Verificar se o disco existe
    DISCO_STATUS=$(gcloud compute disks describe $disco --zone=$ZONA --format="value(status)" 2>/dev/null)
    
    if [ ! -z "$DISCO_STATUS" ]; then
        log "Disco $disco encontrado com status: $DISCO_STATUS"
        
        # Fazer backup dos metadados do disco
        log "Fazendo backup dos metadados do disco $disco"
        gcloud compute disks describe $disco --zone=$ZONA > "backup-disco-$disco-$DATA.json"
        
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

log "Processo de remoção da VM e discos associados concluído."
log "Verifique o arquivo de log $ARQUIVO_LOG para detalhes completos da operação."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "==============================================="
