# Plano de Ação para Otimização da Infraestrutura GCP

## Introdução

Este documento apresenta um plano de ação estruturado em user stories para implementar as recomendações de otimização da infraestrutura GCP da MOVVA. Cada user story segue o formato BDD (Behavior-Driven Development), incluindo título, descrição, critérios de aceite e prioridade.

## Backlog Priorizado

### Fase 1: Otimizações Imediatas (Prioridade Alta)

#### US-01: Remoção de recursos ociosos no projeto movva-datalake

**Como** administrador de infraestrutura cloud,  
**Quero** remover discos persistentes e snapshots ociosos no projeto movva-datalake,  
**Para** eliminar custos desnecessários relacionados a recursos inutilizados.

**Cenário 1: Identificação e remoção de discos persistentes não utilizados**
**Dado que** existem discos persistentes órfãos no projeto movva-datalake,  
**Quando** eu identificar todos os discos persistentes sem VMs associadas,  
**Então** devo criar snapshots de segurança desses discos  
**E** remover os discos persistentes ociosos  
**E** verificar uma redução nos custos de armazenamento.

**Cenário 2: Limpeza de snapshots antigos**
**Dado que** existem snapshots antigos não utilizados no projeto,  
**Quando** eu listar todos os snapshots com mais de 90 dias,  
**Então** devo validar que nenhum é necessário para restauração  
**E** remover os snapshots obsoletos  
**E** documentar os snapshots removidos para referência futura.

**Critérios de Aceite:**

- Redução mensurável nos custos de armazenamento
- Nenhuma perda de dados críticos
- Documentação do processo e dos recursos removidos
- Validação da economia realizada após 7 dias
- Backup de todos os discos persistentes removidos

---

#### US-02: Implementação de políticas de ciclo de vida no Cloud Storage

**Como** arquiteto de nuvem,  
**Quero** implementar políticas de ciclo de vida nos buckets do Cloud Storage,  
**Para** otimizar custos movendo dados antigos para classes de armazenamento mais econômicas.

**Cenário 1: Análise de padrões de acesso nos buckets**
**Dado que** temos múltiplos buckets com diferentes padrões de acesso,  
**Quando** eu analisar os logs de acesso dos últimos 90 dias,  
**Então** devo identificar quais objetos são raramente acessados  
**E** documentar os padrões de acesso para cada bucket.

**Cenário 2: Implementação de políticas para dados raramente acessados**
**Dado que** foram identificados objetos raramente acessados,  
**Quando** eu configurar políticas de ciclo de vida para todos os buckets,  
**Então** objetos não acessados por 30 dias devem ser movidos para classe Nearline  
**E** objetos não acessados por 90 dias devem ser movidos para classe Coldline  
**E** devo visualizar a transição dos objetos nas próximas semanas.

**Critérios de Aceite:**

- Políticas implementadas em todos os buckets dos projetos
- Validação de que os objetos estão migrando corretamente entre classes
- Redução mensurável nos custos de armazenamento após 30 dias
- Sem impacto na disponibilidade dos dados para aplicações

---

#### US-03: Otimização de políticas de backup do Cloud SQL

**Como** DBA da plataforma cloud,  
**Quero** revisar e otimizar as políticas de backup do Cloud SQL,  
**Para** reduzir custos de armazenamento mantendo conformidade com requisitos de recuperação.

**Cenário 1: Análise dos requisitos de retenção de backup**
**Dado que** existem políticas atuais de backup para instâncias PostgreSQL,  
**Quando** eu verificar os requisitos de negócio para recuperação de dados,  
**Então** devo documentar os períodos de retenção necessários por ambiente  
**E** identificar oportunidades de redução no período de retenção.

**Cenário 2: Implementação de políticas otimizadas**
**Dado que** determinei os períodos de retenção ideais,  
**Quando** eu atualizar as configurações de backup do Cloud SQL,  
**Então** devo ajustar a retenção para 7 dias em ambientes de desenvolvimento  
**E** 14 dias em ambientes de homologação  
**E** manter 30 dias em produção  
**E** documentar as alterações realizadas.

**Critérios de Aceite:**

- Políticas de backup atualizadas para todas as instâncias Cloud SQL
- Validação de que os backups antigos são automaticamente excluídos
- Confirmação de que é possível restaurar um backup dentro do período de retenção
- Redução mensurável nos custos de armazenamento de backup

---

### Fase 2: Otimizações Estruturais (Prioridade Média)

#### US-04: Redimensionamento de instâncias Cloud SQL do projeto rapidpro-217518

**Como** administrador de infraestrutura cloud,  
**Quero** redimensionar as instâncias de Cloud SQL no projeto rapidpro-217518,  
**Para** reduzir custos mantendo a performance adequada.

