import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:medicalapp/models/coinInfo_model.dart';
import 'package:medicalapp/screen/market/coin_price_info.dart';
import 'package:medicalapp/services/upbit_coin_info_all_api.dart';

class MarketScreen extends StatefulWidget {
  static String id = "chat_screen";

  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with AutomaticKeepAliveClientMixin {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isLogin = false;
  late User loggedInUser;
  String nickname = '';
  Color baseColor = const Color.fromRGBO(253, 216, 53, 1);
  String searchText = "";
  late Future<List<CoinInfoModel>> coinInfos =
      UpbitCoinInfoAllApi.getCoinInfoAll();
  late List<Map<String, dynamic>> coins;
  final List<bool> selectedMarkets = <bool>[true, false, false];
  List<Widget> Markets = <Widget>[
    const Text('KRW'),
    const Text('BTC'),
    const Text('관심목록')
  ];
  final List<bool> sortCoins = <bool>[
    true,
    true,
    true,
    true
  ]; // 한문,영문/ 현재가/ 전일대비/ 거래대금/
  @override
  bool get wantKeepAlive => true;

  final _isRunning = false;
  List<String> tickers = [];

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        isLogin = true;
      } else {
        isLogin = false;
      }
    } catch (e) {}
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로

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
              onPressed: () {},
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      width: width,
                      height: height * 0.08,
                      color: Colors.yellow[600],
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width * 0.5 - 20,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("총매수"),
                                          Text("매수값"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.5 - 20,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("평가손익"),
                                          Text("손익"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width * 0.5 - 20,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("총평가"),
                                          Text("평가"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.5 - 20,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("수익률"),
                                          Text("수익률"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: width,
              color: Colors.white,
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
                              setState(() {
                                for (int i = 0;
                                    i < selectedMarkets.length;
                                    i++) {
                                  selectedMarkets[i] = i == index;
                                }
                              });
                              print(selectedMarkets);
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
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
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
                                    setState(() {});
                                    print("object");
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "현재가",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Icon(
                                        Icons.swap_vert,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.2,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "전일대비",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Icon(
                                        Icons.swap_vert,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.25,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "거래대금",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Icon(
                                        Icons.swap_vert,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List<CoinInfoModel>>(
                    future: coinInfos,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return Column(
                          children: [
                            for (CoinInfoModel ci in snapshot.data)
                              getCurrentCoins(height, width, ci)
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container getCurrentCoins(
    double height,
    double width,
    CoinInfoModel ci,
  ) {
    if (selectedMarkets[0]) {
      if (ci.market.contains("KRW-")) {
        // 원화
        return getCoinContainer(height, width, ci);
      }
    } else if (selectedMarkets[1]) {
      // btc마켓
      if (ci.market.contains("BTC-")) {
        return getCoinContainer(height, width, ci);
      }
    } else if (selectedMarkets[2]) {
      return Container();
    } else {
      return Container();
    }
    return Container();
  }

  // 코인 목록
  getCoinContainer(double height, double width, CoinInfoModel ci) {
    return CoinPriceContainer(height, width, ci);
  }
}
