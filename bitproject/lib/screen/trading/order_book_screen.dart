import 'dart:ffi';

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

  final CoinOrderBook coinOrderBook;
  final CoinPrice coin;
  final List<CoinTrade> coinTrades;

  var otherf = NumberFormat('###,###,###,###.######');
  var btcf = NumberFormat('###,###,###,###.##############');

  bool isStart = true;

  @override
  Widget build(BuildContext context) {
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
                color: Colors.blue[200],
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: coin.change
                                        .toLowerCase()
                                        .contains("rise")
                                    ? Colors.red[700]
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
                      height: height * 0.06,
                      width: width * 0.33,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black38),
                              top: BorderSide(color: Colors.black38))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("매도 총량"),
                          Text(otherf.format(askTotalSize)),
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
                color: Colors.red[200],
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
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: coin.change.toLowerCase().contains("rise")
                                  ? Colors.red[700]
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
                        const Text("매수 총량"),
                        Text(
                          otherf.format(bidTotalSize),
                        ),
                        SizedBox(
                          height: height * 0.1,
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
