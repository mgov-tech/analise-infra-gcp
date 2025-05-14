#!/bin/bash
# Script para análise de projetos GCP da MOVVA
# Autor: Cascade AI
# Data: 06/05/2025

# Configuração
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DIR_DOCS="$ROOT_DIR/docs/projetos"
SAIDA_PROJETOS="$DIR_DOCS/lista_projetos.md"

# Função para tratamento de erros
tratar_erro() {
  local comando=$1
  local projeto=$2
  echo "AVISO: Não foi possível executar '$comando' para o projeto '$projeto'. Isso pode ocorrer devido a permissões limitadas."
  return 0
}

# Garantir que o diretório de documentação existe
mkdir -p $DIR_DOCS

# Listar todos os projetos
echo "# Lista de Projetos GCP da MOVVA" > $SAIDA_PROJETOS
echo "" >> $SAIDA_PROJETOS
echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $SAIDA_PROJETOS
echo "" >> $SAIDA_PROJETOS
echo "| Nome do Projeto | ID do Projeto | Número do Projeto | Status | Data de Criação |" >> $SAIDA_PROJETOS
echo "|----------------|---------------|------------------|--------|-----------------|" >> $SAIDA_PROJETOS

# Obter a lista de projetos e formatar para markdown
gcloud projects list --format="table[no-heading](name,projectId,projectNumber,lifecycleState)" | while read -r nome id numero status
do
  # Obter data de criação do projeto (com tratamento de erro)
  data_criacao=$(gcloud projects describe $id --format="value(createTime.date('%d/%m/%Y'))" 2>/dev/null || echo "N/A")
  echo "| $nome | $id | $numero | $status | $data_criacao |" >> $SAIDA_PROJETOS
done

# Para cada projeto, coletar informações detalhadas
echo "Coletando informações detalhadas de cada projeto..."
gcloud projects list --format="value(projectId)" | while read -r projeto_id
do
  # Criar arquivo específico para o projeto
  SAIDA_PROJETO="$DIR_DOCS/projeto_${projeto_id}.md"
  
  echo "# Projeto: $projeto_id" > $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  
  # Informações básicas
  echo "## Informações Básicas" >> $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  
  # Obter e formatar detalhes do projeto (com tratamento de erro)
  if ! gcloud projects describe $projeto_id --format="yaml" > /tmp/projeto_info.yaml 2>/dev/null; then
    tratar_erro "describe" "$projeto_id"
    
    # Usar informações disponíveis da lista
    nome=$(gcloud projects list --filter="projectId=$projeto_id" --format="value(name)")
    numero=$(gcloud projects list --filter="projectId=$projeto_id" --format="value(projectNumber)")
    status=$(gcloud projects list --filter="projectId=$projeto_id" --format="value(lifecycleState)")
    criacao="N/A (permissão limitada)"
  else
    nome=$(grep "name:" /tmp/projeto_info.yaml 2>/dev/null | cut -d: -f2- | sed 's/^[ \t]*//' || echo "N/A")
    numero=$(grep "projectNumber:" /tmp/projeto_info.yaml 2>/dev/null | cut -d: -f2- | sed 's/^[ \t]*//' || echo "N/A")
    status=$(grep "lifecycleState:" /tmp/projeto_info.yaml 2>/dev/null | cut -d: -f2- | sed 's/^[ \t]*//' || echo "N/A")
    criacao=$(grep "createTime:" /tmp/projeto_info.yaml 2>/dev/null | cut -d: -f2- | sed 's/^[ \t]*//' || echo "N/A")
  fi
  
  echo "- **Nome:** $nome" >> $SAIDA_PROJETO
  echo "- **ID:** $projeto_id" >> $SAIDA_PROJETO
  echo "- **Número:** $numero" >> $SAIDA_PROJETO
  echo "- **Status:** $status" >> $SAIDA_PROJETO
  echo "- **Data de Criação:** $criacao" >> $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  
  # IAM Políticas (com tratamento de erro)
  echo "## Políticas IAM" >> $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  echo "| Membro | Papel |" >> $SAIDA_PROJETO
  echo "|--------|-------|" >> $SAIDA_PROJETO
  
  if ! gcloud projects get-iam-policy $projeto_id --format="yaml" 2>/dev/null | grep -E "role:|member:" | sed -e 'N;s/\n/ /' | sed 's/- role: \(.*\)  member: \(.*\)/| \2 | \1 |/' >> $SAIDA_PROJETO; then
    echo "| N/A | N/A (permissão limitada) |" >> $SAIDA_PROJETO
    tratar_erro "get-iam-policy" "$projeto_id"
  fi
  
  echo "" >> $SAIDA_PROJETO
  
  # Serviços Habilitados (com tratamento de erro)
  echo "## Serviços API Habilitados" >> $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  echo "| Serviço | Nome | Status |" >> $SAIDA_PROJETO
  echo "|---------|------|--------|" >> $SAIDA_PROJETO
  
  servicos=$(gcloud services list --project=$projeto_id --format="table[no-heading](config.name,config.title,state)" 2>/dev/null)
  if [ -z "$servicos" ]; then
    echo "| N/A | N/A | N/A (permissão limitada) |" >> $SAIDA_PROJETO
    tratar_erro "services list" "$projeto_id"
  else
    echo "$servicos" | while read -r servico nome status
    do
      echo "| $servico | $nome | $status |" >> $SAIDA_PROJETO
    done
  fi
  
  echo "" >> $SAIDA_PROJETO
  echo "## Recomendações" >> $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  echo "Análise de recomendações específicas para este projeto:" >> $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  
  # Verificar serviços habilitados mas potencialmente não utilizados
  echo "### Serviços Potencialmente Não Utilizados" >> $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  echo "Verificação pendente - execute a análise de uso para identificar serviços habilitados mas não utilizados." >> $SAIDA_PROJETO
  echo "" >> $SAIDA_PROJETO
  
  echo "Documentação criada para o projeto $projeto_id"
done

echo "Análise de projetos concluída. Verifique a documentação em $DIR_DOCS"
