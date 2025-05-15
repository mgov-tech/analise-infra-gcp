#!/bin/bash
# Script para remover versões antigas de App Engine no projeto operations-dashboards
# Data: 14/05/2025

# Definição de variáveis
PROJETO="operations-dashboards"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-versoes-appengine-$DATA.txt"
SERVICOS=("dashboards" "reports")
DATA_LIMITE="2025-01-01"  # Manter apenas versões posteriores a esta data

# Função para registrar mensagens no log
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a $ARQUIVO_LOG
}

# Configuração do projeto
log "Configurando projeto para: $PROJETO"
gcloud config set project $PROJETO

# Para cada serviço
for servico in "${SERVICOS[@]}"; do
    log "==== Processando serviço: $servico ===="
    
    # Fazer backup da lista completa de versões para referência
    log "Fazendo backup da lista de versões para o serviço $servico"
    gcloud app versions list --service=$servico --format="table(version.id,version.createTime,traffic_split,serving_status)" > "backup-$servico-versoes-$DATA.txt"
    
    # Obter versão atual que está recebendo tráfego
    VERSAO_COM_TRAFEGO=$(gcloud app versions list --service=$servico --format="value(version.id)" --filter="traffic_split>0")
    if [ ! -z "$VERSAO_COM_TRAFEGO" ]; then
        log "Versão atual com tráfego para o serviço $servico: $VERSAO_COM_TRAFEGO (será preservada)"
    else
        log "Aviso: Nenhuma versão com tráfego encontrada para o serviço $servico"
    fi
    
    # Listar versões antigas para remoção (antes da data limite e sem tráfego)
    log "Listando versões antigas para o serviço $servico"
    VERSOES_PARA_REMOVER=$(gcloud app versions list --service=$servico --format="value(version.id,version.createTime,traffic_split)" | 
                          awk -v data="$DATA_LIMITE" '$2 < data && $3 == "0.0" {print $1}')
    
    # Contar quantas versões serão removidas
    TOTAL_PARA_REMOVER=$(echo "$VERSOES_PARA_REMOVER" | wc -l)
    
    if [ $TOTAL_PARA_REMOVER -gt 0 ] && [ ! -z "$VERSOES_PARA_REMOVER" ]; then
        log "Total de versões antigas identificadas para o serviço $servico: $TOTAL_PARA_REMOVER"
        log "Lista de versões a serem removidas:"
        echo "$VERSOES_PARA_REMOVER" | while read versao; do
            if [ ! -z "$versao" ]; then
                log "  - $versao"
            fi
        done
        
        # IMPORTANTE: Esta seção está comentada para evitar remoção acidental
        # Remover as versões após aprovação (descomente as linhas abaixo)
        # log "Iniciando remoção de versões para o serviço $servico"
        # echo "$VERSOES_PARA_REMOVER" | while read versao; do
        #     if [ ! -z "$versao" ]; then
        #         log "Removendo versão: $servico:$versao"
        #         gcloud app versions delete --service=$servico $versao --quiet
        #         if [ $? -eq 0 ]; then
        #             log "SUCESSO: Versão $versao removida com sucesso."
        #         else
        #             log "FALHA: Não foi possível remover a versão $versao."
        #         fi
        #     fi
        # done
    else
        log "Nenhuma versão antiga encontrada para remoção no serviço $servico."
    fi
    
    log "Concluído processamento do serviço: $servico"
    log ""
done

log "==== Resumo da análise ===="
log "Total de serviços processados: ${#SERVICOS[@]}"
log "Data e hora de execução: $(date)"
log "IMPORTANTE: As remoções não foram executadas. Este script apenas identifica as versões que podem ser removidas."
log "Para executar a remoção, remova os comentários das linhas indicadas após aprovação do responsável."

echo "==============================================="
echo "Script finalizado. Confira o log em $ARQUIVO_LOG"
echo "Backup das versões foi salvo em arquivos 'backup-*-versoes-$DATA.txt'"
echo "ATENÇÃO: Nenhuma versão foi removida. Este script apenas fez a identificação."
echo "==============================================="
