import pandas as pd


def transform_empresas(df):
    df = df.copy()
    df["ticker"]          = df["ticker"].str.strip()
    df["nombre"]          = df["nombre"].str.strip()
    df["sector"]          = df["sector"].str.strip()
    df["industria"]       = df["industria"].str.strip()
    df["fecha_inclusion"] = pd.to_datetime(df["fecha_inclusion"], errors="coerce").dt.date
    df["pais"]            = "US"
    df["moneda"]          = "USD"
    df["activo"]          = True
    return df.reset_index(drop=True)
