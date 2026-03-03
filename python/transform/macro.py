import pandas as pd


def transform_macro(datos, series_fred):
    frames = []
    for nombre, df in datos.items():
        _, frecuencia = series_fred[nombre]
        temp = df.copy()
        temp.index.name = "fecha"
        temp = temp.reset_index()
        temp.columns = ["fecha", "valor"]
        temp["indicador"] = nombre
        temp["frecuencia"] = frecuencia
        frames.append(temp)

    df = pd.concat(frames, ignore_index=True)
    df = df[["fecha", "indicador", "frecuencia", "valor"]]
    df = df.dropna(subset=["valor"])
    return df
