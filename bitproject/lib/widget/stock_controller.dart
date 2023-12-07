// controllers/stock_controller.dart
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../models/stock.dart';
import '../services/stock_service.dart';

class StockController extends GetxController {
  final StockService _stockService = StockService();
  final RxList<Stock> stocks = <Stock>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchStockData();
  }

  void _fetchStockData() async {
    try {
      List<Stock> data = await _stockService.getStockChartData();
      stocks.assignAll(data);
    } catch (e) {
      print('Error fetching stock data: $e');
    }
  }
}
