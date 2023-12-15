import 'package:dio/dio.dart';
import 'package:medicalapp/services/api/api_service.dart';
import 'package:medicalapp/services/api/upbit_url.dart';

class TradePriceApi {
  final ApiService apiService = ApiService();

  Future<Response> getTradePrice(String ticker) async {
    try {
      final Response response =
          await apiService.get(UpbitUrl.tradePrice + ticker);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
