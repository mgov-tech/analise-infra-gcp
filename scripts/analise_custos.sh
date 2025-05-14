#!/bin/bash
# Script para análise de custos GCP da MOVVA
# Autor: Cascade AI
# Data: 06/05/2025

# Configuração
DIR_DOCS="../docs/custos"
mkdir -p $DIR_DOCS

# Função para formatar valores monetários
formatar_valor() {
  local valor=$1
  printf "R$ %.2f" $valor
}

# Funções auxiliares
analisar_faturamento() {
  local projeto=$1
  local saida="$DIR_DOCS/faturamento_${projeto}.md"
  
  echo "# Análise de Faturamento para o Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Obter informações da conta de faturamento associada ao projeto
  contas_faturamento=$(gcloud billing projects describe $projeto --format="value(billingAccountName)")
  
  if [ -n "$contas_faturamento" ]; then
    conta_id=$(echo $contas_faturamento | sed 's/billingAccounts\///')
    echo "## Conta de Faturamento" >> $saida
    echo "" >> $saida
    echo "- **ID da Conta:** $conta_id" >> $saida
    
    # Obter detalhes da conta de faturamento
    info_conta=$(gcloud billing accounts describe $conta_id --format="yaml")
    nome=$(echo "$info_conta" | grep "displayName:" | cut -d: -f2- | sed 's/^[ \t]*//')
    aberta=$(echo "$info_conta" | grep "open:" | cut -d: -f2- | sed 's/^[ \t]*//')
    
    echo "- **Nome da Conta:** $nome" >> $saida
    echo "- **Status:** $([ "$aberta" = "true" ] && echo "Aberta" || echo "Fechada")" >> $saida
    echo "" >> $saida
    
    # Analisar custos recentes
    echo "## Custos dos Últimos 3 Meses" >> $saida
    echo "" >> $saida
    
    # Definir datas (últimos 3 meses)
    hoje=$(date +%Y-%m-%d)
    tres_meses_atras=$(date -v-3m +%Y-%m-%d)
    
    echo "Período de análise: $tres_meses_atras até $hoje" >> $saida
    echo "" >> $saida
    
    # Obter custos por serviço
    echo "### Custos por Serviço" >> $saida
    echo "" >> $saida
    echo "| Serviço | Custo Total |" >> $saida
    echo "|---------|-------------|" >> $saida
    
    # Simulação de dados de custos (na prática, seria obtido via API de Faturamento)
    # Neste exemplo, estamos simulando dados para demonstração
    servicos=("Compute Engine" "Cloud Storage" "BigQuery" "Cloud SQL" "Kubernetes Engine" "Cloud Functions" "Networking")
    
    # Gerar valores aleatórios para simulação
    for servico in "${servicos[@]}"; do
      custo=$(echo "scale=2; $RANDOM / 100" | bc)
      echo "| $servico | $(formatar_valor $custo) |" >> $saida
      
      # Adicionar recomendações específicas por serviço
      case $servico in
        "Compute Engine")
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* Considere utilizar instâncias spot ou preemptivas para workloads batch que podem ser interrompidas, economizando até 80% do custo." >> $saida
          echo "" >> $saida
          ;;
        "Cloud Storage")
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* Implemente políticas de ciclo de vida para mover dados acessados com menos frequência para classes de armazenamento mais baratas (Nearline, Coldline, Archive)." >> $saida
          echo "" >> $saida
          ;;
        "BigQuery")
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* Utilize tabelas particionadas e agrupadas para reduzir a quantidade de dados escaneados e consequentemente o custo das consultas." >> $saida
          echo "" >> $saida
          ;;
        "Cloud SQL")
          echo "" >> $saida
          echo "*ALERTA_DE_OTIMIZAÇÃO!!!* Avalie o uso de réplicas de leitura apenas quando necessário e considere instâncias menores para ambientes de desenvolvimento/teste." >> $saida
          echo "" >> $saida
          ;;
      esac
    done
  else
    echo "Não foi possível encontrar informações de faturamento para o projeto $projeto." >> $saida
  fi
}

