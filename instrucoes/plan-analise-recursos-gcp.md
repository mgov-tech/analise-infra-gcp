# Plano de Análise e Documentação da Infraestrutura GCP da MOVVA

## Preparação do Ambiente

- [x] Instalar Google Cloud CLI (gcloud)
- [x] Preparar arquivos de instruções para configuração de credenciais
- [x] Criar estrutura de pastas para documentação
- [x] Verificar conexão e permissões de acesso

## Análise de Projetos

- [x] Criar script para listar todos os projetos GCP existentes
- [x] Preparar documentação de hierarquia organizacional dos projetos
- [x] Implementar mapeamento de relacionamentos entre projetos
- [x] Preparar estrutura para identificar responsáveis por cada projeto

## Análise de Recursos de Computação

- [x] Criar script para listar todas as instâncias de VMs
- [x] Implementar documentação de configurações das VMs
- [x] Preparar análise de grupos de instâncias gerenciadas
- [x] Incluir verificação de balanceadores de carga no script
- [x] Implementar documentação de clusters Kubernetes (GKE)
- [x] Criar mapeamento de Cloud Functions existentes
- [x] Preparar estrutura para analisar serviços Cloud Run

## Análise de Armazenamento

- [x] Criar script para listar buckets do Cloud Storage
- [x] Implementar documentação de políticas de retenção e ciclo de vida
- [x] Preparar análise de instâncias do Cloud SQL
- [x] Incluir documentação de instâncias do Cloud Spanner no script
- [x] Implementar mapeamento de databases do Firestore/Datastore
- [x] Criar estrutura para documentar instâncias Redis/Memcached
- [x] Preparar análise de tabelas e datasets do BigQuery

## Análise de Rede

- [x] Criar script para documentar topologia de rede VPC
- [x] Implementar listagem de regras de firewall existentes
- [x] Preparar mapeamento de conectividade híbrida (VPN/Interconnect)
- [x] Implementar análise de zonas DNS e registros existentes
- [x] Criar estrutura para documentar configurações de NAT e rotas

## Análise de Segurança

- [x] Criar script para listar contas de serviço e permissões
- [x] Implementar documentação de políticas IAM por projeto
- [x] Preparar análise de chaves de criptografia (KMS)
- [x] Implementar verificação de configurações de Secret Manager
- [x] Criar estrutura para mapear políticas de segurança de rede

## Análise de Custos

- [x] Criar script para extrair relatórios de faturamento por projeto
- [x] Implementar documentação de custos por serviço/recurso
- [x] Preparar identificação de potenciais otimizações de custo
- [x] Criar estrutura para analisar tendências de consumo de recursos

## Análise de Dados

- [x] Criar script para conectar aos datasets do BigQuery
- [x] Implementar estrutura para dicionário de dados do BigQuery
- [x] Preparar mapeamento de fluxos de ingestão de dados
- [x] Criar estrutura para documentar jobs e pipelines ETL/ELT
- [x] Implementar conexão às instâncias PostgreSQL
- [x] Preparar criação de dicionário de dados do PostgreSQL
- [x] Criar estrutura para mapear integrações BigQuery-PostgreSQL

## Problemas Identificados (Durante Execução)

- [x] Criar estrutura para analisar recursos sem documentação
- [x] Implementar identificação de recursos obsoletos ou não utilizados
- [x] Preparar mapeamento de dependências entre recursos

## Consolidação da Documentação

- [x] Implementar estrutura para diagrama de arquitetura geral
- [x] Criar documentação de fluxos de dados entre recursos
- [x] Preparar compilação de lista de otimizações recomendadas
- [x] Criar script para inventário completo de recursos GCP

## Execução (Pendente)

- [x] Autenticar no GCP com credenciais apropriadas
- [x] Executar script principal de análise
- [x] Revisar a documentação gerada
- [x] Identificar recursos adicionais para documentação
- [x] Preparar relatório de otimização de custos
- [x] Planejar criação de terraforms
