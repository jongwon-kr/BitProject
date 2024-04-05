// To parse this JSON data, do
//
//     final coinOrderBook = coinOrderBookFromJson(jsonString);

import 'dart:convert';

CoinOrderBook coinOrderBookFromJson(String str) =>
    CoinOrderBook.fromJson(json.decode(str));

String coinOrderBookToJson(CoinOrderBook data) => json.encode(data.toJson());

class CoinOrderBook {
  String type;
  String code;
  int timestamp;
  double totalAskSize;
  double totalBidSize;
  List<OrderbookUnit> orderbookUnits;
  String streamType;
  double level;

  CoinOrderBook({
    required this.type,
    required this.code,
    required this.timestamp,
    required this.totalAskSize,
    required this.totalBidSize,
    required this.orderbookUnits,
    required this.streamType,
    required this.level,
  });

  factory CoinOrderBook.fromJson(Map<String, dynamic> json) => CoinOrderBook(
        type: json["type"],
        code: json["code"],
        timestamp: json["timestamp"],
        totalAskSize: json["total_ask_size"]?.toDouble(),
        totalBidSize: json["total_bid_size"]?.toDouble(),
        orderbookUnits: List<OrderbookUnit>.from(
            json["orderbook_units"].map((x) => OrderbookUnit.fromJson(x))),
        streamType: json["stream_type"],
        level: json["level"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "timestamp": timestamp,
        "total_ask_size": totalAskSize,
        "total_bid_size": totalBidSize,
        "orderbook_units":
            List<dynamic>.from(orderbookUnits.map((x) => x.toJson())),
        "stream_type": streamType,
        "level": level,
      };
}

class OrderbookUnit {
  double askPrice;
  double bidPrice;
  double askSize;
  double bidSize;

  OrderbookUnit({
    required this.askPrice,
    required this.bidPrice,
    required this.askSize,
    required this.bidSize,
  });

  factory OrderbookUnit.fromJson(Map<String, dynamic> json) => OrderbookUnit(
        askPrice: json["ask_price"]?.toDouble(),
        bidPrice: json["bid_price"]?.toDouble(),
        askSize: json["ask_size"]?.toDouble(),
        bidSize: json["bid_size"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "ask_price": askPrice,
        "bid_price": bidPrice,
        "ask_size": askSize,
        "bid_size": bidSize,
      };
}
