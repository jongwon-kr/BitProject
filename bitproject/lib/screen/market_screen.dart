import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/controller/coin_list_controller.dart';
import 'package:medicalapp/utils/changeRateBar.dart';
import 'package:medicalapp/utils/formatAccTradePrice24H.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';

class MarketScreen extends StatelessWidget {
  final CoinListController coinListController = Get.put(CoinListController());
  MarketScreen({super.key});
  Color baseColor = const Color.fromRGBO(253, 216, 53, 1);
  late List<Map<String, dynamic>> coins;
  List<Widget> Markets = <Widget>[
    const Text('KRW'),
    const Text('BTC'),
    const Text('관심목록')
  ];

  // 한문,영문/ 현재가/ 전일대비/ 거래대금/

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로

    return Obx(
      () => Scaffold(
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
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
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
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide())),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, bottom: 5),
                          child: Row(
                            children: [
                              ToggleButtons(
                                direction: Axis.horizontal,
                                onPressed: (int index) {
                                  for (int i = 0;
                                      i <
                                          coinListController
                                              .selectedMarkets.length;
                                      i++) {
                                    coinListController.selectedMarkets[i] =
                                        i == index;
                                  }
                                  coinListController.fetchCoinPriceList();
                                },
                                selectedBorderColor: Colors.black,
                                selectedColor: Colors.white,
                                fillColor: Colors.grey[800],
                                color: Colors.grey[700],
                                constraints: const BoxConstraints(
                                  minHeight: 35,
                                  minWidth: 80,
                                ),
                                isSelected: coinListController.selectedMarkets,
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
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.3,
                                    child: InkWell(
                                      onTap: () {
                                        if (coinListController.sortCoins[0]) {
                                          coinListController.sortCoins[0] =
                                              false;
                                        } else if (!coinListController
                                            .sortCoins[0]) {
                                          coinListController.sortCoins[0] =
                                              true;
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            coinListController.sortCoins[0]
                                                ? "한글명"
                                                : "영문명",
                                            style:
                                                const TextStyle(fontSize: 13),
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
                                        if (coinListController.sortCoins[1]) {
                                          coinListController.sortCoins[1] =
                                              false;
                                        } else if (!coinListController
                                            .sortCoins[1]) {
                                          coinListController.sortCoins[1] =
                                              true;
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
                                            child: coinListController
                                                    .sortCoins[1]
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
                                        if (coinListController.sortCoins[2]) {
                                          coinListController.sortCoins[2] =
                                              false;
                                        } else if (!coinListController
                                            .sortCoins[2]) {
                                          coinListController.sortCoins[2] =
                                              true;
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
                                            child: coinListController
                                                    .sortCoins[2]
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
                                        if (coinListController.sortCoins[3]) {
                                          coinListController.sortCoins[3] =
                                              false;
                                        } else if (!coinListController
                                            .sortCoins[3]) {
                                          coinListController.sortCoins[3] =
                                              true;
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
                                            child: coinListController
                                                    .sortCoins[3]
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
                        ],
                      ),
                      coinListController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  coinListController.coinPriceList.length,
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
                                              coinListController:
                                                  coinListController,
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
                                                                  fontSize:
                                                                      16.0),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: false,
                                                          text: TextSpan(
                                                            text: coinListController
                                                                        .sortCoins[
                                                                    0]
                                                                ? coinListController
                                                                    .coinPriceList[
                                                                        index]
                                                                    .first
                                                                    .koreanName
                                                                : coinListController
                                                                    .coinPriceList[
                                                                        index]
                                                                    .first
                                                                    .englishName,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${coinListController.coinPriceList[index].first.market.split("-")[1]}/${coinListController.coinPriceList[index].first.market.split("-")[0]}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              coinListController
                                                  .coinPriceList[index]
                                                  .first
                                                  .tradePrice
                                                  .toString(),
                                            ),
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
                                                coinListController
                                                        .coinPriceList[index]
                                                        .first
                                                        .signedChangeRate
                                                        .toString()
                                                        .contains('-')
                                                    ? Text(
                                                        "-${formatChangeRate(coinListController, index)}"
                                                        "%",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blue[600],
                                                            fontSize: 13))
                                                    : Text(
                                                        "+${formatChangeRate(coinListController, index)}"
                                                        "%",
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 13),
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
                                            // 거래대금
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  coinListController
                                                          .selectedMarkets[0]
                                                      ? formatAccTradePrice24H(
                                                          coinListController:
                                                              coinListController,
                                                          index: index)
                                                      : Text(
                                                          "${coinListController.coinPriceList[index].first.accTradePrice24H.toStringAsFixed(3)}BTC")
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
