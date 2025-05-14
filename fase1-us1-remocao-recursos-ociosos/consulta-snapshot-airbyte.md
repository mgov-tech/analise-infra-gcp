# Consulta sobre Snapshot Antigo - airbyte-recovery

## Detalhes do Snapshot

- **Nome:** airbyte-recovery--2023-06-23--14h43
- **Tamanho:** 30 GB
- **Disco de Origem:** airbyte-prod
- **Data de Criação:** 23/06/2023 (691 dias atrás)
- **Projeto:** movva-datalake

## Solicitação de Avaliação

Este snapshot foi criado há mais de 690 dias e parece estar relacionado a um backup de recuperação da VM airbyte-prod. Como a VM airbyte-prod está atualmente desligada e não encontramos nenhum disco persistente associado a ela, precisamos avaliar se este snapshot ainda é necessário.

## Pontos a considerar:

1. A VM airbyte-prod está em estado TERMINATED sem discos associados
2. O snapshot tem quase 2 anos de idade
3. O nome "airbyte-recovery" sugere um snapshot de backup para alguma situação específica
4. Não há outros snapshots ou backups mais recentes do mesmo disco

## Ação Recomendada:

Favor indicar se este snapshot pode ser removido ou se precisa ser preservado, incluindo o motivo para preservação se aplicável.

**Decisão do Arquiteto:**
[X] Remover snapshot - Não é mais necessário
[ ] Preservar snapshot - Motivo:

**Data da Decisão:** **14/05/2025**  
**Nome do Responsável:** **Pablo Winter**
