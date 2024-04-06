// To parse this JSON data, do
//
//     final minuteCandle = minuteCandleFromJson(jsonString);

import 'dart:convert';

List<MinuteCandle> minuteCandleFromJson(String str) => List<MinuteCandle>.from(
    json.decode(str).map((x) => MinuteCandle.fromJson(x)));

String minuteCandleToJson(List<MinuteCandle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MinuteCandle {
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
  int unit;

  MinuteCandle({
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
    required this.unit,
  });

  factory MinuteCandle.fromJson(Map<String, dynamic> json) => MinuteCandle(
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
        unit: json["unit"],
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
        "unit": unit,
      };
}
