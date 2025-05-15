# Plano de Extensão - Remoção de Recursos Ociosos em Todos Projetos MOVVA

## Contexto

Este plano visa estender a implementação da US-01 (Remoção de recursos ociosos) para todos os projetos GCP da MOVVA, seguindo a metodologia já aplicada com sucesso no projeto movva-datalake. O objetivo é identificar e remover recursos ociosos para otimizar custos e melhorar a gestão da infraestrutura.

Data de início: 14/05/2025

## Checagem Inicial

- [x] Concluir a implementação no projeto movva-datalake (realizado com sucesso)
- [x] Iniciar análise do projeto rapidpro-217518
- [ ] Criar estrutura de diretórios para os demais projetos
- [ ] Definir prioridade para análise dos projetos restantes

## Etapas para cada Projeto

### 1. Projeto: rapidpro-217518 (em andamento)

- [x] Criar diretório para documentação e evidências
- [x] Configurar gcloud CLI para o projeto
- [x] Listar VMs em estado TERMINATED (nenhuma encontrada)
- [x] Listar discos persistentes (18 encontrados, todos em uso)
- [x] Listar snapshots antigos (1 encontrado, de 10/01/2019)
- [x] Listar IPs estáticos (6 encontrados, todos em uso)
- [x] Verificar versões de App Engine (nenhuma encontrada)
- [x] Documentar recursos identificados no inventário
- [x] Criar documento de consulta para remoção do snapshot antigo
- [x] Criar script para remoção do snapshot após aprovação
- [ ] Obter aprovação do arquiteto para remoção
- [ ] Executar remoção do snapshot
- [ ] Atualizar documentação pós-remoção
- [ ] Verificar economia real após remoção

### 2. Projeto: coltrane

- [x] Criar diretório para documentação e evidências
- [x] Configurar gcloud CLI para o projeto
- [x] Listar VMs em estado TERMINATED (nenhuma encontrada)
- [x] Listar discos persistentes (1 encontrado, em uso por cluster GKE)
- [x] Listar snapshots antigos (nenhum encontrado)
- [x] Listar IPs estáticos (7 encontrados, 2 reservados sem uso)
- [x] Verificar versões de App Engine sem tráfego (mais de 100 versões encontradas)
- [x] Documentar recursos identificados no inventário
- [x] Criar documento de consulta para recursos a remover
- [x] Criar scripts para remoção após aprovação
- [ ] Obter aprovação do arquiteto para remoção
- [ ] Executar remoção dos recursos aprovados
- [ ] Atualizar documentação pós-remoção
- [ ] Verificar economia real após remoção

### 3. Projeto: operations-dashboards

- [x] Criar diretório para documentação e evidências
- [x] Configurar gcloud CLI para o projeto
- [x] Listar VMs em estado TERMINATED (1 encontrada)
- [x] Listar discos persistentes (2 encontrados associados à VM TERMINATED)
- [x] Listar snapshots antigos (2 encontrados)
- [x] Listar IPs estáticos (1 encontrado associado à VM TERMINATED)
- [x] Verificar versões de App Engine sem tráfego (5 versões antigas encontradas)
- [x] Documentar recursos identificados no inventário
- [x] Criar documento de consulta para recursos a remover
- [x] Criar scripts para remoção após aprovação
- [ ] Obter aprovação do arquiteto para remoção
- [ ] Executar remoção dos recursos aprovados
- [ ] Atualizar documentação pós-remoção
- [ ] Verificar economia real após remoção

### 4. Projeto: movva-splitter

- [x] Criar diretório para documentação e evidências
- [x] Configurar gcloud CLI para o projeto
- [x] Listar VMs em estado TERMINATED (2 encontradas)
- [x] Listar discos persistentes (5 encontrados, 3 associados a VMs TERMINATED)
- [x] Listar snapshots antigos (3 encontrados, todos associados a discos de VMs TERMINATED)
- [x] Listar IPs estáticos (4 encontrados, 2 associados a VMs TERMINATED)
- [x] Verificar versões de App Engine sem tráfego (5 versões antigas encontradas)
- [x] Documentar recursos identificados no inventário
- [x] Criar documento de consulta para recursos a remover
- [x] Criar scripts para remoção após aprovação
- [ ] Obter aprovação do arquiteto para remoção
- [ ] Executar remoção dos recursos aprovados
- [ ] Atualizar documentação pós-remoção
- [ ] Verificar economia real após remoção

### 5. Projeto: movva-captcha

- [x] Criar diretório para documentação e evidências
- [x] Configurar gcloud CLI para o projeto
- [x] Listar VMs em estado TERMINATED (1 encontrada)
- [x] Listar discos persistentes (3 encontrados, 1 associado à VM TERMINATED)
- [x] Listar snapshots antigos (2 encontrados, 1 de 2023)
- [x] Listar IPs estáticos (3 encontrados, 1 associado à VM TERMINATED)
- [x] Verificar versões de App Engine sem tráfego (4 versões antigas encontradas)
- [x] Documentar recursos identificados no inventário
- [x] Criar documento de consulta para recursos a remover
- [x] Criar scripts para remoção após aprovação
- [ ] Obter aprovação do arquiteto para remoção
- [ ] Executar remoção dos recursos aprovados
- [ ] Atualizar documentação pós-remoção
- [ ] Verificar economia real após remoção

## Consolidação e Relatório Final

- [ ] Consolidar resultados de todos os projetos
- [ ] Calcular economia total realizada
- [ ] Documentar lições aprendidas
- [ ] Elaborar recomendações para prevenção futura
- [ ] Preparar apresentação para stakeholders
- [ ] Obter aprovação final do arquiteto
- [ ] Arquivar toda documentação
