import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from config import (
    DB_URL, FRED_API_KEY, PERIODO_PRECIOS,
    METRICAS_INCOME, METRICAS_BALANCE, METRICAS_CASHFLOW, SERIES_FRED
)
from conexion import get_engine, verificar_conexion
from extract.empresas    import extract_empresas
from extract.precios     import extract_precios
from extract.financieros import extract_financieros
from extract.macro       import extract_macro
from transform.empresas    import transform_empresas
from transform.precios     import transform_precios
from transform.financieros import transform_financieros
from transform.macro       import transform_macro
from load.loader import crear_tablas, crear_indices, crear_vistas, cargar_df


def main():
    engine = get_engine()
    verificar_conexion(engine)

    # Crear tablas, índices y vistas
    print("\n--- Creando tablas ---")
    crear_tablas(engine)
    print("\n--- Creando índices ---")
    crear_indices(engine)
    print("\n--- Creando vistas ---")
    crear_vistas(engine)

    # Empresas
    print("\n--- Empresas ---")
    df_empresas = transform_empresas(extract_empresas())
    tickers = df_empresas["ticker"].tolist()
    cargar_df(df_empresas, "empresas", engine)

    # Precios
    print("\n--- Precios ---")
    df_precios = transform_precios(extract_precios(tickers, PERIODO_PRECIOS), tickers)
    cargar_df(df_precios, "precios", engine, chunksize=10000)

    # Financieros
    print("\n--- Financieros ---")
    df_financieros = transform_financieros(
        extract_financieros(tickers),
        METRICAS_INCOME, METRICAS_BALANCE, METRICAS_CASHFLOW
    )
    cargar_df(df_financieros, "financieros", engine)

    # Macro
    print("\n--- Macro ---")
    df_macro = transform_macro(extract_macro(FRED_API_KEY, SERIES_FRED), SERIES_FRED)
    cargar_df(df_macro, "macro_indicadores", engine)

    print("\nPipeline completado.")


if __name__ == "__main__":
    main()
