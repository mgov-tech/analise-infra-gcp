# Cloud Functions

Data da análise: 06/05/2025

## Projeto: movva-datalake

| Nome | Estado | Tipo de Trigger | Região | Ambiente |
|------|--------|-----------------|--------|----------|
| razoes-pra-ficar-upload-gcs | ACTIVE | HTTP Trigger | us-east1 | 1st gen |
| trigger_rapidpro_finca_update_messages_status | ACTIVE | Event Trigger | us-east1 | 1st gen |

### Detalhes e Observações

- Ambas as funções estão ativas e em produção
- Utilizam a 1ª geração do Cloud Functions
- A função `razoes-pra-ficar-upload-gcs` parece estar relacionada ao upload de arquivos para um bucket GCS relacionado ao projeto "razões pra ficar"
- A função `trigger_rapidpro_finca_update_messages_status` parece trabalhar com a atualização de status de mensagens, possivelmente integrada com a plataforma RapidPro

### Recomendações de Otimização

- **Migração para 2ª geração**: As funções estão usando Cloud Functions 1ª geração. A migração para a 2ª geração traria benefícios como:
  - Menor tempo de inicialização
  - Melhor desempenho
  - Menor custo
  - Suporte a novos recursos
- **Revisão de limites de tempo e memória**: Verificar se os limites de tempo e alocação de memória estão corretamente configurados para otimizar custos

## Projeto: movva-splitter

Não foram encontradas Cloud Functions ativas neste projeto.

## Projeto: movva-captcha-1698695351695

Não foram encontradas Cloud Functions ativas neste projeto. O projeto parece ser focado exclusivamente na implementação do serviço reCAPTCHA Enterprise.
