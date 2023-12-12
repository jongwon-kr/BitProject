import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetX;
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medicalapp/models/coin_price_model.dart';

class GetXHttpPage extends StatefulWidget {
  bool isRunning = false;

  GetXHttpPage({super.key});

  @override
  State<GetXHttpPage> createState() => _GetXHttpPageState();
}

class _GetXHttpPageState extends State<GetXHttpPage> {
  final GetXHttp _getXController = GetX.Get.put(GetXHttp());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetX.Obx(() => Text(_getXController.data.string)),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.record_voice_over_rounded),
        onPressed: () async => await _getXController.connectServer(),
      ),
    );
  }
}

// Use http Package
class GetXHttp extends GetX.GetxController {
  late GetX.RxDouble data = 0.0.obs;
  final String _url = "https://api.upbit.com/v1/ticker?markets=KRW-BTC";

  Future<void> connectServer() async {
    final http.Response res = await http.get(Uri.parse(_url));
    final coinPrice = jsonDecode(res.body);
    for (var coinPirce in coinPrice) {
      data = RxDouble(CoinPirceModel.fromJson(coinPirce).trade_price);
    }
    return;
  }
}

class GetXHttpPage2 extends StatelessWidget {
  final GetXHttp2 _getXController2 = GetX.Get.put(GetXHttp2());

  GetXHttpPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetXHttp'),
        actions: [
          IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () {
                // [ Navigator ]
                GetX.Get.back();
              })
        ],
      ),
      body: Center(
        child: GetX.Obx(() => Text(_getXController2.data.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.record_voice_over_rounded),
        onPressed: () async => await _getXController2.connectServer(),
      ),
    );
  }
}

// Built-in
class GetXHttp2 extends GetX.GetConnect {
  final GetX.RxList<dynamic> data = [].obs;
  final String _url = "https://api.upbit.com/v1/market/all";

  Future<void> connectServer() async {
    if (data.isEmpty) {
      GetX.Response<String> res = await get(_url);
      final List result = json.decode(res.body!);
      // ignore: unnecessary_statements
      data + result;
    } else {
      data.clear();
    }
    return;
  }
}
