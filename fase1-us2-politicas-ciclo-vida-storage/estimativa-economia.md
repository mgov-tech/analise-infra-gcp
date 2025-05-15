# Estimativa de Economia com Implementação de Políticas de Ciclo de Vida

Data: 14/05/2025

## Visão Geral

Este documento apresenta uma estimativa de economia com a implementação das políticas de ciclo de vida no Cloud Storage para os buckets prioritários da MOVVA.

## Preços de Referência por Classe de Armazenamento

| Classe de Armazenamento | Preço por GB/Mês (USD) | Preço Relativo ao Standard |
|-------------------------|------------------------|---------------------------|
| Standard                | $0.020                 | 100%                      |
| Nearline                | $0.010                 | 50%                       |
| Coldline                | $0.004                 | 20%                       |
| Archive                 | $0.0012                | 6%                        |

**Fonte:** Tabela de preços do Google Cloud Storage (maio/2025)

## Dados de Volume Atual (Baseados no Documento de Infraestrutura Consolidada)

Conforme o documento "infraestrutura_consolidada.md", os volumes de armazenamento por projeto são:

- **Projeto movva-datalake:** 5.070GB em 8+ buckets
- **Projeto coltrane:** 1.830GB em 4 buckets
- **Projeto rapidpro-217518:** 890GB em 4 buckets
- **Projeto operations-dashboards:** 650GB em 3 buckets
- **Projeto movva-splitter:** 38GB em 4 buckets

**Total aproximado:** 8.478GB

## Estimativa de Transição Entre Classes

Com base em padrões típicos de acesso e nas políticas propostas, estimamos a seguinte distribuição após a implementação completa das políticas de ciclo de vida:

| Projeto | Volume Total (GB) | Standard (estimado) | Nearline (estimado) | Coldline (estimado) |
|---------|-------------------|---------------------|---------------------|---------------------|
| movva-datalake | 5.070 | 30% (1.521GB) | 40% (2.028GB) | 30% (1.521GB) |
| rapidpro-217518 | 890 | 40% (356GB) | 40% (356GB) | 20% (178GB) |
| coltrane | 1.830 | 50% (915GB) | 30% (549GB) | 20% (366GB) |
| operations-dashboards | 650 | 60% (390GB) | 30% (195GB) | 10% (65GB) |
| movva-splitter | 38 | 20% (7.6GB) | 30% (11.4GB) | 50% (19GB) |
| **Total** | **8.478** | **37.6% (3.189.6GB)** | **36.9% (3.139.4GB)** | **25.5% (2.149GB)** |

## Cálculo de Economia Mensal Estimada

### Custo Atual (Tudo em Standard)
8.478GB × $0.020/GB = **$169,56/mês**

### Custo Projetado (Após Implementação Completa)
- Standard: 3.189,6GB × $0.020/GB = $63,79/mês
- Nearline: 3.139,4GB × $0.010/GB = $31,39/mês
- Coldline: 2.149GB × $0.004/GB = $8,60/mês
- **Total:** $103,78/mês

### Economia Mensal Projetada
$169,56 - $103,78 = **$65,78/mês** (aproximadamente **R$ 337,00/mês**)

### Economia Anual Projetada
$65,78 × 12 meses = **$789,36/ano** (aproximadamente **R$ 4.044,00/ano**)

## Considerações Importantes

1. **Custos de Transição:** A mudança de classe de armazenamento pode gerar custos operacionais iniciais, mas esses custos são compensados pela economia a longo prazo.

2. **Custos de Recuperação:** Objetos em classes Nearline e Coldline têm custos de recuperação mais elevados. Este fator foi considerado na estimativa ao manter dados frequentemente acessados na classe Standard.

3. **Tempo para Economia Completa:** A economia total só será realizada após aproximadamente 3-4 meses da implementação, quando a maioria dos objetos já tiver transitado para suas classes de destino.

4. **Período de Retenção Mínimo:** Classes Nearline e Coldline têm períodos mínimos de retenção (30 e 90 dias, respectivamente). Objetos excluídos antes desse período ainda serão cobrados como se estivessem armazenados durante todo o período mínimo.

## Próximos Passos para Maximizar a Economia

1. Configurar monitoramento de custos específico para Cloud Storage
2. Avaliar a migração manual de dados históricos raramente acessados diretamente para Coldline
3. Considerar a implementação de políticas de exclusão para dados realmente obsoletos
4. Estender a implementação para os buckets secundários após validação do piloto
