import 'dart:async';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:medicalapp/models/coin_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_price_model.dart';

class CoinListController extends GetxController {
  late Timer timer;
  RxBool isLoading = true.obs;
  RxList<CoinList> coinsList = <CoinList>[].obs;
  RxList<CoinPrice> coinPrice = <CoinPrice>[].obs;
  RxList<List<CoinPrice>> coinPriceList = <List<CoinPrice>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoinList();
  }

  fetchCoinList() async {
    try {
      isLoading(true);
      timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        var response = await http.get(
            Uri.parse("https://api.upbit.com/v1/market/all?isDetails=true"));
        List<CoinList> coinList = coinListFromJson(response.body);
        coinsList.value = coinList;
        for (var element in coinsList) {
          if (element.market.contains("KRW")) {
            var response2 = await http.get(Uri.parse(
                "https://api.upbit.com/v1/ticker?markets=${element.market}"));
            List<CoinPrice> getcoinPrice = coinPriceFromJson(response2.body);
            coinPrice.value = getcoinPrice;
            coinPriceList.add(coinPrice.value);
          }
        }
        coinPriceList.close();
      });
    } finally {
      isLoading(false);
    }
  }
}
