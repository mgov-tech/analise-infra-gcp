# Documentação de Infraestrutura GCP da MOVVA

Este repositório contém a documentação detalhada da infraestrutura GCP utilizada pela MOVVA.

## Índice Principal

O arquivo [index.md](./index.md) contém a visão geral e links para todos os documentos organizados por categoria.

## Estrutura da Documentação

### Pastas de Recursos

- **projetos/** - Documentação sobre os projetos GCP e suas hierarquias
- **computacao/** - Documentação sobre recursos computacionais (VMs, GKE, Cloud Functions, etc.)
- **armazenamento/** - Documentação sobre recursos de armazenamento (Cloud Storage, Cloud SQL, BigQuery, etc.)
- **rede/** - Documentação sobre configurações de rede (VPC, Firewall, DNS, etc.)
- **seguranca/** - Documentação sobre configurações de segurança (IAM, KMS, Secret Manager, etc.)
- **custos/** - Análise de custos e recomendações de otimização
- **dados/** - Dicionários de dados do BigQuery e PostgreSQL
- **otimizacao/** - Recomendações e guias para otimização de recursos

### Documentos Principais

- [Infraestrutura Consolidada](./infraestrutura_consolidada.md) - Visão consolidada de toda a infraestrutura
- [Recomendações Priorizadas](./recomendacoes-melhorias-priorizadas.md) - Lista de melhorias priorizadas
- [Solicitação de Permissões](./solicitacao_permissoes.md) - Guia para solicitação de permissões
- [Autenticação](./autenticacao.md) - Informações sobre autenticação no GCP

### Análises Detalhadas

- [Análise Detalhada - Coltrane](./analise-detalhada-coltrane.md)
- [Análise Detalhada - MOVVA DataLake](./analise-detalhada-movva-datalake.md)
- [Análise Detalhada - MOVVA Splitter](./analise-detalhada-movva-splitter.md)
- [Análise Detalhada - Operations Dashboards](./analise-detalhada-operations-dashboards.md)
- [Análise Detalhada - RapidPro](./analise-detalhada-rapidpro.md)

## Convenções

Cada recurso GCP documentado seguirá a seguinte estrutura:

```markdown
# [Nome do Recurso]

## Informações Básicas

- **Projeto:** [Nome do Projeto]
- **ID do Recurso:** [ID]
- **Região/Zona:** [Região/Zona]
- **Criado em:** [Data de Criação]
- **Última Modificação:** [Data da Última Modificação]

## Configuração

[Detalhes da configuração do recurso]

## Uso e Dependências

[Como o recurso é utilizado e suas dependências]

## Recomendações

[Recomendações de otimização, se aplicável]
```

Recursos marcados com `*ALERTA_DE_OTIMIZAÇÃO!!!*` indicam oportunidades imediatas de otimização.
