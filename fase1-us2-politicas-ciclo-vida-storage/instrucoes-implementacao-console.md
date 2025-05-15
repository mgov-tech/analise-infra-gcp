# Instruções para Implementação de Políticas de Ciclo de Vida via Console GCP

Data: 14/05/2025

## Visão Geral

Este documento contém instruções detalhadas para implementação das políticas de ciclo de vida nos buckets prioritários identificados no Cloud Storage. Como algumas funcionalidades e configurações não estão disponíveis via CLI, estas instruções são destinadas para implementação através do Console do GCP.

## Buckets Prioritários e Arquivos de Configuração

| Bucket | Arquivo de Configuração | Política |
|--------|--------------------------|----------|
| movva-datalake | config-movva-datalake.json | Produção (30/90 dias) |
| movva-datalake-us-notebooks | config-movva-datalake-us-notebooks.json | Desenvolvimento (15/45 dias) |
| movva-sandbox | config-movva-sandbox.json | Desenvolvimento (15/45 dias) |
| razoes-pra-ficar | config-razoes-pra-ficar.json | Produção (30/90 dias) |
| poc-razoes-pra-ficar | config-poc-razoes-pra-ficar.json | Desenvolvimento (15/45 dias) |

## Instruções para Implementação

### 1. Implementação da Política para o Bucket movva-datalake

