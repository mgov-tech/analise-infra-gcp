#!/bin/bash
# Script para análise de recursos de computação GCP da MOVVA
# Autor: Cascade AI
# Data: 06/05/2025

# Configuração
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DIR_DOCS="$ROOT_DIR/docs/computacao"
mkdir -p $DIR_DOCS

# Função para tratamento de erros
tratar_erro() {
  local comando=$1
  local projeto=$2
  local recurso=$3
  echo "AVISO: Não foi possível executar '$comando' para o projeto '$projeto' e recurso '$recurso'. Isso pode ocorrer devido a permissões limitadas."
  return 0
}

# Funções auxiliares
analisar_vms() {
  local projeto=$1
  local saida="$DIR_DOCS/vms_${projeto}.md"
  
  echo "# Instâncias de VM no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar todas as zonas disponíveis
  zonas=$(gcloud compute zones list --format="value(name)")
  
  # Para cada zona, listar VMs
  for zona in $zonas; do
    vms=$(gcloud compute instances list --project=$projeto --zones=$zona --format="table[no-heading](name)")
    
    if [ -n "$vms" ]; then
      echo "## VMs na Zona: $zona" >> $saida
      echo "" >> $saida
      echo "| Nome | Tipo de Máquina | Status | Disco de Boot | IPs |" >> $saida
      echo "|------|-----------------|--------|--------------|-----|" >> $saida
      
      while read -r vm; do
        if [ -n "$vm" ]; then
          info=$(gcloud compute instances describe $vm --project=$projeto --zone=$zona --format="yaml")
          machine_type=$(echo "$info" | grep "machineType:" | sed 's/.*machineType: ..*zones\/.*\///')
          status=$(echo "$info" | grep "status:" | cut -d: -f2- | sed 's/^[ \t]*//')
          boot_disk=$(echo "$info" | grep -A 1 "boot: true" | grep "deviceName:" | cut -d: -f2- | sed 's/^[ \t]*//')
          ip_externo=$(echo "$info" | grep "natIP:" | cut -d: -f2- | sed 's/^[ \t]*//')
          ip_interno=$(echo "$info" | grep "networkIP:" | cut -d: -f2- | sed 's/^[ \t]*//')
          
          echo "| $vm | $machine_type | $status | $boot_disk | Int: $ip_interno, Ext: $ip_externo |" >> $saida
          
          # Verificar otimizações
          if echo "$machine_type" | grep -q "n1-"; then
            echo "" >> $saida
            echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A instância $vm utiliza tipo de máquina n1, que é de geração antiga. Considere migrar para séries mais recentes (n2, e2, c2, etc) para melhor preço/desempenho." >> $saida
            echo "" >> $saida
          fi
          
          # Verificar discos não SSD
          discos=$(echo "$info" | grep "diskType:" | grep -v "pd-ssd" | wc -l)
          if [ $discos -gt 0 ]; then
            echo "" >> $saida
            echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A instância $vm utiliza discos não-SSD, o que pode impactar o desempenho. Considere migrar para pd-ssd." >> $saida
            echo "" >> $saida
          fi
        fi
      done <<< "$vms"
      
      echo "" >> $saida
    fi
  done
}

analisar_gke() {
  local projeto=$1
  local saida="$DIR_DOCS/gke_${projeto}.md"
  
  echo "# Clusters Kubernetes (GKE) no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar todos os clusters GKE
  clusters=$(gcloud container clusters list --project=$projeto --format="table[no-heading](name,location,currentMasterVersion,currentNodeCount,status)")
  
  if [ -n "$clusters" ]; then
    echo "| Nome do Cluster | Localização | Versão Kubernetes | Nós | Status |" >> $saida
    echo "|----------------|-------------|-------------------|-----|--------|" >> $saida
    
    while read -r nome localizacao versao nos status; do
      if [ -n "$nome" ]; then
        echo "| $nome | $localizacao | $versao | $nos | $status |" >> $saida
        
        # Verificar otimizações
        if [ "$nos" -lt 3 ]; then
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* O cluster $nome possui menos de 3 nós, o que pode comprometer a alta disponibilidade." >> $saida
          echo "" >> $saida
        fi
        
        # Detalhar node pools
        echo "## Node Pools para o Cluster: $nome" >> $saida
        echo "" >> $saida
        echo "| Nome | Tipo de Máquina | Tamanho | Versão | Autoscaling |" >> $saida
        echo "|------|-----------------|---------|--------|-------------|" >> $saida
        
        node_pools=$(gcloud container node-pools list --cluster=$nome --project=$projeto --location=$localizacao --format="table[no-heading](name,config.machineType,initialNodeCount,version,autoscaling.enabled)")
        
        while read -r pool_nome tipo tamanho pool_versao autoscaling; do
          echo "| $pool_nome | $tipo | $tamanho | $pool_versao | $autoscaling |" >> $saida
        done <<< "$node_pools"
        
        echo "" >> $saida
      fi
    done <<< "$clusters"
  else
    echo "Nenhum cluster GKE encontrado neste projeto." >> $saida
  fi
}

analisar_cloud_functions() {
  local projeto=$1
  local saida="$DIR_DOCS/functions_${projeto}.md"
  
  echo "# Cloud Functions no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar todas as regiões para Cloud Functions
  regioes=$(gcloud functions regions list --format="value(name)")
  
  for regiao in $regioes; do
    functions=$(gcloud functions list --project=$projeto --region=$regiao --format="table[no-heading](name,status,runtime,entryPoint)")
    
    if [ -n "$functions" ]; then
      echo "## Cloud Functions na Região: $regiao" >> $saida
      echo "" >> $saida
      echo "| Nome | Status | Runtime | Ponto de Entrada | Trigger |" >> $saida
      echo "|------|--------|---------|-----------------|---------|" >> $saida
      
      while read -r nome status runtime entry; do
        if [ -n "$nome" ]; then
          trigger=$(gcloud functions describe $nome --project=$projeto --region=$regiao --format="value(eventTrigger.eventType)")
          [ -z "$trigger" ] && trigger="HTTP"
          
          echo "| $nome | $status | $runtime | $entry | $trigger |" >> $saida
          
          # Verificar otimizações
          if [ "$runtime" = "nodejs8" ] || [ "$runtime" = "nodejs10" ] || [ "$runtime" = "python37" ]; then
            echo "" >> $saida
            echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A função $nome usa um runtime antigo ($runtime) que pode estar próximo do fim do suporte. Considere atualizar." >> $saida
            echo "" >> $saida
          fi
        fi
      done <<< "$functions"
      
      echo "" >> $saida
    fi
  done
}

# Processar projeto específico ou todos os projetos
if [ -n "$PROJETO_ALVO" ]; then
  # Se PROJETO_ALVO estiver definido, analisar apenas este projeto
  echo "Analisando recursos de computação no projeto: $PROJETO_ALVO"
  analisar_vms $PROJETO_ALVO
  analisar_gke $PROJETO_ALVO
  analisar_cloud_functions $PROJETO_ALVO
else
  # Processar todos os projetos
  projetos=$(gcloud projects list --format="value(projectId)")
  
  for projeto in $projetos; do
    echo "Analisando recursos de computação no projeto: $projeto"
    analisar_vms $projeto
    analisar_gke $projeto
    analisar_cloud_functions $projeto
  done
fi

echo "Análise de recursos de computação concluída. Verifique a documentação em $DIR_DOCS"