**Cenário 1: Coleta e análise de métricas de utilização**
**Dado que** tenho acesso às métricas das instâncias Cloud SQL,  
**Quando** eu extrair dados de utilização de CPU, memória e IOPS por 14 dias,  
**Então** devo identificar os padrões de pico e média de utilização  
**E** criar gráficos de tendência para análise  
**E** identificar o tamanho ideal para cada instância.

**Cenário 2: Implantação do redimensionamento**
**Dado que** determinei o tamanho ideal para cada instância,  
**Quando** eu programar uma janela de manutenção em horário de baixo uso,  
**Então** devo realizar o redimensionamento das instâncias  
**E** monitorar a performance por 48 horas após a mudança  
**E** confirmar que os aplicativos continuam funcionando normalmente.

**Cenário 3: Atualização da versão do PostgreSQL**
**Dado que** existem instâncias PostgreSQL em versões que exigem pagamento de suporte estendido,  
**Quando** eu identificar uma janela de manutenção adequada,  
**Então** devo planejar a atualização para a versão mais recente suportada do PostgreSQL  
**E** realizar testes de compatibilidade com as aplicações em ambiente de homologação  
**E** documentar e corrigir quaisquer incompatibilidades encontradas  
**E** executar a atualização seguindo as melhores práticas.

**Critérios de Aceite:**

- Nenhuma degradação perceptível de performance
- Redução mensurável nos custos mensais do Cloud SQL
- Documentação das configurações antes e depois
- Plano de rollback testado e pronto para ser executado se necessário
- Instâncias PostgreSQL atualizadas para versão que não requer pagamento de suporte estendido
- Testes de regressão bem-sucedidos após a atualização

---

#### US-05: Implementação de escalonamento automático no GKE

**Como** engenheiro de plataforma cloud,  
**Quero** implementar escalonamento automático no cluster GKE do projeto rapidpro-217518,  
**Para** otimizar custos e recursos conforme a demanda real.

**Cenário 1: Configuração de HPA (Horizontal Pod Autoscaler)**
**Dado que** tenho acesso ao cluster GKE,  
**Quando** eu analisar os workloads atuais e suas necessidades de recursos,  
**Então** devo configurar HPA para deployments apropriados  
**E** definir métricas de escalonamento baseadas em CPU e memória  
**E** testar o escalonamento com carga simulada.

**Cenário 2: Configuração de escalonamento automático de nós**
**Dado que** o HPA está funcionando corretamente,  
**Quando** eu configurar o escalonamento automático de nós no cluster,  
**Então** devo definir o número mínimo de nós para garantir disponibilidade  
**E** definir o número máximo de nós baseado em picos históricos  
**E** validar que novos nós são criados quando os pods não podem ser agendados  
**E** validar que nós são removidos quando estão subutilizados.

**Critérios de Aceite:**

- Cluster GKE escala automaticamente com a demanda
- Redução de pelo menos 20% nos custos do GKE em períodos de baixa utilização
- Nenhuma interrupção de serviço durante o escalonamento
- Documentação da configuração e parâmetros de escalonamento

---

#### US-06: Migração de App Engine Flexible para Standard

**Como** arquiteto de soluções cloud,  
**Quero** migrar serviços do App Engine Flexible para Standard no projeto coltrane,  
**Para** reduzir custos mantendo a disponibilidade dos serviços.

**Cenário 1: Análise de compatibilidade de serviços**
**Dado que** temos serviços rodando no App Engine Flexible,  
**Quando** eu analisar os requisitos técnicos de cada serviço,  
**Então** devo identificar quais são compatíveis com o ambiente Standard  
**E** criar uma matriz de compatibilidade e esforço de migração  
**E** priorizar as migrações por potencial de economia.

**Cenário 2: Migração e teste de um serviço piloto**
**Dado que** identifiquei serviços compatíveis com o ambiente Standard,  
**Quando** eu selecionar um serviço não-crítico como piloto,  
**Então** devo adaptar o código para o ambiente Standard  
**E** implantar em um ambiente paralelo para testes  
**E** validar funcionalidade e performance  
**E** migrar tráfego gradualmente (10%, 50%, 100%).

**Critérios de Aceite:**

- Serviço migrado funcionando corretamente no ambiente Standard
- Redução significativa no custo do serviço específico
- Documentação do processo de migração
- Estratégia definida para migração dos demais serviços

---

### Fase 3: Otimizações Avançadas (Prioridade Baixa)

#### US-07: Avaliação e revisão de Alta Disponibilidade no Cloud SQL

**Como** arquiteto de infraestrutura cloud,  
**Quero** reavaliar a necessidade de Alta Disponibilidade (HA) nas instâncias Cloud SQL,  
**Para** reduzir custos em ambientes onde HA não é crítica.

