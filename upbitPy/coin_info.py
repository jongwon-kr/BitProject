import requests


def get_ticker_price(market):
    url = f"https://api.upbit.com/v1/ticker?markets={market}"
    headers = {"accept": "application/json"}
    response = requests.get(url, headers=headers)
    data = response.json()
    return data[0]["trade_price"]


def get_tickers():
    url = "https://api.upbit.com/v1/market/all"
    headers = {"accept": "application/json"}
    response = requests.get(url, headers=headers)
    data = response.json()
    tickers = []
    for market in data:
        if market["market"].startswith("KRW"):
            tickers.append(market["market"])
    return tickers


def main():
    tickers = get_tickers()
    print(f"코인 목록")
    for ticker in tickers:
        print(f"{ticker}")

    while True:
        user_input = input(f"시장 코드를 입력하세요. 종료 'q'")
        if user_input == "q":
            break
        if user_input in tickers:
            coin_price = get_ticker_price(user_input)
            print(f"{user_input}의 가격 : {coin_price}")
        else:
            print(f"유효하지 않은 코드입니다.")


if __name__ == "__main__":
    main()
# 코인 목록 출력


# 사용자가 선택해서 가격 출력
