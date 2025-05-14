# Recomendações de Melhorias - Infraestrutura GCP MOVVA

## Introdução

Este documento apresenta um conjunto de recomendações para otimização dos custos e eficiência da infraestrutura GCP da MOVVA, com base na análise detalhada de todos os projetos durante o mês de abril de 2025. As recomendações estão classificadas de acordo com:

1. **Facilidade de implementação**: Fácil, Média ou Difícil
2. **Impacto potencial**: Alto, Médio ou Baixo
3. **Risco associado**: Alto, Médio ou Baixo

Para cada recomendação, detalhamos também os projetos afetados, as etapas de implementação e a economia estimada.

## Recomendações de Implementação Fácil

### 1. Limpeza de Recursos Ociosos

**Facilidade**: Fácil  
**Impacto**: Médio  
**Risco**: Baixo  
**Economia estimada**: R$ 250-350/mês  
**Projetos afetados**: movva-datalake, movva-splitter, rapidpro-217518

**Descrição**:  
Identificamos recursos inativos ou ociosos que geram custos desnecessários em diversos projetos, principalmente em movva-datalake e movva-splitter, onde existem VMs desligadas mas com recursos associados ainda sendo cobrados.

**Etapas de implementação**:
1. Excluir discos persistentes de VMs desligadas (após backup se necessário)
2. Remover snapshots antigos e desnecessários
3. Liberar IPs estáticos não utilizados
4. Excluir versões de App Engine sem tráfego

**Por que é fácil**:  
São ações pontuais que não afetam serviços em produção e podem ser executadas rapidamente por meio do console ou da CLI do GCP, com possibilidade de rollback via restauração de backups se necessário.

### 2. Implementação de Políticas de Ciclo de Vida no Cloud Storage

**Facilidade**: Fácil  
**Impacto**: Baixo  
**Risco**: Baixo  
**Economia estimada**: R$ 30-60/mês  
**Projetos afetados**: Todos, especialmente movva-datalake

**Descrição**:  
Configurar políticas de ciclo de vida nos buckets para automaticamente transferir objetos antigos para classes de armazenamento mais econômicas ou excluí-los após um período determinado.

**Etapas de implementação**:
1. Identificar padrões de acesso aos dados nos buckets (último acesso)
2. Definir políticas apropriadas por bucket (ex: mover para Nearline após 30 dias, Coldline após 90 dias)
3. Implementar políticas via console ou Terraform
4. Monitorar transições por 15-30 dias

**Por que é fácil**:  
Configuração simples via console ou código, sem impacto na disponibilidade dos dados e com possibilidade de ajuste ou reversão imediata.

### 3. Otimização de Políticas de Backup do Cloud SQL

**Facilidade**: Fácil  
**Impacto**: Médio  
**Risco**: Baixo  
**Economia estimada**: R$ 300-500/mês  
**Projetos afetados**: rapidpro-217518, coltrane

**Descrição**:  
Revisar e ajustar as políticas de backup do Cloud SQL para reduzir a quantidade de backups retidos, otimizando o espaço de armazenamento.

**Etapas de implementação**:
1. Revisar configurações atuais de backup (frequência e período de retenção)
2. Definir política de retenção otimizada baseada em necessidades reais de recuperação
3. Implementar nova política em cada instância
4. Documentar mudanças para equipe operacional

**Por que é fácil**:  
Configuração simples via console com impacto limitado à capacidade de restauração para pontos específicos no tempo, sem afetar a operação atual.

## Recomendações de Implementação Média

### 4. Redimensionamento de Instâncias Cloud SQL

**Facilidade**: Média  
**Impacto**: Alto  
**Risco**: Médio  
**Economia estimada**: R$ 2.500-3.500/mês  
**Projetos afetados**: rapidpro-217518, coltrane

**Descrição**:  
As instâncias de Cloud SQL representam o maior componente de custo, especialmente no projeto rapidpro-217518. O redimensionamento pode trazer economia significativa.

**Etapas de implementação**:
1. Coletar métricas de utilização real (CPU, memória, IOPS, conexões) por 7-14 dias
2. Identificar períodos de pico e média de utilização
3. Definir tamanho adequado com margem de segurança
4. Programar janela de manutenção para redimensionamento
5. Implementar monitoramento pós-mudança
6. Considerar teste em ambiente não-produtivo primeiro

**Por que é média**:  
Requer análise técnica detalhada, envolve downtime durante a aplicação (mesmo que breve), e pode afetar o desempenho se subdimensionado.

### 5. Implementação de Escalonamento Automático para GKE

**Facilidade**: Média  
**Impacto**: Alto  
**Risco**: Médio  
**Economia estimada**: R$ 400-600/mês  
**Projetos afetados**: rapidpro-217518

**Descrição**:  
Configurar o escalonamento automático de nós no cluster GKE para adicionar ou remover nós com base na demanda real.

**Etapas de implementação**:
1. Analisar padrões de consumo de recursos do cluster (CPU, memória)
2. Configurar políticas de escalonamento horizontal de pods (HPA)
3. Configurar escalonamento automático de nós
4. Definir limites mínimos e máximos apropriados
5. Implementar e monitorar por 7-14 dias
6. Ajustar parâmetros com base no comportamento observado

**Por que é média**:  
Requer conhecimento técnico de Kubernetes, pode gerar instabilidade temporária durante escalonamento se não configurado corretamente, e precisa de testes e ajustes contínuos.

