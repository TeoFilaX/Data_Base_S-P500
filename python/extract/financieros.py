import yfinance as yf


def extract_financieros(tickers):
    datos = {}
    for ticker in tickers:
        try:
            t = yf.Ticker(ticker)
            datos[ticker] = {
                "cuneta_resultados": t.income_stmt,
                "balance_general":   t.balance_sheet,
                "cashflow":          t.cashflow
            }
        except Exception as e:
            print(f"Error con {ticker}: {e}")
    return datos
