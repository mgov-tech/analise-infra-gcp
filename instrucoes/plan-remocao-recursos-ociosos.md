# Plano de Execução - US-01: Remoção de recursos ociosos no projeto movva-datalake

## Contexto

- O projeto movva-datalake possui 10 VMs desligadas (TERMINATED)
- Existem recursos associados a essas VMs ainda gerando custos
- A economia estimada é de R$ 250-350/mês após a implementação
- Facilidade: Fácil | Impacto: Médio | Risco: Baixo

## Etapas de Execução

### 1. Preparação e Documentação Inicial

- [x] Criar planilha de inventário para documentação dos recursos a serem removidos
- [x] Configurar projeto GCP no CLI local (CLI já está logada, apenas configurar projeto caso necessário)
- [x] Criar pasta de evidências com data e hora atual

### 2. Identificação e Documentação de Discos Persistentes Não Utilizados

- [x] Listar todas as VMs desligadas no projeto movva-datalake
- [x] Listar todos os discos persistentes no projeto
- [x] Identificar discos sem VMs associadas ou com VMs em estado TERMINATED (nenhum disco encontrado)
- [x] Documentar metadados dos discos (ID, nome, tamanho, zona, última utilização) (nenhum disco encontrado)
- [x] Capturar evidências dos discos identificados (nenhum disco encontrado)
- [x] Gerar relatório de discos a serem removidos (nenhum disco encontrado)

### 3. Backup de Segurança dos Discos Persistentes

- [x] Criar snapshots de todos os discos persistentes identificados (não aplicável - nenhum disco encontrado)
- [x] Verificar integridade dos snapshots criados (não aplicável - nenhum disco encontrado)
- [x] Documentar IDs e nomes dos snapshots de backup (não aplicável - nenhum disco encontrado)
- [x] Exportar metadados dos snapshots para arquivo de evidência (não aplicável - nenhum disco encontrado)
- [x] Verificar permissões de acesso aos snapshots de backup (não aplicável - nenhum disco encontrado)

### 4. Remoção dos Discos Persistentes

- [x] INSTRUIR_ARQUITETO: Solicitar aprovação formal para remoção dos discos (não aplicável - nenhum disco encontrado)
- [x] Criar script de remoção com validação para evitar erros (não aplicável - nenhum disco encontrado)
- [x] Executar remoção dos discos de forma controlada (não aplicável - nenhum disco encontrado)
- [x] Documentar output do comando de remoção (logs) (não aplicável - nenhum disco encontrado)
- [x] Verificar status após remoção (não aplicável - nenhum disco encontrado)

### 5. Identificação e Documentação de Snapshots Antigos

- [x] Listar todos os snapshots existentes no projeto
- [x] Identificar snapshots com mais de 90 dias
- [x] Gerar relatório com metadados dos snapshots antigos (ID, data criação, disco origem, tamanho)
- [x] Capturar evidências dos snapshots identificados
- [x] Classificar snapshots por idade e criticidade

### 6. Validação de Necessidade dos Snapshots

- [x] INSTRUIR_ARQUITETO: Consultar com equipe se há snapshots críticos a preservar (documento de consulta criado)
- [x] Documentar decisões sobre snapshots a preservar (documento de consulta criado com todas as informações)
- [x] Criar lista final de snapshots a serem removidos (1 snapshot identificado: airbyte-recovery--2023-06-23--14h43)

### 7. Remoção dos Snapshots Obsoletos

- [x] Criar script para remoção dos snapshots selecionados
- [x] Executar remoção em lotes pequenos para melhor controle (snapshot removido pelo arquiteto)
- [x] Documentar saída do comando de remoção (logs) (concluído)
- [x] Verificar status após remoção (concluído)

### 8. Identificação e Liberação de IPs Estáticos Não Utilizados

- [x] Listar todos os IPs estáticos no projeto
- [x] Identificar IPs não associados a recursos ativos
- [x] Documentar IPs a serem liberados (endereço, nome, região)
- [x] Capturar evidências dos IPs identificados
- [x] Criar script para liberar IPs estáticos não utilizados
- [x] Executar liberação de IPs (executado em 14/05/2025 às 10:16)
- [x] Verificar status após liberação (concluído - IP liberado com sucesso)

### 9. Verificação de Versões de App Engine sem Tráfego

