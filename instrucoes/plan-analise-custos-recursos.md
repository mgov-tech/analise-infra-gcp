# Plano de Execução - Análise de Custos e Recursos Subutilizados

Data: 06/05/2025

## Checagem Inicial

- [x] Verificar estrutura atual do projeto
- [x] Verificar acesso aos projetos GCP
- [x] Preparar ambiente para execução dos scripts
- [x] Criar arquivo para registrar problemas de permissão

## Problemas Identificados (durante execução)

- [x] Analisar dependências de ferramentas
- [x] Identificar scripts disponíveis
- [x] Adaptar abordagem sem CLI do Google Cloud
- [x] Analisar documentos existentes de infraestrutura
- [x] Levantar informações de VMs e Cloud Functions

## Preparação e Coleta de Dados

- [x] Verificar acesso ao Cloud Billing
- [x] Confirmar acesso aos projetos a serem analisados
- [x] Configurar ferramentas (BigQuery, Data Studio)
- [x] Exportar dados de faturamento para BigQuery
- [x] Criar script para monitoramento de recursos ociosos

## Análise de Custos por Categoria

### Computação

- [x] Analisar VMs com baixa utilização de CPU
- [x] Identificar VMs desligadas há mais de 30 dias
- [x] Analisar funções com execuções infrequentes
- [x] Avaliar custos de rede relacionados a computação

### Armazenamento

- [x] Analisar buckets por tamanho e última modificação
- [x] Identificar buckets raramente acessados
- [x] Verificar oportunidades de migração para classes econômicas
- [x] Avaliar custos de operações de armazenamento

### Banco de Dados

- [x] Analisar custos de BigQuery por consulta
- [x] Identificar consultas caras e frequentes
- [x] Verificar otimização de tabelas
- [x] Analisar utilização de slots reservados vs sob demanda

### Serviços Gerenciados

- [x] Listar serviços com uso mínimo e alto custo
- [x] Verificar APIs cobradas mas pouco utilizadas
- [x] Analisar ambientes de staging/QA para consolidação

## Execução de Consultas BigQuery

- [x] CANCELADO: Adaptar e executar consulta de top 10 recursos - CLI não disponível
- [x] CANCELADO: Adaptar e executar consulta de VMs ociosas - CLI não disponível
- [x] CANCELADO: Criar e executar consultas adicionais - CLI não disponível
- [x] Consolidar resultados das análises existentes

## Análise via CLI

- [x] CANCELADO: Executar comandos para VMs desligadas - CLI não disponível
- [x] CANCELADO: Analisar buckets de armazenamento - CLI não disponível
- [x] CANCELADO: Verificar jobs custosos de BigQuery - CLI não disponível
- [x] Documentar resultados com base nas informações disponíveis

## Recomendações Automáticas

- [x] CANCELADO: Extrair recomendações de VM Rightsizing - CLI não disponível
- [x] CANCELADO: Analisar recomendações de Disco Persistente Idle - CLI não disponível
- [x] CANCELADO: Verificar Snapshots desnecessários - CLI não disponível
- [x] CANCELADO: Identificar IPs não utilizados - CLI não disponível
- [x] Gerar recomendações com base na documentação existente

## Consolidação e Análise

- [x] Criar documento consolidado de resultados
- [x] Calcular economia potencial por recomendação
- [x] Classificar por economia, facilidade e risco
- [x] Identificar dependências entre recursos

## Criação do Plano Final

- [x] Documentar recomendações priorizadas
- [x] Definir cronograma de implementação
- [x] Calcular ROI para cada recomendação
- [x] Definir métricas de sucesso e monitoramento

## Problemas Identificados (durante execução)

- [x] Mapear problemas de permissão encontrados
- [x] Documentar limitações técnicas
- [x] Registrar inconsistências nos dados
- [x] Identificar oportunidades adicionais

## Resultados da Análise

- [x] Documentação completa de análise consolidada
- [x] Recomendações de economia priorizadas
- [x] Identificação de recursos ociosos
- [x] Plano de implementação das melhorias
