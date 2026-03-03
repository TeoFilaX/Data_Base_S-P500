-- ============================================================
-- BASE DE DATOS: mercado_financiero_eeuu
-- Archivo: 01_crear_tablas.sql
-- ============================================================

-- ------------------------------------------------------------
-- TABLA: empresas
-- Fuente: Wikipedia (Lista S&P 500)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS empresas (
    ticker          VARCHAR(10)  PRIMARY KEY,
    nombre          VARCHAR(255) NOT NULL,
    sector          VARCHAR(100),
    industria       VARCHAR(255),
    fecha_inclusion DATE,
    pais            VARCHAR(10)  DEFAULT 'US',
    moneda          VARCHAR(5)   DEFAULT 'USD',
    activo          BOOLEAN      DEFAULT TRUE
);

-- ------------------------------------------------------------
-- TABLA: precios
-- Fuente: yfinance (precios diarios históricos)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS precios (
    id          SERIAL PRIMARY KEY,
    ticker      VARCHAR(10)    NOT NULL REFERENCES empresas(ticker),
    fecha       DATE           NOT NULL,
    open        NUMERIC(12, 2),
    high        NUMERIC(12, 2),
    low         NUMERIC(12, 2),
    close       NUMERIC(12, 2),
    adj_close   NUMERIC(12, 2),
    volume      BIGINT,
    UNIQUE (ticker, fecha)
);

-- ------------------------------------------------------------
-- TABLA: financieros
-- Fuente: yfinance (income_stmt, balance_sheet, cashflow)
-- Formato largo: una fila por ticker + fecha + métrica
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS financieros (
    id      SERIAL PRIMARY KEY,
    ticker  VARCHAR(10)  NOT NULL REFERENCES empresas(ticker),
    fecha   DATE         NOT NULL,
    tipo    VARCHAR(50)  NOT NULL,
    metrica VARCHAR(100) NOT NULL,
    valor   DOUBLE PRECISION,
    UNIQUE (ticker, fecha, tipo, metrica)
);

-- ------------------------------------------------------------
-- TABLA: macro_indicadores
-- Fuente: FRED API
-- Formato largo: una fila por fecha + indicador
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS macro_indicadores (
    id         SERIAL PRIMARY KEY,
    fecha      DATE         NOT NULL,
    indicador  VARCHAR(50)  NOT NULL,
    frecuencia VARCHAR(20),
    valor      DOUBLE PRECISION,
    UNIQUE (fecha, indicador)
);
