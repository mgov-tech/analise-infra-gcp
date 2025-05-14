#!/bin/bash

# Script para habilitar as APIs necessárias para análise completa da infraestrutura GCP da MOVVA
# Autor: Pablo Winter
# Data: 06/05/2025

set -e

# Configuração
PROJETOS=(
  "movva-datalake"
  "movva-splitter"
  "movva-captcha-1698695351695"
)

APIS=(
  "sqladmin.googleapis.com"            # Cloud SQL Admin API
  "datacatalog.googleapis.com"         # Data Catalog API
  "dataflow.googleapis.com"            # Dataflow API
  "composer.googleapis.com"            # Cloud Composer API
  "bigquerydatatransfer.googleapis.com" # BigQuery Data Transfer API
  "compute.googleapis.com"             # Compute Engine API (para algumas verificações)
)

# Cores para saída
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
NC='\033[0m' # No Color

# Função para verificar se o usuário está autenticado
verificar_autenticacao() {
  echo -e "${AMARELO}Verificando autenticação...${NC}"
  if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "@"; then
    echo -e "${VERMELHO}Você não está autenticado no gcloud. Execute 'gcloud auth login' primeiro.${NC}"
    exit 1
  else
    echo -e "${VERDE}Autenticado como $(gcloud auth list --filter=status:ACTIVE --format="value(account)")${NC}"
  fi
}

# Função para habilitar uma API específica em um projeto
habilitar_api() {
  local projeto=$1
  local api=$2
  
  echo -e "${AMARELO}Verificando API $api no projeto $projeto...${NC}"
  
  # Verifica se a API já está habilitada
  if gcloud services list --project=$projeto --filter="name:$api" --format="value(name)" | grep -q "$api"; then
    echo -e "${VERDE}API $api já está habilitada no projeto $projeto.${NC}"
    return 0
  fi
  
  # Tenta habilitar a API
  echo -e "${AMARELO}Habilitando API $api no projeto $projeto...${NC}"
  if gcloud services enable $api --project=$projeto; then
    echo -e "${VERDE}API $api habilitada com sucesso no projeto $projeto.${NC}"
    return 0
  else
    echo -e "${VERMELHO}Falha ao habilitar API $api no projeto $projeto. Verificar permissões.${NC}"
    return 1
  fi
}

# Função principal
main() {
  verificar_autenticacao
  
  local sucessos=0
  local falhas=0
  
  for projeto in "${PROJETOS[@]}"; do
    echo -e "\n${AMARELO}Processando projeto: $projeto${NC}"
    
    for api in "${APIS[@]}"; do
      if habilitar_api "$projeto" "$api"; then
        ((sucessos++))
      else
        ((falhas++))
      fi
    done
  done
  
  echo -e "\n${AMARELO}=== Resumo ===${NC}"
  echo -e "${VERDE}APIs habilitadas com sucesso: $sucessos${NC}"
  echo -e "${VERMELHO}Falhas ao habilitar APIs: $falhas${NC}"
  
  if [ $falhas -gt 0 ]; then
    echo -e "\n${AMARELO}Algumas APIs não puderam ser habilitadas. Possíveis razões:${NC}"
    echo -e "1. Você não tem permissões adequadas (necessário papel roles/serviceusage.serviceUsageAdmin)"
    echo -e "2. O projeto está com o faturamento desativado"
    echo -e "3. A API não está disponível para o projeto"
    echo -e "\n${AMARELO}Entre em contato com um administrador para obter as permissões necessárias.${NC}"
  fi
}

# Executa o script
main
