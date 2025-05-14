#!/bin/bash
# Script para análise de recursos de segurança GCP da MOVVA
# Autor: Cascade AI
# Data: 06/05/2025

# Configuração
DIR_DOCS="../docs/seguranca"
mkdir -p $DIR_DOCS

# Funções auxiliares
analisar_iam() {
  local projeto=$1
  local saida="$DIR_DOCS/iam_${projeto}.md"
  
  echo "# Políticas IAM no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Obter políticas IAM do projeto
  echo "## Políticas IAM a Nível de Projeto" >> $saida
  echo "" >> $saida
  echo "| Membro | Papel | Condição |" >> $saida
  echo "|--------|-------|----------|" >> $saida
  
  gcloud projects get-iam-policy $projeto --format=json | jq -r '.bindings[] | "\(.role) \(.members[])"' | while read -r papel membro; do
    condicao=$(gcloud projects get-iam-policy $projeto --format=json | jq -r --arg role "$papel" --arg member "$membro" '.bindings[] | select(.role==$role and .members[] == $member) | if has("condition") then .condition.expression else "Nenhuma" end')
    echo "| $membro | $papel | $condicao |" >> $saida
    
    # Verificar otimizações
    if [[ "$papel" == *"owner"* ]] && [[ "$membro" == *"@gmail.com"* ]]; then
      echo "" >> $saida
      echo "*ALERTA_DE_OTIMIZAÇÃO!!!* Conta pessoal $membro tem papel de proprietário ($papel). Considere usar contas corporativas para acesso privilegiado." >> $saida
      echo "" >> $saida
    fi
    
    if [[ "$papel" == *"owner"* ]] || [[ "$papel" == *"editor"* ]]; then
      echo "" >> $saida
      echo "*ALERTA_DE_OTIMIZAÇÃO!!!* O papel $papel concede permissões amplas ao membro $membro. Considere usar papéis mais específicos seguindo o princípio do privilégio mínimo." >> $saida
      echo "" >> $saida
    fi
  done
}

analisar_contas_servico() {
  local projeto=$1
  local saida="$DIR_DOCS/service_accounts_${projeto}.md"
  
  echo "# Contas de Serviço no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar contas de serviço
  contas=$(gcloud iam service-accounts list --project=$projeto --format="table[no-heading](email,displayName)")
  
  if [ -n "$contas" ]; then
    echo "| Email | Nome de Exibição |" >> $saida
    echo "|-------|-----------------|" >> $saida
    
    while read -r email nome; do
      if [ -n "$email" ]; then
        echo "| $email | $nome |" >> $saida
        
        # Listar chaves para esta conta de serviço
        echo "" >> $saida
        echo "## Chaves para a conta: $email" >> $saida
        echo "" >> $saida
        
        chaves=$(gcloud iam service-accounts keys list --iam-account=$email --project=$projeto --format="table[no-heading](name.basename(),key_type,valid_after_time,valid_before_time)")
        
        if [ -n "$chaves" ]; then
          echo "| ID da Chave | Tipo | Criada em | Expira em |" >> $saida
          echo "|-------------|------|-----------|-----------|" >> $saida
          
          while read -r id tipo criacao expiracao; do
            if [ -n "$id" ]; then
              echo "| $id | $tipo | $criacao | $expiracao |" >> $saida
            fi
          done <<< "$chaves"
          
          # Verificar número de chaves
          num_chaves=$(echo "$chaves" | wc -l)
          if [ $num_chaves -gt 2 ]; then
            echo "" >> $saida
            echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A conta de serviço $email possui $num_chaves chaves. Considere revogar chaves não utilizadas para melhorar a segurança." >> $saida
            echo "" >> $saida
          fi
        else
          echo "Nenhuma chave encontrada para esta conta de serviço." >> $saida
        fi
        
        echo "" >> $saida
      fi
    done <<< "$contas"
  else
    echo "Nenhuma conta de serviço encontrada neste projeto." >> $saida
  fi
}

