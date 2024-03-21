// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:medicalapp/models/coin_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_price_model.dart';

class CoinListController extends GetxController {
  late Timer timer;
  RxList<bool> selectedMarkets = <bool>[true, false, false].obs;
  RxList<bool> sortCoins = <bool>[true, true, true, true].obs;
  RxBool isLoading = true.obs;
  RxList<CoinList> coinsList = <CoinList>[].obs;
  RxList<CoinPrice> coinPrice = <CoinPrice>[].obs;
  RxList<List<CoinPrice>> coinPriceList = <List<CoinPrice>>[].obs;
  Stopwatch stopwatch = Stopwatch();

  @override
  void onInit() {
    super.onInit();
    fetchCoinPriceList();
  }

  fetchCoinPriceList() async {
    try {
      coinsList.value.clear();
      isLoading(true);
      var response = await http
          .get(Uri.parse("https://api.upbit.com/v1/market/all?isDetails=true"));
      List<CoinList> coinList = coinListFromJson(response.body);
      for (var c in coinList) {
        print(c.market);
      }
      coinsList.value = coinList;
      stopwatch.start();
      for (var element in coinsList.value) {
        if (selectedMarkets[0]) {
          if (element.market.contains("KRW")) {
            var response = await http.get(Uri.parse(
                "https://api.upbit.com/v1/ticker?markets=${element.market}"));
            var bodyList = response.body
                .substring(2, response.body.length - 2)
                .toString()
                .split(',');
            bodyList.add("\"koreanName\":\"${element.koreanName}\"");
            bodyList.add("\"englishName\":\"${element.englishName}\"");
            String response2 = "[{";
            for (String element in bodyList) {
              response2 += "$element,";
            }
            response2 = "${response2.substring(0, response2.length - 1)}}]";
            List<CoinPrice> getcoinPrice = coinPriceFromJson(response2);
            coinPrice.value = getcoinPrice;
            coinPriceList.add(coinPrice.value);
            sleep(const Duration(milliseconds: 30));
          }
        } else if (selectedMarkets[1]) {
          if (element.market.contains("BTC")) {
            var response = await http.get(Uri.parse(
                "https://api.upbit.com/v1/ticker?markets=${element.market}"));
            var bodyList = response.body
                .substring(2, response.body.length - 2)
                .toString()
                .split(',');
            bodyList.add("\"koreanName\":\"${element.koreanName}\"");
            bodyList.add("\"englishName\":\"${element.englishName}\"");
            String response2 = "[{";
            for (String element in bodyList) {
              response2 += "$element,";
            }
            response2 = "${response2.substring(0, response2.length - 1)}}]";
            List<CoinPrice> getcoinPrice = coinPriceFromJson(response2);
            coinPrice.value = getcoinPrice;
            coinPriceList.add(coinPrice.value);
            sleep(const Duration(milliseconds: 30));
          }
        } else if (selectedMarkets[2]) {}
      }
      print('doSomething() executed in ${stopwatch.elapsed}');
      stopwatch.stop();
    } finally {
      isLoading(false);
    }
  }
}
