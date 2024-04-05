import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/models/coin_order_book_model.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/models/coin_trade_model.dart';

class CoinTradeScreen extends StatelessWidget {
  CoinTradeScreen(
      {super.key,
      required this.coin,
      required this.coinOrderBook,
      required this.coinTrades});
  CoinPrice coin;
  CoinOrderBook coinOrderBook;
  List<CoinTrade> coinTrades;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var otherf = NumberFormat('###,###,###,###.#########');
    var btcf = NumberFormat('###,###,###,###.############');

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row

          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black38))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.33,
                  child: const Text(
                    '체결시간',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black26),
                      right: BorderSide(color: Colors.black26),
                    ),
                  ),
                  width: width * 0.33,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.005, bottom: height * 0.005),
                    child: const Text(
                      '체결가격',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.01,
                  ),
                  child: SizedBox(
                    width: width * 0.3,
                    child: const Text(
                      '체결량(수량)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of coin trades
          Expanded(
            child: ListView.builder(
              itemCount: coinTrades.length,
              itemBuilder: (context, index) {
                // UTC 타임스탬프를 DateTime 형식으로 변환합니다.
                DateTime localTime = DateTime.fromMillisecondsSinceEpoch(
                  coinTrades[index].timestamp, // 밀리초 단위이므로 1000을 곱해줍니다.
                  isUtc: true, // UTC 타임스탬프임을 명시합니다.
                ).add(const Duration(hours: 9)); // 현지 시간으로 변환하기 위해 9시간을 더합니다.

                // 날짜 및 시간 형식을 설정합니다. 시 분 초까지만 출력합니다.
                String formattedHMS = DateFormat('HH:mm:ss').format(localTime);

                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black26),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 체결시간
                      SizedBox(
                        width: width * 0.33,
                        child: Text(
                          formattedHMS,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // 체결가격
                      Container(
                        height: height * 0.045,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.black26),
                            right: BorderSide(color: Colors.black26),
                          ),
                        ),
                        width: width * 0.33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              coin.code.contains("BTC-")
                                  ? btcf.format(coinTrades[index].tradePrice)
                                  : otherf.format(coinTrades[index].tradePrice),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // 체결량
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.01),
                        child: SizedBox(
                          width: width * 0.3,
                          child: Text(
                            otherf.format(coinTrades[index].tradeVolume),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
