# Documentação da Infraestrutura GCP da MOVVA

Data da análise: 14/05/2025

## Visão Geral

A MOVVA possui atualmente três projetos principais no Google Cloud Platform:

1. **movva-datalake** - Projeto principal para processamento e armazenamento de dados
2. **movva-splitter** - Projeto para processamento distribuído usando App Engine
3. **movva-captcha-1698695351695** - Projeto específico para implementação do reCAPTCHA Enterprise

## Estrutura da Documentação

Esta documentação está organizada nas seguintes seções:

### Recursos por Categoria

- [Computação](./computacao/) - VMs, Cloud Functions, App Engine
- [Armazenamento](./armazenamento/) - Cloud Storage, Buckets, Discos
- [Dados](./dados/) - BigQuery, Cloud SQL, PostgreSQL
- [Rede](./rede/) - VPCs, Regras de Firewall, DNS
- [Segurança](./seguranca/) - IAM, Service Accounts, Secret Manager
- [Otimização](./otimizacao/) - Recomendações para redução de custos

### Recursos por Projeto

- [Projeto movva-datalake](./projetos/projeto_movva-datalake.md)
- [Projeto movva-splitter](./projetos/projeto_movva-splitter.md)
- [Projeto movva-captcha](./projetos/projeto_movva-captcha-1698695351695.md)

### Análises Detalhadas

- [Análise Detalhada - Coltrane](./analise-detalhada-coltrane.md)
- [Análise Detalhada - MOVVA DataLake](./analise-detalhada-movva-datalake.md)
- [Análise Detalhada - MOVVA Splitter](./analise-detalhada-movva-splitter.md)
- [Análise Detalhada - Operations Dashboards](./analise-detalhada-operations-dashboards.md)
- [Análise Detalhada - RapidPro](./analise-detalhada-rapidpro.md)

### Documentos de Infraestrutura

- [Infraestrutura Consolidada](./infraestrutura_consolidada.md)
- [Recomendações de Melhorias Priorizadas](./recomendacoes-melhorias-priorizadas.md)
- [Autenticação GCP](./autenticacao.md) - Instruções de autenticação
- [Solicitação de Permissões](./solicitacao_permissoes.md) - Permissões necessárias

## Próximos Passos

1. **Implementar Recomendações Priorizadas**
2. **Auditoria Detalhada de Uso**
3. **Criação de Terraform**
4. **Planejamento de Otimização**
