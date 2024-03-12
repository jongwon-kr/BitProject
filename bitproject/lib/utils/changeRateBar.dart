import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medicalapp/controller/coin_list_controller.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';

class changeRateBar extends StatelessWidget {
  const changeRateBar({
    super.key,
    required this.coinListController,
    required this.index,
  });
  final int index;
  final CoinListController coinListController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: coinListController.coinPriceList[index].first.signedChangeRate
              .toString()
              .contains("-")
          ? double.parse(formatChangeRate(coinListController, index)) >= 30
              ? Icon(
                  Icons.battery_full,
                  color: Colors.blue[800],
                )
              : double.parse(formatChangeRate(coinListController, index)) >= 25
                  ? Icon(
                      Icons.battery_6_bar,
                      color: Colors.blue[800],
                    )
                  : double.parse(formatChangeRate(coinListController, index)) >=
                          20
                      ? Icon(
                          Icons.battery_5_bar,
                          color: Colors.blue[800],
                        )
                      : double.parse(formatChangeRate(coinListController, index)) >=
                              15
                          ? Icon(
                              Icons.battery_4_bar,
                              color: Colors.blue[800],
                            )
                          : double.parse(formatChangeRate(
                                      coinListController, index)) >=
                                  10
                              ? Icon(
                                  Icons.battery_3_bar,
                                  color: Colors.blue[800],
                                )
                              : double.parse(formatChangeRate(
                                          coinListController, index)) >=
                                      5
                                  ? Icon(
                                      Icons.battery_2_bar,
                                      color: Colors.blue[800],
                                    )
                                  : double.parse(formatChangeRate(
                                              coinListController, index)) >
                                          0
                                      ? Icon(
                                          Icons.battery_0_bar,
                                          color: Colors.blue[800],
                                        )
                                      : Container()
          : double.parse(formatChangeRate(coinListController, index)) >= 30
              ? Icon(
                  Icons.battery_full,
                  color: Colors.red[500],
                )
              : double.parse(formatChangeRate(coinListController, index)) >= 25
                  ? Icon(
                      Icons.battery_5_bar,
                      color: Colors.red[500],
                    )
                  : double.parse(formatChangeRate(coinListController, index)) >= 20
                      ? Icon(
                          Icons.battery_4_bar,
                          color: Colors.red[500],
                        )
                      : double.parse(formatChangeRate(coinListController, index)) >= 15
                          ? Icon(
                              Icons.battery_3_bar,
                              color: Colors.red[500],
                            )
                          : double.parse(formatChangeRate(coinListController, index)) >= 10
                              ? Icon(
                                  Icons.battery_2_bar,
                                  color: Colors.red[500],
                                )
                              : double.parse(formatChangeRate(coinListController, index)) >= 5
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
