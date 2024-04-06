import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_list_model.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/screen/trading/order_book_screen.dart';
import 'package:web_socket_channel/io.dart';

class MarketController extends GetxController {
  late IOWebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse("wss://api.upbit.com/websocket/v1"));
  final ScrollController scrollController = ScrollController();
  bool _isPaused = false;

  var coins = ''.obs;
  var selectedMarkets = [true, false, false].obs;
  var sortCoins = [true, true, true, true].obs;
  var isLoading = true.obs;
  var isSearch = false.obs;

  RxList<CoinPrice> krwMarket = <CoinPrice>[].obs;
  RxList<CoinPrice> btcMarket = <CoinPrice>[].obs;
  RxList<CoinPrice> usdtMarket = <CoinPrice>[].obs;
  RxList<CoinPrice> filteredMarket = <CoinPrice>[].obs;
  RxList<CoinPrice> selectedMarket = <CoinPrice>[].obs;
  var markets = <Widget>[
    const Text('KRW'),
    const Text('BTC'),
    const Text('USDT')
  ];

  var textEditingController = TextEditingController();

  @override
  void onInit() {
    getCoins();
    super.onInit();
  }

  void onPause() {
    _isPaused = true;
  }

  void onResume() {
    _isPaused = false;
  }

  @override
  void onClose() {
    channel.sink.close();
    super.onClose();
  }

  void getCoins() async {
    var response =
        await http.get(Uri.parse("https://api.upbit.com/v1/market/all"));
    List<CoinList> coinList = coinListFromJson(response.body);
    coins.value =
        coinList.map((coin) => "\"${coin.market.toString()}\"").join(",");

    channel.sink.add(
        "[{\"ticket\": \"test example\"},{\"type\": \"ticker\",\"codes\": [$coins]},{\"format\": \"DEFAULT\"}]");
    channel.stream.listen((message) {
      if (!_isPaused) {
        Map<String, dynamic> jsonData = json.decode(
            "{\"korean_name\":\"koreanName\",\"english_name\":\"englishName\",${String.fromCharCodes(message).substring(1)}");
        CoinPrice coinPrice = CoinPrice.fromJson(jsonData);
        for (var coinInfo in coinList) {
          if (coinInfo.market == coinPrice.code) {
            coinPrice.koreanName = coinInfo.koreanName;
            coinPrice.englishName = coinInfo.englishName;
          }
        }

        List<CoinPrice> marketToUpdate;
        if (coinPrice.code.contains("KRW-")) {
          marketToUpdate = krwMarket;
        } else if (coinPrice.code.contains("BTC-")) {
          marketToUpdate = btcMarket;
        } else {
          marketToUpdate = usdtMarket;
        }

        if (!marketToUpdate.any((cp) => cp.code == coinPrice.code) &&
            !isSearch.value) {
          marketToUpdate.add(coinPrice);
        } else {
          for (int i = 0; i < marketToUpdate.length; i++) {
            if (marketToUpdate[i].code == coinPrice.code) {
              marketToUpdate[i].tradePrice = coinPrice.tradePrice;
              marketToUpdate[i].changeRate = coinPrice.changeRate;
              marketToUpdate[i].signedChangeRate = coinPrice.signedChangeRate;
              marketToUpdate[i].accTradePrice24H = coinPrice.accTradePrice24H;
              marketToUpdate[i].askBid = coinPrice.askBid;
              marketToUpdate[i].change = coinPrice.change;
              break;
            }
          }
        }
        selectMarket();
      }
    });
  }

  void selectMarket() async {
    if (isSearch.value) {
      selectedMarket = filteredMarket;
    } else if (selectedMarkets[0]) {
      selectedMarket = krwMarket;
    } else if (selectedMarkets[1]) {
      selectedMarket = btcMarket;
    } else if (selectedMarkets[2]) {
      selectedMarket = usdtMarket;
    }
    update();
  }

  void getSortPrice() {
    if (sortCoins[1]) {
      krwMarket.sort((b, a) => a.tradePrice.compareTo(b.tradePrice));
    } else if (!sortCoins[1]) {
      krwMarket.sort((a, b) => a.tradePrice.compareTo(b.tradePrice));
    }
    if (sortCoins[1]) {
      btcMarket.sort((b, a) => a.tradePrice.compareTo(b.tradePrice));
    } else if (!sortCoins[1]) {
      btcMarket.sort((a, b) => a.tradePrice.compareTo(b.tradePrice));
    }
    if (sortCoins[1]) {
      usdtMarket.sort((b, a) => a.tradePrice.compareTo(b.tradePrice));
    } else if (!sortCoins[1]) {
      usdtMarket.sort((a, b) => a.tradePrice.compareTo(b.tradePrice));
    }
    if (sortCoins[1]) {
      filteredMarket.sort((b, a) => a.tradePrice.compareTo(b.tradePrice));
    } else if (!sortCoins[1]) {
      filteredMarket.sort((a, b) => a.tradePrice.compareTo(b.tradePrice));
    }
  }

  void getSortChange() {
    if (sortCoins[2]) {
      krwMarket
          .sort((b, a) => a.signedChangeRate.compareTo(b.signedChangeRate));
    } else if (!sortCoins[2]) {
      krwMarket
          .sort((a, b) => a.signedChangeRate.compareTo(b.signedChangeRate));
    }
    if (sortCoins[2]) {
      btcMarket
          .sort((b, a) => a.signedChangeRate.compareTo(b.signedChangeRate));
    } else if (!sortCoins[2]) {
      btcMarket
          .sort((a, b) => a.signedChangeRate.compareTo(b.signedChangeRate));
    }
    if (sortCoins[2]) {
      usdtMarket
          .sort((b, a) => a.signedChangeRate.compareTo(b.signedChangeRate));
    } else if (!sortCoins[2]) {
      usdtMarket
          .sort((a, b) => a.signedChangeRate.compareTo(b.signedChangeRate));
    }
    if (sortCoins[2]) {
      filteredMarket
          .sort((b, a) => a.signedChangeRate.compareTo(b.signedChangeRate));
    } else if (!sortCoins[2]) {
      filteredMarket
          .sort((a, b) => a.signedChangeRate.compareTo(b.signedChangeRate));
    }
  }

  void getSortVolume() {
    if (sortCoins[3]) {
      krwMarket
          .sort((b, a) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    } else if (!sortCoins[3]) {
      krwMarket
          .sort((a, b) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    }
    if (sortCoins[3]) {
      btcMarket
          .sort((b, a) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    } else if (!sortCoins[3]) {
      btcMarket
          .sort((a, b) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    }
    if (sortCoins[3]) {
      usdtMarket
          .sort((b, a) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    } else if (!sortCoins[3]) {
      usdtMarket
          .sort((a, b) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    }
    if (sortCoins[3]) {
      filteredMarket
          .sort((b, a) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    } else if (!sortCoins[3]) {
      filteredMarket
          .sort((a, b) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    }
  }

  void filterMarket(searchText) {
    filteredMarket.clear();
    if (searchText.isNotEmpty) {
      isSearch(true);
    } else {
      isSearch(false);
    }

    if (selectedMarkets[0]) {
      filteredMarket.addAll(
        krwMarket
            .where((coin) =>
                coin.koreanName
                    .replaceAll(" ", "")
                    .contains(searchText.toString().replaceAll(" ", "")) ||
                coin.englishName.toLowerCase().replaceAll(" ", "").contains(
                    searchText.toString().toLowerCase().replaceAll(" ", "")) ||
                coin.code.split("-")[1].toLowerCase().contains(
                    searchText.toString().replaceAll(" ", "").toLowerCase()))
            .toList(),
      );
    } else if (selectedMarkets[1]) {
      filteredMarket.addAll(
        btcMarket
            .where((coin) =>
                coin.koreanName
                    .replaceAll(" ", "")
                    .contains(searchText.toString().replaceAll(" ", "")) ||
                coin.englishName.toLowerCase().replaceAll(" ", "").contains(
                    searchText.toString().toLowerCase().replaceAll(" ", "")) ||
                coin.code.split("-")[1].toLowerCase().contains(
                    searchText.toString().replaceAll(" ", "").toLowerCase()))
            .toList(),
      );
    } else if (selectedMarkets[2]) {
      filteredMarket.addAll(
        usdtMarket
            .where((coin) =>
                coin.koreanName
                    .replaceAll(" ", "")
                    .contains(searchText.toString().replaceAll(" ", "")) ||
                coin.englishName.toLowerCase().replaceAll(" ", "").contains(
                    searchText.toString().toLowerCase().replaceAll(" ", "")) ||
                coin.code.split("-")[1].toLowerCase().contains(
                    searchText.toString().replaceAll(" ", "").toLowerCase()))
            .toList(),
      );
    }
    update();
  }

  void toggleMarket(int index) {
    for (int i = 0; i < selectedMarkets.length; i++) {
      selectedMarkets[i] = i == index;
    }
    if (isSearch.value) {}
    update(); // 상태 변경을 알리기 위해 update 함수 호출
  }

  void toggleName() {
    if (sortCoins[0]) {
      sortCoins[0] = false;
    } else if (!sortCoins[0]) {
      sortCoins[0] = true;
    }
    update();
  }

  void togglePrice() {
    if (sortCoins[1]) {
      sortCoins[1] = false;
    } else if (!sortCoins[1]) {
      sortCoins[1] = true;
    }
    update();
  }

  void toggleChange() {
    if (sortCoins[2]) {
      sortCoins[2] = false;
    } else if (!sortCoins[2]) {
      sortCoins[2] = true;
    }
    update();
  }

  void toggleVolume() {
    if (sortCoins[3]) {
      sortCoins[3] = false;
    } else if (!sortCoins[3]) {
      sortCoins[3] = true;
    }
    update();
  }
}