**Cenário 1: Mapeamento de dependências e criticidade**
**Dado que** temos instâncias com HA ativas nos projetos coltrane e rapidpro-217518,  
**Quando** eu mapear todos os sistemas e aplicações dependentes,  
**Então** devo classificar cada um por criticidade e requisitos de SLA  
**E** documentar o impacto potencial de downtime para cada sistema  
**E** identificar ambientes candidatos para remoção de HA.

**Cenário 2: Implementação de solução alternativa para ambientes não-críticos**
**Dado que** identifiquei ambientes onde HA pode ser removida,  
**Quando** eu desenvolver um plano alternativo de recuperação de desastres,  
**Então** devo implementar procedimentos de backup mais frequentes  
**E** desenvolver scripts automatizados de restauração  
**E** validar o tempo de recuperação no cenário sem HA  
**E** documentar o procedimento para a equipe operacional.

**Critérios de Aceite:**

- Documentação detalhada de análise de criticidade para cada ambiente
- Plano de recuperação de desastres validado para ambientes sem HA
- Testes de recuperação com tempos documentados
- Redução significativa nos custos do Cloud SQL
- Aprovação formal das partes interessadas para mudanças em ambientes críticos

---

#### US-08: Otimização do BigQuery com particionamento e clustering

**Como** engenheiro de dados,  
**Quero** implementar particionamento e clustering nas tabelas do BigQuery,  
**Para** otimizar o desempenho e reduzir custos de consulta.

**Cenário 1: Análise de consultas e padrões de uso**
**Dado que** temos dados históricos de consultas no BigQuery,  
**Quando** eu analisar os padrões de consulta e tabelas mais acessadas,  
**Então** devo identificar colunas candidatas para particionamento  
**E** identificar colunas candidatas para clustering  
**E** priorizar tabelas baseadas em tamanho e frequência de uso.

**Cenário 2: Implementação e validação de particionamento**
**Dado que** identifiquei tabelas e estratégias de particionamento,  
**Quando** eu implementar o particionamento em uma tabela de alto impacto,  
**Então** devo monitorar os custos de consulta antes e depois  
**E** validar que o tempo de resposta melhorou  
**E** verificar que o custo por consulta foi reduzido  
**E** documentar os ganhos de performance e economia.

**Critérios de Aceite:**

- Particionamento implementado nas 10 tabelas mais consultadas
- Redução mensurável no custo de consultas (mínimo 15%)
- Melhoria no tempo de resposta das consultas frequentes
- Documentação da estratégia de particionamento e clustering

---

#### US-09: Consolidação de projetos de baixo uso

**Como** gerente de infraestrutura cloud,  
**Quero** consolidar os projetos movva-datalake e movva-splitter,  
**Para** simplificar o gerenciamento e reduzir custos operacionais.

**Cenário 1: Inventário completo de recursos e dependências**
**Dado que** os projetos movva-datalake e movva-splitter têm uso baixo,  
**Quando** eu realizar um inventário completo de todos os recursos,  
**Então** devo mapear cada recurso e sua finalidade  
**E** identificar todas as dependências externas  
**E** consultar as equipes responsáveis sobre a relevância atual  
**E** definir um projeto destino para cada recurso necessário.

**Cenário 2: Migração planejada de recursos essenciais**
**Dado que** tenho um inventário e plano de migração,  
**Quando** eu iniciar a migração de recursos seguindo o plano,  
**Então** devo mover os recursos por tipo (Storage, Compute, etc.)  
**E** validar cada migração antes de prosseguir  
**E** atualizar referências em sistemas externos  
**E** manter ambos ambientes funcionando em paralelo durante a transição.

**Critérios de Aceite:**

- Documentação detalhada de todo o processo de migração
- Zero perda de dados durante a consolidação
- Atualização de todas as integrações e referências externas
- Encerramento bem-sucedido dos projetos originais após validação
- Redução no número total de projetos GCP

---

## Cronograma Estimado

### Fase 1: Otimizações Imediatas

- **Duração**: 2-3 semanas
- **User Stories**: US-01, US-02, US-03
- **Economia estimada**: R$ 580-910/mês

### Fase 2: Otimizações Estruturais

- **Duração**: 4-6 semanas
- **User Stories**: US-04, US-05, US-06
- **Economia estimada**: R$ 3.200-4.550/mês

### Fase 3: Otimizações Avançadas

- **Duração**: 8-12 semanas
- **User Stories**: US-07, US-08, US-09
- **Economia estimada**: R$ 3.390-5.060/mês

## Métricas de Sucesso

- **Redução de custos**: Meta de 50% de redução nos custos totais
- **Eficiência operacional**: Redução no número de alertas e incidentes
- **Performance**: Manutenção ou melhoria nos indicadores de performance
- **Governança**: Implementação de controles de custo contínuos
