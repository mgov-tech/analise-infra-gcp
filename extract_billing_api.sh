#!/bin/bash

# Adicionar binários do Google Cloud SDK ao PATH
export PATH=$PATH:/Users/pablowinter/google-cloud-sdk/bin

# Variáveis
ACCOUNT_ID="01C8EE-D5051C-C120BC"  # ID da conta MGov
RESULTS_DIR="./resultados_analise_billing"
FORMATO="json"

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Obter dados de faturamento via API
echo "Extraindo dados de faturamento para a conta $ACCOUNT_ID..."

# Listar informações da conta de faturamento
echo "Detalhes da conta de faturamento:"
gcloud billing accounts describe $ACCOUNT_ID --format=$FORMATO > $RESULTS_DIR/detalhes_conta_faturamento.json

# Listar os projetos associados à conta de faturamento
echo "Projetos associados à conta de faturamento:"
gcloud billing projects list --billing-account=$ACCOUNT_ID --format=$FORMATO > $RESULTS_DIR/projetos_billing.json

# Para cada projeto, obter informações de uso e custo estimado
echo "Extraindo informações detalhadas por projeto..."
PROJETOS=$(gcloud billing projects list --billing-account=$ACCOUNT_ID --format="value(projectId)")

for PROJETO in $PROJETOS; do
  echo "Processando projeto: $PROJETO"
  
  # Obter informações sobre recursos ativos
  gcloud compute instances list --project=$PROJETO --format=$FORMATO > $RESULTS_DIR/${PROJETO}_vms.json 2>/dev/null || echo "Sem acesso a VMs ou sem VMs no projeto $PROJETO"
  
  gcloud sql instances list --project=$PROJETO --format=$FORMATO > $RESULTS_DIR/${PROJETO}_sql.json 2>/dev/null || echo "Sem acesso a instâncias SQL ou sem instâncias no projeto $PROJETO"
  
  gcloud functions list --project=$PROJETO --format=$FORMATO > $RESULTS_DIR/${PROJETO}_functions.json 2>/dev/null || echo "Sem acesso a Cloud Functions ou sem funções no projeto $PROJETO"
  
  gcloud app instances list --project=$PROJETO --format=$FORMATO > $RESULTS_DIR/${PROJETO}_appengine.json 2>/dev/null || echo "Sem acesso a App Engine ou sem instâncias no projeto $PROJETO"
  
  gcloud container clusters list --project=$PROJETO --format=$FORMATO > $RESULTS_DIR/${PROJETO}_gke.json 2>/dev/null || echo "Sem acesso a GKE ou sem clusters no projeto $PROJETO"
  
  gsutil ls -L -p $PROJETO gs:// > $RESULTS_DIR/${PROJETO}_buckets_info.txt 2>/dev/null || echo "Sem acesso a buckets ou sem buckets no projeto $PROJETO"
  
  # Agregar informações para estimar custos
  echo "Recursos ativos no projeto $PROJETO:" > $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  
  # Contar VMs
  if [ -s "$RESULTS_DIR/${PROJETO}_vms.json" ]; then
    VM_COUNT=$(jq '. | length' $RESULTS_DIR/${PROJETO}_vms.json 2>/dev/null || echo "0")
    echo "- Compute Engine VMs: $VM_COUNT" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  else
    echo "- Compute Engine VMs: 0" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  fi
  
  # Contar instâncias SQL
  if [ -s "$RESULTS_DIR/${PROJETO}_sql.json" ]; then
    SQL_COUNT=$(jq '. | length' $RESULTS_DIR/${PROJETO}_sql.json 2>/dev/null || echo "0")
    echo "- Cloud SQL Instances: $SQL_COUNT" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  else
    echo "- Cloud SQL Instances: 0" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  fi
  
  # Contar funções
  if [ -s "$RESULTS_DIR/${PROJETO}_functions.json" ]; then
    FUNC_COUNT=$(jq '. | length' $RESULTS_DIR/${PROJETO}_functions.json 2>/dev/null || echo "0")
    echo "- Cloud Functions: $FUNC_COUNT" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  else
    echo "- Cloud Functions: 0" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  fi
  
  # Contar instâncias App Engine
  if [ -s "$RESULTS_DIR/${PROJETO}_appengine.json" ]; then
    APP_COUNT=$(jq '. | length' $RESULTS_DIR/${PROJETO}_appengine.json 2>/dev/null || echo "0")
    echo "- App Engine Instances: $APP_COUNT" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  else
    echo "- App Engine Instances: 0" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  fi
  
  # Contar clusters GKE
  if [ -s "$RESULTS_DIR/${PROJETO}_gke.json" ]; then
    GKE_COUNT=$(jq '. | length' $RESULTS_DIR/${PROJETO}_gke.json 2>/dev/null || echo "0")
    echo "- GKE Clusters: $GKE_COUNT" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  else
    echo "- GKE Clusters: 0" >> $RESULTS_DIR/${PROJETO}_resumo_recursos.txt
  fi
done

echo "Extração de dados via API de Faturamento concluída!"
