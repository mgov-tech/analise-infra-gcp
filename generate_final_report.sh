#!/bin/bash

# Adicionar binários do Google Cloud SDK ao PATH
export PATH=$PATH:/Users/pablowinter/google-cloud-sdk/bin

# Variáveis
RESULTS_DIR="./resultados_analise_billing"
REPORT_FILE="$RESULTS_DIR/relatorio_final_billing.md"
INFRA_DOC="/Users/pablowinter/projects/movva/gcp-arq/docs/infraestrutura_consolidada.md"

# Criar diretório para resultados se não existir
mkdir -p $RESULTS_DIR

# Iniciar relatório
echo "# Relatório de Análise de Gastos GCP" > $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Data: $(date '+%d/%m/%Y')" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Adicionar seção de visão geral dos projetos
echo "## Visão Geral de Projetos" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Projetos analisados:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
awk 'NR>1 {print "- " $1}' $RESULTS_DIR/projetos_conta.txt >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Adicionar dados de custo total
echo "## Custo Total GCP" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Dados do último trimestre:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "| Mês | Custo Total |" >> $REPORT_FILE
echo "|-----|------------|" >> $REPORT_FILE
if [ -f "$RESULTS_DIR/tendencia_gastos.csv" ]; then
  awk -F, 'NR>1 {print "| " $1 " | R$ " $3 " |"}' $RESULTS_DIR/tendencia_gastos.csv | tail -3 >> $REPORT_FILE
else
  echo "| Dados não disponíveis | - |" >> $REPORT_FILE
fi
echo "" >> $REPORT_FILE

# Adicionar seção de análise por projeto
echo "## Análise por Projeto" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Custos totais por projeto (últimos 3 meses):" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "| Projeto | Custo Total |" >> $REPORT_FILE
echo "|---------|-------------|" >> $REPORT_FILE
if [ -f "$RESULTS_DIR/custos_totais_projeto.csv" ]; then
  awk -F, 'NR>1 {print "| " $1 " | R$ " $3 " |"}' $RESULTS_DIR/custos_totais_projeto.csv >> $REPORT_FILE
else
  echo "| Dados não disponíveis | - |" >> $REPORT_FILE
fi
echo "" >> $REPORT_FILE

# Adicionar seção de análise por serviço
echo "## Análise por Serviço" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Serviços mais custosos (todos os projetos):" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "| Serviço | Custo Total |" >> $REPORT_FILE
echo "|---------|-------------|" >> $REPORT_FILE
if [ -f "$RESULTS_DIR/custos_por_servico.csv" ]; then
  awk -F, 'NR>1 {print "| " $1 " | R$ " $3 " |"}' $RESULTS_DIR/custos_por_servico.csv | head -10 >> $REPORT_FILE
else
  echo "| Dados não disponíveis | - |" >> $REPORT_FILE
fi
echo "" >> $REPORT_FILE

# Adicionar seção de análise por recurso
echo "## Análise por Recurso" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Recursos mais custosos:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "| Projeto | Serviço | Recurso | Custo Total |" >> $REPORT_FILE
echo "|---------|---------|---------|-------------|" >> $REPORT_FILE
if [ -f "$RESULTS_DIR/custos_por_sku.csv" ]; then
  awk -F, 'NR>1 {print "| " $1 " | " $2 " | " $3 " | R$ " $5 " |"}' $RESULTS_DIR/custos_por_sku.csv | head -15 >> $REPORT_FILE
else
  echo "| Dados não disponíveis | - | - | - |" >> $REPORT_FILE
fi
echo "" >> $REPORT_FILE

# Adicionar seção de validação com documento existente
echo "## Validação com Documento de Infraestrutura" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Comparação com valores no documento de infraestrutura consolidada:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
if [ -f "$INFRA_DOC" ]; then
  echo "O documento de infraestrutura consolidada foi encontrado. Uma análise manual é necessária para comparar os valores calculados com os presentes no documento." >> $REPORT_FILE
else
  echo "Documento de infraestrutura consolidada não encontrado no caminho especificado." >> $REPORT_FILE
fi
echo "" >> $REPORT_FILE

# Adicionar seção de recomendações
echo "## Recomendações" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "Baseado nos dados analisados, as seguintes recomendações são sugeridas:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "1. **Revisar recursos mais custosos**: Analisar detalhadamente os 10 recursos mais custosos identificados neste relatório." >> $REPORT_FILE
echo "2. **Monitorar tendências**: Implementar monitoramento constante das tendências de gastos, especialmente para os serviços com crescimento significativo." >> $REPORT_FILE
echo "3. **Otimizar recursos subutilizados**: Identificar e eliminar recursos ociosos ou subutilizados." >> $REPORT_FILE
echo "4. **Utilizar instâncias com compromisso**: Para VMs com uso constante, considerar compromissos de uso para obter descontos." >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Relatório final gerado com sucesso: $REPORT_FILE"
