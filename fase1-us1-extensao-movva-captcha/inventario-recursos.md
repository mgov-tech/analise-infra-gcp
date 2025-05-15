# Inventário de Recursos - Projeto movva-captcha

## Data da Análise: 14/05/2025

## 1. VMs Desligadas (TERMINATED)

**Observação:** Foi encontrada 1 VM em estado TERMINATED no projeto movva-captcha. A verificação foi realizada em 14/05/2025.

| Nome da VM | Zona | Estado | Discos Associados | IPs Estáticos | Última Utilização | Observações |
|------------|------|--------|-------------------|---------------|-------------------|-------------|
| captcha-dev | us-central1-a | TERMINATED | captcha-dev | 35.224.42.178 | N/A | Ambiente de desenvolvimento desativado |

## 2. Discos Persistentes

**Observação:** Foram encontrados 3 discos persistentes no projeto movva-captcha. 1 está associado à VM em estado TERMINATED e os outros 2 estão em uso pela VM de produção. A verificação foi realizada em 14/05/2025.

| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Última Utilização | Status | Snapshot Criado | Data Remoção |
|---------------|------|--------------|--------------|-------------------|--------|----------------|--------------|  
| captcha-dev | us-central1-a | 10 | captcha-dev (TERMINATED) | N/A | READY | Não | N/A |
| captcha-app-prod | us-central1-a | 20 | captcha-app-prod (RUNNING) | Ativo | READY | Sim | N/A |
| captcha-app-prod-data | us-central1-a | 100 | captcha-app-prod (RUNNING) | Ativo | READY | Sim | N/A |
| | | | | | | | |

## 3. Snapshots Antigos

**Observação:** Foram encontrados 2 snapshots no projeto movva-captcha. Ambos são de discos em uso, porém um deles é bastante antigo (2023). A verificação foi realizada em 14/05/2025.

| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Data de Criação | Idade (dias) | Status | Data Remoção |
|------------------|--------------|-----------------|-----------------|--------------|--------|--------------|  
| captcha-app-prod-20230510 | 20 | captcha-app-prod | 2023-05-10 | ~735 | READY | N/A |
| captcha-app-prod-data-backup | 100 | captcha-app-prod-data | N/A | N/A | READY | N/A |
| | | | | | | |

## 4. IPs Estáticos

**Observação:** Foram encontrados 3 IPs estáticos no projeto movva-captcha. 1 está associado à VM em estado TERMINATED e 2 estão em uso. A verificação foi realizada em 14/05/2025.

| Nome do IP | Endereço | Região | Recurso Associado | Status | Data Remoção |
|------------|----------|--------|-------------------|--------|--------------|  
| captcha-dev | 35.224.42.178 | us-central1 | captcha-dev (TERMINATED) | RESERVED | N/A |
| captcha-prod | 35.224.45.120 | us-central1 | captcha-app-prod | IN_USE | N/A |
| captcha-lb | 35.224.50.200 | us-central1 | captcha-lb-frontend | IN_USE | N/A |
| | | | | | |

## 5. Versões de App Engine

**Observação:** Foram encontradas 6 versões de App Engine no projeto movva-captcha, sendo 4 versões antigas sem tráfego (STOPPED) e 2 versões atuais com tráfego (SERVING). A verificação foi realizada em 14/05/2025.

| Serviço | Versão | Data de Deploy | Status | Tráfego | Observação |
|---------|--------|----------------|--------|---------|------------|
| captcha-api | 20230615t124532 | 2023-06-15 | STOPPED | 0.00 | Versão antiga sem tráfego |
| captcha-api | 20240220t105612 | 2024-02-20 | STOPPED | 0.00 | Versão antiga sem tráfego |
| captcha-api | 20250312t160045 | 2025-03-12 | SERVING | 1.00 | Versão atual com tráfego |
| captcha-frontend | 20230620t091423 | 2023-06-20 | STOPPED | 0.00 | Versão antiga sem tráfego |
| captcha-frontend | 20240225t143210 | 2024-02-25 | STOPPED | 0.00 | Versão antiga sem tráfego |
| captcha-frontend | 20250315t132245 | 2025-03-15 | SERVING | 1.00 | Versão atual com tráfego |
| | | | | | |

## Resumo de Economia

| Recurso | Quantidade | Economia Mensal Estimada (R$) | Observações |
|---------|------------|-------------------------------|-------------|
| VM Desligada (TERMINATED) | 1 | R$ 50,00 | VM de ambiente de desenvolvimento desativada |
| Disco Persistente | 1 | R$ 10,00 | Disco associado à VM em estado TERMINATED |
| Snapshot antigo | 1 | R$ 15,00 | Snapshot de 2023 sem uso aparente |
| IP Estático | 1 | R$ 30,00 | IP associado à VM em estado TERMINATED |
| Versões App Engine | 4 | R$ 60,00 | Versões antigas sem tráfego |
| **Total** | | **R$ 165,00** | |
