# Análise Detalhada: Projeto operations-dashboards

## Visão Geral do Projeto

O projeto operations-dashboards é dedicado à análise de dados e dashboards operacionais, representando 19,47% do gasto líquido total da MOVVA no mês de abril de 2025. Este projeto concentra recursos de análise e visualização de dados que auxiliam na tomada de decisões operacionais.

**Período analisado:** 01/04/2025 a 30/04/2025

## Distribuição de Custos por Serviço

| Serviço | Custo (R$) | % do Projeto | Observações |
|---------|------------|--------------|-------------|
| Compute Engine | 1.316,49 | 48,7% | VMs e discos persistentes |
| BigQuery | 703,94 | 26,0% | Armazenamento e processamento de dados |
| Cloud SQL | 398,27 | 14,7% | PostgreSQL sem Alta Disponibilidade |
| Networking | 145,85 | 5,4% | Tráfego de rede e regras de firewall |
| Datastream | 103,34 | 3,8% | Serviço de replicação de dados |
| Outros serviços | 36,44 | 1,3% | VM Manager, Cloud Run, Storage, etc. |

**Total bruto:** R$ 2.704,33
**Créditos aplicados:** R$ 53,49
**Total líquido:** R$ 2.650,84

## Análise Detalhada por Serviço

### 1. Compute Engine (48,7% dos custos)

O Compute Engine representa quase metade dos custos do projeto, sendo o principal componente de despesa. Isso sugere uma forte dependência de infraestrutura computacional para processamento de dados e dashboards.

**Principais componentes de custo:**
- VMs do cluster GKE (2 nós e2-standard-2)
- Discos persistentes associados
- Possíveis VMs adicionais para processamento

**Observações:**
- Proporção muito alta de custo em Compute Engine comparado aos outros projetos
- Potencial para otimização com ajuste de tamanho das instâncias
- Verificar utilização real das VMs para identificar ociosidade

### 2. BigQuery (26,0% dos custos)

O BigQuery é o segundo maior componente de custo, evidenciando a natureza analítica do projeto. O custo elevado indica processamento intensivo de dados e/ou armazenamento de grandes volumes.

**Principais componentes de custo:**
- Armazenamento de dados (2TB em 3 datasets)
- Consultas e processamento
- Possíveis tabelas não particionadas ou clustering ineficiente

**Observações:**
- Custo significativo de BigQuery, típico de projetos analíticos
- Potencial para otimização com particionamento e clustering
- Avaliar políticas de retenção de dados e consultas frequentes

### 3. Cloud SQL (14,7% dos custos)

O Cloud SQL representa o terceiro maior custo, mas com uma configuração diferente dos outros projetos: sem Alta Disponibilidade.

**Principais componentes de custo:**
- Instância PostgreSQL de 200GB
- Armazenamento e backups

**Observações:**
- Custo significativamente menor que nos outros projetos devido à ausência de HA
- Instância de 200GB - avaliar se o dimensionamento está adequado
- Monitorar performance para garantir que a ausência de HA não impacta operações

### 4. Networking (5,4% dos custos)

Os custos de rede são proporcionalmente menores que em outros projetos como o coltrane.

**Principais componentes de custo:**
- Transferência de dados entre serviços
- Regras de firewall e configurações de VPC
- Possíveis balanceadores de carga

**Observações:**
- Custo moderado de networking para um projeto analítico
- Verificar padrões de comunicação entre serviços

### 5. Datastream (3,8% dos custos)

O Datastream é um serviço específico deste projeto, não encontrado nos outros, indicando replicação ou migração contínua de dados.

**Principais componentes de custo:**
- Replicação de dados entre origens e destinos
- Processamento e transformação durante a replicação

**Observações:**
- Custo relevante para um serviço específico
- Verificar se todas as replicações configuradas são necessárias
- Avaliar otimização na frequência ou volume de replicação

## Tendência de Custos

A análise da tendência de custos diários mostra um padrão mais irregular comparado aos outros projetos, com variações significativas entre dias. Os valores diários oscilam entre R$ 82 e R$ 113, indicando uso variável dos recursos, possivelmente relacionado a ciclos de processamento em lote ou cargas de trabalho não uniformes.

## Áreas de Otimização Potencial

1. **Compute Engine**
   - Avaliar o dimensionamento adequado das VMs
   - Implementar escalonamento automático para o cluster GKE
   - Considerar o uso de Spot Instances para workloads não críticas
   - Verificar se há VMs ociosas ou superdimensionadas

2. **BigQuery**
   - Implementar particionamento e clustering em tabelas grandes
   - Materializar visões frequentemente consultadas
   - Otimizar consultas para reduzir processamento
   - Implementar políticas de retenção de dados

3. **Cloud SQL**
   - Monitorar utilização e performance para verificar dimensionamento
   - Otimizar políticas de backup
   - Avaliar a possibilidade de escalonamento por demanda

4. **Datastream**
   - Revisar configurações de replicação
   - Avaliar frequência necessária de sincronização
   - Verificar se todos os dados replicados são realmente necessários

5. **Networking**
   - Analisar padrões de tráfego
   - Otimizar comunicação entre serviços
   - Revisar regras de firewall
