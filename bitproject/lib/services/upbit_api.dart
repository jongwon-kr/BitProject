import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coinInfo_model.dart';

class UpbitApi {
  static const String baseUrl = 'https://api.upbit.com';

  static Future<List<CoinInfoModel>> getCoinInfo() async {
    List<CoinInfoModel> coinInfoInstances = [];
    String url = '$baseUrl/v1/candles/minutes/1?market=KRW-BTC&count=2';
    Map<String, String> headers = {
      "accept": "application/json",
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      final coinInfos = jsonDecode(response.body);
      for (var coinInfo in coinInfos) {
        String market = coinInfo['market'];
        String candleDateTimeKst = coinInfo['candle_date_time_kst'];
        double openingPrice = coinInfo['opening_price'];
        double highPrice = coinInfo['high_price'];
        double lowPrice = coinInfo['low_price'];
        double tradePrice = coinInfo['trade_price'];
        double candleAccTradePrice = coinInfo['candle_acc_trade_price'];
        double candleAccTradeVolume = coinInfo['candle_acc_trade_volume'];
        print(
            'Market: $market, caandle_date_time_kst: $candleDateTimeKst, openingPrice: $openingPrice, highPrice: $highPrice, lowPrice: $lowPrice, tradePrice: $tradePrice, candleAccTradePrice: $candleAccTradePrice, candleAccTradeVolume: $candleAccTradeVolume');
      }
    }
    return coinInfoInstances;
  }
}
