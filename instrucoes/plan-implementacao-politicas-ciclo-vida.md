# Plano de Implementação: US-02 - Políticas de Ciclo de Vida no Cloud Storage

## Contexto da User Story

**Como** arquiteto de nuvem,  
**Quero** implementar políticas de ciclo de vida nos buckets do Cloud Storage,  
**Para** otimizar custos movendo dados antigos para classes de armazenamento mais econômicas.

## Checagem Inicial

- [x] Criar diretório para a US-02 e seus artefatos
- [x] Criar arquivo para registro de atividades executadas
- [x] Criar diretório para armazenar evidências

## Fase de Análise

- [x] Listar todos os buckets existentes nos 6 projetos
- [x] Identificar tamanho total e quantidade de objetos por bucket
- [x] Coletar métricas de acesso dos últimos 90 dias para cada bucket
- [x] Criar matriz de classificação de buckets por frequência de acesso
- [x] Identificar quais buckets são candidatos para políticas de ciclo de vida
- [x] Capturar evidências do estado atual dos buckets (custos e classe de armazenamento)

## Fase de Planejamento

- [x] Definir políticas de ciclo de vida apropriadas para cada bucket
- [x] Classificar buckets em categorias de acesso (frequente, moderado, raro)
- [x] Modelar economia esperada após implementação das políticas
- [x] Documentar detalhadamente as políticas a serem implementadas
- [x] Definir métricas de sucesso para monitoramento pós-implementação
- [x] Elaborar cronograma de implementação por projeto

## Fase de Implementação

### Projeto: movva-datalake (Prioridade Alta)
- [x] Coletar evidências pré-implementação dos buckets (custos, classe, objetos)
- [x] Implementar política para objetos não acessados por 30 dias → Nearline
- [x] Implementar política para objetos não acessados por 90 dias → Coldline
- [x] INSTRUIR_ARQUITETO: Configurar notificações de mudança de classe via console GCP
- [x] Documentar configurações implementadas com capturas de tela

### Projeto: coltrane (Prioridade Média)
- [x] Coletar evidências pré-implementação dos buckets (custos, classe, objetos)
- [x] Implementar política para objetos não acessados por 30 dias → Nearline
- [x] Implementar política para objetos não acessados por 90 dias → Coldline
- [x] Documentar configurações implementadas com capturas de tela

### Projeto: rapidpro-217518 (Prioridade Média)
- [x] Coletar evidências pré-implementação dos buckets (custos, classe, objetos)
- [x] Implementar política para objetos não acessados por 30 dias → Nearline
- [x] Implementar política para objetos não acessados por 90 dias → Coldline
- [x] Documentar configurações implementadas com capturas de tela

### Projeto: operations-dashboards (Prioridade Média)
- [x] Coletar evidências pré-implementação dos buckets (custos, classe, objetos)
- [x] Implementar política para objetos não acessados por 30 dias → Nearline
- [x] Implementar política para objetos não acessados por 90 dias → Coldline
- [x] Documentar configurações implementadas com capturas de tela

### Projeto: movva-splitter (Prioridade Baixa)
- [x] Coletar evidências pré-implementação dos buckets (custos, classe, objetos)
- [x] Implementar política para objetos não acessados por 30 dias → Nearline
- [x] Implementar política para objetos não acessados por 90 dias → Coldline
- [x] Documentar configurações implementadas com capturas de tela

## Fase de Validação

- [x] Verificar aplicação correta das políticas em cada bucket
- [x] Confirmar que as regras estão ativas e funcionando conforme esperado
- [x] Monitorar o processo de transição de classe por 7 dias
- [x] Atualizar documentação com status das transições
- [x] Catalogar quaisquer erros ou anomalias encontradas

## Fase de Documentação e Relatório

- [x] Compilar todas as evidências coletadas em um relatório consolidado
- [x] Documentar economia projetada vs economia real (estimativa inicial)
- [x] Criar dashboard para acompanhamento contínuo da economia
- [x] Elaborar relatório técnico detalhando as implementações
- [x] Produzir sumário executivo para apresentação dos resultados
- [x] INSTRUIR_ARQUITETO: Configurar alertas de custo via console GCP

## Ações de Longo Prazo

- [x] Programar revisão das políticas após 60 dias
- [x] Monitorar impacto nas aplicações que acessam os dados
- [x] Refinar políticas com base na análise de 60 dias
- [x] Documentar todas as alterações nas políticas originais
- [x] Avaliar benefício de políticas de exclusão para dados com mais de 1 ano

## Pontos de Atenção

1. **INSTRUIR_ARQUITETO**: A análise de padrões de acesso aos buckets requer ativação do Cloud Monitoring, que deve ser configurado via Console GCP.
2. **INSTRUIR_ARQUITETO**: As notificações de mudança de classe devem ser configuradas via Console GCP, não sendo possível via CLI.
3. **Potenciais riscos**:
   - Alguns workloads podem ser afetados se acessarem objetos raramente usados
   - Custos de recuperação de dados podem aumentar se objetos forem frequentemente acessados após mudança de classe
