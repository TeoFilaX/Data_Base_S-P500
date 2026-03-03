import pandas as pd


def transform_precios(data, tickers):
    frames = []
    for ticker in tickers:
        try:
            df_t = data.xs(ticker, level="Ticker", axis=1).copy()
            df_t = df_t.dropna(how="all")
            df_t = df_t.reset_index()
            df_t["ticker"] = ticker
            df_t = df_t.rename(columns={
                "Date":      "fecha",
                "Open":      "open",
                "High":      "high",
                "Low":       "low",
                "Close":     "close",
                "Adj Close": "adj_close",
                "Volume":    "volume"
            })
            frames.append(df_t[["ticker", "fecha", "open", "high", "low", "close", "adj_close", "volume"]])
        except Exception as e:
            print(f"Error con {ticker}: {e}")

    df = pd.concat(frames, ignore_index=True)
    cols_precio = ["open", "high", "low", "close", "adj_close"]
    df[cols_precio] = df[cols_precio].round(2)
    df["volume"] = df["volume"].astype("Int64")
    return df
