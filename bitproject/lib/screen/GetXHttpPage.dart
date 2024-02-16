import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetX;

import '../controller/coin_controller.dart';

// ignore: must_be_immutable
// lesswidget으로 바꿔도 됨
class GetXHttpPage extends StatefulWidget {
  const GetXHttpPage({super.key});

  @override
  State<GetXHttpPage> createState() => _GetXHttpPageState();
}

class _GetXHttpPageState extends State<GetXHttpPage> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  late Timer _timer;
  CoinController coinController = GetX.Get.put(CoinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: GetX.Obx(() => Text(GetX.Get.find<CoinController>()
              .coinPirces
              .value
              .tradePrice
              .toString())),
        ),
      ),
    );
  }

  // 위젯이 dispose될 때 _timer를 cancel합니다.
// ?. 옵셔널 체이닝을 통해 _timer가 null이 아닌 경우 cancel하도록 해줬습니다.
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

// Timer.periodic을 통해 setInterval과 같은 기능을 사용할 수 있습니다.
// 여기서는 1초마다 _time을 1씩 증가시키도록 했습니다.
  void fetchData() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      coinController.fetchPirces('KRW-SC');
      print(coinController.coinPirces.value.tradePrice);
      print("${coinController.coinPirces.value.signedChangeRate}??");
    });
  }

// 정지 버튼을 누르면 타이머를 정지합니다.aa
  void _pause() {
    _timer.cancel();
  }
}
