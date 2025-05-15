#!/bin/bash

# Script para gerar relatório de status da implementação das políticas de ciclo de vida
# Autor: Arquiteto de Cloud
# Data: 14/05/2025

# Configurações
DATA_HOJE=$(date +"%Y-%m-%d")
ARQUIVO_RELATORIO="status-implementacao-${DATA_HOJE}.md"
BUCKETS=("gs://movva-datalake" "gs://movva-datalake-us-notebooks" "gs://movva-sandbox" "gs://razoes-pra-ficar" "gs://poc-razoes-pra-ficar")

# Cabeçalho do relatório
cat > "$ARQUIVO_RELATORIO" << EOL
# Relatório de Status - Implementação de Políticas de Ciclo de Vida

**Data da Geração:** ${DATA_HOJE}  
**Responsável:** Sistema Automatizado

## Visão Geral

Relatório gerado automaticamente com o status atual da implementação das políticas de ciclo de vida nos buckets prioritários.

## Status por Bucket

EOL

# Verifica cada bucket
for BUCKET in "${BUCKETS[@]}"; do
  echo -n "### ${BUCKET}
" >> "$ARQUIVO_RELATORIO"
  
  # Verifica se a política de ciclo de vida está configurada
  if gsutil lifecycle get "$BUCKET" &> /dev/null; then
    echo "✅ **Status:** Política configurada" >> "$ARQUIVO_RELATORIO"
    
    # Obtém detalhes da política
    echo -e "\n**Detalhes da Política:**" >> "$ARQUIVO_RELATORIO"
    echo '```json' >> "$ARQUIVO_RELATORIO"
    gsutil lifecycle get "$BUCKET" 2>> "$ARQUIVO_RELATORIO" | head -n 20 >> "$ARQUIVO_RELATORIO"
    echo '```' >> "$ARQUIVO_RELATORIO"
  else
    echo "❌ **Status:** Política NÃO configurada" >> "$ARQUIVO_RELATORIO"
  fi
  
  # Adiciona separador
  echo -e "\n---\n" >> "$ARQUIVO_RELATORIO"
done

# Adiciona seção de resumo
echo "## Resumo de Status" >> "$ARQUIVO_RELATORIO"
TOTAL_BUCKETS=${#BUCKETS[@]}
BUCKETS_CONFIGURADOS=$(grep -c "✅" "$ARQUIVO_RELATORIO")

echo "- ✅ **Buckets com política configurada:** ${BUCKETS_CONFIGURADOS}/${TOTAL_BUCKETS}" >> "$ARQUIVO_RELATORIO"
echo "- ⏳ **Buckets pendentes:** $((TOTAL_BUCKETS - BUCKETS_CONFIGURADOS))/${TOTAL_BUCKETS}" >> "$ARQUIVO_RELATORIO"

# Adiciona instruções
echo "
## Próximos Passos" >> "$ARQUIVO_RELATORIO"
echo "1. Revisar os status acima" >> "$ARQUIVO_RELATORIO"
echo "2. Para buckets sem política, seguir instruções em [instrucoes-implementacao-console.md](instrucoes-implementacao-console.md)" >> "$ARQUIVO_RELATORIO"
echo "3. Para dúvidas, contatar a equipe de Arquitetura de Cloud" >> "$ARQUIVO_RELATORIO"

# Torna o script executável
chmod +x "$ARQUIVO_RELATORIO"

echo "Relatório gerado com sucesso: ${ARQUIVO_RELATORIO}"
