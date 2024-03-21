import 'package:flutter/widgets.dart';
import 'package:medicalapp/controller/coin_list_controller.dart';

class formatTradePrice extends StatelessWidget {
  const formatTradePrice({
    super.key,
    required this.coinListController,
    required this.index,
  });
  final int index;
  final CoinListController coinListController;

  @override
  Widget build(BuildContext context) {
    return Text(
      coinListController.coinPriceList[index].first.tradePrice.toString(),
    );
  }
}
