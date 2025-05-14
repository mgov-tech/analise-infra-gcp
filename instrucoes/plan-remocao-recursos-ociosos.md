# Plano de Execução - US-01: Remoção de recursos ociosos no projeto movva-datalake

## Contexto

- O projeto movva-datalake possui 10 VMs desligadas (TERMINATED)
- Existem recursos associados a essas VMs ainda gerando custos
- A economia estimada é de R$ 250-350/mês após a implementação
- Facilidade: Fácil | Impacto: Médio | Risco: Baixo

## Etapas de Execução

### 1. Preparação e Documentação Inicial

- [ ] Criar planilha de inventário para documentação dos recursos a serem removidos
- [ ] Configurar projeto GCP no CLI local (CLI já está logada, apenas configurar projeto caso necessário)
- [ ] Criar pasta de evidências com data e hora atual

### 2. Identificação e Documentação de Discos Persistentes Não Utilizados

- [ ] Listar todas as VMs desligadas no projeto movva-datalake
- [ ] Listar todos os discos persistentes no projeto
- [ ] Identificar discos sem VMs associadas ou com VMs em estado TERMINATED
- [ ] Documentar metadados dos discos (ID, nome, tamanho, zona, última utilização)
- [ ] Capturar evidências (screenshots) dos discos identificados via Console GCP
- [ ] Gerar relatório CSV de discos a serem removidos

### 3. Backup de Segurança dos Discos Persistentes

- [ ] Criar snapshots de todos os discos persistentes identificados
- [ ] Verificar integridade dos snapshots criados
- [ ] Documentar IDs e nomes dos snapshots de backup
- [ ] Exportar metadados dos snapshots para arquivo de evidência
- [ ] Verificar permissões de acesso aos snapshots de backup

### 4. Remoção dos Discos Persistentes

- [ ] INSTRUIR_ARQUITETO: Solicitar aprovação formal para remoção dos discos
- [ ] Criar script de remoção com validação para evitar erros
- [ ] Executar remoção dos discos de forma controlada
- [ ] Documentar output do comando de remoção (logs)
- [ ] Verificar status após remoção

### 5. Identificação e Documentação de Snapshots Antigos

- [ ] Listar todos os snapshots existentes no projeto
- [ ] Identificar snapshots com mais de 90 dias
- [ ] Gerar relatório com metadados dos snapshots antigos (ID, data criação, disco origem, tamanho)
- [ ] Capturar evidências via Console GCP
- [ ] Classificar snapshots por idade e criticidade

### 6. Validação de Necessidade dos Snapshots

- [ ] INSTRUIR_ARQUITETO: Consultar com equipe se há snapshots críticos a preservar
- [ ] Documentar decisões sobre snapshots a preservar (com justificativa)
- [ ] Criar lista final de snapshots a serem removidos

### 7. Remoção dos Snapshots Obsoletos

- [ ] Criar script para remoção dos snapshots selecionados
- [ ] Executar remoção em lotes pequenos para melhor controle
- [ ] Documentar saída do comando de remoção (logs)
- [ ] Verificar status após remoção

### 8. Identificação e Liberação de IPs Estáticos Não Utilizados

- [ ] Listar todos os IPs estáticos no projeto
- [ ] Identificar IPs não associados a recursos ativos
- [ ] Documentar IPs a serem liberados (endereço, nome, região)
- [ ] Capturar evidências via Console GCP
- [ ] Liberar IPs estáticos não utilizados
- [ ] Verificar status após liberação

### 9. Verificação de Versões de App Engine sem Tráfego

- [ ] Listar todas as versões de App Engine no projeto
- [ ] Identificar versões sem tráfego nos últimos 30 dias
- [ ] Documentar versões a serem removidas (ID, serviço, última utilização)
- [ ] Capturar evidências via Console GCP
- [ ] Remover versões de App Engine sem tráfego
- [ ] Verificar status após remoção

### 10. Verificação e Validação Final

- [ ] Gerar relatório consolidado de todos os recursos removidos
- [ ] Calcular economia estimada com base nos recursos removidos
- [ ] Verificar se algum serviço foi impactado após as remoções
- [ ] Documentar estado final do projeto
- [ ] Criar relatório de economia mensal projetada

### 11. Documentação para Auditoria

- [ ] Consolidar todas as evidências em pasta estruturada
- [ ] Gerar relatório final de implementação
- [ ] INSTRUIR_ARQUITETO: Obter aprovação formal do relatório final
- [ ] Arquivar documentação em local seguro e acessível

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
