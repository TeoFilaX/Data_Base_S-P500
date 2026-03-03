import pandas as pd


def transform_financieros(datos, metricas_income, metricas_balance, metricas_cashflow):
    frames = []
    config = [
        ("cuneta_resultados", metricas_income),
        ("balance_general",   metricas_balance),
        ("cashflow",          metricas_cashflow),
    ]
    for ticker, estados in datos.items():
        for tipo, metricas in config:
            df_raw = estados.get(tipo)
            if df_raw is None or df_raw.empty:
                continue
            df_t = df_raw.T
            for metrica in metricas:
                if metrica in df_t.columns:
                    for fecha, valor in df_t[metrica].items():
                        frames.append({
                            "ticker":  ticker,
                            "fecha":   fecha,
                            "tipo":    tipo,
                            "metrica": metrica,
                            "valor":   valor
                        })
    df = pd.DataFrame(frames)
    df = df.dropna(subset=["valor"])
    return df
