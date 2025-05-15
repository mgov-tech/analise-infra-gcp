# Consulta sobre Remoção de Recursos - Projeto operations-dashboards

## Data: 14/05/2025

## Contexto
Durante análise do projeto operations-dashboards, foram identificados vários recursos ociosos que podem ser removidos para otimização de custos. O conjunto desses recursos está gerando um gasto mensal estimado de R$ 200,00 sem aparente benefício para o ambiente.

## Recursos Identificados

### 1. VM Desligada
| Nome da VM | Zona | Estado | Discos Associados | IPs Estáticos |
|------------|------|--------|-------------------|---------------|
| dashboards-vm-test | us-central1-a | TERMINATED | 2 discos | 1 IP estático |

### 2. Discos Persistentes
| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Status |
|---------------|------|--------------|--------------|--------|
| dashboards-vm-test | us-central1-a | 10 | dashboards-vm-test | READY |
| dashboards-vm-test-backup | us-central1-a | 10 | N/A | READY |

### 3. Snapshots
| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Status |
|------------------|--------------|-----------------|--------|
| dashboards-vm-test-backup1 | 10 | dashboards-vm-test | READY |
| dashboards-vm-test-backup2 | 10 | dashboards-vm-test | READY |

### 4. IP Estático
| Nome do IP | Endereço | Região | Recurso Associado | Status |
|------------|----------|--------|-------------------|--------|
| dashboards-vm-test | 34.71.179.233 | us-central1 | dashboards-vm-test (TERMINATED) | RESERVED |

### 5. Versões de App Engine
| Serviço | Versão | Data de Deploy | Status | Tráfego |
|---------|--------|----------------|--------|---------|
| dashboards | 20230827t140516 | 2023-08-27 | STOPPED | 0.00 |
| dashboards | 20231012t123045 | 2023-10-12 | STOPPED | 0.00 |
| dashboards | 20240305t091230 | 2024-03-05 | STOPPED | 0.00 |
| reports | 20231105t082510 | 2023-11-05 | STOPPED | 0.00 |
| reports | 20240216t110845 | 2024-02-16 | STOPPED | 0.00 |

## Perguntas para Avaliação

1. A VM "dashboards-vm-test" em estado TERMINATED pode ser completamente removida junto com seus recursos associados?
2. Os snapshots "dashboards-vm-test-backup1" e "dashboards-vm-test-backup2" são necessários para backup ou histórico?
3. O IP estático "dashboards-vm-test" precisa ser mantido para uso futuro?
4. As versões antigas de App Engine sem tráfego podem ser removidas?
5. Existe algum motivo para manter qualquer um desses recursos inativos?

## Recomendação Técnica

Considerando que todos os recursos identificados possuem o sufixo "-test" em seus nomes ou são versões antigas de App Engine sem tráfego, recomendamos:

1. **Remover completamente** a VM em estado TERMINATED e seus recursos associados (discos, snapshots e IP)
2. **Limpar** todas as versões de App Engine sem tráfego que foram implantadas antes de 2025

Essa ação resultaria em uma economia mensal estimada de R$ 200,00 sem impacto aparente nos serviços em execução.

## Plano de Ação Proposto

1. Fazer backup de metadados de todos os recursos antes da remoção
2. Remover snapshots "dashboards-vm-test-backup1" e "dashboards-vm-test-backup2"
3. Excluir a VM "dashboards-vm-test" (já em estado TERMINATED)
4. Remover os discos persistentes "dashboards-vm-test" e "dashboards-vm-test-backup"
5. Liberar o IP estático "dashboards-vm-test"
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
