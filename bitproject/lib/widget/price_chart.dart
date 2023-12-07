import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChart extends StatelessWidget {
  final List<double> prices = [50, 75, 60, 90, 80]; // 각 시간대의 가격을 나타내는 리스트
  final List<String> timeLabels = [
    '9AM',
    '10AM',
    '11AM',
    '12PM',
    '1PM'
  ]; // 각 시간대의 레이블을 나타내는 리스트

  PriceChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: prices.reduce(
                  (value, element) => value > element ? value : element) *
              1.2, // 최대 값의 1.2배
          barGroups: List.generate(
            prices.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: prices[index],
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          titlesData: const FlTitlesData(
              leftTitles: AxisTitles(),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
              ))),
          borderData: FlBorderData(
            show: true,
          ),
        ),
      ),
    );
  }
}
