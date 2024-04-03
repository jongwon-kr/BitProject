import 'package:flutter/services.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
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

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final channel =
      IOWebSocketChannel.connect(Uri.parse("wss://api.upbit.com/websocket/v1"));
  String coins = "";
  List<bool> selectedMarkets = [true, false, false];
  List<bool> sortCoins = [true, true, true, true];
  bool isLoading = true;
  Stopwatch stopwatch = Stopwatch();

  List<CoinPrice> krwMarket = <CoinPrice>[];
  List<CoinPrice> btcMarket = <CoinPrice>[];
  List<CoinPrice> usdtMarket = <CoinPrice>[];

  List<Widget> Markets = <Widget>[
    const Text('KRW'),
    const Text('BTC'),
    const Text('USDT')
  ];

  @override
  void initState() {
    super.initState();
    getCoins();
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
        if (!krwMarket.any((cp) => cp.code == coinPrice.code)) {
          krwMarket.add(coinPrice);
        } else {
          for (int i = 0; i < krwMarket.length; i++) {
            if (krwMarket[i].code == coinPrice.code) {
              krwMarket[i].tradePrice = coinPrice.tradePrice;
              krwMarket[i].changeRate = coinPrice.changeRate;
              krwMarket[i].signedChangeRate = coinPrice.signedChangeRate;
              krwMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
              break;
            }
          }
        }
      } else if (coinPrice.code.contains("BTC-")) {
        if (!btcMarket.any((cp) => cp.code == coinPrice.code)) {
          btcMarket.add(coinPrice);
        } else {
          for (int i = 0; i < krwMarket.length; i++) {
            if (btcMarket[i].code == coinPrice.code) {
              btcMarket[i].tradePrice = coinPrice.tradePrice;
              btcMarket[i].changeRate = coinPrice.changeRate;
              btcMarket[i].signedChangeRate = coinPrice.signedChangeRate;
              btcMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
              break;
            }
          }
        }
      } else {
        if (!usdtMarket.any((cp) => cp.code == coinPrice.code)) {
          usdtMarket.add(coinPrice);
        } else {
          for (int i = 0; i < krwMarket.length; i++) {
            if (usdtMarket[i].code == coinPrice.code) {
              usdtMarket[i].tradePrice = coinPrice.tradePrice;
              usdtMarket[i].changeRate = coinPrice.changeRate;
              usdtMarket[i].signedChangeRate = coinPrice.signedChangeRate;
              usdtMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
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
    for (var c in coinList) {
      print(c.changePrice);
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
                        onSubmitted: (Value) async {
                          int cnt = 0;
                          print('coinCount = $cnt');
                        },
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selectedMarkets[0]
                              ? krwMarket.length
                              : selectedMarkets[1]
                                  ? btcMarket.length
                                  : usdtMarket.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: height * 0.078,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(224, 224, 224, 1),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.3,
                                    child: Row(
                                      // 등락율에 따라서 battery_0,1,2,3 등등 게이지 조절 필요
                                      children: [
                                        selectedMarkets[0]
                                            ? changeRateBar(
                                                market: krwMarket,
                                                index: index,
                                              )
                                            : selectedMarkets[1]
                                                ? changeRateBar(
                                                    market: btcMarket,
                                                    index: index,
                                                  )
                                                : changeRateBar(
                                                    market: usdtMarket,
                                                    index: index,
                                                  ),
                                        // 코인 이름
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: width * 0.2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: RichText(
                                                        maxLines: 2,
                                                        strutStyle:
                                                            const StrutStyle(
                                                                fontSize: 16.0),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: false,
                                                        text: selectedMarkets[0]
                                                            ? sortCoins[0]
                                                                ? TextSpan(
                                                                    text: krwMarket[
                                                                            index]
                                                                        .koreanName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                                : TextSpan(
                                                                    text: krwMarket[
                                                                            index]
                                                                        .englishName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                            : selectedMarkets[1]
                                                                ? sortCoins[0]
                                                                    ? TextSpan(
                                                                        text: btcMarket[index]
                                                                            .koreanName,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      )
                                                                    : TextSpan(
                                                                        text: btcMarket[index]
                                                                            .englishName,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      )
                                                                : sortCoins[0]
                                                                    ? TextSpan(
                                                                        text: usdtMarket[index]
                                                                            .koreanName,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      )
                                                                    : TextSpan(
                                                                        text: usdtMarket[index]
                                                                            .englishName,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                selectedMarkets[0]
                                                    ? Text(
                                                        "${krwMarket[index].code.split("-")[1]}/${krwMarket[index].code.split("-")[0]}",
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.grey),
                                                      )
                                                    : selectedMarkets[1]
                                                        ? Text(
                                                            "${btcMarket[index].code.split("-")[1]}/${btcMarket[index].code.split("-")[0]}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .grey),
                                                          )
                                                        : Text(
                                                            "${usdtMarket[index].code.split("-")[1]}/${usdtMarket[index].code.split("-")[0]}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .grey),
                                                          )
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        selectedMarkets[2]
                                            ? formatTradePriceUsdt(
                                                market: usdtMarket,
                                                index: index)
                                            : selectedMarkets[0]
                                                ? formatTradePrice(
                                                    market: krwMarket,
                                                    index: index)
                                                : formatTradePrice(
                                                    market: btcMarket,
                                                    index: index)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // 999퍼센트까지 표시 가능
                                            selectedMarkets[0]
                                                ? krwMarket[index]
                                                        .signedChangeRate
                                                        .toString()
                                                        .contains('-')
                                                    ? Text(
                                                        "-${formatChangeRate(krwMarket, index)}"
                                                        "%",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blue[600],
                                                            fontSize: 13))
                                                    : Text(
                                                        "+${formatChangeRate(krwMarket, index)}"
                                                        "%",
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 13),
                                                      )
                                                : selectedMarkets[1]
                                                    ? btcMarket[index]
                                                            .signedChangeRate
                                                            .toString()
                                                            .contains('-')
                                                        ? Text(
                                                            "-${formatChangeRate(btcMarket, index)}"
                                                            "%",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue[600],
                                                                fontSize: 13))
                                                        : Text(
                                                            "+${formatChangeRate(btcMarket, index)}"
                                                            "%",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        13),
                                                          )
                                                    : usdtMarket[index]
                                                            .signedChangeRate
                                                            .toString()
                                                            .contains('-')
                                                        ? Text(
                                                            "-${formatChangeRate(usdtMarket, index)}"
                                                            "%",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue[600],
                                                                fontSize: 13))
                                                        : Text(
                                                            "+${formatChangeRate(usdtMarket, index)}"
                                                            "%",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        13),
                                                          ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // 거래대금
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              selectedMarkets[0]
                                                  ? formatAccTradePrice24HKRW(
                                                      market: krwMarket,
                                                      index: index)
                                                  : selectedMarkets[1]
                                                      ? formatAccTradePrice24HOther(
                                                          market: btcMarket,
                                                          index: index)
                                                      : formatAccTradePrice24HOther(
                                                          market: usdtMarket,
                                                          index: index)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
}
