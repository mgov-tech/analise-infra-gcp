#!/bin/bash
# Script para análise de recursos de armazenamento GCP da MOVVA
# Autor: Cascade AI
# Data: 06/05/2025

# Configuração
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DIR_DOCS="$ROOT_DIR/docs/armazenamento"
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
analisar_buckets() {
  local projeto=$1
  local saida="$DIR_DOCS/storage_${projeto}.md"
  
  echo "# Buckets Cloud Storage no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar buckets
  buckets=$(gsutil ls -p $projeto 2>/dev/null)
  
  if [ -n "$buckets" ]; then
    echo "| Nome do Bucket | Classe de Armazenamento | Versioning | Idade | Localização |" >> $saida
    echo "|----------------|--------------------------|------------|-------|------------|" >> $saida
    
    for bucket in $buckets; do
      bucket_name=${bucket#gs://}
      bucket_name=${bucket_name%/}
      
      # Obter detalhes do bucket
      info=$(gsutil ls -L -b $bucket 2>/dev/null)
      storage_class=$(echo "$info" | grep "Storage class:" | cut -d: -f2- | sed 's/^[ \t]*//')
      location=$(echo "$info" | grep "Location constraint:" | cut -d: -f2- | sed 's/^[ \t]*//')
      versioning=$(gsutil versioning get $bucket 2>/dev/null | grep -q "Enabled" && echo "Habilitado" || echo "Desabilitado")
      criacao=$(echo "$info" | grep "Creation time:" | cut -d: -f2- | sed 's/^[ \t]*//')
      
      echo "| $bucket_name | $storage_class | $versioning | $criacao | $location |" >> $saida
      
      # Verificar otimizações
      if [ "$storage_class" = "STANDARD" ]; then
        tamanho=$(gsutil du -s $bucket 2>/dev/null | awk '{print $1}')
        if [ $tamanho -gt 1073741824 ]; then # Maior que 1GB
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* O bucket $bucket_name tem mais de 1GB em classe STANDARD. Considere implementar políticas de ciclo de vida para dados acessados com pouca frequência." >> $saida
          echo "" >> $saida
        fi
      fi
      
      if [ "$versioning" = "Habilitado" ]; then
        echo "" >> $saida
        echo "*ALERTA_DE_OTIMIZAÇÃO!!!* O bucket $bucket_name tem versionamento habilitado, o que pode aumentar custos de armazenamento. Considere configurar políticas de expiração para versões antigas." >> $saida
        echo "" >> $saida
      fi
    done
  else
    echo "Nenhum bucket encontrado neste projeto." >> $saida
  fi
}

analisar_cloudsql() {
  local projeto=$1
  local saida="$DIR_DOCS/cloudsql_${projeto}.md"
  
  echo "# Instâncias Cloud SQL no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar instâncias Cloud SQL
  instancias=$(gcloud sql instances list --project=$projeto --format="table[no-heading](name,database_version,tier,region)")
  
  if [ -n "$instancias" ]; then
    echo "| Nome | Versão do Banco | Tier | Região |" >> $saida
    echo "|------|-----------------|------|--------|" >> $saida
    
    while read -r nome versao tier regiao; do
      if [ -n "$nome" ]; then
        echo "| $nome | $versao | $tier | $regiao |" >> $saida
        
        # Obter detalhes da instância
        info=$(gcloud sql instances describe $nome --project=$projeto --format="yaml")
        
        # Verificar armazenamento
        storage_size=$(echo "$info" | grep "dataDiskSizeGb:" | cut -d: -f2- | sed 's/^[ \t]*//')
        storage_type=$(echo "$info" | grep "dataDiskType:" | cut -d: -f2- | sed 's/^[ \t]*//')
        
        echo "" >> $saida
        echo "### Detalhes da Instância: $nome" >> $saida
        echo "" >> $saida
        echo "- **Armazenamento:** ${storage_size}GB ($storage_type)" >> $saida
        
        # Verificar backup
        backup_enabled=$(echo "$info" | grep -A 5 "backupConfiguration:" | grep "enabled:" | cut -d: -f2- | sed 's/^[ \t]*//')
        if [ "$backup_enabled" = "true" ]; then
          backup_time=$(echo "$info" | grep -A 5 "backupConfiguration:" | grep "startTime:" | cut -d: -f2- | sed 's/^[ \t]*//')
          echo "- **Backup:** Habilitado (Horário: $backup_time)" >> $saida
        else
          echo "- **Backup:** Desabilitado" >> $saida
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A instância $nome não tem backups automáticos configurados." >> $saida
        fi
        
        # Listar databases
        echo "" >> $saida
        echo "#### Databases na Instância $nome:" >> $saida
        echo "" >> $saida
        
        databases=$(gcloud sql databases list --instance=$nome --project=$projeto --format="table[no-heading](name)")
        
        if [ -n "$databases" ]; then
          echo "| Nome da Database |" >> $saida
          echo "|-----------------|" >> $saida
          
          while read -r db_nome; do
            if [ -n "$db_nome" ]; then
              echo "| $db_nome |" >> $saida
            fi
          done <<< "$databases"
        else
          echo "Nenhuma database encontrada nesta instância." >> $saida
        fi
        
        # Verificar otimizações
        if [[ "$tier" == *"db-f1-micro"* ]] || [[ "$tier" == *"db-g1-small"* ]]; then
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A instância $nome usa um tier de baixo desempenho ($tier). Considere avaliar se atende às necessidades de performance da aplicação." >> $saida
        fi
        
        if [ "$storage_type" = "PD_HDD" ]; then
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A instância $nome usa armazenamento HDD em vez de SSD, o que pode impactar o desempenho." >> $saida
        fi
        
        echo "" >> $saida
      fi
    done <<< "$instancias"
  else
    echo "Nenhuma instância Cloud SQL encontrada neste projeto." >> $saida
  fi
}

analisar_bigquery() {
  local projeto=$1
  local saida="$DIR_DOCS/bigquery_${projeto}.md"
  
  echo "# Datasets BigQuery no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar datasets no BigQuery
  datasets=$(bq ls --project_id=$projeto --format=pretty)
  
  if [ -n "$datasets" ] && ! echo "$datasets" | grep -q "Listed 0 items"; then
    echo "| ID do Dataset | Localização |" >> $saida
    echo "|---------------|------------|" >> $saida
    
    # Pular a primeira linha (cabeçalho)
    echo "$datasets" | tail -n +2 | while read -r linha; do
      dataset_id=$(echo "$linha" | awk '{print $1}')
      location=$(echo "$linha" | awk '{print $2}')
      
      if [ -n "$dataset_id" ]; then
        echo "| $dataset_id | $location |" >> $saida
        
        # Listar tabelas no dataset
        echo "" >> $saida
        echo "### Tabelas no Dataset: $dataset_id" >> $saida
        echo "" >> $saida
        
        tabelas=$(bq ls --project_id=$projeto $dataset_id 2>/dev/null)
        
        if [ -n "$tabelas" ] && ! echo "$tabelas" | grep -q "Listed 0 items"; then
          echo "| ID da Tabela | Tipo | Tamanho | Linhas | Última Modificação |" >> $saida
          echo "|--------------|------|---------|--------|-------------------|" >> $saida
          
          # Pular a primeira linha (cabeçalho)
          echo "$tabelas" | tail -n +2 | while read -r tab_linha; do
            table_id=$(echo "$tab_linha" | awk '{print $1}')
            table_type=$(echo "$tab_linha" | awk '{print $2}')
            table_size=$(echo "$tab_linha" | awk '{print $3}')
            table_rows=$(echo "$tab_linha" | awk '{print $4}')
            table_modified=$(echo "$tab_linha" | awk '{print $5, $6}')
            
            echo "| $table_id | $table_type | $table_size | $table_rows | $table_modified |" >> $saida
            
            # Verificar otimizações para tabelas grandes sem particionamento
            if [ "$table_size" -gt 10737418240 ] && [ "$table_type" = "TABLE" ]; then # Maior que 10GB
              # Verificar se a tabela é particionada
              particionamento=$(bq show --format=pretty $projeto:$dataset_id.$table_id | grep -q "Partitioning:" && echo "Sim" || echo "Não")
              
              if [ "$particionamento" = "Não" ]; then
                echo "" >> $saida
                echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A tabela $table_id tem mais de 10GB e não está particionada, o que pode aumentar custos e tempo de consulta." >> $saida
                echo "" >> $saida
              fi
            fi
          done
        else
          echo "Nenhuma tabela encontrada neste dataset." >> $saida
        fi
        
        echo "" >> $saida
      fi
    done
  else
    echo "Nenhum dataset BigQuery encontrado neste projeto." >> $saida
  fi
}

# Processar projeto específico ou todos os projetos
if [ -n "$PROJETO_ALVO" ]; then
  # Se PROJETO_ALVO estiver definido, analisar apenas este projeto
  echo "Analisando recursos de armazenamento no projeto: $PROJETO_ALVO"
  analisar_buckets $PROJETO_ALVO
  analisar_cloudsql $PROJETO_ALVO
  analisar_bigquery $PROJETO_ALVO
else
  # Processar todos os projetos
  projetos=$(gcloud projects list --format="value(projectId)")
  
  for projeto in $projetos; do
    echo "Analisando recursos de armazenamento no projeto: $projeto"
    analisar_buckets $projeto
    analisar_cloudsql $projeto
    analisar_bigquery $projeto
  done
fi

echo "Análise de recursos de armazenamento concluída. Verifique a documentação em $DIR_DOCS"
