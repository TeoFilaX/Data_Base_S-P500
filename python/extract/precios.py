import yfinance as yf


def extract_precios(tickers, periodo="10y"):
    return yf.download(tickers, period=periodo, auto_adjust=False, progress=False)
