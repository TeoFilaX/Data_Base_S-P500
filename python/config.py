from dotenv import load_dotenv
from pathlib import Path
import os

ROOT = Path(__file__).parent.parent
load_dotenv(ROOT / ".env")

# Base de datos
DB_USER     = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST     = os.getenv("DB_HOST", "localhost")
DB_PORT     = os.getenv("DB_PORT", "5432")
DB_NAME     = os.getenv("DB_NAME")
DB_URL      = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# FRED API
FRED_API_KEY = os.getenv("FRED_API_KEY")

# Periodo histórico de precios
PERIODO_PRECIOS = "10y"

# Métricas financieras a extraer
METRICAS_INCOME = [
    "Total Revenue", "Gross Profit", "Operating Income", "EBITDA",
    "Net Income", "Basic EPS", "Diluted EPS", "Research And Development"
]
METRICAS_BALANCE = [
    "Total Assets", "Total Liabilities Net Minority Interest",
    "Stockholders Equity", "Total Debt", "Net Debt",
    "Cash And Cash Equivalents", "Working Capital", "Net PPE"
]
METRICAS_CASHFLOW = [
    "Operating Cash Flow", "Capital Expenditure", "Free Cash Flow",
    "Cash Dividends Paid", "Depreciation And Amortization"
]

# Series FRED: nombre → (código FRED, frecuencia)
SERIES_FRED = {
    "fed_rate":     ("FEDFUNDS", "mensual"),
    "cpi":          ("CPIAUCSL", "mensual"),
    "unemployment": ("UNRATE",   "mensual"),
    "gdp":          ("GDP",      "trimestral"),
    "vix":          ("VIXCLS",   "diario"),
    "pmi":          ("MANEMP",   "mensual"),
}
