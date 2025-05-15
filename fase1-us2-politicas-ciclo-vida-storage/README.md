# Otimização de Custos - Políticas de Ciclo de Vida no Cloud Storage

Este diretório contém todos os artefatos relacionados à implementação de políticas de ciclo de vida nos buckets de armazenamento da GCP, parte da US-02 da Fase 1 do projeto de otimização de infraestrutura na nuvem.

## Estrutura do Diretório

- 📄 `README.md` - Este arquivo
- 📑 `resumo-executivo.md` - Visão geral para stakeholders
- 📊 `relatorio-consolidado.md` - Relatório detalhado da implementação
- ✅ `CONCLUSAO.md` - Documento de conclusão do projeto
- 🔧 `aplicar-politicas-cli.sh` - Script para aplicar políticas via CLI
- 📋 `buckets-identificados.md` - Inventário de buckets analisados
- ⚙️ `config-*.json` - Arquivos de configuração por bucket
- 💰 `estimativa-economia.md` - Análise detalhada de custos
- 📸 `evidencias/` - Capturas de tela e logs
- 📝 `instrucoes-implementacao-console.md` - Guia passo a passo
- 📑 `politicas-ciclo-vida-propostas.md` - Definição das políticas
- 📋 `registro-auditoria.md` - Log de atividades
- 📊 `gerar-relatorio-status.sh` - Script para gerar relatório de status atual

## Como Usar

### 1. Aplicar Políticas via CLI

```bash
# Navegue até o diretório
cd fase1-us2-politicas-ciclo-vida-storage

# Torne o script executável
chmod +x aplicar-politicas-cli.sh

# Execute o script (serão solicitadas as credenciais do GCP)
./aplicar-politicas-cli.sh
```

### 2. Aplicar via Console GCP

Siga as instruções detalhadas em [instrucoes-implementacao-console.md](instrucoes-implementacao-console.md).

### 3. Gerar Relatório de Status

Para verificar o status atual da implementação das políticas em todos os buckets:

```bash
# Navegue até o diretório
cd fase1-us2-politicas-ciclo-vida-storage

# Torne o script executável
chmod +x gerar-relatorio-status.sh

# Execute o script
./gerar-relatorio-status.sh
```

O script irá gerar um arquivo chamado `status-implementacao-YYYY-MM-DD.md` com o status atual de cada bucket.

## Monitoramento

Após a implementação, monitore:

1. **Custos de Armazenamento**
   - Acompanhe a redução mensal de custos
   - Valide as economias projetadas

2. **Transições de Classe**
   - Verifique se os dados estão sendo movidos conforme esperado
   - Monitore eventuais impactos no desempenho

## Manutenção

Recomenda-se revisar as políticas a cada 6 meses ou após mudanças significativas nos padrões de acesso aos dados.

## Contato

Para dúvidas ou suporte, entre em contato com a equipe de Arquitetura de Cloud.

---

**Última Atualização**: 14/05/2025  
**Versão**: 1.0
