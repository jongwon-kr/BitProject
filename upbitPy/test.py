import requests


def get_ticker_price(market):
    url = f"https://api.upbit.com/vi/ticker?markets={market}"
    headers = {"accept": "application/json"}
    response = requests.get(url, headers=headers)
