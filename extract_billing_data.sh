#!/bin/bash

# Adicionar binários do Google Cloud SDK ao PATH
export PATH=$PATH:/Users/pablowinter/google-cloud-sdk/bin

# Variáveis
ACCOUNT_ID="01C8EE-D5051C-C120BC"  # ID da conta MGov
RESULTS_DIR="./resultados_analise_billing"
MESES=3
FORMATO_SAIDA="csv"

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Extrair dados de faturamento via gcloud CLI para os projetos associados
echo "Extraindo dados de faturamento para projetos associados à conta $ACCOUNT_ID..."

# Listar todos os projetos
PROJETOS=$(gcloud billing projects list --billing-account=$ACCOUNT_ID --format="value(PROJECT_ID)")

# Para cada projeto, obter os custos
for PROJETO in $PROJETOS; do
  echo "Extraindo custos para o projeto: $PROJETO"
  
  # Obter detalhes do projeto
  gcloud projects describe $PROJETO > $RESULTS_DIR/${PROJETO}_info.txt
  
  # Obter serviços em uso
  gcloud services list --project=$PROJETO > $RESULTS_DIR/${PROJETO}_services.txt
  
  # Obter VMs em execução
  gcloud compute instances list --project=$PROJETO --format=csv > $RESULTS_DIR/${PROJETO}_vms.csv 2>/dev/null || echo "Sem acesso a VMs ou sem VMs no projeto $PROJETO"
  
  # Obter buckets de armazenamento
  gsutil ls -p $PROJETO > $RESULTS_DIR/${PROJETO}_buckets.txt 2>/dev/null || echo "Sem acesso a buckets ou sem buckets no projeto $PROJETO"
  
  # Obter Cloud Functions
  gcloud functions list --project=$PROJETO --format=csv > $RESULTS_DIR/${PROJETO}_functions.csv 2>/dev/null || echo "Sem acesso a functions ou sem functions no projeto $PROJETO"
done

# Extrair relatório de faturamento resumido usando gcloud beta billing (se disponível)
if gcloud beta billing accounts --help &>/dev/null; then
  echo "Exportando resumo de faturamento via gcloud beta billing..."
  gcloud beta billing accounts --project=movva-datalake --billing-account=$ACCOUNT_ID > $RESULTS_DIR/beta_billing_summary.txt 2>/dev/null
else
  echo "Comando gcloud beta billing não disponível. Pulando exportação de resumo de faturamento."
fi

echo "Extração de dados de faturamento concluída!"