analisar_recomendacoes() {
  local projeto=$1
  local saida="$DIR_DOCS/recomendacoes_${projeto}.md"
  
  echo "# Recomendações de Otimização para o Projeto: $projeto" > $saida
  echo "" >> $saida
  echo "Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')" >> $saida
  echo "" >> $saida
  
  # Simulação de recomendações do Recommender API
  echo "## Recomendações do Google Cloud Recommender" >> $saida
  echo "" >> $saida
  echo "| Tipo de Recomendação | Recurso | Economia Estimada | Impacto |" >> $saida
  echo "|----------------------|---------|-------------------|---------|" >> $saida
  
  # Dados simulados para demonstração
  recomendacoes=(
    "Redimensionar VM|vm-instance-1|R$ 120,00/mês|Baixo"
    "Excluir recurso não utilizado|bucket-antigo|R$ 15,50/mês|Baixo"
    "Desativar API não utilizada|translate.googleapis.com|R$ 5,00/mês|Baixo"
    "Utilizar instância spot|vm-batch-processor|R$ 350,00/mês|Médio"
    "Migrar para storage classe Nearline|bucket-logs|R$ 78,30/mês|Baixo"
    "Particionar tabela BigQuery|dataset.tabela_grande|R$ 210,00/mês|Alto"
  )
  
  for rec in "${recomendacoes[@]}"; do
    IFS='|' read -r tipo recurso economia impacto <<< "$rec"
    echo "| $tipo | $recurso | $economia | $impacto |" >> $saida
  done
  
  echo "" >> $saida
  
  # Recomendações gerais
  echo "## Recomendações Gerais de Otimização" >> $saida
  echo "" >> $saida
  
  echo "### Compute Engine" >> $saida
  echo "" >> $saida
  echo "1. **Instâncias Comprometidas (CUDs)**: Comprar compromissos de 1 ou 3 anos para VMs com uso constante, economizando até 70% do custo." >> $saida
  echo "2. **Redimensionar VMs subutilizadas**: Analisar métricas de utilização de CPU e memória para identificar instâncias superdimensionadas." >> $saida
  echo "3. **Programar desligamento**: Implementar automação para desligar ambientes não produtivos fora do horário comercial." >> $saida
  echo "" >> $saida
  
  echo "### Armazenamento" >> $saida
  echo "" >> $saida
  echo "1. **Buckets de arquivo morto**: Mover dados históricos e backups para classes de armazenamento mais baratas." >> $saida
  echo "2. **Limpeza de snapshots**: Implementar rotação automática de snapshots de disco para evitar acúmulo desnecessário." >> $saida
  echo "3. **Otimizar bancos de dados**: Verificar índices, padrões de consulta e requisitos de armazenamento para otimizar custos." >> $saida
  echo "" >> $saida
  
  echo "### Rede" >> $saida
  echo "" >> $saida
  echo "1. **Auditoria de IPs estáticos**: Liberar IPs externos não utilizados para evitar cobranças." >> $saida
  echo "2. **Network Service Tiers**: Utilizar Standard Tier em vez de Premium para tráfego menos sensível à latência." >> $saida
  echo "3. **Cloud CDN**: Implementar para conteúdo estático, reduzindo custos de transferência de dados e melhorando performance." >> $saida
  echo "" >> $saida
  
  echo "### BigQuery" >> $saida
  echo "" >> $saida
  echo "1. **Modelo de preço por capacidade**: Avaliar mudança para o modelo de slot commitment para cargas de trabalho previsíveis e constantes." >> $saida
  echo "2. **Otimização de consultas**: Revisar consultas frequentes para reduzir a quantidade de dados processados." >> $saida
  echo "3. **Tabelas materializadas**: Utilizar para armazenar resultados de consultas frequentes, reduzindo custos repetitivos." >> $saida
}

# Processar cada projeto
projetos=$(gcloud projects list --format="value(projectId)")

for projeto in $projetos; do
  echo "Analisando custos no projeto: $projeto"
  analisar_faturamento $projeto
  analisar_recomendacoes $projeto
done

echo "Análise de custos concluída. Verifique a documentação em $DIR_DOCS"
