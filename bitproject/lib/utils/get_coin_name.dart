import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicalapp/models/coin_price_model.dart';

class getCoinName extends StatelessWidget {
  const getCoinName({
    super.key,
    required this.market,
    required this.index,
  });
  final List<CoinPrice> market;
  final int index;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // 화면의 가로
    return Column(
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
                    text: market[index].code,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Text(
              "${market[index].code.split("-")[1]}/${market[index].code.split("-")[0]}",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
