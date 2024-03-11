// To parse this JSON data, do
//
//     final coinList = coinListFromJson(jsonString);

import 'dart:convert';

List<CoinList> coinListFromJson(String str) =>
    List<CoinList>.from(json.decode(str).map((x) => CoinList.fromJson(x)));

String coinListToJson(List<CoinList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoinList {
  String market;
  String koreanName;
  String englishName;
  MarketWarning marketWarning;
  MarketEvent marketEvent;

  CoinList({
    required this.market,
    required this.koreanName,
    required this.englishName,
    required this.marketWarning,
    required this.marketEvent,
  });

  factory CoinList.fromJson(Map<String, dynamic> json) => CoinList(
        market: json["market"],
        koreanName: json["korean_name"],
        englishName: json["english_name"],
        marketWarning: marketWarningValues.map[json["market_warning"]]!,
        marketEvent: MarketEvent.fromJson(json["market_event"]),
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "korean_name": koreanName,
        "english_name": englishName,
        "market_warning": marketWarningValues.reverse[marketWarning],
        "market_event": marketEvent.toJson(),
      };
}

class MarketEvent {
  bool warning;
  Caution caution;

  MarketEvent({
    required this.warning,
    required this.caution,
  });

  factory MarketEvent.fromJson(Map<String, dynamic> json) => MarketEvent(
        warning: json["warning"],
        caution: Caution.fromJson(json["caution"]),
      );

  Map<String, dynamic> toJson() => {
        "warning": warning,
        "caution": caution.toJson(),
      };
}

class Caution {
  bool priceFluctuations;
  bool tradingVolumeSoaring;
  bool depositAmountSoaring;
  bool globalPriceDifferences;
  bool concentrationOfSmallAccounts;

  Caution({
    required this.priceFluctuations,
    required this.tradingVolumeSoaring,
    required this.depositAmountSoaring,
    required this.globalPriceDifferences,
    required this.concentrationOfSmallAccounts,
  });

  factory Caution.fromJson(Map<String, dynamic> json) => Caution(
        priceFluctuations: json["PRICE_FLUCTUATIONS"],
        tradingVolumeSoaring: json["TRADING_VOLUME_SOARING"],
        depositAmountSoaring: json["DEPOSIT_AMOUNT_SOARING"],
        globalPriceDifferences: json["GLOBAL_PRICE_DIFFERENCES"],
        concentrationOfSmallAccounts: json["CONCENTRATION_OF_SMALL_ACCOUNTS"],
      );

  Map<String, dynamic> toJson() => {
        "PRICE_FLUCTUATIONS": priceFluctuations,
        "TRADING_VOLUME_SOARING": tradingVolumeSoaring,
        "DEPOSIT_AMOUNT_SOARING": depositAmountSoaring,
        "GLOBAL_PRICE_DIFFERENCES": globalPriceDifferences,
        "CONCENTRATION_OF_SMALL_ACCOUNTS": concentrationOfSmallAccounts,
      };
}

enum MarketWarning { CAUTION, NONE }

final marketWarningValues =
    EnumValues({"CAUTION": MarketWarning.CAUTION, "NONE": MarketWarning.NONE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