### 6. Migração de App Engine Flexible para Standard ou Cloud Run

**Facilidade**: Média  
**Impacto**: Alto  
**Risco**: Médio  
**Economia estimada**: R$ 300-450/mês  
**Projetos afetados**: coltrane

**Descrição**:  
O App Engine Flexible no projeto coltrane é significativamente mais caro que alternativas serverless como App Engine Standard ou Cloud Run.

**Etapas de implementação**:
1. Analisar requisitos técnicos das aplicações atuais
2. Avaliar compatibilidade com ambiente Standard ou Cloud Run
3. Desenvolver plano de migração por aplicação
4. Implementar e testar em ambiente paralelo
5. Migrar tráfego gradualmente (10%, 50%, 100%)
6. Manter ambiente original como fallback até validação completa

**Por que é média**:  
Requer adaptações no código, mudanças na arquitetura da aplicação e testes extensivos para garantir compatibilidade e performance.

## Recomendações de Implementação Difícil

### 7. Avaliação da Necessidade de Alta Disponibilidade no Cloud SQL

**Facilidade**: Difícil  
**Impacto**: Muito Alto  
**Risco**: Alto  
**Economia estimada**: R$ 3.000-4.500/mês  
**Projetos afetados**: rapidpro-217518, coltrane

**Descrição**:  
As configurações de Alta Disponibilidade (HA) nas instâncias Cloud SQL praticamente duplicam o custo. Uma reavaliação poderia identificar ambientes onde HA não é criticamente necessária.

**Etapas de implementação**:
1. Mapear todas as aplicações dependentes de cada banco
2. Classificar criticidade e requisitos de SLA
3. Analisar impacto de downtime para cada ambiente
4. Desenvolver arquitetura alternativa para casos não-críticos
5. Criar plano de recuperação de desastres sem HA
6. Implementar em fases, começando por ambientes não-produtivos
7. Extensa validação e testes de recuperação

**Por que é difícil**:  
Impacto potencial na disponibilidade de sistemas críticos, requer redesenho arquitetural, envolve múltiplas equipes e exige extenso planejamento e validação.

### 8. Consolidação e Otimização de BigQuery

**Facilidade**: Difícil  
**Impacto**: Alto  
**Risco**: Alto  
**Economia estimada**: R$ 350-500/mês  
**Projetos afetados**: operations-dashboards

**Descrição**:  
Otimizar o BigQuery através de particionamento, clustering, e possível implementação de slot commitments para reduzir custos de processamento e armazenamento.

**Etapas de implementação**:
1. Analisar detalhadamente padrões de consulta atuais
2. Identificar tabelas candidatas para particionamento/clustering
3. Analisar padrões históricos de consumo de slots
4. Redesenhar esquemas de dados para otimização
5. Implementar particionamento em tabelas existentes (requer migração de dados)
6. Criar ou atualizar processos ETL para suportar novo design
7. Avaliar slot commitments com base em padrões de uso
8. Monitorar e ajustar continuamente

**Por que é difícil**:  
Requer profundo conhecimento de BigQuery, pode exigir redesenho de pipelines de dados existentes, envolve migração de grandes volumes de dados, e mudanças nas consultas analíticas.

### 9. Consolidação de Projetos de Baixo Uso

**Facilidade**: Difícil  
**Impacto**: Baixo  
**Risco**: Alto  
**Economia estimada**: R$ 40-60/mês  
**Projetos afetados**: movva-datalake, movva-splitter

**Descrição**:  
Consolidar os projetos de baixo uso (movva-datalake, movva-splitter) em outros projetos existentes para reduzir a complexidade da infraestrutura e custos administrativos.

**Etapas de implementação**:
1. Mapear todos os recursos e dependências externas
2. Identificar projetos destino para migração
3. Desenvolver plano detalhado de migração por recurso
4. Atualizar referências e dependências em todos os sistemas
5. Migração por fases com períodos de operação paralela
6. Testes extensivos de integração
7. Atualização de documentação e monitoramento

**Por que é difícil**:  
Envolve múltiplas equipes, exige coordenação complexa, requer mudanças em múltiplos sistemas e pode afetar processos operacionais estabelecidos.

## Resumo de Potencial de Economia

| Categoria | Economia Mensal Estimada | % do Gasto Atual |
|-----------|--------------------------|------------------|
| Implementação Fácil | R$ 580-910 | 4,2-6,6% |
| Implementação Média | R$ 3.200-4.550 | 23,3-33,1% |
| Implementação Difícil | R$ 3.390-5.060 | 24,7-36,8% |
| **Total** | **R$ 7.170-10.520** | **52,1-76,5%** |

## Próximos Passos Recomendados

1. **Imediato (1-2 semanas)**
   - Implementar todas as recomendações de categoria "Fácil"
   - Iniciar análise para as recomendações de categoria "Média"
   - Estabelecer dashboard de monitoramento contínuo de custos

2. **Curto Prazo (1-2 meses)**
   - Implementar as recomendações de categoria "Média" após análise detalhada
   - Iniciar estudos para avaliar viabilidade das recomendações "Difíceis"
   - Revisar resultados das otimizações já implementadas

3. **Médio Prazo (2-4 meses)**
   - Planejar e iniciar implementação das recomendações "Difíceis" priorizadas
   - Desenvolver modelo de governança para controle de custos futuros
   - Estabelecer processo contínuo de revisão e otimização
