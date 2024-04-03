import 'package:flutter/services.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_list_model.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/utils/changeRateBar.dart';
import 'package:medicalapp/utils/formatAccTradePrice24HKrw.dart';
import 'package:medicalapp/utils/formatAccTradePrice24HOther.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';
import 'package:medicalapp/utils/formatTradePrice.dart';
import 'package:medicalapp/utils/formatTradePriceUsdt.dart';

import 'package:web_socket_channel/io.dart';

import 'get_market_coin_list.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final channel =
      IOWebSocketChannel.connect(Uri.parse("wss://api.upbit.com/websocket/v1"));
  String coins = "";
  List<bool> selectedMarkets = [true, false, false];
  List<bool> sortCoins = [true, true, true, true];
  bool isLoading = true;
  bool isSearch = false;
  Stopwatch stopwatch = Stopwatch();

  List<CoinPrice> krwMarket = <CoinPrice>[];
  List<CoinPrice> btcMarket = <CoinPrice>[];
  List<CoinPrice> usdtMarket = <CoinPrice>[];
  List<CoinPrice> filteredMarket = <CoinPrice>[];

  List<Widget> Markets = <Widget>[
    const Text('KRW'),
    const Text('BTC'),
    const Text('USDT')
  ];

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCoins();
  }

  @override
  void dispose() {
    // 페이지를 벗어나면 스트림 연결을 종료합니다.
    channel.sink.close();
    super.dispose();
  }

  void getCoins() async {
    isLoading = true;
    var response =
        await http.get(Uri.parse("https://api.upbit.com/v1/market/all"));
    List<CoinList> coinList = coinListFromJson(response.body);
    for (var coin in coinList) {
      coins += "\"${coin.market.toString()}\",";
    }
    coins = coins.substring(0, coins.length - 1);
    channel.sink.add(
        "[{\"ticket\": \"test example\"},{\"type\": \"ticker\",\"codes\": [$coins]},{\"format\": \"DEFAULT\"}]");
    channel.stream.listen((message) {
      Map<String, dynamic> jsonData = json.decode(
          "{\"korean_name\":\"koreanName\",\"english_name\":\"englishName\",${String.fromCharCodes(message).substring(1)}");

      CoinPrice coinPrice = CoinPrice.fromJson(jsonData);
      for (var coinInfo in coinList) {
        if (coinInfo.market == coinPrice.code) {
          coinPrice.koreanName = coinInfo.koreanName;
          coinPrice.englishName = coinInfo.englishName;
        }
      }
      if (coinPrice.code.contains("KRW-")) {
        if (!krwMarket.any((cp) => cp.code == coinPrice.code) && !isSearch) {
          krwMarket.add(coinPrice);
        } else {
          for (int i = 0; i < krwMarket.length; i++) {
            if (krwMarket[i].code == coinPrice.code) {
              krwMarket[i].tradePrice = coinPrice.tradePrice;
              krwMarket[i].changeRate = coinPrice.changeRate;
              krwMarket[i].signedChangeRate = coinPrice.signedChangeRate;
              krwMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
              krwMarket[i].askBid = coinPrice.askBid;
              break;
            }
          }
        }
      } else if (coinPrice.code.contains("BTC-")) {
        if (!btcMarket.any((cp) => cp.code == coinPrice.code) && !isSearch) {
          btcMarket.add(coinPrice);
        } else {
          for (int i = 0; i < krwMarket.length; i++) {
            if (btcMarket[i].code == coinPrice.code) {
              btcMarket[i].tradePrice = coinPrice.tradePrice;
              btcMarket[i].changeRate = coinPrice.changeRate;
              btcMarket[i].signedChangeRate = coinPrice.signedChangeRate;
              btcMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
              btcMarket[i].askBid = coinPrice.askBid;
              break;
            }
          }
        }
      } else {
        if (!usdtMarket.any((cp) => cp.code == coinPrice.code) && !isSearch) {
          usdtMarket.add(coinPrice);
        } else {
          for (int i = 0; i < krwMarket.length; i++) {
            if (usdtMarket[i].code == coinPrice.code) {
              usdtMarket[i].tradePrice = coinPrice.tradePrice;
              usdtMarket[i].changeRate = coinPrice.changeRate;
              usdtMarket[i].signedChangeRate = coinPrice.signedChangeRate;
              usdtMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
              usdtMarket[i].askBid = coinPrice.askBid;
              break;
            }
          }
        }
      }
      isLoading = false;
      setState(() {});
    });
  }

  void getSortPrice(List<CoinPrice> coinList) {
    if (sortCoins[1]) {
      // 현재가 내림차순
      coinList.sort((b, a) => a.tradePrice.compareTo(b.tradePrice));
    } else if (!sortCoins[1]) {
      // 현재가 오름차순
      coinList.sort((a, b) => a.tradePrice.compareTo(b.tradePrice));
    }
  }

  void getSortChange(List<CoinPrice> coinList) {
    if (sortCoins[2]) {
      // 전일대비 내림차순
      coinList.sort((b, a) => a.signedChangeRate.compareTo(b.signedChangeRate));
    } else if (!sortCoins[2]) {
      // 전일대비 오름차순
      coinList.sort((a, b) => a.signedChangeRate.compareTo(b.signedChangeRate));
    }
  }

  void getSortVolum(List<CoinPrice> coinList) {
    if (sortCoins[3]) {
      // 거래대금 내림차순
      coinList.sort((b, a) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    } else if (!sortCoins[3]) {
      // 거래대금 오름차순
      coinList.sort((a, b) => a.accTradePrice24H.compareTo(b.accTradePrice24H));
    }
  }

  void filterMarketData(String searchText, List<CoinPrice> coinList) {}

  @override
  Widget build(BuildContext context) {
    Color baseColor = const Color.fromRGBO(253, 216, 53, 1);

    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        shadowColor: Colors.white,
        elevation: 0,
        titleSpacing: 10,
        backgroundColor: baseColor,
        leadingWidth: 10,
        title: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            "Market",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              color: Colors.black,
              onPressed: () {
                print("설정");
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            // 코인/심볼 검색
            Container(
              width: width,
              height: height * 0.17,
              color: Colors.yellow[600],
              child: Column(
                children: [
                  SizedBox(
                    width: width,
                    height: height * 0.09,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 3),
                      child: TextField(
                        controller: textEditingController,
                        onChanged: filterMarket,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search),
                          hintText: '코인/심볼명 입력',
                          hintStyle: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: width,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide())),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: Row(
                          children: [
                            ToggleButtons(
                              direction: Axis.horizontal,
                              onPressed: (int index) {
                                for (int i = 0;
                                    i < selectedMarkets.length;
                                    i++) {
                                  selectedMarkets[i] = i == index;
                                }
                                setState(() {});
                              },
                              selectedBorderColor: Colors.black,
                              selectedColor: Colors.white,
                              fillColor: Colors.grey[800],
                              color: Colors.grey[700],
                              constraints: const BoxConstraints(
                                minHeight: 35,
                                minWidth: 80,
                              ),
                              isSelected: selectedMarkets,
                              children: Markets,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 정렬바
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 0.3,
                                  child: InkWell(
                                    onTap: () {
                                      if (sortCoins[0]) {
                                        sortCoins[0] = false;
                                      } else if (!sortCoins[0]) {
                                        sortCoins[0] = true;
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          sortCoins[0] ? "한글명" : "영문명",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 3),
                                          child: Icon(
                                            Icons.swap_horiz,
                                            size: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.25,
                                  child: InkWell(
                                    onTap: () {
                                      if (sortCoins[1]) {
                                        sortCoins[1] = false;
                                      } else if (!sortCoins[1]) {
                                        sortCoins[1] = true;
                                      }
                                      if (selectedMarkets[0]) {
                                        getSortPrice(krwMarket);
                                      } else if (selectedMarkets[1]) {
                                        getSortPrice(btcMarket);
                                      } else if (selectedMarkets[2]) {
                                        getSortPrice(usdtMarket);
                                      }
                                      if (isSearch) {
                                        getSortPrice(filteredMarket);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "현재가",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: sortCoins[1]
                                              ? const Icon(
                                                  Icons.keyboard_arrow_up,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 16,
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.2,
                                  child: InkWell(
                                    onTap: () {
                                      if (sortCoins[2]) {
                                        sortCoins[2] = false;
                                      } else if (!sortCoins[2]) {
                                        sortCoins[2] = true;
                                      }
                                      if (selectedMarkets[0]) {
                                        getSortChange(krwMarket);
                                      } else if (selectedMarkets[1]) {
                                        getSortChange(btcMarket);
                                      } else if (selectedMarkets[2]) {
                                        getSortChange(usdtMarket);
                                      }
                                      if (isSearch) {
                                        getSortChange(filteredMarket);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "전일대비",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: sortCoins[2]
                                              ? const Icon(
                                                  Icons.keyboard_arrow_up,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 16,
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.25,
                                  child: InkWell(
                                    onTap: () {
                                      if (sortCoins[3]) {
                                        sortCoins[3] = false;
                                      } else if (!sortCoins[3]) {
                                        sortCoins[3] = true;
                                      }
                                      if (selectedMarkets[0]) {
                                        getSortVolum(krwMarket);
                                      } else if (selectedMarkets[1]) {
                                        getSortVolum(btcMarket);
                                      } else if (selectedMarkets[2]) {
                                        getSortVolum(usdtMarket);
                                      }
                                      if (isSearch) {
                                        getSortVolum(filteredMarket);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "거래대금",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: sortCoins[3]
                                              ? const Icon(
                                                  Icons.keyboard_arrow_up,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 16,
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        getMarketCoinList(
                            selectedMarkets: selectedMarkets,
                            krwMarket: krwMarket,
                            btcMarket: btcMarket,
                            usdtMarket: usdtMarket,
                            height: height,
                            width: width,
                            sortCoins: sortCoins,
                            isSearch: isSearch,
                            filteredMarket: filteredMarket),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void filterMarket(searchText) {
    filteredMarket.clear();
    if (searchText.isNotEmpty) {
      isSearch = true;
    } else {
      isSearch = false;
    }
    if (selectedMarkets[0]) {
      filteredMarket = krwMarket
          .where((coin) =>
              coin.koreanName.contains(searchText) ||
              coin.englishName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              coin.code
                  .split("-")[1]
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    } else if (selectedMarkets[1]) {
      filteredMarket = btcMarket
          .where((coin) =>
              coin.koreanName.contains(searchText) ||
              coin.englishName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              coin.code
                  .split("-")[1]
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    } else if (selectedMarkets[2]) {
      filteredMarket = usdtMarket
          .where((coin) =>
              coin.koreanName.contains(searchText) ||
              coin.englishName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              coin.code
                  .split("-")[1]
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }

    setState(() {});
  }
}
