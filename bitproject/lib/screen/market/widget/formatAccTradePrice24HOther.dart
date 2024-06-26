import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/models/coin_price_model.dart';

// 거래대금 format util
class formatAccTradePrice24HOther extends StatelessWidget {
  formatAccTradePrice24HOther({
    super.key,
    required this.market,
    required this.index,
  });
  final int index;
  var f = NumberFormat('###,###,###.###');
  final List<CoinPrice> market;

  @override
  Widget build(BuildContext context) {
    return Text(
      // "${f.format(int.parse(market[index].accTradePrice24H.toStringAsFixed(0).substring(0, market[index].accTradePrice24H.toStringAsFixed(0).length - 6)))}백만");
      f.format(market[index].accTradePrice24H),
    );
  }
}
