import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/controller/coin_list_controller.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/utils/formatAccTradePrice24HKrw.dart';
import 'package:medicalapp/utils/formatAccTradePrice24HOther.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';
import 'package:medicalapp/utils/formatTradePrice.dart';
import 'package:medicalapp/utils/formatTradePriceUsdt.dart';
import 'package:get/get.dart';

import 'down_bar.dart';
import 'rise_bar.dart';

class getMarketCoinList extends StatelessWidget {
  CoinListController controller = Get.put(CoinListController());

  getMarketCoinList({
    super.key,
    required this.selectedMarkets,
    required this.krwMarket,
    required this.btcMarket,
    required this.usdtMarket,
    required this.height,
    required this.width,
    required this.sortCoins,
    required this.isSearch,
    required this.filteredMarket,
  });

  final List<bool> selectedMarkets;
  final List<CoinPrice> krwMarket;
  final List<CoinPrice> btcMarket;
  final List<CoinPrice> usdtMarket;
  final List<CoinPrice> filteredMarket;
  final double height;
  final double width;
  final List<bool> sortCoins;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    var otherF = NumberFormat('###,###,###,###.############');
    var usdtF = NumberFormat('###,###,###,###.###');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: isSearch
          ? filteredMarket.length
          : selectedMarkets[0]
              ? krwMarket.length
              : selectedMarkets[1]
                  ? btcMarket.length
                  : usdtMarket.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Container(
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
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isSearch
                                ? riseBar(
                                    width: width,
                                    height: height,
                                    market: filteredMarket,
                                    index: index)
                                : selectedMarkets[0]
                                    ? riseBar(
                                        width: width,
                                        height: height,
                                        market: krwMarket,
                                        index: index)
                                    : selectedMarkets[1]
                                        ? riseBar(
                                            width: width,
                                            height: height,
                                            market: btcMarket,
                                            index: index)
                                        : riseBar(
                                            width: width,
                                            height: height,
                                            market: usdtMarket,
                                            index: index),
                            isSearch
                                ? downBar(
                                    width: width,
                                    height: height,
                                    market: filteredMarket,
                                    index: index)
                                : selectedMarkets[0]
                                    ? downBar(
                                        width: width,
                                        height: height,
                                        market: krwMarket,
                                        index: index)
                                    : selectedMarkets[1]
                                        ? downBar(
                                            width: width,
                                            height: height,
                                            market: btcMarket,
                                            index: index)
                                        : downBar(
                                            width: width,
                                            height: height,
                                            market: usdtMarket,
                                            index: index),
                          ],
                        ),
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
                                    text: isSearch
                                        ? sortCoins[0]
                                            ? TextSpan(
                                                text: filteredMarket[index]
                                                    .koreanName,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              )
                                            : TextSpan(
                                                text: filteredMarket[index]
                                                    .englishName,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              )
                                        : selectedMarkets[0]
                                            ? sortCoins[0]
                                                ? TextSpan(
                                                    text: krwMarket[index]
                                                        .koreanName,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  )
                                                : TextSpan(
                                                    text: krwMarket[index]
                                                        .englishName,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  )
                                            : selectedMarkets[1]
                                                ? sortCoins[0]
                                                    ? TextSpan(
                                                        text: btcMarket[index]
                                                            .koreanName,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      )
                                                    : TextSpan(
                                                        text: btcMarket[index]
                                                            .englishName,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      )
                                                : sortCoins[0]
                                                    ? TextSpan(
                                                        text: usdtMarket[index]
                                                            .koreanName,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      )
                                                    : TextSpan(
                                                        text: usdtMarket[index]
                                                            .englishName,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                isSearch
                                    ? Text(
                                        "${krwMarket[index].code.split("-")[1]}/${krwMarket[index].code.split("-")[0]}",
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      )
                                    : selectedMarkets[0]
                                        ? Text(
                                            "${krwMarket[index].code.split("-")[1]}/${krwMarket[index].code.split("-")[0]}",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          )
                                        : selectedMarkets[1]
                                            ? Text(
                                                "${btcMarket[index].code.split("-")[1]}/${btcMarket[index].code.split("-")[0]}",
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey),
                                              )
                                            : Text(
                                                "${usdtMarket[index].code.split("-")[1]}/${usdtMarket[index].code.split("-")[0]}",
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey),
                                              )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: isSearch
                          ? filteredMarket[index]
                                  .askBid
                                  .toLowerCase()
                                  .contains("ask")
                              ? const BorderSide(
                                  width: 2,
                                  color: Colors.blue,
                                )
                              : const BorderSide(
                                  width: 2,
                                  color: Colors.red,
                                )
                          : selectedMarkets[0]
                              ? krwMarket[index]
                                      .askBid
                                      .toLowerCase()
                                      .contains("ask")
                                  ? const BorderSide(
                                      width: 2,
                                      color: Colors.blue,
                                    )
                                  : const BorderSide(
                                      width: 2,
                                      style: BorderStyle.solid,
                                      color: Colors.red,
                                    )
                              : selectedMarkets[1]
                                  ? btcMarket[index]
                                          .askBid
                                          .toLowerCase()
                                          .contains("ask")
                                      ? const BorderSide(
                                          width: 2,
                                          color: Colors.blue,
                                        )
                                      : const BorderSide(
                                          width: 2,
                                          color: Colors.red,
                                        )
                                  : selectedMarkets[2]
                                      ? usdtMarket[index]
                                              .askBid
                                              .toLowerCase()
                                              .contains("ask")
                                          ? const BorderSide(
                                              width: 2,
                                              color: Colors.blue,
                                            )
                                          : const BorderSide(
                                              width: 2,
                                              color: Colors.red,
                                            )
                                      : const BorderSide(),
                    ),
                  ),
                  width: width * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isSearch
                          ? selectedMarkets[2]
                              ? formatTradePriceUsdt(
                                  market: filteredMarket, index: index)
                              : formatTradePrice(
                                  market: filteredMarket, index: index)
                          : selectedMarkets[2]
                              ? formatTradePriceUsdt(
                                  market: usdtMarket, index: index)
                              : selectedMarkets[0]
                                  ? formatTradePrice(
                                      market: krwMarket, index: index)
                                  : formatTradePrice(
                                      market: btcMarket, index: index)
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
                          isSearch
                              ? filteredMarket[index]
                                      .change
                                      .toLowerCase()
                                      .contains("fall")
                                  ? Text(
                                      "-${formatChangeRate(filteredMarket, index)}"
                                      "%",
                                      style: TextStyle(
                                          color: Colors.blue[600],
                                          fontSize: 13))
                                  : filteredMarket[index]
                                          .change
                                          .toLowerCase()
                                          .contains("rise")
                                      ? Text(
                                          "+${formatChangeRate(filteredMarket, index)}"
                                          "%",
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 13),
                                        )
                                      : Text(
                                          "${formatChangeRate(filteredMarket, index)}"
                                          "%",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        )
                              : selectedMarkets[0]
                                  ? krwMarket[index]
                                          .change
                                          .toLowerCase()
                                          .contains("fall")
                                      ? Text(
                                          "-${formatChangeRate(krwMarket, index)}"
                                          "%",
                                          style: TextStyle(
                                              color: Colors.blue[600],
                                              fontSize: 13))
                                      : krwMarket[index]
                                              .change
                                              .toLowerCase()
                                              .contains("rise")
                                          ? Text(
                                              "+${formatChangeRate(krwMarket, index)}"
                                              "%",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 13),
                                            )
                                          : Text(
                                              "${formatChangeRate(krwMarket, index)}"
                                              "%",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            )
                                  : selectedMarkets[1]
                                      ? btcMarket[index]
                                              .change
                                              .toLowerCase()
                                              .contains("fall")
                                          ? Text(
                                              "-${formatChangeRate(btcMarket, index)}"
                                              "%",
                                              style: TextStyle(
                                                  color: Colors.blue[600],
                                                  fontSize: 13))
                                          : btcMarket[index]
                                                  .change
                                                  .toLowerCase()
                                                  .contains("rise")
                                              ? Text(
                                                  "+${formatChangeRate(btcMarket, index)}"
                                                  "%",
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 13),
                                                )
                                              : Text(
                                                  "${formatChangeRate(btcMarket, index)}"
                                                  "%",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                )
                                      : usdtMarket[index]
                                              .change
                                              .toLowerCase()
                                              .contains("fall")
                                          ? Text(
                                              "-${formatChangeRate(usdtMarket, index)}"
                                              "%",
                                              style: TextStyle(
                                                  color: Colors.blue[600],
                                                  fontSize: 13))
                                          : usdtMarket[index]
                                                  .change
                                                  .toLowerCase()
                                                  .contains("rise")
                                              ? Text(
                                                  "+${formatChangeRate(usdtMarket, index)}"
                                                  "%",
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 13),
                                                )
                                              : Text(
                                                  "${formatChangeRate(usdtMarket, index)}"
                                                  "%",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                ),
                          isSearch
                              ? selectedMarkets[0]
                                  ? filteredMarket[index]
                                          .change
                                          .toLowerCase()
                                          .contains("fall")
                                      ? Text("-${otherF.format(filteredMarket[index].changePrice)}",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.blue[600]))
                                      : filteredMarket[index]
                                              .change
                                              .toLowerCase()
                                              .contains("rise")
                                          ? Text(
                                              "+${otherF.format(filteredMarket[index].changePrice)}",
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.red),
                                            )
                                          : Text(
                                              otherF.format(
                                                  filteredMarket[index]
                                                      .changePrice),
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black),
                                            )
                                  : selectedMarkets[1]
                                      ? filteredMarket[index]
                                              .change
                                              .toLowerCase()
                                              .contains("fall")
                                          ? Text("-${otherF.format(filteredMarket[index].changePrice)}",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.blue[600]))
                                          : filteredMarket[index]
                                                  .change
                                                  .toLowerCase()
                                                  .contains("rise")
                                              ? Text(
                                                  "+${otherF.format(filteredMarket[index].changePrice)}",
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.red),
                                                )
                                              : Text(
                                                  otherF.format(
                                                      filteredMarket[index]
                                                          .changePrice),
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black),
                                                )
                                      : filteredMarket[index]
                                              .change
                                              .toLowerCase()
                                              .contains("fall")
                                          ? Text("-${usdtF.format(filteredMarket[index].changePrice)}",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.blue[600]))
                                          : filteredMarket[index]
                                                  .change
                                                  .toLowerCase()
                                                  .contains("rise")
                                              ? Text(
                                                  "+${usdtF.format(filteredMarket[index].changePrice)}",
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.red),
                                                )
                                              : Text(
                                                  usdtF.format(
                                                      filteredMarket[index]
                                                          .changePrice),
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black),
                                                )
                              : selectedMarkets[0]
                                  ? krwMarket[index]
                                          .change
                                          .toLowerCase()
                                          .contains("fall")
                                      ? Text("-${otherF.format(krwMarket[index].changePrice)}",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.blue[600]))
                                      : krwMarket[index]
                                              .change
                                              .toLowerCase()
                                              .contains("rise")
                                          ? Text(
                                              "+${otherF.format(krwMarket[index].changePrice)}",
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.red),
                                            )
                                          : Text(
                                              otherF.format(
                                                  krwMarket[index].changePrice),
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black),
                                            )
                                  : selectedMarkets[1]
                                      ? btcMarket[index].change.toLowerCase().contains("fall")
                                          ? Text("-${otherF.format(btcMarket[index].changePrice)}", style: TextStyle(fontSize: 11, color: Colors.blue[600]))
                                          : btcMarket[index].change.toLowerCase().contains("rise")
                                              ? Text(
                                                  "+${otherF.format(btcMarket[index].changePrice)}",
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.red),
                                                )
                                              : Text(
                                                  otherF.format(btcMarket[index]
                                                      .changePrice),
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black),
                                                )
                                      : usdtMarket[index].change.toLowerCase().contains("fall")
                                          ? Text("-${usdtF.format(usdtMarket[index].changePrice)}", style: TextStyle(fontSize: 11, color: Colors.blue[600]))
                                          : usdtMarket[index].change.toLowerCase().contains("rise")
                                              ? Text(
                                                  "+${usdtF.format(usdtMarket[index].changePrice)}",
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.red),
                                                )
                                              : Text(
                                                  usdtF.format(usdtMarket[index]
                                                      .changePrice),
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black),
                                                )
                        ],
                      ),
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
                            isSearch
                                ? selectedMarkets[0]
                                    ? formatAccTradePrice24HKRW(
                                        market: filteredMarket, index: index)
                                    : formatAccTradePrice24HOther(
                                        market: filteredMarket, index: index)
                                : selectedMarkets[0]
                                    ? formatAccTradePrice24HKRW(
                                        market: krwMarket, index: index)
                                    : selectedMarkets[1]
                                        ? formatAccTradePrice24HOther(
                                            market: btcMarket, index: index)
                                        : formatAccTradePrice24HOther(
                                            market: usdtMarket, index: index)
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
    );
  }
}
