# Inventário de Recursos - Projeto operations-dashboards

## Data da Análise: 14/05/2025

## 1. VMs Desligadas (TERMINATED)

**Observação:** Foi encontrada 1 VM em estado TERMINATED no projeto operations-dashboards. A verificação foi realizada em 14/05/2025.

| Nome da VM | Zona | Estado | Discos Associados | IPs Estáticos | Última Utilização | Observações |
|------------|------|--------|-------------------|---------------|-------------------|-------------|
| dashboards-vm-test | us-central1-a | TERMINATED | dashboards-vm-test, dashboards-vm-test-backup | 34.71.179.233 | N/A | VM de teste desativada |

## 2. Discos Persistentes

**Observação:** Foram encontrados 2 discos persistentes no projeto operations-dashboards. Ambos estão associados à VM em estado TERMINATED. A verificação foi realizada em 14/05/2025.

| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Última Utilização | Status | Snapshot Criado | Data Remoção |
|---------------|------|--------------|--------------|-------------------|--------|----------------|--------------|  
| dashboards-vm-test | us-central1-a | 10 | dashboards-vm-test | N/A | READY | Sim | N/A |
| dashboards-vm-test-backup | us-central1-a | 10 | N/A | N/A | READY | Não | N/A |
| | | | | | | | |

## 3. Snapshots Antigos

**Observação:** Foram encontrados 2 snapshots no projeto operations-dashboards. Ambos são do mesmo disco associado à VM em estado TERMINATED. A verificação foi realizada em 14/05/2025.

| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Data de Criação | Idade (dias) | Status | Data Remoção |
|------------------|--------------|-----------------|-----------------|--------------|--------|--------------|  
| dashboards-vm-test-backup1 | 10 | dashboards-vm-test | N/A | N/A | READY | N/A |
| dashboards-vm-test-backup2 | 10 | dashboards-vm-test | N/A | N/A | READY | N/A |
| | | | | | | |

## 4. IPs Estáticos

**Observação:** Foi encontrado 1 IP estático no projeto operations-dashboards. Este IP está associado à VM em estado TERMINATED. A verificação foi realizada em 14/05/2025.

| Nome do IP | Endereço | Região | Recurso Associado | Status | Data Remoção |
|------------|----------|--------|-------------------|--------|--------------|  
| dashboards-vm-test | 34.71.179.233 | us-central1 | dashboards-vm-test (TERMINATED) | RESERVED | N/A |
| | | | | | |

## 5. Versões de App Engine

**Observação:** Foram encontradas 7 versões de App Engine no projeto operations-dashboards, sendo 5 versões antigas sem tráfego (STOPPED) e 2 versões atuais com tráfego (SERVING). A verificação foi realizada em 14/05/2025.

| Serviço | Versão | Data de Deploy | Status | Tráfego | Observação |
|---------|--------|----------------|--------|---------|-------------|
| dashboards | 20230827t140516 | 2023-08-27 | STOPPED | 0.00 | Versão antiga sem tráfego |
| dashboards | 20231012t123045 | 2023-10-12 | STOPPED | 0.00 | Versão antiga sem tráfego |
| dashboards | 20240305t091230 | 2024-03-05 | STOPPED | 0.00 | Versão antiga sem tráfego |
| dashboards | 20250128t151233 | 2025-01-28 | SERVING | 1.00 | Versão atual com tráfego |
| reports | 20231105t082510 | 2023-11-05 | STOPPED | 0.00 | Versão antiga sem tráfego |
| reports | 20240216t110845 | 2024-02-16 | STOPPED | 0.00 | Versão antiga sem tráfego |
| reports | 20250203t143022 | 2025-02-03 | SERVING | 1.00 | Versão atual com tráfego |
| | | | | | |

## Resumo de Economia

| Recurso | Quantidade | Economia Mensal Estimada (R$) | Observações |
|---------|------------|-------------------------------|-------------|
| VM Desligada (TERMINATED) | 1 | R$ 50,00 | VM de teste em estado TERMINATED há tempo indeterminado. |
| Discos Persistentes | 2 | R$ 30,00 | Discos associados à VM em estado TERMINATED. |
| Snapshots | 2 | R$ 15,00 | Snapshots associados ao disco da VM em estado TERMINATED. |
| IP Estático | 1 | R$ 30,00 | IP associado à VM em estado TERMINATED. |
| Versões App Engine | 5 | R$ 75,00 | Versões antigas sem tráfego. |
| **Total** | | **R$ 200,00** | |
