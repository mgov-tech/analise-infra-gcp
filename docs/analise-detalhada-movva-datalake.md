# Análise Detalhada: Projeto movva-datalake

## Visão Geral do Projeto

O projeto movva-datalake é dedicado ao processamento e armazenamento central de dados, representando apenas 0,24% do gasto líquido total da MOVVA no mês de abril de 2025. Apesar do nome sugerir um data lake completo, os custos atuais são surpreendentemente baixos em comparação com a infraestrutura descrita no documento original.

**Período analisado:** 01/04/2025 a 30/04/2025

## Distribuição de Custos por Serviço

| Serviço | Custo (R$) | % do Projeto | Observações |
|---------|------------|--------------|-------------|
| Cloud Storage | 30,32 | 94,1% | Armazenamento em 8+ buckets |
| Compute Engine | 1,90 | 5,9% | Relacionado a VMs desligadas (custos residuais) |
| Outros serviços | 0,00 | 0,0% | Cloud Logging, Networking, Source Repository |

**Total bruto/líquido:** R$ 32,22
**Créditos aplicados:** R$ 0,00

## Análise Detalhada por Serviço

### 1. Cloud Storage (94,1% dos custos)

O Cloud Storage é praticamente o único componente de custo significativo deste projeto, concentrando quase a totalidade das despesas.

**Principais componentes de custo:**
- Armazenamento distribuído em 8+ buckets (5.070GB conforme documentação)
- Operações de leitura/escrita nos buckets
- Possíveis classes de armazenamento diversas

**Observações:**
- Custo extremamente baixo considerando o volume de dados documentado (5.070GB)
- Possibilidade de que a maioria dos dados esteja em classes de armazenamento econômicas
- Potencial para dados muito pouco acessados ou armazenados em classes como Archive

### 2. Compute Engine (5,9% dos custos)

Os custos de Compute Engine são mínimos e provavelmente relacionados a recursos residuais.

**Principais componentes de custo:**
- Discos persistentes de VMs desligadas
- Possíveis snapshots ou imagens
- Cobranças de recursos estáticos (IPs reservados, etc.)

**Observações:**
- Custo muito baixo, indicando ausência de VMs ativas
- Conforme o documento original, existem 10 VMs desligadas neste projeto
- Os custos provavelmente são de armazenamento persistente mantido mesmo com VMs desligadas

## Tendência de Custos

A análise da tendência de custos diários mostra um padrão extremamente estável, com valores diários constantes em torno de R$ 1,07/dia, indicando uma infraestrutura estática, sem uso ativo ou variações significativas. Isso é consistente com um ambiente onde os recursos computacionais estão desligados e apenas o armazenamento está sendo cobrado.

## Áreas de Otimização Potencial

1. **Cloud Storage**
   - Verificar se todos os buckets ainda são necessários
   - Implementar políticas de ciclo de vida para dados antigos
   - Consolidar buckets com propósitos semelhantes
   - Avaliar a necessidade de manter 5.070GB de dados

2. **Compute Engine**
   - Excluir discos persistentes órfãos se não houver previsão de reativação das VMs
   - Limpar snapshots e imagens antigas
   - Liberar recursos estáticos como IPs reservados

3. **Avaliação Estratégica**
   - Reavaliar o propósito deste projeto, dado o baixo uso atual
   - Considerar migração dos dados para outro projeto se o datalake não estiver em uso ativo
   - Documentar claramente o conteúdo dos buckets para decisões futuras

## Observações Adicionais

Existe uma discrepância significativa entre a descrição do projeto no documento de infraestrutura consolidada (que menciona um datalake substancial com múltiplos datasets no BigQuery totalizando 5,1TB) e os custos reais observados no período analisado. Isso pode indicar:

1. Uma redução drástica no uso deste projeto no período recente
2. Possível migração de recursos para outros projetos
3. Dados que podem estar armazenados em um formato altamente otimizado em termos de custo

Recomenda-se uma investigação mais aprofundada para entender a real situação deste projeto e seu papel na arquitetura atual da MOVVA.
