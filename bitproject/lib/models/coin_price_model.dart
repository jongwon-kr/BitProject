// To parse this JSON data, do
//
//     final coinPrice = coinPriceFromJson(jsonString);

import 'dart:convert';

CoinPrice coinPriceFromJson(String str) => CoinPrice.fromJson(json.decode(str));

String coinPriceToJson(CoinPrice data) => json.encode(data.toJson());

class CoinPrice {
  String koreanName;
  String englishName;
  String code;
  double openingPrice;
  double highPrice;
  double lowPrice;
  double tradePrice;
  double prevClosingPrice;
  double accTradePrice;
  String change;
  double changePrice;
  double signedChangePrice;
  double changeRate;
  double signedChangeRate;
  String askBid;
  double tradeVolume;
  double accTradeVolume;
  String tradeDate;
  String tradeTime;
  double accAskVolume;
  double accBidVolume;
  double accTradePrice24H;
  double accTradeVolume24H;

  CoinPrice({
    required this.code,
    required this.koreanName,
    required this.englishName,
    required this.openingPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.tradePrice,
    required this.prevClosingPrice,
    required this.accTradePrice,
    required this.change,
    required this.changePrice,
    required this.signedChangePrice,
    required this.changeRate,
    required this.signedChangeRate,
    required this.askBid,
    required this.tradeVolume,
    required this.accTradeVolume,
    required this.tradeDate,
    required this.tradeTime,
    required this.accAskVolume,
    required this.accBidVolume,
    required this.accTradePrice24H,
    required this.accTradeVolume24H,
  });

  factory CoinPrice.fromJson(Map<String, dynamic> json) => CoinPrice(
        code: json["code"],
        koreanName: json["korean_name"],
        englishName: json["english_name"],
        openingPrice: json["opening_price"]?.toDouble(),
        highPrice: json["high_price"]?.toDouble(),
        lowPrice: json["low_price"]?.toDouble(),
        tradePrice: json["trade_price"]?.toDouble(),
        prevClosingPrice: json["prev_closing_price"]?.toDouble(),
        accTradePrice: json["acc_trade_price"]?.toDouble(),
        change: json["change"],
        changePrice: json["change_price"]?.toDouble(),
        signedChangePrice: json["signed_change_price"]?.toDouble(),
        changeRate: json["change_rate"]?.toDouble(),
        signedChangeRate: json["signed_change_rate"]?.toDouble(),
        askBid: json["ask_bid"],
        tradeVolume: json["trade_volume"]?.toDouble(),
        accTradeVolume: json["acc_trade_volume"]?.toDouble(),
        tradeDate: json["trade_date"],
        tradeTime: json["trade_time"],
        accAskVolume: json["acc_ask_volume"]?.toDouble(),
        accBidVolume: json["acc_bid_volume"]?.toDouble(),
        accTradePrice24H: json["acc_trade_price_24h"]?.toDouble(),
        accTradeVolume24H: json["acc_trade_volume_24h"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "korean_name": koreanName,
        "english_name": englishName,
        "opening_price": openingPrice,
        "high_price": highPrice,
        "low_price": lowPrice,
        "trade_price": tradePrice,
        "prev_closing_price": prevClosingPrice,
        "acc_trade_price": accTradePrice,
        "change": change,
        "change_price": changePrice,
        "signed_change_price": signedChangePrice,
        "change_rate": changeRate,
        "signed_change_rate": signedChangeRate,
        "ask_bid": askBid,
        "trade_volume": tradeVolume,
        "acc_trade_volume": accTradeVolume,
        "trade_date": tradeDate,
        "trade_time": tradeTime,
        "acc_ask_volume": accAskVolume,
        "acc_bid_volume": accBidVolume,
        "acc_trade_price_24h": accTradePrice24H,
        "acc_trade_volume_24h": accTradeVolume24H,
      };
}
