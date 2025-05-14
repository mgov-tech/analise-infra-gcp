# Registro de Auditoria - US-01: Remoção de Recursos Ociosos
# Projeto: movva-datalake
# Data: 14/05/2025

## Resumo da Execução

Este documento registra todas as etapas executadas como parte da US-01 da Fase 1 do plano de otimização da infraestrutura GCP MOVVA, especificamente relacionadas à remoção de recursos ociosos no projeto movva-datalake.

## Inventário dos Arquivos de Evidência

### Estrutura de Diretórios

- `/fase1-us1-remocao-recursos-ociosos/`
  - `evidencias-20250514-090409/` (contém todos os arquivos de evidência)
  - `inventario-recursos.md` (inventário detalhado de todos os recursos analisados)
  - `consulta-snapshot-airbyte.md` (documento para aprovação da remoção do snapshot)
  - `consulta-ip-airbyte.md` (documento para aprovação da liberação do IP estático)
  - `remover-snapshots.sh` (script para remoção do snapshot)
  - `liberar-ip-estatico.sh` (script para liberação do IP estático)
  - `relatorio-consolidado.md` (relatório final com resultados e economia estimada)
  - `registro-auditoria.md` (este arquivo)

### Arquivos de Evidência

1. `vms-desligadas.txt` - Lista completa das VMs em estado TERMINATED
2. `discos-persistentes.txt` - Verificação de discos persistentes (nenhum encontrado)
3. `snapshots-antigos.txt` - Lista de snapshots antigos identificados
4. `ips-estaticos.txt` - Lista de IPs estáticos associados a VMs desligadas
5. `app-engine-verificacao.txt` - Verificação de App Engine (não configurado no projeto)

## Cronologia da Execução

1. **Preparação (14/05/2025 - 09:03)**
   - Criação da estrutura de diretórios e arquivos de inventário
   - Configuração do ambiente e ferramentas

2. **Análise de VMs e Discos (14/05/2025 - 09:04)**
   - Identificação de 10 VMs em estado TERMINATED
   - Verificação de discos persistentes (nenhum encontrado)

3. **Análise de Snapshots (14/05/2025 - 09:06)**
   - Identificação de 1 snapshot antigo (691 dias)
   - Criação de documento de consulta para remoção

4. **Análise de IPs Estáticos (14/05/2025 - 09:08)**
   - Identificação de 1 IP estático associado a VM desligada
   - Criação de documento de consulta para liberação

5. **Verificação de App Engine (14/05/2025 - 09:10)**
   - Constatação de que o App Engine não está configurado no projeto

6. **Consolidação e Relatório (14/05/2025 - 09:44)**
   - Geração de relatório consolidado com todos os recursos identificados
   - Cálculo de economia potencial estimada: ~R$ 50,00/mês

## Status das Ações Pendentes

1. **Remoção de Snapshot**
   - Status: Aguardando aprovação do arquiteto
   - Script preparado e pronto para execução

2. **Liberação de IP Estático**
   - Status: Aguardando aprovação do arquiteto
   - Script preparado e pronto para execução

## Economia Potencial Estimada

Com base nos recursos identificados, a economia potencial estimada é:

| Tipo de Recurso | Quantidade | Economia Mensal Estimada (R$) |
|-----------------|------------|-------------------------------|
| Snapshots Antigos | 1 (30 GB) | ~R$ 30,00 |
| IPs Estáticos | 1 | ~R$ 20,00 |
| **Total** | | **~R$ 50,00** |

## Conclusão e Recomendações

A análise do projeto movva-datalake revelou:

1. O projeto contém 10 VMs em estado TERMINATED, mas sem discos persistentes associados, o que sugere que parte da limpeza já foi realizada anteriormente.

2. Foram identificados apenas 2 recursos ociosos gerando custos:
   - 1 snapshot antigo de 30 GB (691 dias)
   - 1 IP estático associado a uma VM desligada

3. A economia potencial estimada (~R$ 50,00/mês) é menor que a inicialmente prevista (R$ 250-350/mês) devido ao estado atual do projeto.

4. Recomendamos a continuidade do processo com a aprovação e execução dos scripts de remoção/liberação dos recursos identificados.

---

Todos os artefatos de evidência estão disponíveis para consulta nos diretórios mencionados acima.
