// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:medicalapp/models/coin_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:web_socket_channel/io.dart';

class CoinListController extends GetxController {
  late Timer timer;
  RxList<bool> selectedMarkets = <bool>[true, false, false].obs;
  RxList<bool> sortCoins = <bool>[true, true, true, true].obs;
  RxBool isLoading = true.obs;
  RxList<CoinList> coinsList = <CoinList>[].obs;
  RxList<CoinPrice> coinPrice = <CoinPrice>[].obs;
  RxList<List<CoinPrice>> coinPriceList = <List<CoinPrice>>[].obs;
  Stopwatch stopwatch = Stopwatch();

  final channel =
      IOWebSocketChannel.connect(Uri.parse("wss://api.upbit.com/websocket/v1"));

  @override
  void onInit() {
    super.onInit();
    fetchCoinPriceList();
  }

  fetchCoinPriceList() async {
    try {
      coinsList.value.clear();
      coinPriceList.clear();
      isLoading(true);
      var response = await http
          .get(Uri.parse("https://api.upbit.com/v1/market/all?isDetails=true"));
      List<CoinList> coinList = coinListFromJson(response.body);
    } finally {
      isLoading(false);
    }
  }
}
