import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/controller/market_controller.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/screen/market/widget/down_bar.dart';
import 'package:medicalapp/screen/market/widget/formatAccTradePrice24HKrw.dart';
import 'package:medicalapp/screen/market/widget/formatAccTradePrice24HOther.dart';
import 'package:medicalapp/screen/market/widget/formatSignedChangeRate.dart';
import 'package:medicalapp/screen/market/widget/formatTradePrice.dart';
import 'package:medicalapp/screen/market/widget/formatTradePriceUsdt.dart';
import 'package:medicalapp/screen/market/widget/rise_bar.dart';
import 'package:medicalapp/screen/trading/trading_screen.dart';

class MarketScreen extends StatelessWidget {
  final MarketController _controller = Get.put(MarketController());

  MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        shadowColor: Colors.white,
        elevation: 0,
        titleSpacing: 10,
        backgroundColor: Theme.of(context).primaryColor,
        leadingWidth: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.shopping_cart),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 32.0),
          child: Text(
            "Market",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                _controller.getCoins();
              },
              child: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              // 스크롤이 시작되었을 때 실행할 코드
              _controller.onPause();
            } else if (notification is ScrollUpdateNotification) {
              // 스크롤 중일 때 실행할 코드
              print("스크롤 중입니다.");
            } else if (notification is ScrollEndNotification) {
              // 스크롤이 끝났을 때 실행할 코드
              _controller.onResume();
            }
            return true;
          },
          child: SingleChildScrollView(
            controller: _controller.scrollController,
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * 0.13,
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
                            controller: _controller.textEditingController,
                            onChanged: _controller.filterMarket,
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
                            padding: const EdgeInsets.only(
                                left: 10, top: 5, bottom: 5),
                            child: Row(
                              children: [
                                ToggleButtons(
                                  direction: Axis.horizontal,
                                  onPressed: (int index) {
                                    _controller.toggleMarket(index);
                                  },
                                  selectedBorderColor: Colors.black,
                                  selectedColor: Colors.white,
                                  fillColor: Colors.grey[800],
                                  color: Colors.grey[700],
                                  constraints: const BoxConstraints(
                                    minHeight: 35,
                                    minWidth: 80,
                                  ),
                                  isSelected: _controller.selectedMarkets,
                                  children: _controller.markets,
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
                                padding:
                                    const EdgeInsets.only(bottom: 5, top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * 0.3,
                                      child: InkWell(
                                        onTap: () {
                                          _controller.toggleName();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _controller.sortCoins[0]
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
                                          _controller.togglePrice();
                                          _controller.getSortPrice();
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
                                              child: _controller.sortCoins[1]
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
                                          _controller.toggleChange();
                                          _controller.getSortChange();
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
                                              child: _controller.sortCoins[2]
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
                                          _controller.toggleVolume();
                                          _controller.getSortVolume();
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
                                              child: _controller.sortCoins[3]
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
                            GetBuilder<MarketController>(
                              builder: (_) => ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _controller.selectedMarket.length,
                                itemBuilder: (context, index) {
                                  var otherF = NumberFormat(
                                      '###,###,###,###.############');
                                  var usdtF =
                                      NumberFormat('###,###,###,###.###');
                                  return GestureDetector(
                                    onTap: () {
                                      CoinPrice coin;
                                      RxList<CoinPrice> market;
                                      coin = _controller.selectedMarket[index];
                                      market = _controller.selectedMarket;
                                      _controller.onPause();
                                      Get.to(
                                        () => TradingScreen(
                                          coin: coin,
                                          market: market,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: height * 0.078,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color.fromRGBO(
                                                224, 224, 224, 1),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: width * 0.3,
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      riseBar(
                                                          width: width,
                                                          height: height,
                                                          index: index,
                                                          market: _controller
                                                              .selectedMarket),
                                                      downBar(
                                                          width: width,
                                                          height: height,
                                                          index: index,
                                                          market: _controller
                                                              .selectedMarket)
                                                    ],
                                                  ),
                                                ),
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
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            child: RichText(
                                                              maxLines: 2,
                                                              strutStyle:
                                                                  const StrutStyle(
                                                                      fontSize:
                                                                          16.0),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: false,
                                                              text: TextSpan(
                                                                text: _controller
                                                                            .sortCoins[
                                                                        0]
                                                                    ? _controller
                                                                        .selectedMarket[
                                                                            index]
                                                                        .koreanName
                                                                    : _controller
                                                                        .selectedMarket[
                                                                            index]
                                                                        .englishName,
                                                                style: const TextStyle(
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
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "${_controller.selectedMarket[index].code.split("-")[1]}/${_controller.selectedMarket[index].code.split("-")[0]}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: height,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: _controller
                                                        .selectedMarket[index]
                                                        .askBid
                                                        .toLowerCase()
                                                        .contains("ask")
                                                    ? const BorderSide(
                                                        width: 1,
                                                        color: Colors.blue,
                                                      )
                                                    : const BorderSide(
                                                        width: 1,
                                                        color: Colors.red,
                                                      ),
                                              ),
                                            ),
                                            width: width * 0.25,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                _controller
                                                        .selectedMarket[index]
                                                        .code
                                                        .contains("USDT")
                                                    ? formatTradePriceUsdt(
                                                        market: _controller
                                                            .selectedMarket,
                                                        index: index)
                                                    : formatTradePrice(
                                                        market: _controller
                                                            .selectedMarket,
                                                        index: index),
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
                                                    _controller
                                                            .selectedMarket[
                                                                index]
                                                            .change
                                                            .toLowerCase()
                                                            .contains("fall")
                                                        ? Text(
                                                            "-${formatChangeRate(_controller.selectedMarket, index)}"
                                                            "%",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue[600],
                                                                fontSize: 13),
                                                          )
                                                        : _controller
                                                                .selectedMarket[
                                                                    index]
                                                                .change
                                                                .toLowerCase()
                                                                .contains(
                                                                    "rise")
                                                            ? Text(
                                                                "+${formatChangeRate(_controller.selectedMarket, index)}"
                                                                "%",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        13),
                                                              )
                                                            : Text(
                                                                "${formatChangeRate(_controller.selectedMarket, index)}"
                                                                "%",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                    _controller.selectedMarket[index].code
                                                            .contains("USDT")
                                                        ? _controller.selectedMarket[index].change
                                                                .toLowerCase()
                                                                .contains(
                                                                    "fall")
                                                            ? Text("-${usdtF.format(_controller.selectedMarket[index].changePrice)}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors.blue[
                                                                        600]))
                                                            : _controller.selectedMarket[index].change
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        "rise")
                                                                ? Text(
                                                                    "+${usdtF.format(_controller.selectedMarket[index].changePrice)}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .red),
                                                                  )
                                                                : Text(
                                                                    usdtF.format(_controller
                                                                        .selectedMarket[
                                                                            index]
                                                                        .changePrice),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                        : _controller
                                                                .selectedMarket[
                                                                    index]
                                                                .change
                                                                .toLowerCase()
                                                                .contains(
                                                                    "fall")
                                                            ? Text("-${otherF.format(_controller.selectedMarket[index].changePrice)}",
                                                                style: TextStyle(
                                                                    fontSize: 11,
                                                                    color: Colors.blue[600]))
                                                            : _controller.selectedMarket[index].change.toLowerCase().contains("rise")
                                                                ? Text(
                                                                    "+${otherF.format(_controller.selectedMarket[index].changePrice)}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .red),
                                                                  )
                                                                : Text(
                                                                    otherF.format(_controller
                                                                        .selectedMarket[
                                                                            index]
                                                                        .changePrice),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black),
                                                                  )
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      _controller
                                                              .selectedMarket[
                                                                  index]
                                                              .code
                                                              .contains("KRW")
                                                          ? formatAccTradePrice24HKRW(
                                                              market: _controller
                                                                  .selectedMarket,
                                                              index: index)
                                                          : formatAccTradePrice24HOther(
                                                              market: _controller
                                                                  .selectedMarket,
                                                              index: index)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
