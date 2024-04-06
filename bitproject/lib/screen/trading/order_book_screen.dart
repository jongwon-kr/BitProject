import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/models/coin_order_book_model.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/models/coin_trade_model.dart';

class OrderBookScreen extends StatelessWidget {
  OrderBookScreen({
    Key? key,
    required this.coin,
    required this.coinOrderBook,
    required this.coinTrades,
  }) : super(key: key);

  late final CoinOrderBook coinOrderBook;
  final CoinPrice coin;
  final List<CoinTrade> coinTrades;
  var krwf = NumberFormat('###,###,###');
  var otherf = NumberFormat('###,###,###,###.###');
  var btcf = NumberFormat('###,###,###,###.##############');
  bool isStart = true;

  @override
  Widget build(BuildContext context) {
    String changeRate =
        "${coin.changeRate.toString().split('.')[0].replaceFirst('0', '').replaceAll('-', '') + coin.changeRate.toStringAsFixed(4).split(".")[1].substring(0, 2).replaceFirst(RegExp(r'00'), '0')}.${coin.changeRate.toStringAsFixed(4).split(".")[1].substring(2, 4)}";
    if (changeRate.split(".")[0].length > 1 &&
        changeRate.split(".")[0][0] == '0') {
      changeRate = changeRate.substring(1);
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScrollController controller =
        ScrollController(initialScrollOffset: height / 2 - height * 0.02);
    double askTotalSize = 0;
    double bidTotalSize = 0;
    for (var size in coinOrderBook.orderbookUnits) {
      askTotalSize += size.askSize;
      bidTotalSize += size.bidSize;
    }

    return ListView(
      controller: controller,
      children: [
        // 첫 번째 row
        Row(
          children: [
            // 첫 번째 column
            Expanded(
              child: Container(
                color: Colors.blue[100],
                child: Column(
                  children: coinOrderBook.orderbookUnits.map<Widget>((item) {
                    double percentage = (item.askSize / askTotalSize) * 2.2;
                    return Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.withOpacity(0.4)),
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.blue.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          stops: [percentage, percentage],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  right: 4.0), // 오른쪽 여백 추가
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${item.askSize}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    // do the build here
                  }).toList(),
                ),
              ),
            ),

            // 두 번째 column
            Expanded(
              child: Container(
                color: Colors.blue[400],
                child: Column(
                  children:
                      coinOrderBook.orderbookUnits.reversed.map<Widget>((item) {
                    return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)),
                        height: height * 0.06,
                        child: ListTile(
                          title: Text(
                            item.askPrice > 0
                                ? coin.code.contains("BTC-")
                                    ? btcf.format(item.askPrice)
                                    : otherf.format(item.askPrice)
                                : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: coin.change
                                        .toLowerCase()
                                        .contains("rise")
                                    ? Colors.red[900]
                                    : coin.change.toLowerCase().contains("fall")
                                        ? Colors.blue[900]
                                        : Colors.black),
                          ),
                        ));
                    // do the build here
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: height * 0.06 * 15,
                color: Colors.blue.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: width * 0.33,
                      decoration: const BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Colors.black26))),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 4, right: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "현재가",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: [
                                Text(
                                  otherf.format(coin.tradePrice),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: coin.change
                                            .toLowerCase()
                                            .contains('rise')
                                        ? Colors.red
                                        : coin.change
                                                .toLowerCase()
                                                .contains('fall')
                                            ? Colors.blue
                                            : Colors.black,
                                  ),
                                ),
                                Text(
                                  coin.change.toLowerCase().contains('rise')
                                      ? "+$changeRate"
                                      : coin.change
                                              .toLowerCase()
                                              .contains('fall')
                                          ? "-$changeRate"
                                          : changeRate,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: coin.change
                                            .toLowerCase()
                                            .contains('rise')
                                        ? Colors.red
                                        : coin.change
                                                .toLowerCase()
                                                .contains('fall')
                                            ? Colors.blue
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Colors.black26))),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 4, right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("거래량"),
                            Column(
                              children: [
                                Text(
                                  otherf.format(coin.accTradeVolume24H),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  coin.code.split("-")[1],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    coin.code.toLowerCase().contains("krw")
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 4, left: 4, right: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("거래금"),
                                Column(
                                  children: [
                                    Text(
                                      "${krwf.format(coin.accTradePrice24H).substring(0, krwf.format(coin.accTradePrice24H).length - 8)}백만",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Container(),
                    Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Colors.black26))),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 4, right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("52주최고"),
                            Column(
                              children: [
                                Text(
                                  otherf.format(coin.highest52WeekPrice),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  DateFormat('(yy-MM-dd)')
                                      .format(coin.highest52WeekDate),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("52주최저"),
                          Column(
                            children: [
                              Text(
                                otherf.format(coin.lowest52WeekPrice),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                DateFormat('(yy-MM-dd)')
                                    .format(coin.lowest52WeekDate),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Colors.black26))),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 4, right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("전일종가"),
                            Text(otherf.format(coin.prevClosingPrice),
                                style: const TextStyle(
                                  fontSize: 11,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("당일고가"),
                          Text(otherf.format(coin.highPrice),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("당일저가"),
                          Text(otherf.format(coin.lowPrice),
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.blue))
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.black26),
                          bottom: BorderSide(color: Colors.black26),
                        ),
                      ),
                      height: height * 0.06,
                      width: width * 0.33,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "매도 총량",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            otherf.format(askTotalSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // 두 번째 row
        Row(
          children: [
            // 세 번째 column
            Expanded(
              child: Container(
                color: Colors.red[100],
                child: Column(
                  children: coinOrderBook.orderbookUnits.map<Widget>((item) {
                    double percentage = (item.bidSize / bidTotalSize) * 2.2;
                    return Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.withOpacity(0.4)),
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.red.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          stops: [percentage, percentage],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  right: 4.0), // 오른쪽 여백 추가
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${item.bidSize}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    // do the build here
                  }).toList(),
                ),
              ),
            ),
            // 네 번째 column
            Expanded(
              child: Container(
                color: Colors.red[300],
                child: Column(
                  children: coinOrderBook.orderbookUnits.map<Widget>((item) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26)),
                      height: height * 0.06,
                      child: ListTile(
                        title: Text(
                          coin.code.contains("BTC-")
                              ? btcf.format(item.bidPrice)
                              : otherf.format(item.bidPrice),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: coin.change.toLowerCase().contains("rise")
                                  ? Colors.red[900]
                                  : coin.change.toLowerCase().contains("fall")
                                      ? Colors.blue[900]
                                      : Colors.black),
                        ),
                      ),
                    );
                    // do the build here
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: height * 0.06 * 15,
                color: Colors.red.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black26))),
                              height: height * 0.06,
                              width: width * 0.33,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "매수 총량",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    otherf.format(bidTotalSize),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 5, left: 5, bottom: 5),
                                child: Text(
                                  "체결가",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5, right: 5, bottom: 5),
                                child: Text(
                                  "체결액",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: coinTrades.map<Widget>((item) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    coin.code.contains("BTC-")
                                        ? btcf.format(item.tradePrice)
                                        : otherf.format(item.tradePrice),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: item.askBid
                                                .toLowerCase()
                                                .contains("bid")
                                            ? Colors.red
                                            : Colors.blue)),
                                Text(
                                  coin.code.contains("BTC-")
                                      ? btcf.format(
                                          item.tradePrice * item.tradeVolume)
                                      : otherf.format(
                                          item.tradePrice * item.tradeVolume),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: item.askBid
                                              .toLowerCase()
                                              .contains("bid")
                                          ? Colors.red
                                          : Colors.blue),
                                ),
                              ],
                            );
                            // do the build here
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
