-- ============================================================
-- BASE DE DATOS: mercado_financiero_eeuu
-- Archivo: 02_crear_indices.sql
-- ============================================================

-- ------------------------------------------------------------
-- ÍNDICES: tabla precios
-- Caso de uso: "dame los precios de AAPL entre 2020 y 2024"
-- ------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_precios_ticker
    ON precios (ticker);

CREATE INDEX IF NOT EXISTS idx_precios_fecha
    ON precios (fecha);

CREATE INDEX IF NOT EXISTS idx_precios_ticker_fecha
    ON precios (ticker, fecha);

-- ------------------------------------------------------------
-- ÍNDICES: tabla financieros
-- Caso de uso: "dame el Net Income de todas las empresas en 2024"
-- Caso de uso: "dame todos los datos de AAPL"
-- ------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_financieros_ticker
    ON financieros (ticker);

CREATE INDEX IF NOT EXISTS idx_financieros_ticker_fecha
    ON financieros (ticker, fecha);

CREATE INDEX IF NOT EXISTS idx_financieros_metrica
    ON financieros (metrica);

CREATE INDEX IF NOT EXISTS idx_financieros_tipo
    ON financieros (tipo);

-- ------------------------------------------------------------
-- ÍNDICES: tabla macro_indicadores
-- Caso de uso: "dame el histórico del fed_rate"
-- Caso de uso: "dame todos los indicadores del año 2022"
-- ------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_macro_indicador
    ON macro_indicadores (indicador);

CREATE INDEX IF NOT EXISTS idx_macro_fecha
    ON macro_indicadores (fecha);

CREATE INDEX IF NOT EXISTS idx_macro_indicador_fecha
    ON macro_indicadores (indicador, fecha);

-- ------------------------------------------------------------
-- ÍNDICES: tabla empresas
-- Caso de uso: "dame todas las empresas del sector Technology"
-- ------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_empresas_sector
    ON empresas (sector);
