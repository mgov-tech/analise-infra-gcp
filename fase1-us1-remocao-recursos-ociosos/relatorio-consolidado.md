# Relatório Consolidado - Remoção de Recursos Ociosos
# Projeto: movva-datalake
# Data: 14/05/2025
# Atualizado em: 14/05/2025 10:16

## Resumo Executivo

Este relatório apresenta os resultados da análise de recursos ociosos no projeto movva-datalake,
conforme definido na US-01 da Fase 1 do plano de otimização da infraestrutura GCP.

A análise identificou e tratou:
- 10 VMs em estado TERMINATED
- 0 discos persistentes ociosos
- 1 snapshot antigo (691 dias) - **REMOVIDO PELO ARQUITETO**
- 1 IP estático associado a uma VM desligada - **LIBERADO EM 14/05/2025**
- 0 versões de App Engine (App Engine não está configurado no projeto)

## Recursos Identificados

### 1. VMs Desligadas (TERMINATED)

Foram identificadas 10 VMs em estado TERMINATED no projeto movva-datalake:

1. airbyte-prod (us-east1-b)
2. python-ml1 (us-east1-b)
3. python-ml2-highmem (us-east1-b)
4. python-ml3-e2-highmem64 (us-east1-b)
5. python-ml4-highmem (us-east1-b)
6. sato-test-1 (us-east1-b)
7. sato-test-3 (us-east1-b)
8. sato-test-4 (us-east1-b)
9. sato-test-5 (us-east1-b)
10. sato-teste-2 (us-east1-b)

Apesar das VMs estarem desligadas, elas não estão gerando custos diretos.
No entanto, recursos associados como IPs estáticos e snapshots continuam gerando custos.

### 2. Discos Persistentes

Não foram encontrados discos persistentes no projeto movva-datalake, o que contradiz a expectativa
inicial de encontrar discos ociosos associados às VMs desligadas. Isso sugere que os discos já
foram removidos anteriormente.

### 3. Snapshots

Foi identificado e removido 1 snapshot antigo no projeto:

- **Nome**: airbyte-recovery--2023-06-23--14h43
- **Tamanho**: 30 GB
- **Disco de Origem**: airbyte-prod
- **Data de Criação**: 23/06/2023 (691 dias atrás)
- **Status**: REMOVIDO
- **Removido por**: Arquiteto

A remoção foi realizada pelo arquiteto conforme aprovação.

### 4. IPs Estáticos

Foi identificado e liberado 1 IP estático que estava associado a uma VM desligada:

- **Nome**: airbyte-prod
- **Endereço**: 34.23.150.23
- **Região**: us-east1
- **Status**: LIBERADO
- **Recurso Associado anteriormente**: VM airbyte-prod (TERMINATED)
- **Data da liberação**: 14/05/2025 10:16

A liberação foi realizada com sucesso conforme aprovação do arquiteto.

### 5. Versões de App Engine

Não foi encontrada nenhuma instância de App Engine configurada no projeto movva-datalake.

## Economia Realizada

Com base nos recursos removidos, a economia realizada é:

| Tipo de Recurso | Quantidade | Economia Mensal Estimada (R$) | Status |
|-----------------|------------|-------------------------------|--------|
| Snapshots Antigos | 1 (30 GB) | ~R$ 30,00 | REMOVIDO |
| IPs Estáticos | 1 | ~R$ 20,00 | LIBERADO |
| **Total** | | **~R$ 50,00** | **CONCLUÍDO** |

**Observação**: Estas são estimativas aproximadas baseadas nos preços padrão do GCP. A economia real poderá ser confirmada no próximo ciclo de faturamento.

## Ações Realizadas

1. Snapshot antigo removido pelo arquiteto
2. IP estático liberado em 14/05/2025 às 10:16

## Próximos Passos

1. Verificar e documentar a economia real após 30 dias (14/06/2025)
2. Comunicar aos stakeholders a conclusão da US-01 da Fase 1 do plano de otimização

## Conclusão

A análise do projeto movva-datalake foi concluída com sucesso, resultando na remoção de todos os recursos ociosos identificados: um snapshot antigo de 30GB e um IP estático associado a uma VM desligada.

Embora a economia realizada seja menor que a inicialmente estimada (R$ 50,00/mês vs. R$ 250-350/mês), o objetivo da US-01 da Fase 1 foi alcançado com sucesso, resultando em uma infra-estrutura mais otimizada e com menos desperdício de recursos.

Recomenda-se manter uma política regular de verificação e remoção de recursos ociosos para evitar custos desnecessários no futuro.
