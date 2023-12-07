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
    print(response.body);
    if (response.statusCode == 200) {
      final coinInfos = jsonDecode(response.body);
      for (var coinInfo in coinInfos) {
        String market = coinInfo['market'];
        String koreanName = coinInfo['korean_name'];
        String englishName = coinInfo['english_name'];
        print(
            'Market: $market, Korean Name: $koreanName, English Name: $englishName');
        coinInfoInstances.add(CoinInfoModel.fromJson(coinInfo));
      }
    }
    return coinInfoInstances;
  }
}