1. Acesse o [Console do Google Cloud](https://console.cloud.google.com/)
2. Selecione o projeto **movva-datalake**
3. No menu de navegação, vá para **Cloud Storage > Buckets**
4. Clique no bucket **movva-datalake**
5. Vá para a aba **Lifecycle**
6. Clique em **+ Add rule**
7. Adicione a primeira regra:
   - Em **Action**, selecione **Set to Nearline Storage**
   - Em **Condition**, selecione **Age** e insira **30** dias
   - Em **Storage class**, selecione **Standard Storage**
   - Clique em **Continue**
8. Clique novamente em **+ Add rule**
9. Adicione a segunda regra:
   - Em **Action**, selecione **Set to Coldline Storage**
   - Em **Condition**, selecione **Age** e insira **90** dias
   - Em **Storage class**, selecione **Nearline Storage**
   - Clique em **Continue**
10. Clique em **Save**
11. Capture uma evidência (screenshot) da configuração

### 2. Implementação da Política para o Bucket movva-datalake-us-notebooks

1. Acesse o [Console do Google Cloud](https://console.cloud.google.com/)
2. Selecione o projeto **movva-datalake**
3. No menu de navegação, vá para **Cloud Storage > Buckets**
4. Clique no bucket **movva-datalake-us-notebooks**
5. Vá para a aba **Lifecycle**
6. Clique em **+ Add rule**
7. Adicione a primeira regra:
   - Em **Action**, selecione **Set to Nearline Storage**
   - Em **Condition**, selecione **Age** e insira **15** dias
   - Em **Storage class**, selecione **Standard Storage**
   - Clique em **Continue**
8. Clique novamente em **+ Add rule**
9. Adicione a segunda regra:
   - Em **Action**, selecione **Set to Coldline Storage**
   - Em **Condition**, selecione **Age** e insira **45** dias
   - Em **Storage class**, selecione **Nearline Storage**
   - Clique em **Continue**
10. Clique em **Save**
11. Capture uma evidência (screenshot) da configuração

### 3. Implementação da Política para o Bucket movva-sandbox

1. Identifique o projeto correto do bucket **movva-sandbox**
2. Acesse o [Console do Google Cloud](https://console.cloud.google.com/)
3. Selecione o projeto identificado
4. No menu de navegação, vá para **Cloud Storage > Buckets**
5. Clique no bucket **movva-sandbox**
6. Vá para a aba **Lifecycle**
7. Clique em **+ Add rule**
8. Adicione a primeira regra:
   - Em **Action**, selecione **Set to Nearline Storage**
   - Em **Condition**, selecione **Age** e insira **15** dias
   - Em **Storage class**, selecione **Standard Storage**
   - Clique em **Continue**
9. Clique novamente em **+ Add rule**
10. Adicione a segunda regra:
    - Em **Action**, selecione **Set to Coldline Storage**
    - Em **Condition**, selecione **Age** e insira **45** dias
    - Em **Storage class**, selecione **Nearline Storage**
    - Clique em **Continue**
11. Clique em **Save**
12. Capture uma evidência (screenshot) da configuração

### 4. Implementação da Política para o Bucket razoes-pra-ficar

1. Acesse o [Console do Google Cloud](https://console.cloud.google.com/)
2. Selecione o projeto **rapidpro-217518**
3. No menu de navegação, vá para **Cloud Storage > Buckets**
4. Clique no bucket **razoes-pra-ficar**
5. Vá para a aba **Lifecycle**
6. Clique em **+ Add rule**
7. Adicione a primeira regra:
   - Em **Action**, selecione **Set to Nearline Storage**
   - Em **Condition**, selecione **Age** e insira **30** dias
   - Em **Storage class**, selecione **Standard Storage**
   - Clique em **Continue**
8. Clique novamente em **+ Add rule**
9. Adicione a segunda regra:
   - Em **Action**, selecione **Set to Coldline Storage**
   - Em **Condition**, selecione **Age** e insira **90** dias
   - Em **Storage class**, selecione **Nearline Storage**
   - Clique em **Continue**
10. Clique em **Save**
11. Capture uma evidência (screenshot) da configuração

### 5. Implementação da Política para o Bucket poc-razoes-pra-ficar

1. Acesse o [Console do Google Cloud](https://console.cloud.google.com/)
2. Selecione o projeto **rapidpro-217518**
3. No menu de navegação, vá para **Cloud Storage > Buckets**
4. Clique no bucket **poc-razoes-pra-ficar**
5. Vá para a aba **Lifecycle**
6. Clique em **+ Add rule**
7. Adicione a primeira regra:
   - Em **Action**, selecione **Set to Nearline Storage**
   - Em **Condition**, selecione **Age** e insira **15** dias
   - Em **Storage class**, selecione **Standard Storage**
   - Clique em **Continue**
8. Clique novamente em **+ Add rule**
9. Adicione a segunda regra:
   - Em **Action**, selecione **Set to Coldline Storage**
   - Em **Condition**, selecione **Age** e insira **45** dias
   - Em **Storage class**, selecione **Nearline Storage**
   - Clique em **Continue**
10. Clique em **Save**
11. Capture uma evidência (screenshot) da configuração

## Configurando Notificações para Mudanças de Classe (Opcional)

1. Acesse o [Console do Google Cloud](https://console.cloud.google.com/)
2. Navegue até **Pub/Sub**
3. Crie um tópico chamado **storage-class-changes**
4. Crie uma assinatura para este tópico (pull ou push, dependendo da necessidade)
5. Navegue até **Cloud Storage > Buckets**
6. Para cada bucket com política implementada:
   1. Selecione o bucket
   2. Vá para a aba **Notifications**
   3. Clique em **Create notification**
   4. Selecione o tópico **storage-class-changes**
   5. Em **Event types**, selecione **Object metadata update**
   6. Clique em **Create**

## Configurando Alertas de Custo (Recomendado)

1. Acesse o [Console do Google Cloud](https://console.cloud.google.com/)
2. Navegue até **Billing**
3. Selecione a conta de faturamento apropriada
4. Clique em **Budgets & alerts**
5. Clique em **Create budget**
6. Configure o orçamento para monitorar gastos específicos de Cloud Storage
7. Defina alertas em níveis apropriados (ex: 50%, 90%, 100%)
8. Adicione destinatários para as notificações de alerta
9. Clique em **Save**

## Monitoramento Pós-Implementação

Após a implementação das políticas de ciclo de vida, é importante monitorar a transição dos objetos e o impacto nos custos:

1. Acesse o [Console do Google Cloud](https://console.cloud.google.com/)
2. Navegue até **Monitoring**
3. Configure um dashboard para monitorar:
   - Distribuição de classes de armazenamento nos buckets
   - Tendências de custo por bucket e classe
   - Operações de mudança de classe

Guarde todas as evidências (screenshots) das configurações implementadas no diretório de evidências do projeto para documentação e auditoria.
