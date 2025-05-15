# Consulta sobre Versões Antigas de App Engine - Projeto Coltrane

## Data: 14/05/2025

## Contexto
Durante análise do projeto coltrane, foram identificadas mais de 100 versões de App Engine, sendo a maioria delas antigas e sem tráfego. A remoção das versões mais antigas pode gerar economia mensal estimada de R$ 150,00.

## Recursos Identificados

| Serviço | Quantidade de Versões | Período | Status | Tráfego | Observações |
|---------|----------------------|---------|--------|---------|-------------|
| default | 27 versões | 2023-03-20 a 2024-11-27 | STOPPED | 0.00 | Versões antigas sem tráfego |
| stage | 5 versões | 2024-11-22 a 2024-11-28 | STOPPED | 0.00 | Versões sem tráfego |
| webapp-stage | +50 versões | 2023-05-04 a 2025-02-26 | SERVING | 0.00 | Versões sem tráfego |
| webapp | +30 versões | 2023-02-10 a 2025-02-26 | SERVING | 0.00 | Versões sem tráfego |

## Perguntas para Avaliação

1. É possível remover as versões anteriores a 2025 para todos os serviços?
2. Existe alguma política específica para retenção de versões anteriores? (Por exemplo: manter as últimas N versões ou versões dos últimos X meses)
3. Há alguma versão específica que deve ser mantida por motivos históricos ou para possível rollback?
4. Com que frequência são realizados rollbacks para versões mais antigas?

## Recomendação Técnica

Considerando a grande quantidade de versões acumuladas, recomendamos:

1. Manter apenas as versões de 2025 (últimos ~5 meses)
2. Alternativamente, manter apenas as últimas 5 versões de cada serviço
3. Implementar uma política de limpeza automática para remover versões mais antigas após um período determinado
4. Antes da remoção, documentar metadados relevantes das versões (como SHA do commit, tag de versão, etc.)

## Proposta de Script de Limpeza

Podemos criar um script para remover automaticamente as versões mais antigas, mantendo apenas as mais recentes:

```bash
#!/bin/bash
# Script para remover versões antigas de App Engine no projeto coltrane
# Mantém apenas as últimas N versões ou versões mais recentes que X meses

PROJETO="coltrane"
SERVICOS=("default" "stage" "webapp" "webapp-stage")
MANTER_VERSOES=5  # Número de versões mais recentes a manter por serviço
DATA_LIMITE="2025-01-01"  # Manter apenas versões posteriores a esta data

# Configurar o projeto
gcloud config set project $PROJETO

# Para cada serviço
for servico in "${SERVICOS[@]}"; do
  echo "Processando serviço: $servico"
  
  # Listar todas as versões que não estão recebendo tráfego e são anteriores à data limite
  versoes_para_remover=$(gcloud app versions list --service=$servico --format="value(id,version.createTime,traffic_split)" | 
                         awk -v data="$DATA_LIMITE" '$2 < data && $3 == "0.0" {print $1}')
  
  # Contar quantas versões serão removidas
  total_versoes=$(echo "$versoes_para_remover" | wc -l)
  
  echo "Identificadas $total_versoes versões para remoção no serviço $servico"
  
  # Remover as versões (comentado até aprovação)
  # for versao in $versoes_para_remover; do
  #   echo "Removendo $servico:$versao"
  #   gcloud app versions delete --service=$servico $versao --quiet
  # done
done

echo "Script finalizado. Remova os comentários para executar a remoção efetiva após aprovação."
```

## Próximos Passos

1. Aguardar avaliação do arquiteto/responsável pelo projeto
2. Se aprovado, refinar e executar script de limpeza
3. Documentar a economia gerada no relatório consolidado
4. Propor implementação de política automática de limpeza

## Contato para Aprovação

- Nome: [INSERIR NOME DO RESPONSÁVEL]
- Email: [INSERIR EMAIL DO RESPONSÁVEL]

---

**Nota:** Esta consulta faz parte do projeto de otimização de recursos do GCP - Fase 1 - US-01 (Remoção de Recursos Ociosos).
