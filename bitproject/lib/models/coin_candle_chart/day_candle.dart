// To parse this JSON data, do
//
//     final dayCandle = dayCandleFromJson(jsonString);

import 'dart:convert';

List<DayCandle> dayCandleFromJson(String str) =>
    List<DayCandle>.from(json.decode(str).map((x) => DayCandle.fromJson(x)));

String dayCandleToJson(List<DayCandle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DayCandle {
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
  double prevClosingPrice;
  double changePrice;
  double changeRate;

  DayCandle({
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
    required this.prevClosingPrice,
    required this.changePrice,
    required this.changeRate,
  });

  factory DayCandle.fromJson(Map<String, dynamic> json) => DayCandle(
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
        prevClosingPrice: json["prev_closing_price"]?.toDouble(),
        changePrice: json["change_price"]?.toDouble(),
        changeRate: json["change_rate"]?.toDouble(),
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
        "prev_closing_price": prevClosingPrice,
        "change_price": changePrice,
        "change_rate": changeRate,
      };
}