analisar_kms() {
  local projeto=$1
  local saida="$DIR_DOCS/kms_${projeto}.md"
  
  echo "# Cloud KMS no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar keyrings
  locations="global us-central1 us-east1 us-west1 europe-west1 europe-west2 europe-west3 europe-west4 asia-east1 asia-northeast1 asia-southeast1 australia-southeast1"
  
  for location in $locations; do
    keyrings=$(gcloud kms keyrings list --location=$location --project=$projeto --format="table[no-heading](name)")
    
    if [ -n "$keyrings" ]; then
      echo "## Keyrings na região: $location" >> $saida
      echo "" >> $saida
      
      while read -r keyring_path; do
        if [ -n "$keyring_path" ]; then
          keyring_name=$(basename "$keyring_path")
          echo "### Keyring: $keyring_name" >> $saida
          echo "" >> $saida
          
          # Listar chaves neste keyring
          keys=$(gcloud kms keys list --keyring=$keyring_name --location=$location --project=$projeto --format="table[no-heading](name,purpose,versionTemplate.algorithm,versionTemplate.protectionLevel)")
          
          if [ -n "$keys" ]; then
            echo "| Nome da Chave | Propósito | Algoritmo | Nível de Proteção |" >> $saida
            echo "|---------------|-----------|-----------|-------------------|" >> $saida
            
            while read -r key_path purpose algorithm protection; do
              if [ -n "$key_path" ]; then
                key_name=$(basename "$key_path")
                echo "| $key_name | $purpose | $algorithm | $protection |" >> $saida
                
                # Verificar otimizações
                if [ "$protection" != "HSM" ]; then
                  echo "" >> $saida
                  echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A chave $key_name não usa proteção HSM, que oferece segurança de nível mais alto para material criptográfico sensível." >> $saida
                  echo "" >> $saida
                fi
              fi
            done <<< "$keys"
          else
            echo "Nenhuma chave encontrada neste keyring." >> $saida
          fi
          
          echo "" >> $saida
        fi
      done <<< "$keyrings"
    fi
  done
}

analisar_secret_manager() {
  local projeto=$1
  local saida="$DIR_DOCS/secrets_${projeto}.md"
  
  echo "# Secret Manager no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar secrets
  secrets=$(gcloud secrets list --project=$projeto --format="table[no-heading](name,create_time,labels)")
  
  if [ -n "$secrets" ]; then
    echo "| Nome do Secret | Data de Criação | Labels |" >> $saida
    echo "|----------------|-----------------|--------|" >> $saida
    
    while read -r nome criacao labels; do
      if [ -n "$nome" ]; then
        echo "| $nome | $criacao | $labels |" >> $saida
        
        # Listar versões
        echo "" >> $saida
        echo "## Versões do secret: $nome" >> $saida
        echo "" >> $saida
        
        versoes=$(gcloud secrets versions list $nome --project=$projeto --format="table[no-heading](name,create_time,state)")
        
        if [ -n "$versoes" ]; then
          echo "| Versão | Data de Criação | Estado |" >> $saida
          echo "|--------|-----------------|--------|" >> $saida
          
          while read -r versao vcriacao estado; do
            if [ -n "$versao" ]; then
              echo "| $versao | $vcriacao | $estado |" >> $saida
            fi
          done <<< "$versoes"
          
          # Verificar número de versões
          num_versoes=$(echo "$versoes" | wc -l)
          if [ $num_versoes -gt 5 ]; then
            echo "" >> $saida
            echo "*ALERTA_DE_OTIMIZAÇÃO!!!* O secret $nome possui $num_versoes versões. Considere limpar versões antigas não utilizadas." >> $saida
            echo "" >> $saida
          fi
        else
          echo "Nenhuma versão encontrada para este secret." >> $saida
        fi
        
        echo "" >> $saida
      fi
    done <<< "$secrets"
  else
    echo "Nenhum secret encontrado neste projeto." >> $saida
  fi
}

# Processar cada projeto
projetos=$(gcloud projects list --format="value(projectId)")

for projeto in $projetos; do
  echo "Analisando recursos de segurança no projeto: $projeto"
  analisar_iam $projeto
  analisar_contas_servico $projeto
  analisar_kms $projeto
  analisar_secret_manager $projeto
done

echo "Análise de recursos de segurança concluída. Verifique a documentação em $DIR_DOCS"
