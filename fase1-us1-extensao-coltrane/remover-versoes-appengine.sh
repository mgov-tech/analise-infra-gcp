#!/bin/bash
# Script para remover versões antigas de App Engine no projeto coltrane
# Data: 14/05/2025

# Definição de variáveis
PROJETO="coltrane"
DATA=$(date +"%Y%m%d-%H%M%S")
ARQUIVO_LOG="log-remocao-versoes-appengine-$DATA.txt"
SERVICOS=("default" "stage" "webapp" "webapp-stage")
DATA_LIMITE="2025-01-01"  # Manter apenas versões posteriores a esta data
VERSOES_MANTER=5  # Número mínimo de versões a manter por serviço (independente da data)

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
    
    # Listar todas as versões em ordem cronológica inversa (mais recentes primeiro)
    log "Listando versões para o serviço $servico"
    TODAS_VERSOES=$(gcloud app versions list --service=$servico --format="value(version.id,version.createTime,traffic_split)" | sort -k2 -r)
    
    # Contar o número total de versões
    TOTAL_VERSOES=$(echo "$TODAS_VERSOES" | wc -l)
    log "Total de versões encontradas para o serviço $servico: $TOTAL_VERSOES"
    
    # Iniciar contador de versões processadas e mantidas
    VERSOES_PROCESSADAS=0
    VERSOES_MANTIDAS=0
    VERSOES_PARA_REMOVER=()
    
    # Processar cada versão
    while IFS= read -r linha; do
        # Extrair informações da linha
        VERSAO=$(echo $linha | awk '{print $1}')
        DATA_CRIACAO=$(echo $linha | awk '{print $2}')
        TRAFEGO=$(echo $linha | awk '{print $3}')
        
        VERSOES_PROCESSADAS=$((VERSOES_PROCESSADAS + 1))
        
        # Verificar se é a versão com tráfego
        if [ "$VERSAO" = "$VERSAO_COM_TRAFEGO" ]; then
            log "Mantendo versão com tráfego: $VERSAO ($DATA_CRIACAO)"
            VERSOES_MANTIDAS=$((VERSOES_MANTIDAS + 1))
            continue
        fi
        
        # Verificar se está dentro das versões a manter (mais recentes)
        if [ $VERSOES_MANTIDAS -lt $VERSOES_MANTER ]; then
            log "Mantendo versão recente: $VERSAO ($DATA_CRIACAO)"
            VERSOES_MANTIDAS=$((VERSOES_MANTIDAS + 1))
            continue
        fi
        
        # Verificar se é posterior à data limite
        if [[ "$DATA_CRIACAO" > "$DATA_LIMITE" ]]; then
            log "Mantendo versão posterior à data limite: $VERSAO ($DATA_CRIACAO)"
            VERSOES_MANTIDAS=$((VERSOES_MANTIDAS + 1))
            continue
        fi
        
        # Se chegou aqui, a versão deve ser removida
        log "Marcando para remoção: $VERSAO ($DATA_CRIACAO)"
        VERSOES_PARA_REMOVER+=("$VERSAO")
        
    done <<< "$TODAS_VERSOES"
    
    # Resumo das versões a serem removidas
    TOTAL_PARA_REMOVER=${#VERSOES_PARA_REMOVER[@]}
    log "Total de versões a serem removidas para o serviço $servico: $TOTAL_PARA_REMOVER"
    
    if [ $TOTAL_PARA_REMOVER -gt 0 ]; then
        log "Lista de versões a serem removidas:"
        for versao in "${VERSOES_PARA_REMOVER[@]}"; do
            log "  - $versao"
        done
        
        # IMPORTANTE: Esta seção está comentada para evitar remoção acidental
        # Remover as versões após aprovação (descomente as linhas abaixo)
        # log "Iniciando remoção de versões para o serviço $servico"
        # for versao in "${VERSOES_PARA_REMOVER[@]}"; do
        #     log "Removendo versão: $servico:$versao"
        #     gcloud app versions delete --service=$servico $versao --quiet
        #     if [ $? -eq 0 ]; then
        #         log "SUCESSO: Versão $versao removida com sucesso."
        #     else
        #         log "FALHA: Não foi possível remover a versão $versao."
        #     fi
        # done
    else
        log "Nenhuma versão a ser removida para o serviço $servico."
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
