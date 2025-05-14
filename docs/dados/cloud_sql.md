# Cloud SQL (PostgreSQL)

Data da análise: 06/05/2025

## Visão Geral

Durante a análise, não conseguimos identificar ou analisar instâncias Cloud SQL (PostgreSQL) em nenhum dos projetos da MOVVA devido a limitações de permissão.

## Projeto: movva-datalake

Não foram encontradas instâncias Cloud SQL (PostgreSQL) durante a análise. O comando `gcloud sql instances list` não retornou nenhum resultado.

### Observações

- A ausência de instâncias Cloud SQL não significa que o projeto não utilize bancos PostgreSQL
- É possível que as instâncias PostgreSQL estejam em outros projetos não analisados
- Também é possível que sejam utilizadas soluções gerenciadas externas ao GCP

## Projeto: movva-splitter

**SEM PERMISSÃO** - A API Cloud SQL Admin não está habilitada no projeto `movva-splitter` ou não temos permissão para acessá-la.

### Observações

- Baseado nos buckets App Engine identificados, é possível que exista uma integração com PostgreSQL para armazenamento de dados da aplicação

## Projeto: movva-captcha-1698695351695

**SEM PERMISSÃO** - A API Cloud SQL Admin não está habilitada no projeto `movva-captcha-1698695351695` ou não temos permissão para acessá-la.

### Observações

- Devido ao foco específico em reCAPTCHA Enterprise, é menos provável que este projeto utilize PostgreSQL diretamente

## Próximos Passos

1. Obter permissões apropriadas para API Cloud SQL Admin em todos os projetos
2. Listar todas as instâncias PostgreSQL em uso
3. Documentar esquemas, tamanhos de banco e configurações
4. Mapear integrações com BigQuery e outras fontes de dados
5. Criar dicionário de dados para tabelas principais
