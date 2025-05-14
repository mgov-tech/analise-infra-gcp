# Instâncias de Máquinas Virtuais (VMs)

Data da análise: 06/05/2025

## Projeto: movva-datalake

| Nome | Zona | Tipo de Máquina | IP Interno | IP Externo | Status |
|------|------|-----------------|------------|------------|--------|
| airbyte-prod | us-east1-b | custom (e2, 2 vCPU, 4.00 GiB) | 10.142.0.3 | 34.23.150.23 | TERMINATED |
| python-ml1 | us-east1-b | n1-standard-8 | 10.0.0.31 | - | TERMINATED |
| python-ml2-highmem | us-east1-b | n1-highmem-8 | 10.0.0.49 | - | TERMINATED |
| python-ml3-e2-highmem64 | us-east1-b | e2-highmem-8 | 10.0.0.76 | - | TERMINATED |
| python-ml4-highmem | us-east1-b | n1-highmem-16 | 10.0.0.82 | - | TERMINATED |
| sato-test-1 | us-east1-b | n1-standard-96 | 10.0.0.27 | - | TERMINATED |
| sato-test-3 | us-east1-b | n1-standard-96 | 10.0.0.92 | - | TERMINATED |
| sato-test-4 | us-east1-b | n1-standard-96 | 10.0.0.109 | - | TERMINATED |
| sato-test-5 | us-east1-b | n1-standard-96 | 10.0.0.110 | - | TERMINATED |
| sato-teste-2 | us-east1-b | n1-standard-96 | 10.0.0.91 | - | TERMINATED |

### Detalhes e Observações

- Todas as VMs estão atualmente desligadas (TERMINATED)
- Máquinas `python-ml*` parecem dedicadas a cargas de trabalho de machine learning
- Máquinas `sato-test*` são máquinas muito grandes (96 vCPUs) provavelmente usadas para testes
- A máquina `airbyte-prod` provavelmente está sendo usada para integração de dados com Airbyte

### Recomendações de Otimização

- **Exclusão de VMs desligadas**: Se estas VMs não estão sendo utilizadas, considerar excluí-las para evitar custos de armazenamento do disco permanente
- **Dimensionamento adequado**: Avaliar se as máquinas `n1-standard-96` são realmente necessárias para testes
- **Atualização de série**: Migrar de instâncias `n1` para `e2` para reduzir custos
- **Uso de preemptivas**: Para cargas de trabalho de ML que podem ser interrompidas, considerar o uso de VMs preemptivas

## Projeto: movva-splitter

| Nome | Zona | Tipo de Máquina | IP Interno | IP Externo | Status |
|------|------|-----------------|------------|------------|--------|
| splitter-2-2 | us-east1-c | e2-small | 10.142.0.22 | - | TERMINATED |

### Detalhes e Observações

- A VM está atualmente desligada (TERMINATED)
- Usa um tipo de máquina econômico (e2-small)
- Possivelmente usada para processamento distribuído ou para suportar a aplicação App Engine

### Recomendações de Otimização

- **Verificar necessidade**: Se não estiver em uso, considerar excluí-la para eliminar custos de armazenamento
- **Auto-scaling**: Se o serviço necessitar de disponibilidade, considerar implementar auto-scaling para ligar/desligar conforme demanda

## Projeto: movva-captcha-1698695351695

Não foram identificadas instâncias de VM neste projeto. A API Compute Engine não está habilitada.
