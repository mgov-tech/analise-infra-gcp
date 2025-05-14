#!/bin/bash

# Adicionar binários do Google Cloud SDK ao PATH
export PATH=$PATH:/Users/pablowinter/google-cloud-sdk/bin

# Variáveis
RESULTS_DIR="./resultados_analise_billing"
REPORT_FILE="$RESULTS_DIR/relatorio_analise_recursos_gcp.md"
INFRA_DOC="/Users/pablowinter/projects/movva/gcp-arq/docs/infraestrutura_consolidada.md"

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Iniciar relatório
echo "# Relatório de Análise de Recursos GCP" > $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Data: $(date '+%d/%m/%Y')" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Adicionar seção de visão geral dos projetos
echo "## Visão Geral de Projetos" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Projetos analisados na conta de faturamento MGov (01C8EE-D5051C-C120BC):" >> $REPORT_FILE
echo "" >> $REPORT_FILE
awk 'NR>1 {print "- **" $1 "** - Faturamento ativo: " $3}' $RESULTS_DIR/projetos_conta.txt >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Adicionar seção de análise por projeto
echo "## Análise de Recursos por Projeto" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Loop sobre cada projeto
PROJETOS=$(awk 'NR>1 {print $1}' $RESULTS_DIR/projetos_conta.txt)
for PROJETO in $PROJETOS; do
  echo "### Projeto: $PROJETO" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  
  # Informações do projeto
  echo "#### Informações Básicas" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  echo "\`\`\`" >> $REPORT_FILE
  cat $RESULTS_DIR/${PROJETO}_info.txt >> $REPORT_FILE
  echo "\`\`\`" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  
  # Serviços ativos
  echo "#### Serviços Ativos" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  echo "Total de serviços ativos: $(grep -v "^NAME" $RESULTS_DIR/${PROJETO}_services.txt | wc -l | xargs)" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  echo "Principais serviços de computação e armazenamento:" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  grep -E "(compute|storage|bigquery|firestore|datastore|bigtable|container|functions|run)" $RESULTS_DIR/${PROJETO}_services.txt | sort >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  
  # Recursos de armazenamento
  echo "#### Recursos de Armazenamento" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  if [ -s "$RESULTS_DIR/${PROJETO}_buckets.txt" ]; then
    echo "Buckets Cloud Storage:" >> $REPORT_FILE
    echo "" >> $REPORT_FILE
    cat $RESULTS_DIR/${PROJETO}_buckets.txt >> $REPORT_FILE
  else
    echo "Nenhum bucket Cloud Storage encontrado ou sem permissão para listar." >> $REPORT_FILE
  fi
  echo "" >> $REPORT_FILE
  
  # Recursos de computação
  echo "#### Recursos de Computação" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  
  # Verificar se existem VMs
  if [ -s "$RESULTS_DIR/${PROJETO}_vms.csv" ]; then
    echo "Instâncias de VM Compute Engine:" >> $REPORT_FILE
    echo "" >> $REPORT_FILE
    if [ "$(wc -l < $RESULTS_DIR/${PROJETO}_vms.csv)" -gt 1 ]; then
      echo "| Nome | Zona | Tipo | Status |" >> $REPORT_FILE
      echo "|------|------|------|--------|" >> $REPORT_FILE
      awk -F, 'NR>1 {print "| " $1 " | " $2 " | " $3 " | " $4 " |"}' $RESULTS_DIR/${PROJETO}_vms.csv >> $REPORT_FILE
    else
      echo "Apenas cabeçalho presente, sem instâncias listadas." >> $REPORT_FILE
    fi
  else
    echo "Nenhuma instância VM encontrada ou sem permissão para listar." >> $REPORT_FILE
  fi
  echo "" >> $REPORT_FILE
  
  # Verificar se existem Functions
  if [ -s "$RESULTS_DIR/${PROJETO}_functions.csv" ]; then
    echo "Cloud Functions:" >> $REPORT_FILE
    echo "" >> $REPORT_FILE
    if [ "$(wc -l < $RESULTS_DIR/${PROJETO}_functions.csv)" -gt 1 ]; then
      echo "| Nome | Região | Status | Tipo |" >> $REPORT_FILE
      echo "|------|--------|--------|------|" >> $REPORT_FILE
      awk -F, 'NR>1 {print "| " $1 " | " $2 " | " $3 " | " $4 " |"}' $RESULTS_DIR/${PROJETO}_functions.csv >> $REPORT_FILE
    else
      echo "Apenas cabeçalho presente, sem funções listadas." >> $REPORT_FILE
    fi
  else
    echo "Nenhuma Cloud Function encontrada ou sem permissão para listar." >> $REPORT_FILE
  fi
  echo "" >> $REPORT_FILE
done

# Comparação com documento de infraestrutura
echo "## Análise Comparativa com Infraestrutura Documentada" >> $REPORT_FILE
echo "" >> $REPORT_FILE

if [ -f "$INFRA_DOC" ]; then
  echo "Comparação com o documento de infraestrutura consolidada:" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  
  # Contar recursos no documento
  DOC_BUCKETS=$(grep -i "bucket" $INFRA_DOC | wc -l | xargs)
  DOC_VMS=$(grep -i "compute engine" $INFRA_DOC | wc -l | xargs)
  DOC_FUNCTIONS=$(grep -i "cloud functions" $INFRA_DOC | wc -l | xargs)
  
  # Contar recursos encontrados
  FOUND_BUCKETS=$(find $RESULTS_DIR -name "*_buckets.txt" -not -empty | wc -l | xargs)
  FOUND_VMS=$(find $RESULTS_DIR -name "*_vms.csv" -not -empty | wc -l | xargs)
  FOUND_FUNCTIONS=$(find $RESULTS_DIR -name "*_functions.csv" -not -empty | wc -l | xargs)
  
  echo "| Tipo de Recurso | Mencionado no Documento | Encontrado na Análise |" >> $REPORT_FILE
  echo "|----------------|--------------------------|------------------------|" >> $REPORT_FILE
  echo "| Buckets Cloud Storage | $DOC_BUCKETS | $FOUND_BUCKETS |" >> $REPORT_FILE
  echo "| VMs Compute Engine | $DOC_VMS | $FOUND_VMS |" >> $REPORT_FILE
  echo "| Cloud Functions | $DOC_FUNCTIONS | $FOUND_FUNCTIONS |" >> $REPORT_FILE
  echo "" >> $REPORT_FILE
  
  echo "**Observação**: Esta é uma análise simplificada que conta menções no documento, não recursos exatos. Uma análise manual mais detalhada é recomendada." >> $REPORT_FILE
else
  echo "Documento de infraestrutura consolidada não encontrado no caminho especificado." >> $REPORT_FILE
fi
echo "" >> $REPORT_FILE

# Recomendações
echo "## Recomendações" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Com base na análise realizada, recomendamos:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "1. **Configurar Exportação de Billing para BigQuery**: Permitirá análises mais detalhadas de custos." >> $REPORT_FILE
echo "2. **Revisar Permissões de IAM**: As permissões atuais limitaram o acesso a alguns recursos durante a análise." >> $REPORT_FILE
echo "3. **Consolidar Recursos**: Considerar a consolidação de recursos entre projetos para otimizar custos." >> $REPORT_FILE
echo "4. **Implementar Políticas de Economia**: Para recursos de computação, considerar o uso de preemptible VMs ou compromissos de uso." >> $REPORT_FILE
echo "5. **Revisar Documentação**: Atualizar a documentação de infraestrutura com base nos recursos atualmente em uso." >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Relatório de análise gerado com sucesso: $REPORT_FILE"
