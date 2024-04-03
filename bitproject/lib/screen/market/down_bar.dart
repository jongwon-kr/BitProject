import 'package:flutter/material.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';

class downBar extends StatelessWidget {
  const downBar({
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
      padding: const EdgeInsets.only(left: 10, bottom: 10, right: 13),
      child: market[index].signedChangeRate < 0
          ? double.parse(formatChangeRate(market, index)) >= 12
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: const Border(
                        top: BorderSide(width: 15, color: Colors.blue),
                      )),
                  width: width * 0.03,
                  height: height * 0.02,
                )
              : double.parse(formatChangeRate(market, index)) >= 10
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: const Border(
                            top: BorderSide(width: 12, color: Colors.blue),
                          )),
                      width: width * 0.03,
                      height: height * 0.02,
                    )
                  : double.parse(formatChangeRate(market, index)) >= 8
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: const Border(
                                top: BorderSide(width: 10, color: Colors.blue),
                              )),
                          width: width * 0.03,
                          height: height * 0.02,
                        )
                      : double.parse(formatChangeRate(market, index)) >= 6
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: const Border(
                                    top: BorderSide(
                                        width: 8, color: Colors.blue),
                                  )),
                              width: width * 0.03,
                              height: height * 0.02,
                            )
                          : double.parse(formatChangeRate(market, index)) >= 4
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: const Border(
                                        top: BorderSide(
                                            width: 6, color: Colors.blue),
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
                                            top: BorderSide(
                                                width: 4, color: Colors.blue),
                                          )),
                                      width: width * 0.03,
                                      height: height * 0.02,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: const Border(
                                            top: BorderSide(
                                                width: 2, color: Colors.blue),
                                          )),
                                      width: width * 0.03,
                                      height: height * 0.02,
                                    )
          : Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: const Border(
                    top: BorderSide(width: 0.1, color: Colors.blue),
                  )),
              width: width * 0.03,
              height: height * 0.02,
            ),
    );
  }
}
