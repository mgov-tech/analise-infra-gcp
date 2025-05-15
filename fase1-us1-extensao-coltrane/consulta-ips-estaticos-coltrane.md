# Consulta sobre IPs Estáticos Reservados - Projeto Coltrane

## Data: 14/05/2025

## Contexto
Durante análise do projeto coltrane, foram identificados 2 IPs estáticos que estão reservados mas não associados a nenhum recurso. A liberação desses IPs pode gerar economia mensal estimada de R$ 60,00.

## Recursos Identificados

| Nome do IP | Endereço | Status | Uso Atual |
|------------|----------|--------|-----------|
| coltrane-loadbalancer-demo-ip | 34.120.47.139 | RESERVED | Não associado a nenhum recurso |
| coltrane-loadbalancer-demo-ip-br | 34.96.87.123 | RESERVED | Não associado a nenhum recurso |

## Perguntas para Avaliação

1. Os IPs estáticos identificados podem ser liberados?
2. Existe algum motivo para manter esses IPs reservados mesmo sem uso? (Por exemplo: planejamento futuro de deploy, uso em testes ocasionais, etc.)
3. Houve tentativas anteriores de liberar esses recursos? Se sim, qual foi o resultado?

## Recomendação Técnica

Considerando que os IPs possuem o sufixo "-demo" em seus nomes, é possível que sejam utilizados para ambientes de demonstração ocasionais. Recomendamos avaliar:

1. A última vez que esses recursos foram utilizados
2. Se há previsão de uso futuro
3. Se a estratégia de "reservar quando necessário" seria mais econômica do que manter a reserva permanente

## Próximos Passos

1. Aguardar avaliação do arquiteto/responsável pelo projeto
2. Se aprovado, executar script de liberação dos IPs
3. Documentar a economia gerada no relatório consolidado

## Contato para Aprovação

- Nome: [INSERIR NOME DO RESPONSÁVEL]
- Email: [INSERIR EMAIL DO RESPONSÁVEL]

---

**Nota:** Esta consulta faz parte do projeto de otimização de recursos do GCP - Fase 1 - US-01 (Remoção de Recursos Ociosos).
