import 'package:flutter/material.dart';
import 'package:medicalapp/models/coin_order_book_model.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/models/coin_trade_model.dart';

class testScreen extends StatelessWidget {
  testScreen({
    Key? key,
    required this.coin,
    required this.coinOrderBook,
    required this.coinTrades,
  }) : super(key: key);

  final CoinOrderBook coinOrderBook;
  final CoinPrice coin;
  final List<CoinTrade> coinTrades;

  bool isStart = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (isStart) {
      isStart = false;
    }

    return ListView(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: coinOrderBook.orderbookUnits.length,
            itemBuilder: (context, index) {
              final askIndex = coinOrderBook.orderbookUnits.length - index - 1;
              final ask = coinOrderBook.orderbookUnits[askIndex];
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      '${ask.askPrice}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${ask.askSize}',
                    ),
                    tileColor: Colors.blue.withOpacity(
                      ask.askSize / (300000000 / ask.askPrice),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: height,
          width: width,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: coinOrderBook.orderbookUnits.length,
            itemBuilder: (context, index) {
              final order = coinOrderBook.orderbookUnits[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      '${order.bidPrice}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${order.bidSize}',
                    ),
                    tileColor: Colors.red.withOpacity(
                      order.bidSize / (300000000 / order.bidPrice),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
