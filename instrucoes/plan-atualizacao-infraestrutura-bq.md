# Plano de Atualização da Infraestrutura Consolidada com Dados de Billing do BigQuery

## Análise Inicial

- [x] Verificar estrutura atual do documento infraestrutura_consolidada.md
- [x] Identificar quais seções precisam ser atualizadas com dados do BQ
- [x] Analisar o conjunto de dados "faturamento" no projeto "rapidpro"
- [x] Mapear tabelas e visualizações disponíveis no BigQuery

## Extração de Dados do BigQuery

- [x] Analisar estrutura das tabelas de faturamento no BQ
  - Identificadas duas tabelas principais: `gcp_billing_export_resource_v1_017436_D221A3_C4D547` e `evolutivo_gastos_transicao`
- [x] Criar queries para extrair custos por projeto
- [x] Criar queries para extrair custos por serviço
- [x] Extrair dados com informações até 30 de março e além (dados de 30/03 a 12/05)
- [x] Validar consistência dos dados extraídos

## Processamento e Consolidação

- [x] Comparar dados antigos com novos dados do BQ
- [x] Identificar discrepâncias e inconsistências
  - Os valores de custo no BQ são significativamente diferentes dos valores listados no documento original
- [x] Criar resumos e agregações de custos
  - Totais consolidados por projeto e serviço
- [x] Preparar visualizações para relatórios futuros
  - Criadas queries para análises diversas no arquivo queries_faturamento.sql
- [x] Elaborar recomendações baseadas nos novos dados
  - Recomendações atualizadas no documento principal com base nos novos custos

## Análise de Custo por Projeto

- [x] Analisar custos do projeto rapidpro-217518
  - Custo mensal: R$ 15.877,85 (mais alto que no documento original)
  - Serviços principais: Cloud SQL (67,3%), Kubernetes Engine (12,8%), Compute Engine (9,8%)
- [x] Analisar custos do projeto movva-datalake
  - Custo mensal: R$ 43,54 (muito menor que no documento original)
  - Serviços principais: Cloud Storage (94,2%), Compute Engine (5,8%)
- [x] Analisar custos do projeto coltrane
  - Custo mensal: R$ 3.693,69 (menor que no documento original)
  - Serviços principais: Cloud SQL (58,4%), App Engine (24,7%), Networking (10,5%)
- [x] Analisar custos do projeto operations-dashboards
  - Custo mensal: R$ 3.578,94 (menor que no documento original)
  - Serviços principais: Compute Engine (49,2%), BigQuery (25,4%), Cloud SQL (15,0%)
- [x] Analisar custos do projeto movva-splitter
  - Custo mensal: R$ 16,08 (muito menor que no documento original)
  - Serviços principais: Compute Engine (92,4%), Cloud Storage (7,6%)
- [x] Analisar custos do projeto movva-captcha
  - Não foram encontrados dados no BigQuery para este projeto

## Análise de Custo por Serviço

- [x] Analisar custos de BigQuery
  - Custo mensal: R$ 910,32
  - Principalmente no projeto operations-dashboards
- [x] Analisar custos de Cloud SQL
  - Custo mensal: R$ 13.382,97
  - Distribuição: rapidpro-217518 (R$ 10.690,32), coltrane (R$ 2.156,20), operations-dashboards (R$ 536,44)
- [x] Analisar custos de Compute Engine
  - Custo mensal: R$ 3.464,23
  - Distribuição: operations-dashboards (R$ 1.762,42), rapidpro-217518 (R$ 1.548,27), coltrane (R$ 136,13)
- [x] Analisar custos de Cloud Storage
  - Custo mensal: R$ 98,14
  - Distribuição: coltrane (R$ 47,02), movva-datalake (R$ 41,00), outros projetos (R$ 10,12)
- [x] Analisar custos de GKE
  - Custo mensal: R$ 2.037,92 (Kubernetes Engine) + R$ 299,83 (GKE Enterprise/GDC)
  - Exclusivamente no projeto rapidpro-217518
- [x] Analisar custos de outros serviços
  - App Engine: R$ 926,87 (principalmente em coltrane)
  - Cloud Run: R$ 861,79 (principalmente em rapidpro-217518)
  - Networking: R$ 977,12 (distribuído entre vários projetos)
  - Vertex AI: Custo negligenciável (R$ 0,08)

## Criação de Queries para Relatórios Futuros

- [x] Desenvolver query para análise de tendência de custos
- [x] Desenvolver query para identificação de picos de gastos
- [x] Desenvolver query para monitoramento de recursos ociosos
- [x] Preparar documentação sobre as queries desenvolvidas
  - Criado arquivo `/scripts/queries_faturamento.sql` com 10 queries documentadas para diferentes análises

## Atualização do Documento

- [x] Atualizar seção de Visão Geral
  - Data atualizada para 12/05/2025
- [x] Atualizar seção de Resumo de Recursos por Projeto
  - Atualizados valores de custo mensal para cada projeto com base no BigQuery
- [x] Atualizar seção de Resumo de Custos por Serviço
  - Reformulada tabela com dados reais do BigQuery
  - Incluída observação sobre o total consolidado de R$ 23.210,10
- [x] Atualizar seção de Recomendações de Otimização
  - Ajustados valores de economia potencial com base nos novos dados
  - Reordenadas prioridades de otimização segundo custos atuais
- [x] Revisar e atualizar seção de Próximos Passos
  - Priorizada otimização de Cloud SQL como ação principal

## Validação Final

- [x] Verificar consistência das informações no documento
  - Verificada coerência entre valores apresentados e dados extraídos do BigQuery
- [x] Validar se todas as seções foram atualizadas
  - Todas as seções relevantes foram atualizadas com os novos dados
- [x] Garantir formatação adequada do documento
  - Mantida a formatação original do documento com atualizações
- [x] Realizar revisão final do documento atualizado
  - Documento revisado e finalizado
