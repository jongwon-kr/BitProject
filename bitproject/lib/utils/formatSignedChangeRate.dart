import 'package:medicalapp/controller/coin_list_controller.dart';

String formatChangeRate(CoinListController coinListController, int index) {
  String changeRate =
      "${coinListController.coinPriceList[index].first.changeRate.toString().split('.')[0].replaceFirst('0', '').replaceAll('-', '') + coinListController.coinPriceList[index].first.changeRate.toStringAsFixed(4).split(".")[1].substring(0, 2).replaceFirst(RegExp(r'00'), '0')}.${coinListController.coinPriceList[index].first.changeRate.toStringAsFixed(4).split(".")[1].substring(2, 4)}";
  if (changeRate.split(".")[0].length > 1 &&
      changeRate.split(".")[0][0] == '0') {
    changeRate = changeRate.substring(1);
  }
  return changeRate;
}
