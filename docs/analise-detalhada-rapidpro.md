# Análise Detalhada: Projeto rapidpro-217518

## Visão Geral do Projeto

O projeto rapidpro-217518 é o principal em termos de custo na infraestrutura da MOVVA, representando 66,11% do gasto líquido total no mês de abril de 2025. Este projeto hospeda a plataforma de comunicação e automação para campanhas via múltiplos canais.

**Período analisado:** 01/04/2025 a 30/04/2025

## Distribuição de Custos por Serviço

| Serviço | Custo (R$) | % do Projeto | Observações |
|---------|------------|--------------|-------------|
| Cloud SQL | 7.892,87 | 67,1% | Banco PostgreSQL com Alta Disponibilidade |
| Kubernetes Engine | 1.511,30 | 12,8% | Inclui o cluster GKE |
| Compute Engine | 1.163,38 | 9,9% | Inclui 3 VMs ativas |
| Cloud Run | 644,53 | 5,5% | 2 serviços |
| Networking | 292,39 | 2,5% | Tráfego de rede, regras de firewall |
| GKE Enterprise/GDC | 222,37 | 1,9% | Recursos empresariais do GKE |
| Outros serviços | 39,09 | 0,3% | App Engine, Cloud DNS, etc. |

**Total bruto:** R$ 11.765,93
**Créditos aplicados:** R$ 2.767,66
**Total líquido:** R$ 8.998,27

## Análise Detalhada por Serviço

### 1. Cloud SQL (67,1% dos custos)

O Cloud SQL representa mais de dois terços do custo total do projeto, principalmente devido à instância PostgreSQL configurada com Alta Disponibilidade (HA). Este tipo de configuração duplica efetivamente os recursos necessários para manter o banco de dados, pois exige uma instância secundária em standby.

**Principais componentes de custo:**
- Instância principal PostgreSQL com 100GB
- Instância standby para Alta Disponibilidade
- Armazenamento e backups

**Observações:**
- A alta disponibilidade é um componente significativo do custo
- Os custos de armazenamento aumentam com a retenção de backups
- Potencial de otimização com ajuste no tamanho da instância e políticas de backup

### 2. Kubernetes Engine (12,8% dos custos)

O serviço GKE representa o segundo maior custo no projeto, consistindo de um cluster com 3 nós utilizando máquinas e2-standard-4.

**Principais componentes de custo:**
- 3 nós e2-standard-4 (4 vCPUs, 16GB RAM cada)
- Custos de gerenciamento do cluster
- Funções adicionais do GKE

**Observações:**
- Custo fixo por hora para cada nó, independente da utilização
- Potencial para escalonamento automático ou uso de Spot Instances para workloads tolerantes a interrupções
- Os custos do GKE Enterprise (1,9% adicional) indicam uso de recursos avançados

### 3. Compute Engine (9,9% dos custos)

O Compute Engine representa quase 10% dos custos do projeto, principalmente devido às 3 VMs ativas.

**Principais componentes de custo:**
- VM rapidpro-main (e2-standard-4)
- VM rapidpro-worker (e2-standard-2)
- VM rapidpro-redis (e2-medium)
- Discos persistentes associados

**Observações:**
- Custo fixo por hora para cada VM em execução
- Potencial para redimensionamento baseado em uso real
- Oportunidade para implementar programação de desligamento em períodos de baixo uso

### 4. Cloud Run (5,5% dos custos)

O Cloud Run representa 5,5% dos custos do projeto, com 2 serviços implantados.

**Principais componentes de custo:**
- Alocação de CPU e memória para os serviços
- Tempo de execução dos containers
- Solicitações processadas

**Observações:**
- Cobranças baseadas em consumo (CPU, memória, solicitações)
- Potencial para ajustar configurações de CPU/memória
- Avaliar se os serviços estão configurados corretamente para escalar a zero quando não utilizados

## Tendência de Custos

A análise da tendência de custos diários mostra um padrão relativamente constante ao longo do mês de abril, com média diária de aproximadamente R$ 390,00, indicando uma infraestrutura estável sem grandes flutuações de uso ou custos.

## Áreas de Otimização Potencial

1. **Cloud SQL**
   - Avaliar a real necessidade de Alta Disponibilidade para todos os ambientes
   - Implementar políticas de backup mais eficientes
   - Considerar downgrade do tipo de máquina em períodos de baixo uso

2. **Kubernetes Engine**
   - Implementar escalonamento automático de nós
   - Avaliar a possibilidade de usar Spot Instances para cargas não críticas
   - Revisar a real necessidade dos recursos do GKE Enterprise

3. **Compute Engine**
   - Avaliar redimensionamento das VMs com base em métricas de utilização
   - Implementar programação para reduzir capacidade em horários de baixo uso
   - Verificar se todas as VMs precisam estar ativas 24/7

4. **Cloud Run**
   - Revisar configurações de CPU/memória
   - Garantir que os serviços estão configurados para escalar a zero
   - Analisar padrões de uso para otimizar custos
