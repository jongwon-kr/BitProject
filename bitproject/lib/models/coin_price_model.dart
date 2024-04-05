// To parse this JSON data, do
//
//     final coinPrice = coinPriceFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

CoinPrice coinPriceFromJson(String str) => CoinPrice.fromJson(json.decode(str));

String coinPriceToJson(CoinPrice data) => json.encode(data.toJson());

class CoinPrice {
  String koreanName;
  String englishName;
  String type;
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
  int tradeTimestamp;
  double accAskVolume;
  double accBidVolume;
  double highest52WeekPrice;
  DateTime highest52WeekDate;
  double lowest52WeekPrice;
  DateTime lowest52WeekDate;
  String marketState;
  bool isTradingSuspended;
  dynamic delistingDate;
  String marketWarning;
  int timestamp;
  double accTradePrice24H;
  double accTradeVolume24H;
  String streamType;

  CoinPrice({
    required this.koreanName,
    required this.englishName,
    required this.type,
    required this.code,
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
    required this.tradeTimestamp,
    required this.accAskVolume,
    required this.accBidVolume,
    required this.highest52WeekPrice,
    required this.highest52WeekDate,
    required this.lowest52WeekPrice,
    required this.lowest52WeekDate,
    required this.marketState,
    required this.isTradingSuspended,
    required this.delistingDate,
    required this.marketWarning,
    required this.timestamp,
    required this.accTradePrice24H,
    required this.accTradeVolume24H,
    required this.streamType,
  });

  factory CoinPrice.fromJson(Map<String, dynamic> json) => CoinPrice(
        koreanName: json["korean_name"],
        englishName: json["english_name"],
        type: json["type"],
        code: json["code"],
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
        tradeTimestamp: json["trade_timestamp"],
        accAskVolume: json["acc_ask_volume"]?.toDouble(),
        accBidVolume: json["acc_bid_volume"]?.toDouble(),
        highest52WeekPrice: json["highest_52_week_price"]?.toDouble(),
        highest52WeekDate: DateTime.parse(json["highest_52_week_date"]),
        lowest52WeekPrice: json["lowest_52_week_price"]?.toDouble(),
        lowest52WeekDate: DateTime.parse(json["lowest_52_week_date"]),
        marketState: json["market_state"],
        isTradingSuspended: json["is_trading_suspended"],
        delistingDate: json["delisting_date"],
        marketWarning: json["market_warning"],
        timestamp: json["timestamp"],
        accTradePrice24H: json["acc_trade_price_24h"]?.toDouble(),
        accTradeVolume24H: json["acc_trade_volume_24h"]?.toDouble(),
        streamType: json["stream_type"],
      );

  Map<String, dynamic> toJson() => {
        "korean_name": koreanName,
        "english_name": englishName,
        "type": type,
        "code": code,
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
        "trade_timestamp": tradeTimestamp,
        "acc_ask_volume": accAskVolume,
        "acc_bid_volume": accBidVolume,
        "highest_52_week_price": highest52WeekPrice,
        "highest_52_week_date":
            "${highest52WeekDate.year.toString().padLeft(4, '0')}-${highest52WeekDate.month.toString().padLeft(2, '0')}-${highest52WeekDate.day.toString().padLeft(2, '0')}",
        "lowest_52_week_price": lowest52WeekPrice,
        "lowest_52_week_date":
            "${lowest52WeekDate.year.toString().padLeft(4, '0')}-${lowest52WeekDate.month.toString().padLeft(2, '0')}-${lowest52WeekDate.day.toString().padLeft(2, '0')}",
        "market_state": marketState,
        "is_trading_suspended": isTradingSuspended,
        "delisting_date": delistingDate,
        "market_warning": marketWarning,
        "timestamp": timestamp,
        "acc_trade_price_24h": accTradePrice24H,
        "acc_trade_volume_24h": accTradeVolume24H,
        "stream_type": streamType,
      };
  @override
  String toString() {
    return '''
    Korean Name: $koreanName,
    English Name: $englishName,
    Type: $type,
    Code: $code,
    Opening Price: $openingPrice,
    High Price: $highPrice,
    Low Price: $lowPrice,
    Trade Price: $tradePrice,
    Prev Closing Price: $prevClosingPrice,
    Acc Trade Price: $accTradePrice,
    Change: $change,
    Change Price: $changePrice,
    Signed Change Price: $signedChangePrice,
    Change Rate: $changeRate,
    Signed Change Rate: $signedChangeRate,
    Ask Bid: $askBid,
    Trade Volume: $tradeVolume,
    Acc Trade Volume: $accTradeVolume,
    Trade Date: $tradeDate,
    Trade Time: $tradeTime,
    Trade Timestamp: $tradeTimestamp,
    Acc Ask Volume: $accAskVolume,
    Acc Bid Volume: $accBidVolume,
    Highest 52 Week Price: $highest52WeekPrice,
    Highest 52 Week Date: $highest52WeekDate,
    Lowest 52 Week Price: $lowest52WeekPrice,
    Lowest 52 Week Date: $lowest52WeekDate,
    Market State: $marketState,
    Is Trading Suspended: $isTradingSuspended,
    Delisting Date: $delistingDate,
    Market Warning: $marketWarning,
    Timestamp: $timestamp,
    Acc Trade Price 24H: $accTradePrice24H,
    Acc Trade Volume 24H: $accTradeVolume24H,
    Stream Type: $streamType
    ''';
  }
}
