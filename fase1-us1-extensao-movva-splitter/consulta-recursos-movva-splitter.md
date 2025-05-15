# Consulta sobre Remoção de Recursos - Projeto movva-splitter

## Data: 14/05/2025

## Contexto
Durante análise do projeto movva-splitter, foram identificados diversos recursos ociosos associados à versão anterior da aplicação (v1). Todos esses recursos parecem estar relacionados à migração para a nova versão (v2), que já está em operação. A remoção dos recursos ociosos pode gerar uma economia mensal estimada de R$ 305,00.

## Recursos Identificados

### 1. VMs Desligadas
| Nome da VM | Zona | Estado | Discos Associados | IPs Estáticos |
|------------|------|--------|-------------------|---------------|
| splitter-prod-v1 | us-central1-a | TERMINATED | 2 discos | 34.72.45.89 |
| splitter-stage-v1 | us-central1-a | TERMINATED | 1 disco | 34.72.46.90 |

### 2. Discos Persistentes
| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Status |
|---------------|------|--------------|--------------|--------|
| splitter-prod-v1 | us-central1-a | 30 | splitter-prod-v1 (TERMINATED) | READY |
| splitter-prod-v1-data | us-central1-a | 100 | splitter-prod-v1 (TERMINATED) | READY |
| splitter-stage-v1 | us-central1-a | 30 | splitter-stage-v1 (TERMINATED) | READY |

### 3. Snapshots
| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Data de Criação |
|------------------|--------------|-----------------|-----------------|
| splitter-prod-v1-backup-2023 | 30 | splitter-prod-v1 | 2023 |
| splitter-prod-v1-data-backup | 100 | splitter-prod-v1-data | 2023 |
| splitter-migration-20230715 | 130 | splitter-prod-v1-data | 2023-07-15 |

### 4. IPs Estáticos
| Nome do IP | Endereço | Região | Recurso Associado | Status |
|------------|----------|--------|-------------------|--------|
| splitter-prod-v1 | 34.72.45.89 | us-central1 | splitter-prod-v1 (TERMINATED) | RESERVED |
| splitter-stage-v1 | 34.72.46.90 | us-central1 | splitter-stage-v1 (TERMINATED) | RESERVED |

### 5. Versões de App Engine
| Serviço | Versão | Data de Deploy | Status | Tráfego |
|---------|--------|----------------|--------|---------|
| splitter-api | 20230510t132045 | 2023-05-10 | STOPPED | 0.00 |
| splitter-api | 20230715t091230 | 2023-07-15 | STOPPED | 0.00 |
| splitter-api | 20240305t114523 | 2024-03-05 | STOPPED | 0.00 |
| splitter-frontend | 20230520t082510 | 2023-05-20 | STOPPED | 0.00 |
| splitter-frontend | 20240125t110845 | 2024-01-25 | STOPPED | 0.00 |

## Perguntas para Avaliação

1. As VMs "splitter-prod-v1" e "splitter-stage-v1" em estado TERMINATED podem ser completamente removidas junto com seus recursos associados?
2. Os snapshots "splitter-prod-v1-backup-2023", "splitter-prod-v1-data-backup" e "splitter-migration-20230715" ainda são necessários para histórico ou possível rollback?
3. Os IPs estáticos "splitter-prod-v1" e "splitter-stage-v1" precisam ser mantidos para uso futuro ou podem ser liberados?
4. As versões antigas de App Engine sem tráfego podem ser removidas, visto que já existem versões mais recentes em produção?
5. Existe algum plano de retorno à versão v1 ou esses recursos são apenas remanescentes da migração para v2?

## Recomendação Técnica

Com base na análise realizada, recomendamos:

1. **Manter temporariamente apenas o snapshot mais recente** ("splitter-migration-20230715") para caso seja necessário recuperar dados históricos, e remover os outros dois mais antigos.
2. **Remover completamente** as VMs em estado TERMINATED, seus discos associados e liberar os IPs estáticos.
3. **Limpar** as versões de App Engine anteriores a 2025, mantendo apenas as versões atuais com tráfego.

Esta abordagem conservadora mantém um ponto de recuperação (o snapshot de migração) enquanto remove a maioria dos recursos ociosos, resultando em uma economia mensal significativa.

## Plano de Ação Proposto

1. Fazer backup de metadados de todos os recursos antes da remoção
2. Remover snapshots mais antigos (manter apenas o "splitter-migration-20230715")
3. Excluir as VMs "splitter-prod-v1" e "splitter-stage-v1" (já em estado TERMINATED)
4. Remover os discos persistentes associados às VMs TERMINATED
5. Liberar os IPs estáticos associados às VMs TERMINATED
6. Remover as versões antigas de App Engine sem tráfego

## Próximos Passos

1. Aguardar avaliação do arquiteto/responsável pelo projeto
2. Se aprovado, executar scripts de remoção
3. Documentar a economia gerada no relatório consolidado

## Contato para Aprovação

- Nome: [INSERIR NOME DO RESPONSÁVEL]
- Email: [INSERIR EMAIL DO RESPONSÁVEL]

---

**Nota:** Esta consulta faz parte do projeto de otimização de recursos do GCP - Fase 1 - US-01 (Remoção de Recursos Ociosos).
