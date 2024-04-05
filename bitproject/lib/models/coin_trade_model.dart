// To parse this JSON data, do
//
//     final coinTrade = coinTradeFromJson(jsonString);

import 'dart:convert';

CoinTrade coinTradeFromJson(String str) => CoinTrade.fromJson(json.decode(str));

String coinTradeToJson(CoinTrade data) => json.encode(data.toJson());

class CoinTrade {
  String type;
  String code;
  int timestamp;
  DateTime tradeDate;
  String tradeTime;
  int tradeTimestamp;
  double tradePrice;
  double tradeVolume;
  String askBid;
  double prevClosingPrice;
  String change;
  double changePrice;
  int sequentialId;
  String streamType;

  CoinTrade({
    required this.type,
    required this.code,
    required this.timestamp,
    required this.tradeDate,
    required this.tradeTime,
    required this.tradeTimestamp,
    required this.tradePrice,
    required this.tradeVolume,
    required this.askBid,
    required this.prevClosingPrice,
    required this.change,
    required this.changePrice,
    required this.sequentialId,
    required this.streamType,
  });

  factory CoinTrade.fromJson(Map<String, dynamic> json) => CoinTrade(
        type: json["type"],
        code: json["code"],
        timestamp: json["timestamp"],
        tradeDate: DateTime.parse(json["trade_date"]),
        tradeTime: json["trade_time"],
        tradeTimestamp: json["trade_timestamp"],
        tradePrice: json["trade_price"]?.toDouble(),
        tradeVolume: json["trade_volume"]?.toDouble(),
        askBid: json["ask_bid"],
        prevClosingPrice: json["prev_closing_price"]?.toDouble(),
        change: json["change"],
        changePrice: json["change_price"]?.toDouble(),
        sequentialId: json["sequential_id"],
        streamType: json["stream_type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "timestamp": timestamp,
        "trade_date":
            "${tradeDate.year.toString().padLeft(4, '0')}-${tradeDate.month.toString().padLeft(2, '0')}-${tradeDate.day.toString().padLeft(2, '0')}",
        "trade_time": tradeTime,
        "trade_timestamp": tradeTimestamp,
        "trade_price": tradePrice,
        "trade_volume": tradeVolume,
        "ask_bid": askBid,
        "prev_closing_price": prevClosingPrice,
        "change": change,
        "change_price": changePrice,
        "sequential_id": sequentialId,
        "stream_type": streamType,
      };
}
