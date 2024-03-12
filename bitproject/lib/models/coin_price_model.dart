// To parse this JSON data, do
//
//     final coinPrice = coinPriceFromJson(jsonString);

import 'dart:convert';

List<CoinPrice> coinPriceFromJson(String str) =>
    List<CoinPrice>.from(json.decode(str).map((x) => CoinPrice.fromJson(x)));

String coinPriceToJson(List<CoinPrice> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoinPrice {
  String market;
  String koreanName;
  String englishName;
  String tradeDate;
  String tradeTime;
  String tradeDateKst;
  String tradeTimeKst;
  int tradeTimestamp;
  double openingPrice;
  double highPrice;
  double lowPrice;
  double tradePrice;
  double prevClosingPrice;
  String change;
  double changePrice;
  double changeRate;
  double signedChangePrice;
  double signedChangeRate;
  double tradeVolume;
  double accTradePrice;
  double accTradePrice24H;
  double accTradeVolume;
  double accTradeVolume24H;
  double highest52WeekPrice;
  DateTime highest52WeekDate;
  double lowest52WeekPrice;
  DateTime lowest52WeekDate;
  int timestamp;

  CoinPrice({
    required this.market,
    required this.koreanName,
    required this.englishName,
    required this.tradeDate,
    required this.tradeTime,
    required this.tradeDateKst,
    required this.tradeTimeKst,
    required this.tradeTimestamp,
    required this.openingPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.tradePrice,
    required this.prevClosingPrice,
    required this.change,
    required this.changePrice,
    required this.changeRate,
    required this.signedChangePrice,
    required this.signedChangeRate,
    required this.tradeVolume,
    required this.accTradePrice,
    required this.accTradePrice24H,
    required this.accTradeVolume,
    required this.accTradeVolume24H,
    required this.highest52WeekPrice,
    required this.highest52WeekDate,
    required this.lowest52WeekPrice,
    required this.lowest52WeekDate,
    required this.timestamp,
  });

  factory CoinPrice.fromJson(Map<String, dynamic> json) => CoinPrice(
        market: json["market"],
        koreanName: json["koreanName"],
        englishName: json["englishName"],
        tradeDate: json["trade_date"],
        tradeTime: json["trade_time"],
        tradeDateKst: json["trade_date_kst"],
        tradeTimeKst: json["trade_time_kst"],
        tradeTimestamp: json["trade_timestamp"],
        openingPrice: json["opening_price"],
        highPrice: json["high_price"],
        lowPrice: json["low_price"],
        tradePrice: json["trade_price"],
        prevClosingPrice: json["prev_closing_price"],
        change: json["change"],
        changePrice: json["change_price"],
        changeRate: json["change_rate"]?.toDouble(),
        signedChangePrice: json["signed_change_price"],
        signedChangeRate: json["signed_change_rate"]?.toDouble(),
        tradeVolume: json["trade_volume"]?.toDouble(),
        accTradePrice: json["acc_trade_price"]?.toDouble(),
        accTradePrice24H: json["acc_trade_price_24h"]?.toDouble(),
        accTradeVolume: json["acc_trade_volume"]?.toDouble(),
        accTradeVolume24H: json["acc_trade_volume_24h"]?.toDouble(),
        highest52WeekPrice: json["highest_52_week_price"],
        highest52WeekDate: DateTime.parse(json["highest_52_week_date"]),
        lowest52WeekPrice: json["lowest_52_week_price"],
        lowest52WeekDate: DateTime.parse(json["lowest_52_week_date"]),
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "trade_date": tradeDate,
        "trade_time": tradeTime,
        "trade_date_kst": tradeDateKst,
        "trade_time_kst": tradeTimeKst,
        "trade_timestamp": tradeTimestamp,
        "opening_price": openingPrice,
        "high_price": highPrice,
        "low_price": lowPrice,
        "trade_price": tradePrice,
        "prev_closing_price": prevClosingPrice,
        "change": change,
        "change_price": changePrice,
        "change_rate": changeRate,
        "signed_change_price": signedChangePrice,
        "signed_change_rate": signedChangeRate,
        "trade_volume": tradeVolume,
        "acc_trade_price": accTradePrice,
        "acc_trade_price_24h": accTradePrice24H,
        "acc_trade_volume": accTradeVolume,
        "acc_trade_volume_24h": accTradeVolume24H,
        "highest_52_week_price": highest52WeekPrice,
        "highest_52_week_date":
            "${highest52WeekDate.year.toString().padLeft(4, '0')}-${highest52WeekDate.month.toString().padLeft(2, '0')}-${highest52WeekDate.day.toString().padLeft(2, '0')}",
        "lowest_52_week_price": lowest52WeekPrice,
        "lowest_52_week_date":
            "${lowest52WeekDate.year.toString().padLeft(4, '0')}-${lowest52WeekDate.month.toString().padLeft(2, '0')}-${lowest52WeekDate.day.toString().padLeft(2, '0')}",
        "timestamp": timestamp,
      };
}
