# Consulta sobre Remoção de Recursos - Projeto movva-captcha

## Data: 14/05/2025

## Contexto
Durante análise do projeto movva-captcha, foram identificados diversos recursos ociosos associados principalmente a um ambiente de desenvolvimento desativado. A remoção desses recursos pode gerar uma economia mensal estimada de R$ 165,00.

## Recursos Identificados

### 1. VM Desligada
| Nome da VM | Zona | Estado | Discos Associados | IPs Estáticos |
|------------|------|--------|-------------------|---------------|
| captcha-dev | us-central1-a | TERMINATED | 1 disco | 35.224.42.178 |

### 2. Disco Persistente
| Nome do Disco | Zona | Tamanho (GB) | VM Associada | Status |
|---------------|------|--------------|--------------|--------|
| captcha-dev | us-central1-a | 10 | captcha-dev (TERMINATED) | READY |

### 3. Snapshot Antigo
| Nome do Snapshot | Tamanho (GB) | Disco de Origem | Data de Criação |
|------------------|--------------|-----------------|-----------------|
| captcha-app-prod-20230510 | 20 | captcha-app-prod | 2023-05-10 |

### 4. IP Estático
| Nome do IP | Endereço | Região | Recurso Associado | Status |
|------------|----------|--------|-------------------|--------|
| captcha-dev | 35.224.42.178 | us-central1 | captcha-dev (TERMINATED) | RESERVED |

### 5. Versões de App Engine
| Serviço | Versão | Data de Deploy | Status | Tráfego |
|---------|--------|----------------|--------|---------|
| captcha-api | 20230615t124532 | 2023-06-15 | STOPPED | 0.00 |
| captcha-api | 20240220t105612 | 2024-02-20 | STOPPED | 0.00 |
| captcha-frontend | 20230620t091423 | 2023-06-20 | STOPPED | 0.00 |
| captcha-frontend | 20240225t143210 | 2024-02-25 | STOPPED | 0.00 |

## Perguntas para Avaliação

1. A VM "captcha-dev" em estado TERMINATED pode ser completamente removida junto com seus recursos associados?
2. O snapshot "captcha-app-prod-20230510" de 2023 ainda é necessário ou pode ser removido?
3. O IP estático "captcha-dev" pode ser liberado ou precisa ser mantido para uso futuro?
4. As versões antigas de App Engine sem tráfego podem ser removidas, visto que já existem versões mais recentes em produção?
5. Existe algum plano para reativar o ambiente de desenvolvimento ou esses recursos são apenas remanescentes de uma versão desativada?

## Recomendação Técnica

Com base na análise realizada, recomendamos:

1. **Remover completamente** a VM em estado TERMINATED e seus recursos associados (disco e IP).
2. **Remover o snapshot antigo** de 2023, uma vez que já existem recursos em produção há mais de 2 anos desde a criação desse snapshot.
3. **Limpar** as versões de App Engine anteriores a 2025, mantendo apenas as versões atuais com tráfego.

Esta abordagem permite remover recursos que não têm sido utilizados há bastante tempo, resultando em economia mensal imediata.

## Plano de Ação Proposto

1. Fazer backup de metadados de todos os recursos antes da remoção
2. Remover a VM "captcha-dev" (já em estado TERMINATED)
3. Remover o disco persistente "captcha-dev"
4. Liberar o IP estático "captcha-dev"
5. Remover o snapshot antigo "captcha-app-prod-20230510"
6. Remover as versões antigas de App Engine sem tráfego

## Próximos Passos

1. Aguardar avaliação do arquiteto/responsável pelo projeto
2. Se aprovado, executar scripts de remoção
3. Documentar a economia gerada no relatório consolidado

## Contato para Aprovação

- Nome: [INSERIR NOME DO RESPONSÁVEL]
- Email: [INSERIR EMAIL DO RESPONSÁVEL]

---

**Nota:** Esta consulta faz parte do projeto de otimização de recursos do GCP - Fase 1 - US-01 (Remoção de Recursos Ociosos).
