import 'package:flutter/widgets.dart';
import 'package:medicalapp/models/coin_price_model.dart';

class formatTradePrice extends StatelessWidget {
  const formatTradePrice({
    super.key,
    required this.market,
    required this.index,
  });
  final int index;
  final List<CoinPrice> market;

  @override
  Widget build(BuildContext context) {
    return Text(
      market[index].tradePrice.toString(),
    );
  }
}