- [x] Listar todas as versões de App Engine no projeto
- [x] Verificar se o projeto possui instância de App Engine (não possui)
- [x] Documentar resultado da verificação (App Engine não encontrado no projeto)
- [x] Capturar evidências da verificação
- [x] Remover versões de App Engine sem tráfego (não aplicável - App Engine não encontrado)
- [x] Verificar status após remoção (não aplicável - nada a remover)

### 10. Verificação e Validação Final

- [x] Gerar relatório consolidado de todos os recursos identificados
- [x] Calcular economia estimada com base nos recursos identificados
- [x] Documentar estado atual do projeto
- [x] Criar relatório de economia mensal projetada
- [x] Verificar se algum serviço foi impactado após as remoções (concluído - nenhum serviço impactado)

### 11. Documentação para Auditoria

- [x] Consolidar todas as evidências em pasta estruturada
- [x] Gerar relatório final de implementação
- [x] Criar registro de auditoria detalhado
- [x] INSTRUIR_ARQUITETO: Obter aprovação formal do relatório final
- [x] Arquivar documentação em local seguro e acessível

## Comandos CLI para Execução

Para cada etapa que envolve CLI, vou detalhar os comandos a serem utilizados:

### Listagem de VMs desligadas

```bash
gcloud compute instances list --project=movva-datalake --filter="status=TERMINATED" --format="table(name,zone,status,disks[].source.basename(),networkInterfaces[].accessConfigs[].natIP)"
```

### Listagem de discos persistentes

```bash
gcloud compute disks list --project=movva-datalake --format="table(name,zone,sizeGb,users.basename(),lastAttachTimestamp)"
```

### Criação de snapshots de backup

```bash
# Para cada disco identificado:
gcloud compute disks snapshot NOME_DO_DISCO --project=movva-datalake --zone=ZONA_DO_DISCO --snapshot-names=backup-pre-remocao-NOME_DO_DISCO-$(date +%Y%m%d)
```

### Remoção de discos persistentes

```bash
# Para cada disco a ser removido:
gcloud compute disks delete NOME_DO_DISCO --project=movva-datalake --zone=ZONA_DO_DISCO --quiet
```

### Listagem de snapshots

```bash
gcloud compute snapshots list --project=movva-datalake --format="table(name,diskSizeGb,sourceDisk.basename(),creationTimestamp)"
```

### Remoção de snapshots

```bash
# Para cada snapshot a ser removido:
gcloud compute snapshots delete NOME_DO_SNAPSHOT --project=movva-datalake --quiet
```

### Listagem de IPs estáticos

```bash
gcloud compute addresses list --project=movva-datalake --format="table(name,address,region,status,users.basename())"
```

### Liberação de IPs estáticos

```bash
# Para cada IP a ser liberado:
gcloud compute addresses delete NOME_DO_IP --project=movva-datalake --region=REGIAO_DO_IP --quiet
```

### Listagem de versões de App Engine

```bash
gcloud app versions list --project=movva-datalake --format="table(service,version.id,traffic_split,last_deployed_time.date('%Y-%m-%d'),version.servingStatus)"
```

### Remoção de versões de App Engine

```bash
# Para cada versão a ser removida:
gcloud app versions delete VERSAO --service=SERVICO --project=movva-datalake --quiet
```

## Instruções para o Arquiteto

### INSTRUIR_ARQUITETO: Aprovação para Remoção de Discos

Para remover os discos persistentes, siga os passos abaixo no Console GCP:

1. Acesse https://console.cloud.google.com/compute/disks
2. Selecione o projeto "movva-datalake"
3. Verifique os discos marcados na planilha de inventário
4. Selecione cada disco e clique em "Criar snapshot" para backup
5. Após criar os snapshots, selecione os discos e clique em "Excluir"
6. Confirme a exclusão digitando "excluir" no campo de confirmação

### INSTRUIR_ARQUITETO: Validação de Snapshots Críticos

Para validar quais snapshots devem ser preservados:

1. Acesse https://console.cloud.google.com/compute/snapshots
2. Selecione o projeto "movva-datalake"
3. Analise os snapshots com mais de 90 dias
4. Consulte a equipe de desenvolvimento/dados sobre a necessidade de manter algum snapshot específico
5. Documente na planilha de inventário quais snapshots serão preservados e o motivo

## Comentários Finais

Este plano foi estruturado para garantir a remoção segura dos recursos ociosos, mantendo evidências de todo o processo. A documentação detalhada é fundamental para:

1. Comprovar a economia gerada
2. Permitir recuperação em caso de problemas
3. Servir como referência para futuras otimizações
