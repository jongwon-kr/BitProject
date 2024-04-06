// To parse this JSON data, do
//
//     final weekAndMonthCandle = weekAndMonthCandleFromJson(jsonString);

import 'dart:convert';

List<WeekOrMonthCandle> weekOrMonthCandleFromJson(String str) =>
    List<WeekOrMonthCandle>.from(
        json.decode(str).map((x) => WeekOrMonthCandle.fromJson(x)));

String weekOrMonthCandleToJson(List<WeekOrMonthCandle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WeekOrMonthCandle {
  String market;
  String candleDateTimeUtc;
  String candleDateTimeKst;
  double openingPrice;
  double highPrice;
  double lowPrice;
  double tradePrice;
  int timestamp;
  double candleAccTradePrice;
  double candleAccTradeVolume;
  DateTime firstDayOfPeriod;

  WeekOrMonthCandle({
    required this.market,
    required this.candleDateTimeUtc,
    required this.candleDateTimeKst,
    required this.openingPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.tradePrice,
    required this.timestamp,
    required this.candleAccTradePrice,
    required this.candleAccTradeVolume,
    required this.firstDayOfPeriod,
  });

  factory WeekOrMonthCandle.fromJson(Map<String, dynamic> json) =>
      WeekOrMonthCandle(
        market: json["market"],
        candleDateTimeUtc: json["candle_date_time_utc"],
        candleDateTimeKst: json["candle_date_time_kst"],
        openingPrice: json["opening_price"]?.toDouble(),
        highPrice: json["high_price"]?.toDouble(),
        lowPrice: json["low_price"]?.toDouble(),
        tradePrice: json["trade_price"]?.toDouble(),
        timestamp: json["timestamp"],
        candleAccTradePrice: json["candle_acc_trade_price"]?.toDouble(),
        candleAccTradeVolume: json["candle_acc_trade_volume"]?.toDouble(),
        firstDayOfPeriod: DateTime.parse(json["first_day_of_period"]),
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "candle_date_time_utc": candleDateTimeUtc,
        "candle_date_time_kst": candleDateTimeKst,
        "opening_price": openingPrice,
        "high_price": highPrice,
        "low_price": lowPrice,
        "trade_price": tradePrice,
        "timestamp": timestamp,
        "candle_acc_trade_price": candleAccTradePrice,
        "candle_acc_trade_volume": candleAccTradeVolume,
        "first_day_of_period":
            "${firstDayOfPeriod.year.toString().padLeft(4, '0')}-${firstDayOfPeriod.month.toString().padLeft(2, '0')}-${firstDayOfPeriod.day.toString().padLeft(2, '0')}",
      };
}
