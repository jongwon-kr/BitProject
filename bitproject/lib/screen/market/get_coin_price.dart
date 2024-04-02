import 'package:flutter/material.dart';
import 'package:medicalapp/controller/coin_list_controller.dart';
import 'package:medicalapp/utils/changeRateBar.dart';
import 'package:medicalapp/utils/formatAccTradePrice24H.dart';
import 'package:medicalapp/utils/formatSignedChangeRate.dart';
import 'package:medicalapp/utils/formatTradePrice.dart';

class getCoinPrice extends StatelessWidget {
  const getCoinPrice({
    super.key,
    required this.coinListController,
    required this.height,
    required this.width,
  });

  final CoinListController coinListController;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coinListController.coinPriceList.length,
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
                                  strutStyle: const StrutStyle(fontSize: 16.0),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  text: TextSpan(
                                    text: coinListController.sortCoins[0]
                                        ? coinListController
                                            .coinPriceList[index].first.change
                                        : coinListController
                                            .coinPriceList[index].first.change,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${coinListController.coinPriceList[index].first.code.split("-")[1]}/${coinListController.coinPriceList[index].first.code.split("-")[0]}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
              SizedBox(
                width: width * 0.2,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 999퍼센트까지 표시 가능
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: width * 0.25,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 거래대금
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
