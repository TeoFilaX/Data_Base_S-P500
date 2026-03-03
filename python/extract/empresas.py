import pandas as pd
import requests
from io import StringIO


def extract_empresas():
    url = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)
    df = pd.read_html(StringIO(response.text))[0]
    df = df.rename(columns={
        "Symbol":            "ticker",
        "Security":          "nombre",
        "GICS Sector":       "sector",
        "GICS Sub-Industry": "industria",
        "Date added":        "fecha_inclusion"
    })
    df["ticker"] = df["ticker"].str.replace(".", "-", regex=False)
    return df[["ticker", "nombre", "sector", "industria", "fecha_inclusion"]]
