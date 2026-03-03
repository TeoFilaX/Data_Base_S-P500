import pandas as pd
from fredapi import Fred


def extract_macro(fred_api_key, series_fred):
    fred = Fred(api_key=fred_api_key)
    datos = {}
    for nombre, (serie_id, _) in series_fred.items():
        datos[nombre] = pd.DataFrame(fred.get_series(serie_id))
    return datos
