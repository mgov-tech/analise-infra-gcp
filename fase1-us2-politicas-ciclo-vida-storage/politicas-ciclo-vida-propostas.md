# Políticas de Ciclo de Vida Propostas para Buckets GCP

Data: 14/05/2025

## Abordagem Geral

Com base na análise preliminar dos buckets existentes, definimos políticas padrão de ciclo de vida para otimizar o custo de armazenamento, mantendo a disponibilidade dos dados conforme necessário.

## Políticas Padrão

### Política para Dados de Produção (Acesso Moderado)

Esta política se aplica a buckets que armazenam dados operacionais com acesso moderado.

```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "NEARLINE"
        },
        "condition": {
          "age": 30,
          "matchesStorageClass": ["STANDARD"]
        }
      },
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "COLDLINE"
        },
        "condition": {
          "age": 90,
          "matchesStorageClass": ["NEARLINE"]
        }
      }
    ]
  }
}
```

### Política para Dados de Desenvolvimento/Sandbox (Acesso Ocasional)

Esta política se aplica a ambientes não produtivos onde o acesso é menos frequente.

```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "NEARLINE"
        },
        "condition": {
          "age": 15,
          "matchesStorageClass": ["STANDARD"]
        }
      },
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "COLDLINE"
        },
        "condition": {
          "age": 45,
          "matchesStorageClass": ["NEARLINE"]
        }
      }
    ]
  }
}
```

### Política para Dados de Backup/Arquivamento (Acesso Raro)

Esta política se aplica a buckets que armazenam backups e dados históricos.

```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "NEARLINE"
        },
        "condition": {
          "age": 1,
          "matchesStorageClass": ["STANDARD"]
        }
      },
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "COLDLINE"
        },
        "condition": {
          "age": 30,
          "matchesStorageClass": ["NEARLINE"]
        }
      },
      {
        "action": {
          "type": "SetStorageClass",
          "storageClass": "ARCHIVE"
        },
        "condition": {
          "age": 180,
          "matchesStorageClass": ["COLDLINE"]
        }
      }
    ]
  }
}
```

## Políticas Específicas por Bucket

| Bucket | Projeto | Tipo de Política | Justificativa |
|--------|---------|------------------|---------------|
| movva-datalake | movva-datalake | Produção | Bucket principal com múltiplos tipos de dados |
| movva-datalake-us-notebooks | movva-datalake | Desenvolvimento | Contém notebooks que são acessados ocasionalmente |
| movva-sandbox | A determinar | Desenvolvimento | Ambiente de sandbox com acesso ocasional |
| razoes-pra-ficar | rapidpro-217518 | Produção | Dados de produção com acesso moderado |
| poc-razoes-pra-ficar | rapidpro-217518 | Desenvolvimento | Ambiente de POC com acesso ocasional |
| databricks-* | movva-datalake | **Não aplicar ainda** | Buckets gerenciados pelo Databricks, requer análise específica |
| us-east1-movva-airflow-* | movva-datalake | **Não aplicar ainda** | Buckets do Airflow, requer análise específica |

## Implementação Prioritária

1. **Fase 1 (Imediata):**
   - Implementar políticas para buckets de desenvolvimento/sandbox
   - Coletar métricas base para comparação futura

2. **Fase 2 (Após validação inicial):**
   - Implementar políticas para buckets de produção
   - Monitorar transição por 2 semanas

3. **Fase 3 (Análise detalhada):**
   - Análise específica para buckets de sistema
   - Implementar políticas customizadas onde necessário
