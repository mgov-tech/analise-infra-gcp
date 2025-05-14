#!/bin/bash
# Script para análise de recursos de rede GCP da MOVVA
# Autor: Cascade AI
# Data: 06/05/2025

# Configuração
DIR_DOCS="../docs/rede"
mkdir -p $DIR_DOCS

# Funções auxiliares
analisar_vpcs() {
  local projeto=$1
  local saida="$DIR_DOCS/vpc_${projeto}.md"
  
  echo "# Redes VPC no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar redes VPC
  redes=$(gcloud compute networks list --project=$projeto --format="table[no-heading](name,subnet_mode,x_gcloud_bgp_routing_mode)")
  
  if [ -n "$redes" ]; then
    echo "| Nome da Rede | Modo de Sub-rede | Modo de Roteamento BGP |" >> $saida
    echo "|--------------|------------------|------------------------|" >> $saida
    
    while read -r nome modo_subrede modo_bgp; do
      if [ -n "$nome" ]; then
        echo "| $nome | $modo_subrede | $modo_bgp |" >> $saida
        
        # Listar sub-redes para esta rede
        echo "" >> $saida
        echo "## Sub-redes na rede: $nome" >> $saida
        echo "" >> $saida
        
        subredes=$(gcloud compute networks subnets list --filter="network:$nome" --project=$projeto --format="table[no-heading](name,region,ipCidrRange,privateIpGoogleAccess)")
        
        if [ -n "$subredes" ]; then
          echo "| Nome da Sub-rede | Região | Range CIDR | Acesso Privado Google |" >> $saida
          echo "|------------------|--------|------------|------------------------|" >> $saida
          
          while read -r subrede_nome regiao cidr acesso_privado; do
            if [ -n "$subrede_nome" ]; then
              echo "| $subrede_nome | $regiao | $cidr | $acesso_privado |" >> $saida
              
              # Verificar otimizações
              if [ "$acesso_privado" = "False" ]; then
                echo "" >> $saida
                echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A sub-rede $subrede_nome não tem acesso privado ao Google habilitado, o que pode gerar custos de tráfego de saída quando acessando APIs e serviços Google." >> $saida
                echo "" >> $saida
              fi
              
              # Verificar tamanho da sub-rede
              cidr_size=$(echo $cidr | cut -d/ -f2)
              if [ $cidr_size -lt 24 ]; then
                echo "" >> $saida
                echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A sub-rede $subrede_nome possui um range CIDR grande ($cidr), considerando o uso atual. Avalie se é possível dividir em sub-redes menores para melhor organização." >> $saida
                echo "" >> $saida
              fi
            fi
          done <<< "$subredes"
        else
          echo "Nenhuma sub-rede encontrada para esta rede." >> $saida
        fi
        
        echo "" >> $saida
      fi
    done <<< "$redes"
  else
    echo "Nenhuma rede VPC encontrada neste projeto." >> $saida
  fi
}

analisar_firewall() {
  local projeto=$1
  local saida="$DIR_DOCS/firewall_${projeto}.md"
  
  echo "# Regras de Firewall no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar regras de firewall
  regras=$(gcloud compute firewall-rules list --project=$projeto --format="table[no-heading](name,network,direction,priority,sourceRanges.list():label=SRC_RANGES,destinationRanges.list():label=DEST_RANGES,allowed[].map().firewall_rule().list():label=ALLOW,denied[].map().firewall_rule().list():label=DENY,disabled)")
  
  if [ -n "$regras" ]; then
    echo "| Nome da Regra | Rede | Direção | Prioridade | Origem | Destino | Permitido | Negado | Desabilitada |" >> $saida
    echo "|---------------|------|---------|------------|--------|---------|-----------|--------|--------------|" >> $saida
    
    while read -r linha; do
      if [ -n "$linha" ]; then
        # Extrair campos (considerando que podem conter espaços)
        read -r nome rede direcao prioridade origem destino permitido negado desabilitada <<< "$linha"
        
        echo "| $nome | $rede | $direcao | $prioridade | $origem | $destino | $permitido | $negado | $desabilitada |" >> $saida
        
        # Verificar otimizações
        if [ "$origem" = "0.0.0.0/0" ] && [ "$direcao" = "INGRESS" ] && [[ "$permitido" == *"all"* ]]; then
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A regra $nome permite todo tráfego de entrada de qualquer origem. Isso representa um risco de segurança significativo." >> $saida
          echo "" >> $saida
        fi
        
        if [ "$prioridade" = "1000" ]; then
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* A regra $nome usa a prioridade padrão (1000). Considere ajustar prioridades para garantir a ordem correta de aplicação das regras." >> $saida
          echo "" >> $saida
        fi
      fi
    done <<< "$regras"
  else
    echo "Nenhuma regra de firewall encontrada neste projeto." >> $saida
  fi
}

analisar_dns() {
  local projeto=$1
  local saida="$DIR_DOCS/dns_${projeto}.md"
  
  echo "# Zonas DNS no Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Listar zonas DNS
  zonas=$(gcloud dns managed-zones list --project=$projeto --format="table[no-heading](name,dnsName,visibility,description)")
  
  if [ -n "$zonas" ]; then
    echo "| Nome da Zona | Nome DNS | Visibilidade | Descrição |" >> $saida
    echo "|--------------|----------|--------------|-----------|" >> $saida
    
    while read -r nome dns visibilidade descricao; do
      if [ -n "$nome" ]; then
        echo "| $nome | $dns | $visibilidade | $descricao |" >> $saida
        
        # Listar registros para esta zona
        echo "" >> $saida
        echo "## Registros na zona: $nome" >> $saida
        echo "" >> $saida
        
        registros=$(gcloud dns record-sets list --zone=$nome --project=$projeto --format="table[no-heading](name,type,ttl,rrdatas)")
        
        if [ -n "$registros" ]; then
          echo "| Nome do Registro | Tipo | TTL | Dados |" >> $saida
          echo "|------------------|------|-----|-------|" >> $saida
          
          while read -r reg_nome tipo ttl dados; do
            if [ -n "$reg_nome" ]; then
              echo "| $reg_nome | $tipo | $ttl | $dados |" >> $saida
              
              # Verificar otimizações
              if [ $ttl -gt 86400 ]; then
                echo "" >> $saida
                echo "*ALERTA_DE_OTIMIZAÇÃO!!!* O registro $reg_nome possui um TTL muito alto (${ttl}s), o que pode dificultar mudanças rápidas em caso de necessidade." >> $saida
                echo "" >> $saida
              fi
            fi
          done <<< "$registros"
        else
          echo "Nenhum registro encontrado para esta zona." >> $saida
        fi
        
        echo "" >> $saida
      fi
    done <<< "$zonas"
  else
    echo "Nenhuma zona DNS encontrada neste projeto." >> $saida
  fi
}

# Processar cada projeto
projetos=$(gcloud projects list --format="value(projectId)")

for projeto in $projetos; do
  echo "Analisando recursos de rede no projeto: $projeto"
  analisar_vpcs $projeto
  analisar_firewall $projeto
  analisar_dns $projeto
done

echo "Análise de recursos de rede concluída. Verifique a documentação em $DIR_DOCS"
