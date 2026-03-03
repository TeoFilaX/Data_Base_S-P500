from pathlib import Path
from sqlalchemy import text

SQL_DIR = Path(__file__).parent.parent.parent / "SQL"


def _ejecutar_sql(engine, nombre_archivo):
    sql_path = SQL_DIR / nombre_archivo
    with open(sql_path, "r") as f:
        sql = f.read()
    with engine.begin() as conn:
        conn.execute(text(sql))
    print(f"{nombre_archivo} ejecutado.")


def crear_tablas(engine):
    _ejecutar_sql(engine, "01_crear_tablas.sql")


def crear_indices(engine):
    _ejecutar_sql(engine, "02_crear_indices.sql")


def crear_vistas(engine):
    _ejecutar_sql(engine, "03_crear_vistas.sql")


def cargar_df(df, tabla, engine, chunksize=5000):
    df.to_sql(tabla, engine, if_exists="append", index=False, chunksize=chunksize)
    print(f"{tabla}: {len(df)} filas cargadas.")
