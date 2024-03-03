import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:medicalapp/models/coinInfo_model.dart';
import 'package:medicalapp/services/api/trade_price_api.dart';

import '../models/coin_price_model.dart';

class CoinController extends GetxController with StateMixin<CoinPirceModel> {
  final TradePriceApi tradePriceApi = TradePriceApi();
  late RxList<dynamic> coinPriceList = [].obs;
  Rx<CoinPirceModel> coinPirces =
      CoinPirceModel("", "", 0.0, 0.0, 0.0, 0.0).obs;

  void fetchPirces(List<String> tickers) async {
    for (String ticker in tickers) {
      try {
        final response = await tradePriceApi.getTradePrice(ticker);
        if (response.statusCode == 200) {
          final coinPriceModel = CoinPirceModel.fromJson(response.data[0]);
          coinPirces(coinPriceModel);
          coinPriceList.add(coinPirces);
        }
        // ignore: deprecated_member_use
      } on DioError {}
    }
    int i = 0;
    for (Rx<CoinPirceModel> cm in coinPriceList) {
      i++;
      print("${i.toString() + cm.value.market}market${coinPriceList.length}");
    }
  }
}
