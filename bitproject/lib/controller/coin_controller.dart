import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:medicalapp/services/api/trade_price_api.dart';

import '../models/coin_price_model.dart';

class CoinController extends GetxController with StateMixin<CoinPirceModel> {
  final TradePriceApi tradePriceApi = TradePriceApi();
  Rx<CoinPirceModel> coinPirces = CoinPirceModel("", "", 0.0, 0.0, 0.0).obs;

  void fetchPirces(String ticker) async {
    try {
      final response = await tradePriceApi.getTradePrice(ticker);
      if (response.statusCode == 200) {
        final coinPriceModel = CoinPirceModel.fromJson(response.data[0]);
        coinPirces(coinPriceModel);
      }
    } on DioError catch (e) {}
  }
}
