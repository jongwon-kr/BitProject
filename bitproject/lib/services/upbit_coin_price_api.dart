import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medicalapp/models/coin_price_model.dart';

class UpbitCoinPriceApi {
  static const String baseUrl = 'https://api.upbit.com';

  static Future<CoinPirceModel> getCoinPrice(ticker) async {
    String url = '$baseUrl/v1/ticker';
    Map<String, String> headers = {
      "accept": "application/json",
    };
    var queryParameters = {
      "markets": ticker,
    };
    Uri uri = Uri.parse(url);
    final finalUri = uri.replace(queryParameters: queryParameters);
    http.Response response = await http.get(
      finalUri,
      headers: headers,
    );
    print(response.body);

    final coinPrice = jsonDecode(response.body);
    return CoinPirceModel.fromJson(coinPrice);
  }
}
// 2.5재하고 바로 코딩하자