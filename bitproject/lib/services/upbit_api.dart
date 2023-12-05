import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medicalapp/model/coinInfo_model.dart';

class UpbitApi {
  static const String baseUrl = 'https://api.upbit.com';

  static Future<List<CoinInfoModel>> getCoinInfo() async {
    List<CoinInfoModel> coinInfoInstances = [];
    String url = '$baseUrl/v1/market/all';
    Map<String, String> headers = {
      "accept": "application/json",
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final coinInfos = jsonDecode(response.body);
      for (var coinInfo in coinInfos) {
        print(CoinInfoModel.fromJson(coinInfo));
        coinInfoInstances.add(CoinInfoModel.fromJson(coinInfo));
      }
    }
    return coinInfoInstances;
  }
}
