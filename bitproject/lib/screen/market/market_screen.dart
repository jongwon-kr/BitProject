import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:medicalapp/models/coinInfo_model.dart';
import 'package:medicalapp/services/upbit_api.dart';

class MarketScreen extends StatefulWidget {
  static String id = "chat_screen";

  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isLogin = false;
  late User loggedInUser;
  String nickname = '';
  Color baseColor = const Color.fromRGBO(253, 216, 53, 1);
  String searchText = "";
  late Future<List<CoinInfoModel>> coinInfos;
  late List<Map<String, dynamic>> coins;
  int currentPageIndex = 0;
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

  void getCurrentCoins() async {
    coinInfos = UpbitApi.getCoinInfoAll();
  }

  @override
  void initState() {
    getCurrentUser();
    getCurrentCoins();
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
                      height: height * 0.07,
                      color: Colors.yellow[500],
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
                          padding: const EdgeInsets.only(
                              left: 20, bottom: 10, right: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.30,
                                child: const Row(
                                  children: [
                                    Text("한문명"),
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Icon(
                                        Icons.swap_horiz,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.23,
                                child: const Row(
                                  children: [
                                    Text("현재가"),
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
                                width: width * 0.18,
                                child: const Row(
                                  children: [
                                    Text("전일 대비"),
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
                                width: width * 0.18,
                                child: const Row(
                                  children: [
                                    Text("거래 대금"),
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
                              getCurrentCoin(height, width, ci)
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

  Container getCurrentCoin(
    double height,
    double width,
    CoinInfoModel ci,
  ) {
    if (selectedMarkets[0]) {
      if (ci.market.contains("KRW-")) {
        return Container(
          height: height * 0.06,
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.3,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(Icons.candlestick_chart),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              sortCoins[0] ? ci.korean_name : ci.english_name,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              ci.market.substring(4),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.25,
                  child: const Row(
                    children: [
                      Text("50,000,000"),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.14,
                  child: const Row(
                    children: [
                      Text("-300%"),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.20,
                  child: const Row(
                    children: [
                      Text("504,201백만"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else if (selectedMarkets[1]) {
      if (ci.market.contains("BTC-")) {}
    } else if (selectedMarkets[2]) {
      return Container();
    } else {
      return Container();
    }
    return Container();
  }
}
