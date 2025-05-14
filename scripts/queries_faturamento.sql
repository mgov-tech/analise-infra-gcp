-- Queries para análise de faturamento GCP
-- Projeto: rapidpro-217518
-- Dataset: faturamento

-- 1. Tendência de custos por projeto (últimos 30 dias)
SELECT 
  project_id,
  DATE(usage_start_time) as data,
  SUM(cost) as custo_diario
FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
WHERE 
  project_id IS NOT NULL 
  AND DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY project_id, data
ORDER BY project_id, data;

-- 2. Custos por serviço e projeto
SELECT 
  project_id,
  service_description,
  SUM(cost) as custo_total
FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
WHERE project_id IS NOT NULL
GROUP BY project_id, service_description
ORDER BY project_id, custo_total DESC;

-- 3. Top 10 SKUs mais caros
SELECT 
  sku_description,
  service_description,
  SUM(cost) as custo_total
FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
WHERE project_id IS NOT NULL
GROUP BY sku_description, service_description
ORDER BY custo_total DESC
LIMIT 10;

-- 4. Comparação mês a mês por projeto
SELECT
  project_id,
  FORMAT_DATE('%Y-%m', DATE(usage_start_time)) as mes,
  SUM(cost) as custo_mensal
FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
WHERE project_id IS NOT NULL
GROUP BY project_id, mes
ORDER BY project_id, mes;

-- 5. Identificação de picos de gastos diários
SELECT
  project_id,
  DATE(usage_start_time) as data,
  SUM(cost) as custo_diario
FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
WHERE project_id IS NOT NULL
GROUP BY project_id, data
HAVING custo_diario > (
  SELECT AVG(custo_diario) * 1.5 FROM (
    SELECT
      project_id as proj,
      DATE(usage_start_time) as dt,
      SUM(cost) as custo_diario
    FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
    WHERE project_id IS NOT NULL
    GROUP BY proj, dt
  )
  WHERE project_id = proj
)
ORDER BY custo_diario DESC;

-- 6. Monitoramento de recursos potencialmente ociosos
-- Esta consulta identifica serviços com custo mas sem uso significativo
-- Nota: A definição exata de "ocioso" varia por serviço
SELECT
  project_id,
  service_description,
  sku_description,
  SUM(cost) as custo_total
FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
WHERE 
  cost > 0 
  AND (sku_description LIKE '%idle%' 
       OR sku_description LIKE '%unused%'
       OR sku_description LIKE '%minimum%')
GROUP BY project_id, service_description, sku_description
ORDER BY custo_total DESC;

-- 7. Distribuição percentual de custos por serviço
WITH custos_totais AS (
  SELECT SUM(cost) as total FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
  WHERE project_id IS NOT NULL
),
custos_por_servico AS (
  SELECT 
    service_description,
    SUM(cost) as custo_servico
  FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
  WHERE project_id IS NOT NULL
  GROUP BY service_description
)
SELECT 
  service_description,
  custo_servico,
  ROUND(custo_servico / (SELECT total FROM custos_totais) * 100, 2) as percentual
FROM custos_por_servico
ORDER BY percentual DESC;

-- 8. Análise de custos por região
SELECT
  project_id,
  REGEXP_EXTRACT(sku_id, r'[a-z]+-[a-z0-9]+') as regiao,
  service_description,
  SUM(cost) as custo_total
FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
WHERE 
  project_id IS NOT NULL
  AND REGEXP_CONTAINS(sku_id, r'[a-z]+-[a-z0-9]+')
GROUP BY project_id, regiao, service_description
ORDER BY custo_total DESC;

-- 9. Previsão de custos (tendência linear simples)
WITH dados_historicos AS (
  SELECT
    DATE(usage_start_time) as data,
    SUM(cost) as custo_diario
  FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
  WHERE project_id IS NOT NULL
  GROUP BY data
  ORDER BY data
),
estatisticas AS (
  SELECT
    COUNT(*) as n,
    AVG(UNIX_DATE(data)) as media_x,
    AVG(custo_diario) as media_y,
    SUM((UNIX_DATE(data) - AVG(UNIX_DATE(data))) * (custo_diario - AVG(custo_diario))) / SUM(POW(UNIX_DATE(data) - AVG(UNIX_DATE(data)), 2)) as b
  FROM dados_historicos
)
SELECT
  'Próximo mês' as periodo,
  ROUND(AVG(media_y) + AVG(b) * (AVG(media_x) + 30 - AVG(media_x)) * 30, 2) as previsao_custo_mensal
FROM estatisticas;

-- 10. Análise de variação de custo (volatilidade)
WITH custos_diarios AS (
  SELECT
    DATE(usage_start_time) as data,
    SUM(cost) as custo_diario
  FROM `rapidpro-217518.faturamento.evolutivo_gastos_transicao`
  WHERE project_id IS NOT NULL
  GROUP BY data
  ORDER BY data
),
variacoes AS (
  SELECT
    data,
    custo_diario,
    LAG(custo_diario) OVER (ORDER BY data) as custo_anterior,
    (custo_diario - LAG(custo_diario) OVER (ORDER BY data)) / NULLIF(LAG(custo_diario) OVER (ORDER BY data), 0) * 100 as variacao_percentual
  FROM custos_diarios
)
SELECT
  data,
  custo_diario,
  custo_anterior,
  ROUND(variacao_percentual, 2) as variacao_percentual
FROM variacoes
WHERE ABS(variacao_percentual) > 10  -- Variações significativas (mais de 10%)
ORDER BY ABS(variacao_percentual) DESC;
