# Relatório Consolidado - Remoção de Recursos Ociosos

## Data: 14/05/2025

## Resumo Executivo

Este relatório apresenta os resultados da análise de recursos ociosos em 6 projetos GCP da MOVVA, com o objetivo de identificar oportunidades de otimização de custos. Foram encontrados diversos recursos que podem ser removidos ou otimizados, gerando uma economia mensal estimada de **R$ 930,00**.

## Projetos Analisados

1. **movva-datalake** (projeto piloto)
2. **rapidpro-217518**
3. **coltrane**
4. **operations-dashboards**
5. **movva-splitter**
6. **movva-captcha**

## Recursos Identificados para Otimização

| Projeto | Tipo de Recurso | Quantidade | Economia Mensal Estimada (R$) | Status |
|---------|----------------|------------|-------------------------------|--------|
| **movva-datalake** | Snapshot | 1 | R$ 20,00 | Removido ✅ |
| **movva-datalake** | IP Estático | 1 | R$ 30,00 | Liberado ✅ |
| **rapidpro-217518** | Snapshot | 1 | R$ 50,00 | Pendente de aprovação |
| **coltrane** | IPs Estáticos | 2 | R$ 60,00 | Pendente de aprovação |
| **coltrane** | Versões App Engine | 100+ | R$ 150,00 | Pendente de aprovação |
| **operations-dashboards** | VM Desligada | 1 | R$ 50,00 | Pendente de aprovação |
| **operations-dashboards** | Discos Persistentes | 2 | R$ 30,00 | Pendente de aprovação |
| **operations-dashboards** | Snapshots | 2 | R$ 15,00 | Pendente de aprovação |
| **operations-dashboards** | IP Estático | 1 | R$ 30,00 | Pendente de aprovação |
| **operations-dashboards** | Versões App Engine | 5 | R$ 75,00 | Pendente de aprovação |
| **movva-splitter** | VMs Desligadas | 2 | R$ 100,00 | Pendente de aprovação |
| **movva-splitter** | Discos Persistentes | 3 | R$ 40,00 | Pendente de aprovação |
| **movva-splitter** | Snapshots | 3 | R$ 30,00 | Pendente de aprovação |
| **movva-splitter** | IPs Estáticos | 2 | R$ 60,00 | Pendente de aprovação |
| **movva-splitter** | Versões App Engine | 5 | R$ 75,00 | Pendente de aprovação |
| **movva-captcha** | VM Desligada | 1 | R$ 50,00 | Pendente de aprovação |
| **movva-captcha** | Disco Persistente | 1 | R$ 10,00 | Pendente de aprovação |
| **movva-captcha** | Snapshot | 1 | R$ 15,00 | Pendente de aprovação |
| **movva-captcha** | IP Estático | 1 | R$ 30,00 | Pendente de aprovação |
| **movva-captcha** | Versões App Engine | 4 | R$ 60,00 | Pendente de aprovação |
| **TOTAL** | | | **R$ 930,00** | |

## Análise por Tipo de Recurso

### VMs Desligadas (TERMINATED)
- Total: 4 VMs
- Economia Estimada: R$ 200,00/mês
- Projetos: operations-dashboards, movva-splitter, movva-captcha
- Observação: Todas as VMs identificadas estão em estado TERMINATED há pelo menos vários meses.

### Discos Persistentes
- Total: 8 discos
- Economia Estimada: R$ 110,00/mês
- Projetos: operations-dashboards, movva-splitter, movva-captcha
- Observação: Todos os discos estão associados a VMs em estado TERMINATED.

### Snapshots
- Total: 8 snapshots
- Economia Estimada: R$ 160,00/mês
- Projetos: movva-datalake, rapidpro-217518, movva-splitter, operations-dashboards, movva-captcha
- Observação: A maioria dos snapshots é de 2023 ou mais antigos.

### IPs Estáticos
- Total: 7 IPs
- Economia Estimada: R$ 210,00/mês
- Projetos: movva-datalake, coltrane, operations-dashboards, movva-splitter, movva-captcha
- Observação: Os IPs estão em status RESERVED mas não associados a recursos ativos.

### Versões de App Engine
- Total: 114+ versões
- Economia Estimada: R$ 250,00/mês
- Projetos: coltrane, operations-dashboards, movva-splitter, movva-captcha
- Observação: A maioria das versões é anterior a 2025 e todas estão sem tráfego (STOPPED).

## Recomendações

1. **Aprovação para remoção**: Obter aprovação dos responsáveis para remoção dos recursos identificados.

2. **Priorização de remoção**:
   - Prioridade Alta: Versões antigas de App Engine (maior volume)
   - Prioridade Média: IPs estáticos e VMs desligadas
   - Prioridade Baixa: Snapshots antigos

3. **Implementar políticas de limpeza automática**:
   - Versões de App Engine: Manter apenas as últimas 3 versões ou versões dos últimos 3 meses
   - Snapshots: Implementar política de retenção com expiração automática
   - VMs TERMINATED: Remover automaticamente após 30 dias em estado TERMINATED

4. **Documentação**: Manter registro detalhado de todos os recursos removidos para auditoria e referência futura.

## Próximos Passos

1. Apresentar este relatório consolidado para aprovação da equipe de arquitetura
2. Executar os scripts de remoção de recursos após aprovação
3. Verificar a economia real após a remoção dos recursos
4. Implementar políticas de limpeza automática para evitar acúmulo futuro de recursos ociosos
5. Expandir a análise para outros projetos GCP, se aplicável

## Conclusão

A análise de recursos ociosos nos projetos GCP da MOVVA identificou oportunidades significativas de otimização de custos. Com a implementação das recomendações, é possível obter uma economia mensal de aproximadamente R$ 930,00, além de melhorar a organização e manutenção dos ambientes de nuvem.

---

**Nota**: Este relatório faz parte do projeto de otimização de recursos do GCP - Fase 1 - US-01 (Remoção de Recursos Ociosos).
