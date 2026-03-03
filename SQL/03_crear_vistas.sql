-- ============================================================
-- BASE DE DATOS: mercado_financiero_eeuu
-- Archivo: 03_crear_vistas.sql
-- ============================================================

-- ------------------------------------------------------------
-- VISTA: v_precios_recientes
-- Último precio de cierre registrado de cada empresa
-- Uso: ¿a cuánto cerró hoy cada acción?
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_precios_recientes AS
SELECT
    p.ticker,
    e.nombre,
    e.sector,
    p.fecha,
    p.close,
    p.adj_close,
    p.volume
FROM precios p
JOIN empresas e ON e.ticker = p.ticker
WHERE p.fecha = (
    SELECT MAX(p2.fecha)
    FROM precios p2
    WHERE p2.ticker = p.ticker
);

-- ------------------------------------------------------------
-- VISTA: v_rentabilidad_anual
-- Retorno anual por ticker comparando primer y último precio
-- Uso: ¿qué empresas subieron más en cada año?
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_rentabilidad_anual AS
WITH precios_año AS (
    SELECT
        ticker,
        EXTRACT(YEAR FROM fecha) AS año,
        FIRST_VALUE(adj_close) OVER (
            PARTITION BY ticker, EXTRACT(YEAR FROM fecha)
            ORDER BY fecha ASC
        ) AS precio_inicio,
        LAST_VALUE(adj_close) OVER (
            PARTITION BY ticker, EXTRACT(YEAR FROM fecha)
            ORDER BY fecha ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS precio_fin
    FROM precios
)
SELECT DISTINCT
    p.ticker,
    e.nombre,
    e.sector,
    p.año::INT                                                                       AS año,
    ROUND(p.precio_inicio::NUMERIC, 2)                                               AS precio_inicio,
    ROUND(p.precio_fin::NUMERIC, 2)                                                  AS precio_fin,
    ROUND(((p.precio_fin - p.precio_inicio) / p.precio_inicio * 100)::NUMERIC, 2)   AS retorno_pct
FROM precios_año p
JOIN empresas e ON e.ticker = p.ticker
ORDER BY año DESC, retorno_pct DESC;

-- ------------------------------------------------------------
-- VISTA: v_resumen_financiero
-- Métricas clave por empresa y año en formato ancho (columnas)
-- Uso: comparar Revenue, EBITDA y Net Income de un vistazo
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_resumen_financiero AS
SELECT
    f.ticker,
    e.nombre,
    e.sector,
    EXTRACT(YEAR FROM f.fecha)::INT AS año,
    MAX(CASE WHEN f.metrica = 'Total Revenue'    THEN f.valor END) AS total_revenue,
    MAX(CASE WHEN f.metrica = 'Gross Profit'     THEN f.valor END) AS gross_profit,
    MAX(CASE WHEN f.metrica = 'Operating Income' THEN f.valor END) AS operating_income,
    MAX(CASE WHEN f.metrica = 'EBITDA'           THEN f.valor END) AS ebitda,
    MAX(CASE WHEN f.metrica = 'Net Income'       THEN f.valor END) AS net_income,
    MAX(CASE WHEN f.metrica = 'Basic EPS'        THEN f.valor END) AS basic_eps,
    MAX(CASE WHEN f.metrica = 'Diluted EPS'      THEN f.valor END) AS diluted_eps,
    MAX(CASE WHEN f.metrica = 'Total Assets'     THEN f.valor END) AS total_assets,
    MAX(CASE WHEN f.metrica = 'Total Debt'       THEN f.valor END) AS total_debt,
    MAX(CASE WHEN f.metrica = 'Free Cash Flow'   THEN f.valor END) AS free_cash_flow
FROM financieros f
JOIN empresas e ON e.ticker = f.ticker
GROUP BY f.ticker, e.nombre, e.sector, EXTRACT(YEAR FROM f.fecha)
ORDER BY f.ticker, año DESC;

-- ------------------------------------------------------------
-- VISTA: v_macro_reciente
-- Último valor disponible de cada indicador macroeconómico
-- Uso: ¿cuál es el tipo de interés actual? ¿y el VIX?
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_macro_reciente AS
SELECT
    indicador,
    frecuencia,
    fecha,
    valor
FROM macro_indicadores
WHERE fecha = (
    SELECT MAX(m2.fecha)
    FROM macro_indicadores m2
    WHERE m2.indicador = macro_indicadores.indicador
)
ORDER BY indicador;

-- ------------------------------------------------------------
-- VISTA: v_empresas_por_sector
-- Distribución de empresas del S&P 500 por sector
-- Uso: ¿cuántas empresas hay en cada sector?
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_empresas_por_sector AS
SELECT
    sector,
    COUNT(*) AS num_empresas
FROM empresas
WHERE activo = TRUE
GROUP BY sector
ORDER BY num_empresas DESC;

-- ------------------------------------------------------------
-- VISTA: v_volatilidad_anual
-- Volatilidad (desviación estándar de retornos diarios) por año
-- Uso: ¿qué empresas fueron más volátiles en cada año?
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_volatilidad_anual AS
WITH retornos AS (
    SELECT
        ticker,
        EXTRACT(YEAR FROM fecha)::INT AS año,
        (adj_close - LAG(adj_close) OVER (PARTITION BY ticker ORDER BY fecha))
            / NULLIF(LAG(adj_close) OVER (PARTITION BY ticker ORDER BY fecha), 0) AS retorno_diario
    FROM precios
)
SELECT
    r.ticker,
    e.nombre,
    e.sector,
    r.año,
    ROUND(STDDEV(r.retorno_diario)::NUMERIC * 100, 4) AS volatilidad_pct
FROM retornos r
JOIN empresas e ON e.ticker = r.ticker
WHERE r.retorno_diario IS NOT NULL
GROUP BY r.ticker, e.nombre, e.sector, r.año
ORDER BY r.año DESC, volatilidad_pct DESC;
