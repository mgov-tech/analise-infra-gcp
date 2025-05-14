# Análise Detalhada: Projeto movva-splitter

## Visão Geral do Projeto

O projeto movva-splitter é focado em processamento distribuído usando App Engine, representando apenas 0,09% do gasto líquido total da MOVVA no mês de abril de 2025. Este é o menor projeto em termos de custos.

**Período analisado:** 01/04/2025 a 30/04/2025

## Distribuição de Custos por Serviço

| Serviço | Custo (R$) | % do Projeto | Observações |
|---------|------------|--------------|-------------|
| Compute Engine | 11,10 | 92,4% | Relacionado a recursos residuais |
| Cloud Storage | 0,91 | 7,6% | Armazenamento em 4 buckets (38GB) |
| Cloud Logging | 0,00 | 0,0% | Logs do sistema |

**Total bruto/líquido:** R$ 12,01
**Créditos aplicados:** R$ 0,00

## Análise Detalhada por Serviço

### 1. Compute Engine (92,4% dos custos)

Mesmo sendo o principal componente de custo, o valor absoluto é muito baixo, indicando recursos limitados ou inativos.

**Principais componentes de custo:**
- Recursos relacionados a uma VM e2-small desligada
- Discos persistentes mantidos
- Possíveis recursos estáticos (IPs, snapshots)

**Observações:**
- Custos muito baixos, consistentes com recursos inativos
- Conforme documento original, existe 1 VM desligada neste projeto
- Ausência de custos significativos do App Engine, apesar de ser mencionado como propósito principal

### 2. Cloud Storage (7,6% dos custos)

O Cloud Storage representa uma pequena fração dos custos, coerente com o volume modesto de dados (38GB).

**Principais componentes de custo:**
- Armazenamento distribuído em 4 buckets
- Operações de acesso aos dados

**Observações:**
- Custo proporcional ao volume de dados relativamente pequeno
- Baixo nível de operações, indicando pouco acesso aos dados

## Tendência de Custos

A análise da tendência de custos diários mostra um padrão estável ao longo do mês, com valores diários constantes em torno de R$ 0,40/dia, indicando uma infraestrutura estática sem atividade significativa. Há um pequeno custo inicial no começo do mês ligeiramente menor, que depois se estabiliza.

## Áreas de Otimização Potencial

1. **Compute Engine**
   - Excluir recursos órfãos se não houver previsão de uso futuro
   - Remover discos persistentes não utilizados
   - Liberar recursos estáticos (IPs, snapshots) desnecessários

2. **Cloud Storage**
   - Verificar a necessidade de manter múltiplos buckets para um volume pequeno de dados
   - Implementar políticas de ciclo de vida para dados antigos
   - Considerar consolidação de buckets

3. **Avaliação Estratégica**
   - Reavaliar a relevância deste projeto na arquitetura atual
   - Considerar a possibilidade de incorporar estes recursos em outros projetos
   - Documentar claramente o propósito e conteúdo para decisões futuras

## Observações Adicionais

Existe uma discrepância entre a descrição do projeto no documento de infraestrutura consolidada (que menciona App Engine Standard como principal serviço) e os custos reais observados, que são quase exclusivamente de Compute Engine. Isso pode indicar:

1. Uma mudança recente na arquitetura ou uso do projeto
2. Possível migração de funcionalidades para outros projetos
3. Recursos de App Engine que estão completamente inativos ou já foram removidos

Dada a natureza mínima dos custos deste projeto, a principal recomendação seria avaliar sua relevância estratégica no contexto atual e considerar a possibilidade de consolidação com outros projetos ou encerramento completo se não estiver em uso ativo.
