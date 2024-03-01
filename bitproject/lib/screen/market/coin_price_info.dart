import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetX;
import 'package:intl/intl.dart';
import 'package:medicalapp/controller/coin_controller.dart';
import 'package:medicalapp/models/coinInfo_model.dart';
import 'package:medicalapp/services/upbit_coin_info_all_api.dart';

Container CoinPriceContainer(double height, double width, CoinInfoModel ci) {
  late Future<List<CoinInfoModel>> coinInfos =
      UpbitCoinInfoAllApi.getCoinInfoAll();
  List<String> tickers = [];

  var f = NumberFormat('###,###,###,###');
  late Timer timer;
  CoinController coinController =
      GetX.Get.put(CoinController()); // 이 부분을 수정합니다.
  final List<bool> sortCoins = <bool>[
    true,
    true,
    true,
    true
  ]; // 한문,영문/ 현재가/ 전일대비/ 거래대금
  void fetchData() async {
    for (CoinInfoModel ticker in await coinInfos) {
      tickers.add(ticker.market);
    }
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      coinController.fetchPirces(tickers);
      for (CoinInfoModel cm in coinController.coinPriceList) {}
    });
  }

  fetchData();

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
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(Icons.candlestick_chart),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GetX.Obx(
                          () => Text(
                            coinController.coinPriceList.first.value.market
                                .toString(),
                          ),
                        ),
                        // Flexible(
                        //   child: RichText(
                        //     maxLines: 2,
                        //     strutStyle: const StrutStyle(fontSize: 16.0),
                        //     overflow: TextOverflow.ellipsis,
                        //     softWrap: false,
                        //     text: TextSpan(
                        //       text: sortCoins[0]
                        //           ? ci.korean_name
                        //           : ci.english_name,
                        //       style: const TextStyle(
                        //           fontSize: 14, color: Colors.black),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${ci.market.split("-")[1]}/${ci.market.split("-")[0]}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
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
              GetX.Obx(
                () => Text(
                  coinController.coinPriceList.first.value.tradePrice
                      .toString(),
                ),
              ),
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
                  GetX.Obx(
                    () => coinController
                            .coinPriceList.first.value.signedChangeRate
                            .toString()
                            .contains('-')
                        ? Text(
                            '${'-${"${coinController.coinPriceList.first.value.signedChangeRate.toString().split('.')[0].replaceFirst('0', '').replaceAll('-', '') + coinController.coinPirces.value.signedChangeRate.toStringAsFixed(4).split(".")[1].substring(0, 2).replaceFirst(RegExp(r'00'), '0')}.${coinController.coinPirces.value.signedChangeRate.toStringAsFixed(4).split(".")[1].substring(2, 4)}"}'}%',
                            style: TextStyle(
                                color: Colors.blue[600], fontSize: 13))
                        : Text(
                            '${'+${"${coinController.coinPriceList.first.value.signedChangeRate.toString().split('.')[0].replaceFirst('0', '').replaceAll('+', '') + coinController.coinPirces.value.signedChangeRate.toStringAsFixed(4).split(".")[1].substring(0, 2).replaceFirst(RegExp(r'00'), '0')}.${coinController.coinPirces.value.signedChangeRate.toStringAsFixed(4).split(".")[1].substring(2, 4)}"}'}%',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13),
                          ),
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
              GetX.Obx(
                () => Text(
                  "${f.format(int.parse(coinController.coinPriceList.first.value.acctradePrice24h.toStringAsFixed(0).substring(0, coinController.coinPirces.value.acctradePrice24h.toStringAsFixed(0).length - 6)))}백만",
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
