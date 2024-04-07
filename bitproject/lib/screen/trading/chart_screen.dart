import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicalapp/controller/chart_controller.dart';
import 'package:medicalapp/models/coin_candle_chart/day_candle.dart';
import 'package:medicalapp/models/coin_candle_chart/minute_candle.dart';
import 'package:medicalapp/models/coin_candle_chart/week_or_month_candle.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatelessWidget {
  ChartScreen({Key? key, required this.coin}) : super(key: key);

  final ChartController _controller = Get.put(ChartController());

  final CoinPrice coin;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    _controller.selectcoin = coin.code;
    final TooltipBehavior tooltipBehavior = TooltipBehavior(
      enable: true,
      color: Colors.white,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        final candle = _controller.minuteCandle[pointIndex];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('시간: ${candle.candleDateTimeKst}'),
              Text('시가: ${candle.openingPrice}'),
              Text('고가: ${candle.highPrice}'),
              Text('저가: ${candle.lowPrice}'),
              Text('종가: ${candle.tradePrice}'),
            ],
          ),
        );
      },
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: _controller.selectTime,
                  onChanged: (String? newValue) {
                    _controller.selectTime = newValue!;
                    _controller.resetChart();
                    _controller.getCurrent200Candles();
                  },
                  items: <String>['minutes', 'days', 'weeks', 'months']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: _controller.selectMinute,
                  onChanged: (String? newValue) {
                    print(_controller.selectMinute);
                    _controller.selectMinute = newValue!;
                    _controller.resetChart();
                    _controller.getCurrent200Candles();
                  },
                  items: <String>['1분', '3분', '5분', '15분', '30분', '60분', '240분']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                IconButton(
                  onPressed: () {
                    _controller.getCurrent200Candles();
                  },
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () {
                    _controller.resetChart();
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            Obx(() {
              if (_controller.minuteCandle.isNotEmpty ||
                  _controller.dayCandle.isNotEmpty ||
                  _controller.weekOrMonthCandle.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: height * 0.75,
                      child: _controller.selectTime.contains("minutes")
                          ? SfCartesianChart(
                              primaryXAxis: const DateTimeCategoryAxis(
                                isVisible: true,
                                isInversed: true,
                                initialZoomFactor: 0.5,
                                initialZoomPosition: 0.5,
                              ),
                              primaryYAxis: NumericAxis(
                                labelIntersectAction:
                                    AxisLabelIntersectAction.multipleRows,
                                maximum: _controller.minuteCandle
                                    .map((candle) => candle.highPrice)
                                    .reduce((max, value) =>
                                        value > max ? value : max),
                                minimum: _controller.minuteCandle
                                    .map((candle) => candle.highPrice)
                                    .reduce((max, value) =>
                                        value < max ? value : max),
                                opposedPosition: true,
                                axisLine: const AxisLine(width: 0),
                                initialZoomFactor: 0.8,
                                initialZoomPosition: 0.2,
                              ),

                              series: <CandleSeries<MinuteCandle, DateTime>>[
                                CandleSeries<MinuteCandle, DateTime>(
                                  enableTooltip: true,
                                  animationDuration: 0,
                                  name: coin.code,
                                  dataSource: _controller.minuteCandle,
                                  xValueMapper: (MinuteCandle candle, _) =>
                                      DateTime.parse(candle.candleDateTimeKst),
                                  lowValueMapper: (MinuteCandle candle, _) =>
                                      candle.lowPrice,
                                  highValueMapper: (MinuteCandle candle, _) =>
                                      candle.highPrice,
                                  openValueMapper: (MinuteCandle candle, _) =>
                                      candle.openingPrice,
                                  closeValueMapper: (MinuteCandle candle, _) =>
                                      candle.tradePrice,
                                  borderWidth: 1.5,
                                  enableSolidCandles: true,
                                  bullColor: Colors.red,
                                  bearColor:
                                      const Color.fromRGBO(21, 101, 192, 1),
                                ),
                              ],
                              tooltipBehavior: tooltipBehavior,

                              zoomPanBehavior: ZoomPanBehavior(
                                enablePanning: true,
                                enablePinching: true,
                              ), // ZoomPanBehavior 추가
                            )
                          : _controller.selectTime.contains("days")
                              ? SfCartesianChart(
                                  primaryXAxis: const DateTimeCategoryAxis(
                                    isVisible: true,
                                    isInversed: true,
                                    initialZoomFactor: 0.5,
                                    initialZoomPosition: 0.5,
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    opposedPosition: true,
                                    axisLine: AxisLine(width: 0),
                                    initialZoomFactor: 0.8,
                                    initialZoomPosition: 0.2,
                                  ),
                                  series: <CandleSeries<DayCandle, DateTime>>[
                                    CandleSeries<DayCandle, DateTime>(
                                      animationDuration: 0,
                                      name: coin.code,
                                      dataSource: _controller.dayCandle,
                                      xValueMapper: (DayCandle candle, _) =>
                                          DateTime.parse(
                                              candle.candleDateTimeKst),
                                      lowValueMapper: (DayCandle candle, _) =>
                                          candle.lowPrice,
                                      highValueMapper: (DayCandle candle, _) =>
                                          candle.highPrice,
                                      openValueMapper: (DayCandle candle, _) =>
                                          candle.openingPrice,
                                      closeValueMapper: (DayCandle candle, _) =>
                                          candle.tradePrice,
                                      borderWidth: 1.5,
                                      enableSolidCandles: true,
                                      bullColor: Colors.red,
                                      bearColor:
                                          const Color.fromRGBO(21, 101, 192, 1),
                                    ),
                                  ],
                                  zoomPanBehavior: ZoomPanBehavior(
                                    enablePanning: true,
                                    enablePinching: true,
                                  ), // ZoomPanBehavior 추가
                                )
                              : _controller.selectTime.contains("weeks") ||
                                      _controller.selectTime.contains("months")
                                  ? SfCartesianChart(
                                      primaryXAxis: const DateTimeCategoryAxis(
                                        isVisible: true,
                                        isInversed: true,
                                        initialZoomFactor: 0.5,
                                        initialZoomPosition: 0.5,
                                      ),
                                      primaryYAxis: const NumericAxis(
                                        opposedPosition: true,
                                        axisLine: AxisLine(width: 0),
                                        initialZoomFactor: 0.8,
                                        initialZoomPosition: 0.2,
                                      ),
                                      series: <CandleSeries<WeekOrMonthCandle,
                                          DateTime>>[
                                        CandleSeries<WeekOrMonthCandle,
                                            DateTime>(
                                          animationDuration: 0,
                                          name: coin.code,
                                          dataSource:
                                              _controller.weekOrMonthCandle,
                                          xValueMapper:
                                              (WeekOrMonthCandle candle, _) =>
                                                  DateTime.parse(
                                                      candle.candleDateTimeKst),
                                          lowValueMapper:
                                              (WeekOrMonthCandle candle, _) =>
                                                  candle.lowPrice,
                                          highValueMapper:
                                              (WeekOrMonthCandle candle, _) =>
                                                  candle.highPrice,
                                          openValueMapper:
                                              (WeekOrMonthCandle candle, _) =>
                                                  candle.openingPrice,
                                          closeValueMapper:
                                              (WeekOrMonthCandle candle, _) =>
                                                  candle.tradePrice,
                                          borderWidth: 1.5,
                                          enableSolidCandles: true,
                                          bullColor: Colors.red,
                                          bearColor: const Color.fromRGBO(
                                              21, 101, 192, 1),
                                        ),
                                      ],
                                      zoomPanBehavior: ZoomPanBehavior(
                                        enablePanning: true,
                                        enablePinching: true,
                                      ), // ZoomPanBehavior 추가
                                    )
                                  : Container(),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
          ],
        ),
      ),
    );
  }
}
