import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_list_model.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/utils/changeRateBar.dart';
import 'package:medicalapp/utils/formatAccTradePrice24H.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';
import 'package:medicalapp/utils/formatTradePrice.dart';

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
  List<CoinPrice> krwMarket = [];
  List<CoinPrice> btcMarket = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoins();
    streamListener();
  }

  void streamListener() {}

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
    streamListen();
  }

  void streamListen() {
    channel.stream.listen((message) {
      Map<String, dynamic> jsonData =
          json.decode(String.fromCharCodes(message));
      CoinPrice coinPrice = CoinPrice.fromJson(jsonData);
      if (coinPrice.code.contains("KRW-")) {
        if (!krwMarket.any((cp) => cp.code == coinPrice.code)) {
          krwMarket.add(coinPrice);
        } else {
          int index = -1;
          for (int i = 0; i < krwMarket.length; i++) {
            if (krwMarket[i].code == coinPrice.code) {
              krwMarket[i].tradePrice = coinPrice.tradePrice;
              krwMarket[i].changeRate = coinPrice.changeRate;
              krwMarket[i].accTradePrice24H = coinPrice.accTradePrice24H;
              krwMarket[i].signedChangeRate = coinPrice.signedChangeRate;
              index = i;
              break;
            }
          }
          print(index);
        }
      } else if (coinPrice.code.contains("BTC-")) {
        if (!btcMarket.any((cp) => cp.code == coinPrice.code)) {
          btcMarket.add(coinPrice);
        }
      }
      print(coinPrice.code);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: krwMarket.length,
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
                        changeRateBar(
                          market: krwMarket,
                          index: index,
                        ),
                        // 코인 이름
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * 0.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: RichText(
                                      maxLines: 2,
                                      strutStyle:
                                          const StrutStyle(fontSize: 16.0),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      text: TextSpan(
                                        text: krwMarket[index].code,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${krwMarket[index].code.split("-")[1]}/${krwMarket[index].code.split("-")[0]}",
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        formatTradePrice(market: krwMarket, index: index),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 999퍼센트까지 표시 가능
                            krwMarket[index]
                                    .signedChangeRate
                                    .toString()
                                    .contains('-')
                                ? Text(
                                    "-${formatChangeRate(krwMarket, index)}"
                                    "%",
                                    style: TextStyle(
                                        color: Colors.blue[600], fontSize: 13))
                                : Text(
                                    "+${formatChangeRate(krwMarket, index)}"
                                    "%",
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 거래대금
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              formatAccTradePrice24H(
                                  market: krwMarket, index: index)
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
      ),
    );
  }
}
