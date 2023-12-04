import pyupbit
import numpy as np


class backTesting:
    def __init__(self, daily_data, start_cash):
        self.daily_data = daily_data  # 일봉 데이터
        self.fee = 0  # 수수료
        self.buy_signal = False  # 매수 신호

        self.start_cash = start_cash  # 시작 자산
        self.current_cash = start_cash  # 현재 자산
        self.highest_cash = start_cash  # 자산 최고점
        self.lowest_cash = start_cash  # 자산 최저점

        self.ror = 1  # 수익률
        self.accumulated_ror = 1  # 누적 수익률
        self.mdd = 0  # 최대 낙폭

        self.trade_count = 0  # 거래횟수
        self.win_count = 0  # 승리횟수\

        def execute(self):
            K = 0.5
            # 변동폭 ( 고가 - 저가 )
            self.daily_data["range"] = self.daily_data["high"] - self.daily_data["low"]
            # 목표매수가 ( 시가 + 변동폭 * K )
            self.daily_data["targetPrice"] = (
                self.daily_data["open"] + self.daily_data["range"].shift(1) * K
            )

        execute()


df = pyupbit.get_ohlcv("KRW-BTC", count=7)
print(df)
