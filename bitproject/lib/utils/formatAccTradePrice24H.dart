import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/controller/coin_list_controller.dart';

// 거래대금 format util
class formatAccTradePrice24H extends StatelessWidget {
  formatAccTradePrice24H({
    super.key,
    required this.coinListController,
    required this.index,
  });
  final int index;
  var f = NumberFormat('###,###,###,###');
  final CoinListController coinListController;

  @override
  Widget build(BuildContext context) {
    return Text(
        "${f.format(int.parse(coinListController.coinPriceList[index].first.accTradePrice24H.toStringAsFixed(0).substring(0, coinListController.coinPriceList[index].first.accTradePrice24H.toStringAsFixed(0).length - 6)))}백만");
  }
}
