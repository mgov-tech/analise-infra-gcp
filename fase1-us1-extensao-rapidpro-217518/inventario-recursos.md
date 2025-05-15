# Inventário de Recursos para Remoção - Projeto rapidpro-217518

Data de início: 14/05/2025
Responsável: Arquiteto Cloud

## 1. VMs Desligadas (TERMINATED)

**Observação:** Não foram encontradas VMs em estado TERMINATED no projeto rapidpro-217518. A verificação foi realizada em 14/05/2025.

| Nome da VM | Zona | Estado | Discos Associados | IPs Estáticos | Última Utilização | Observações |
|------------|------|--------|-------------------|---------------|-------------------|-------------|
| N/A | N/A | N/A | N/A | N/A | N/A | Não foram encontradas VMs desligadas |
| | | | | | | |

## 2. Discos Persistentes

**Observação:** Foram encontrados 18 discos persistentes no projeto rapidpro-217518. A maioria deles parece estar associada a clusters Kubernetes (prefixo 'gke-'). Todos os discos estão com status READY, o que sugere que estão em uso. Não identificamos discos órfãos ou não utilizados para remoção. A verificação foi realizada em 14/05/2025.

| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Última Utilização | Status | Snapshot Criado | Data Remoção |
|---------------|------|--------------|--------------|-------------------|--------|----------------|--------------|
| N/A | N/A | N/A | N/A | N/A | N/A | N/A | N/A |
| | | | | | | | |

## 3. Snapshots Antigos

**Observação:** Foi encontrado 1 snapshot muito antigo no projeto rapidpro-217518, com mais de 6 anos de idade. Este snapshot é candidato à remoção após avaliação do arquiteto.

| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Data de Criação | Idade (dias) | Status | Data Remoção |
|------------------|--------------|-----------------|-----------------|--------------|--------|--------------|  
| snapshot-1 | 30 | rapidpro | 2019-01-10 | 2317 | A remover | |
| | | | | | | |

## 4. IPs Estáticos

**Observação:** Foram encontrados 6 IPs estáticos no projeto rapidpro-217518. Todos parecem estar em uso ou reservados para serviços específicos (balanceadores de carga, NAT, etc.). Não identificamos IPs estáticos ociosos para liberação. A verificação foi realizada em 14/05/2025.

| Nome do IP | Endereço | Região | Recurso Associado | Status | Data Remoção |
|------------|----------|--------|-------------------|--------|--------------|  
| N/A | N/A | N/A | N/A | N/A | N/A |
| | | | | | |

## 5. Versões de App Engine

**Observação:** Não foram encontradas versões de App Engine no projeto rapidpro-217518. Isso pode indicar que o App Engine não está configurado neste projeto ou que não há versões implantadas atualmente. A verificação foi realizada em 14/05/2025.

| Serviço | Versão | Data de Deploy | Última Utilização | Status | Data Remoção |
|---------|--------|----------------|-------------------|--------|--------------|  
| N/A | N/A | N/A | N/A | N/A | N/A |
| | | | | | |

## Resumo de Economia

| Tipo de Recurso | Quantidade Identificada | Status | Economia Mensal Estimada (R$) |
|-----------------|--------------------------|--------|-------------------------------|
| VMs Desligadas | 0 | N/A | R$ 0,00 |
| Discos Persistentes | 18 | Em uso | R$ 0,00 |
| Snapshots | 1 | A remover | ~R$ 30,00 |
| IPs Estáticos | 6 | Em uso | R$ 0,00 |
| Versões App Engine | 0 | N/A | R$ 0,00 |
| **Total** | | | **~R$ 30,00** |
