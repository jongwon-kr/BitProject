import 'dart:async';

import 'package:medicalapp/models/stock.dart';

// services/stock_service.dart
class StockService {
  Future<List<Stock>> getStockChartData() async {
    // 여기에서 API 호출 또는 다른 데이터 소스를 사용하여 실제 데이터를 가져옵니다.
    // 여기에서는 간단한 더미 데이터를 반환합니다.
    await Future.delayed(const Duration(seconds: 1));
    return [
      Stock(symbol: 'AAPL', price: 150.0),
      Stock(symbol: 'GOOGL', price: 2700.0),
      Stock(symbol: 'MSFT', price: 300.0),
    ];
  }
}
