// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:medicalapp/models/coin_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:web_socket_channel/io.dart';

class CoinListController extends GetxController {
  RxList<bool> selectedMarkets = <bool>[true, false, false].obs;
  RxList<bool> sortCoins = <bool>[true, true, true, true].obs;
  RxBool isLoading = true.obs;
  RxList<CoinList> coinsList = <CoinList>[].obs;
  RxList<CoinPrice> coinPrice = <CoinPrice>[].obs;
  RxList<List<CoinPrice>> coinPriceList = <List<CoinPrice>>[].obs;
  Stopwatch stopwatch = Stopwatch();
  final IOWebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse("wss://api.upbit.com/websocket/v1"));

  String coins = "";
  RxList<CoinPrice> market = <CoinPrice>[].obs;
  RxList<CoinPrice> krwMarket = <CoinPrice>[].obs;
  RxList<CoinPrice> btcMarket = <CoinPrice>[].obs;
  RxList<CoinPrice> usdtMarket = <CoinPrice>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCoins();
    getMarket();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void updateMarket() {
    update(market);
    print("${market.first.code} ${market.first.tradePrice}");
  }

  void getMarket() {
    if (selectedMarkets[0]) {
      market = krwMarket;
      print("krwMarket");
    } else if (selectedMarkets[1]) {
      market = btcMarket;
      print("btcMarket");
    } else {
      market = usdtMarket;
      print("usdtMarket");
    }
  }

  void getSort() {
    if (sortCoins[0]) {
      // 한글표시
    } else if (!sortCoins[0]) {
      // 영문표시
    } else if (sortCoins[1]) {
      market.sort((a, b) => a.tradePrice.compareTo(b.tradePrice));
      // 현재가 내림차순
    } else if (!sortCoins[1]) {
      // 현재가 오름차순
    } else if (sortCoins[2]) {
      // 전일대비 내림차순
    } else if (!sortCoins[2]) {
      // 전일대비 오름차순
    } else if (sortCoins[3]) {
      // 거래대금 내림차순
    } else if (!sortCoins[3]) {
      // 거래대금 오름차순
    }
  }

  void getCoins() async {
    var response =
        await http.get(Uri.parse("https://api.upbit.com/v1/market/all"));
    List<CoinList> coinList = coinListFromJson(response.body);
    for (var coin in coinList) {
      coins += "\"${coin.market.toString()}\",";
    }
    coins = coins.substring(0, coins.length - 1);
    getPricese();
  }

  void getPricese() async {
    channel.sink.add(
        "[{\"ticket\": \"test example\"},{\"type\": \"ticker\",\"codes\": [$coins]},{\"format\": \"DEFAULT\"}]");
    streamListener();
  }

  void streamListener() {
    try {
      isLoading(true);
      channel.stream.listen((message) {
        Map<String, dynamic> jsonData =
            json.decode(String.fromCharCodes(message));
        CoinPrice coinPrice = CoinPrice.fromJson(jsonData);
        if (coinPrice.code.contains("KRW-")) {
          if (!krwMarket.any((cp) => cp.code == coinPrice.code)) {
            krwMarket.add(coinPrice);
            update();
          } else {
            for (int i = 0; i < krwMarket.length; i++) {
              if (krwMarket[i].code == coinPrice.code) {
                krwMarket[i].tradePrice = coinPrice.tradePrice;
                krwMarket[i].changeRate = coinPrice.changeRate;
                krwMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
                krwMarket[i].signedChangeRate = coinPrice.signedChangeRate;
                update();
                break;
              }
            }
          }
        } else if (coinPrice.code.contains("BTC-")) {
          if (!btcMarket.any((cp) => cp.code == coinPrice.code)) {
            btcMarket.add(coinPrice);
            update();
          } else {
            for (int i = 0; i < krwMarket.length; i++) {
              if (btcMarket[i].code == coinPrice.code) {
                btcMarket[i].tradePrice = coinPrice.tradePrice;
                btcMarket[i].changeRate = coinPrice.changeRate;
                btcMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
                btcMarket[i].signedChangeRate = coinPrice.signedChangeRate;
                update();
                break;
              }
            }
          }
        } else {
          if (!usdtMarket.any((cp) => cp.code == coinPrice.code)) {
            usdtMarket.add(coinPrice);
            update();
          } else {
            for (int i = 0; i < krwMarket.length; i++) {
              if (usdtMarket[i].code == coinPrice.code) {
                usdtMarket[i].tradePrice = coinPrice.tradePrice;
                usdtMarket[i].changeRate = coinPrice.changeRate;
                usdtMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
                usdtMarket[i].signedChangeRate = coinPrice.signedChangeRate;
                update();
                break;
              }
            }
          }
        }
      });
    } finally {
      isLoading(false);
    }
  }

  void printMarket() {
    for (var coin in market) {
      print("${coin.code}  ${coin.tradePrice}");
    }
  }
}
