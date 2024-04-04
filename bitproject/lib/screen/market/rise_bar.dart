import 'package:flutter/material.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';

class riseBar extends StatelessWidget {
  const riseBar({
    super.key,
    required this.width,
    required this.height,
    required this.index,
    required this.market,
  });

  final double width;
  final double height;
  final int index;
  final List<CoinPrice> market;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 13),
      child: market[index].change.toLowerCase().contains("rise")
          ? double.parse(formatChangeRate(market, index)) >= 12
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: const Border(
                        bottom: BorderSide(width: 15, color: Colors.red),
                      )),
                  width: width * 0.03,
                  height: height * 0.02,
                )
              : double.parse(formatChangeRate(market, index)) >= 10
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: const Border(
                            bottom: BorderSide(width: 12, color: Colors.red),
                          )),
                      width: width * 0.03,
                      height: height * 0.02,
                    )
                  : double.parse(formatChangeRate(market, index)) >= 8
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: const Border(
                                bottom:
                                    BorderSide(width: 10, color: Colors.red),
                              )),
                          width: width * 0.03,
                          height: height * 0.02,
                        )
                      : double.parse(formatChangeRate(market, index)) >= 6
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: const Border(
                                    bottom:
                                        BorderSide(width: 8, color: Colors.red),
                                  )),
                              width: width * 0.03,
                              height: height * 0.02,
                            )
                          : double.parse(formatChangeRate(market, index)) >= 4
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: const Border(
                                        bottom: BorderSide(
                                            width: 6, color: Colors.red),
                                      )),
                                  width: width * 0.03,
                                  height: height * 0.02,
                                )
                              : double.parse(formatChangeRate(market, index)) >=
                                      2
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: const Border(
                                            bottom: BorderSide(
                                                width: 4, color: Colors.red),
                                          )),
                                      width: width * 0.03,
                                      height: height * 0.02,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: const Border(
                                            bottom: BorderSide(
                                                width: 2, color: Colors.red),
                                          )),
                                      width: width * 0.03,
                                      height: height * 0.02,
                                    )
          : market[index].change.toLowerCase().contains("even")
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: const Border(
                        bottom: BorderSide(width: 0.5, color: Colors.black),
                      )),
                  width: width * 0.03,
                  height: height * 0.02,
                )
              : SizedBox(
                  width: width * 0.03,
                  height: height * 0.02,
                ),
    );
  }
}
