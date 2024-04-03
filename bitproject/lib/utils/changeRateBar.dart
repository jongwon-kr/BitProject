import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';

class changeRateBar extends StatelessWidget {
  const changeRateBar({
    super.key,
    required this.market,
    required this.index,
  });

  final int index;
  final List<CoinPrice> market;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: market[index].signedChangeRate.toString().contains("-")
          ? double.parse(formatChangeRate(market, index)) >= 30
              ? Icon(
                  Icons.battery_full,
                  color: Colors.blue[800],
                )
              : double.parse(formatChangeRate(market, index)) >= 25
                  ? Icon(
                      Icons.battery_6_bar,
                      color: Colors.blue[800],
                    )
                  : double.parse(formatChangeRate(market, index)) >= 20
                      ? Icon(
                          Icons.battery_5_bar,
                          color: Colors.blue[800],
                        )
                      : double.parse(formatChangeRate(market, index)) >= 15
                          ? Icon(
                              Icons.battery_4_bar,
                              color: Colors.blue[800],
                            )
                          : double.parse(formatChangeRate(market, index)) >= 10
                              ? Icon(
                                  Icons.battery_3_bar,
                                  color: Colors.blue[800],
                                )
                              : double.parse(formatChangeRate(market, index)) >=
                                      5
                                  ? Icon(
                                      Icons.battery_2_bar,
                                      color: Colors.blue[800],
                                    )
                                  : double.parse(
                                              formatChangeRate(market, index)) >
                                          0
                                      ? Icon(
                                          Icons.battery_0_bar,
                                          color: Colors.blue[800],
                                        )
                                      : Container()
          : double.parse(formatChangeRate(market, index)) >= 30
              ? Icon(
                  Icons.battery_full,
                  color: Colors.red[500],
                )
              : double.parse(formatChangeRate(market, index)) >= 25
                  ? Icon(
                      Icons.battery_5_bar,
                      color: Colors.red[500],
                    )
                  : double.parse(formatChangeRate(market, index)) >= 20
                      ? Icon(
                          Icons.battery_4_bar,
                          color: Colors.red[500],
                        )
                      : double.parse(formatChangeRate(market, index)) >= 15
                          ? Icon(
                              Icons.battery_3_bar,
                              color: Colors.red[500],
                            )
                          : double.parse(formatChangeRate(market, index)) >= 10
                              ? Icon(
                                  Icons.battery_2_bar,
                                  color: Colors.red[500],
                                )
                              : double.parse(formatChangeRate(market, index)) >=
                                      5
                                  ? Icon(
                                      Icons.battery_1_bar,
                                      color: Colors.red[500],
                                    )
                                  : Icon(
                                      Icons.battery_0_bar,
                                      color: Colors.red[500],
                                    ),
    );
  }
}
