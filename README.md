# Análisis Financiero S&P 500

Pipeline ETL que extrae, transforma y carga datos del S&P 500 y datos macroeconómicos en una base de datos PostgreSQL.

## Fuentes de datos

| Fuente | Datos |
|---|---|
| Wikipedia | Lista de 503 empresas del S&P 500 |
| yfinance | Precios históricos diarios (10 años) y estados financieros anuales |
| FRED API | Indicadores macroeconómicos (Fed Rate, CPI, GDP, VIX, Desempleo, PMI) |

## Estructura del proyecto

```
Análisis_Financiero/
├── .env.example          # Variables de entorno (plantilla)
├── requirements.txt      # Dependencias Python
│
├── SQL/
│   ├── 01_crear_tablas.sql   # Schema de la base de datos
│   ├── 02_crear_indices.sql  # Índices para optimizar consultas
│   └── 03_crear_vistas.sql   # Vistas para análisis comunes
│
├── python/
│   ├── config.py             # Configuración central y constantes
│   ├── conexion.py           # Conexión a PostgreSQL
│   ├── main.py               # Orquestador del pipeline ETL
│   │
│   ├── extract/
│   │   ├── empresas.py       # Scraping Wikipedia S&P 500
│   │   ├── precios.py        # Precios históricos (yfinance)
│   │   ├── financieros.py    # Estados financieros (yfinance)
│   │   └── macro.py          # Indicadores macroeconómicos (FRED)
│   │
│   ├── transform/
│   │   ├── empresas.py       # Limpieza y enriquecimiento
│   │   ├── precios.py        # Normalización de precios
│   │   ├── financieros.py    # Formato largo, eliminación de NaN
│   │   └── macro.py          # Combinación de series temporales
│   │
│   └── load/
│       └── loader.py         # Carga a PostgreSQL
│
├── notebooks/
│   └── Data_Extract.ipynb    # Exploración y prototipado
│
└── logs/                     # Logs de ejecución
```

## Base de datos

**Tablas:**

| Tabla | Descripción | Filas aprox. |
|---|---|---|
| `empresas` | Lista S&P 500 con sector e industria | 503 |
| `precios` | Precios diarios OHLCV ajustados | ~1.230.000 |
| `financieros` | Estados financieros anuales (formato largo) | ~9.500 |
| `macro_indicadores` | Series macroeconómicas históricas | ~13.500 |

**Vistas disponibles:**

| Vista | Descripción |
|---|---|
| `v_precios_recientes` | Último precio de cada empresa |
| `v_rentabilidad_anual` | Retorno % anual por ticker |
| `v_resumen_financiero` | Revenue, EBITDA, Net Income en columnas |
| `v_macro_reciente` | Último valor de cada indicador macro |
| `v_empresas_por_sector` | Distribución por sector |
| `v_volatilidad_anual` | Volatilidad anual de cada acción |

## Instalación

### 1. Clonar el repositorio

```bash
git clone <url-del-repo>
cd Análisis_Financiero
```

### 2. Crear y activar entorno virtual

```bash
python -m venv venv
source venv/bin/activate  # macOS/Linux
```

### 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

### 4. Configurar variables de entorno

```bash
cp .env.example .env
```

Editar `.env` con tus credenciales:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=mercado_financiero_eeuu
DB_USER=tu_usuario
DB_PASSWORD=tu_contraseña
FRED_API_KEY=tu_api_key_fred
```

> La API key de FRED es gratuita: https://fred.stlouisfed.org/docs/api/api_key.html

### 5. Crear la base de datos en PostgreSQL

```bash
psql -U postgres -c "CREATE DATABASE mercado_financiero_eeuu;"
```

### 6. Ejecutar el pipeline

```bash
python python/main.py
```

El pipeline ejecuta en orden:
1. Crea tablas, índices y vistas en PostgreSQL
2. Extrae y carga empresas del S&P 500
3. Extrae y carga precios históricos (~15-20 min)
4. Extrae y carga estados financieros (~10 min)
5. Extrae y carga datos macroeconómicos

## Tecnologías

- Python 3.13
- PostgreSQL
- pandas, yfinance, fredapi, SQLAlchemy, psycopg2
