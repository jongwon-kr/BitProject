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
  late Timer _timer;
  var _isRunning = false;
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.record_voice_over_rounded),
        onPressed: () async => _clickButton(),
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

// 특정 버튼을 누르면 타이머를 시작합니다.
  void _clickButton() {
    _isRunning = !_isRunning;
    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

// Timer.periodic을 통해 setInterval과 같은 기능을 사용할 수 있습니다.
// 여기서는 1초마다 _time을 1씩 증가시키도록 했습니다.
  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      coinController.fetchPirces('KRW-SUI');
      print(coinController.coinPirces.value.tradePrice);
    });
  }

// 정지 버튼을 누르면 타이머를 정지합니다.aa
  void _pause() {
    _timer.cancel();
  }
}
