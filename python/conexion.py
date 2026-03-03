from sqlalchemy import create_engine, text
from config import DB_URL


def get_engine():
    return create_engine(DB_URL)


def verificar_conexion(engine):
    with engine.connect() as conn:
        db = conn.execute(text("SELECT current_database()")).scalar()
        print(f"Conectado a: {db}")
