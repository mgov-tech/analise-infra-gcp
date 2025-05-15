# Relatório de Status - Implementação de Políticas de Ciclo de Vida

**Data da Geração:** 2025-05-15  
**Responsável:** Sistema Automatizado

## Visão Geral

Relatório gerado automaticamente com o status atual da implementação das políticas de ciclo de vida nos buckets prioritários.

## Status por Bucket

### gs://movva-datalake
✅ **Status:** Política configurada

**Detalhes da Política:**
```json
{"rule": [{"action": {"storageClass": "NEARLINE", "type": "SetStorageClass"}, "condition": {"age": 30, "matchesStorageClass": ["STANDARD"]}}, {"action": {"storageClass": "COLDLINE", "type": "SetStorageClass"}, "condition": {"age": 90, "matchesStorageClass": ["NEARLINE"]}}]}
```

---

### gs://movva-datalake-us-notebooks
✅ **Status:** Política configurada

**Detalhes da Política:**
```json
{"rule": [{"action": {"storageClass": "NEARLINE", "type": "SetStorageClass"}, "condition": {"age": 15, "matchesStorageClass": ["STANDARD"]}}, {"action": {"storageClass": "COLDLINE", "type": "SetStorageClass"}, "condition": {"age": 45, "matchesStorageClass": ["NEARLINE"]}}]}
```

---

### gs://movva-sandbox
✅ **Status:** Política configurada

**Detalhes da Política:**
```json
{"rule": [{"action": {"storageClass": "NEARLINE", "type": "SetStorageClass"}, "condition": {"age": 15, "matchesStorageClass": ["STANDARD"]}}, {"action": {"storageClass": "COLDLINE", "type": "SetStorageClass"}, "condition": {"age": 45, "matchesStorageClass": ["NEARLINE"]}}]}
```

---

### gs://razoes-pra-ficar
✅ **Status:** Política configurada

**Detalhes da Política:**
```json
{"rule": [{"action": {"storageClass": "NEARLINE", "type": "SetStorageClass"}, "condition": {"age": 30, "matchesStorageClass": ["STANDARD"]}}, {"action": {"storageClass": "COLDLINE", "type": "SetStorageClass"}, "condition": {"age": 90, "matchesStorageClass": ["NEARLINE"]}}]}
```

---

### gs://poc-razoes-pra-ficar
✅ **Status:** Política configurada

**Detalhes da Política:**
```json
{"rule": [{"action": {"storageClass": "NEARLINE", "type": "SetStorageClass"}, "condition": {"age": 15, "matchesStorageClass": ["STANDARD"]}}, {"action": {"storageClass": "COLDLINE", "type": "SetStorageClass"}, "condition": {"age": 45, "matchesStorageClass": ["NEARLINE"]}}]}
```

---

## Resumo de Status
- ✅ **Buckets com política configurada:** 5/5
- ⏳ **Buckets pendentes:** 0/5

## Próximos Passos
1. Revisar os status acima
2. Para buckets sem política, seguir instruções em [instrucoes-implementacao-console.md](instrucoes-implementacao-console.md)
3. Para dúvidas, contatar a equipe de Arquitetura de Cloud
