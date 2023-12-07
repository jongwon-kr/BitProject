// views/stock_chart_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicalapp/models/stock.dart';
import 'package:medicalapp/widget/stock_controller.dart';

class StockChartView extends StatelessWidget {
  final StockController _stockController = Get.find();

  StockChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Chart')),
      body: Obx(
        () => ListView.builder(
          itemCount: _stockController.stocks.length,
          itemBuilder: (context, index) {
            Stock stock = _stockController.stocks[index];
            return ListTile(
              title: Text('${stock.symbol}: ${stock.price.toString()}'),
            );
          },
        ),
      ),
    );
  }
}
