#!/bin/bash
# Script principal para análise da infraestrutura GCP da MOVVA
# Autor: Cascade AI
# Data: 06/05/2025

# Diretório base
DIR_BASE=$(dirname "$0")
cd "$DIR_BASE" || exit 1

# Exibir banner
echo "========================================================"
echo "  ANÁLISE DE INFRAESTRUTURA GCP - MOVVA"
echo "  Data: $(date '+%d/%m/%Y %H:%M:%S')"
echo "========================================================"
echo ""

# Verificar se gcloud está instalado e configurado
if ! command -v gcloud &> /dev/null; then
    echo "Google Cloud SDK (gcloud) não encontrado. Verifique se está instalado corretamente."
    echo "Para instalar: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Verificar autenticação
auth_status=$(gcloud auth list --format="value(status)" 2>/dev/null)
if [[ -z "$auth_status" || "$auth_status" != "ACTIVE" ]]; then
    echo "Você não está autenticado no Google Cloud."
    echo "Execute: gcloud auth login"
    echo "ou utilize uma conta de serviço: gcloud auth activate-service-account"
    exit 1
fi

# Garantir que os scripts tenham permissão de execução
echo "Configurando permissões para os scripts de análise..."
chmod +x scripts/*.sh

# Criar diretórios necessários
mkdir -p docs
mkdir -p docs/projetos docs/computacao docs/armazenamento docs/rede docs/seguranca docs/custos docs/dados

# Função para executar script com temporizador
executar_script() {
    script=$1
    descricao=$2
    
    echo ""
    echo "========================================================"
    echo "  EXECUTANDO: $descricao"
    echo "  Script: $script"
    echo "  Início: $(date '+%d/%m/%Y %H:%M:%S')"
    echo "========================================================"
    
    inicio=$(date +%s)
    
    # Executar o script
    bash "$script"
    status=$?
    
    fim=$(date +%s)
    duracao=$((fim - inicio))
    minutos=$((duracao / 60))
    segundos=$((duracao % 60))
    
    echo ""
    echo "========================================================"
    echo "  CONCLUÍDO: $descricao"
    echo "  Status: $([ $status -eq 0 ] && echo "Sucesso" || echo "Falha")"
    echo "  Tempo de execução: ${minutos}m ${segundos}s"
    echo "  Término: $(date '+%d/%m/%Y %H:%M:%S')"
    echo "========================================================"
    
    return $status
}

# Definir projetos-alvo da MOVVA
PROJETOS_MOVVA=("movva-captcha-1698695351695" "movva-datalake" "movva-splitter")

# Função para executar análise focada em projetos específicos
executar_analise_focada() {
    script=$1
    descricao=$2
    
    for projeto in "${PROJETOS_MOVVA[@]}"; do
        echo ""
        echo "======================================================="
        echo "  EXECUTANDO: $descricao para o projeto: $projeto"
        echo "  Script: $script"
        echo "  Início: $(date '+%d/%m/%Y %H:%M:%S')"
        echo "======================================================="
        
        # Executar o script apenas para este projeto
        export PROJETO_ALVO="$projeto"
        bash "$script"
        unset PROJETO_ALVO
    done
}

# Executar cada script de análise na ordem adequada
echo "Iniciando análise focada da infraestrutura GCP da MOVVA..."

# Primeiro, analisar todos os projetos para obter o mapeamento geral
executar_script "scripts/analise_projetos.sh" "Análise de Projetos"

# Em seguida, analisar recursos específicos apenas dos projetos MOVVA
echo "Analisando recursos de computação para projetos específicos da MOVVA..."
executar_analise_focada "scripts/analise_computacao.sh" "Análise de Recursos de Computação"

echo "Analisando recursos de armazenamento para projetos específicos da MOVVA..."
executar_analise_focada "scripts/analise_armazenamento.sh" "Análise de Recursos de Armazenamento"

echo "Analisando recursos de rede para projetos específicos da MOVVA..."
executar_analise_focada "scripts/analise_rede.sh" "Análise de Recursos de Rede"

echo "Analisando recursos de segurança para projetos específicos da MOVVA..."
executar_analise_focada "scripts/analise_seguranca.sh" "Análise de Recursos de Segurança"

echo "Analisando custos para projetos específicos da MOVVA..."
executar_analise_focada "scripts/analise_custos.sh" "Análise de Custos"

echo "Analisando dados para projetos específicos da MOVVA..."
executar_analise_focada "scripts/analise_dados.sh" "Análise de Dados (BigQuery e PostgreSQL)"

# Gerar índice final
echo "Gerando índice de documentação..."

cat > docs/indice.md << EOL
# Índice da Documentação de Infraestrutura GCP da MOVVA

Análise realizada em: $(date '+%d/%m/%Y %H:%M:%S')

## Organização da Documentação

- [README e Visão Geral](README.md)
- [Instruções de Autenticação](autenticacao.md)

## Projetos
$(find docs/projetos -name "*.md" | sort | sed 's|docs/|[|g; s|.md|](& "Ver documentação")|g')

## Computação
$(find docs/computacao -name "*.md" | sort | sed 's|docs/|[|g; s|.md|](& "Ver documentação")|g')

## Armazenamento
$(find docs/armazenamento -name "*.md" | sort | sed 's|docs/|[|g; s|.md|](& "Ver documentação")|g')

## Rede
$(find docs/rede -name "*.md" | sort | sed 's|docs/|[|g; s|.md|](& "Ver documentação")|g')

## Segurança
$(find docs/seguranca -name "*.md" | sort | sed 's|docs/|[|g; s|.md|](& "Ver documentação")|g')

## Custos
$(find docs/custos -name "*.md" | sort | sed 's|docs/|[|g; s|.md|](& "Ver documentação")|g')

## Dados
$(find docs/dados -name "*.md" | sort | sed 's|docs/|[|g; s|.md|](& "Ver documentação")|g')

## Alertas de Otimização

Foram identificados os seguintes alertas de otimização na infraestrutura:

$(grep -r "ALERTA_DE_OTIMIZAÇÃO" docs/ | sort | uniq | sed 's/.*ALERTA_DE_OTIMIZAÇÃO!!!//g; s/^/- /g')

## Próximos Passos

1. Revisar a documentação gerada
2. Priorizar otimizações identificadas
3. Criar Terraforms para os recursos documentados
4. Implementar as otimizações de custo recomendadas
EOL

echo ""
echo "========================================================"
echo "  ANÁLISE CONCLUÍDA!"
echo "  Documentação disponível em: $(pwd)/docs"
echo "  Índice principal: $(pwd)/docs/indice.md"
echo "========================================================"
