import 'package:medicalapp/models/coin_price_model.dart';

String formatChangeRate(List<CoinPrice> market, int index) {
  String changeRate =
      "${market[index].changeRate.toString().split('.')[0].replaceFirst('0', '').replaceAll('-', '') + market[index].changeRate.toStringAsFixed(4).split(".")[1].substring(0, 2).replaceFirst(RegExp(r'00'), '0')}.${market[index].changeRate.toStringAsFixed(4).split(".")[1].substring(2, 4)}";
  if (changeRate.split(".")[0].length > 1 &&
      changeRate.split(".")[0][0] == '0') {
    changeRate = changeRate.substring(1);
  }
  return changeRate;
}
