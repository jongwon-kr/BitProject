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

  CoinList({
    required this.market,
    required this.koreanName,
    required this.englishName,
  });

  factory CoinList.fromJson(Map<String, dynamic> json) => CoinList(
        market: json["market"],
        koreanName: json["korean_name"],
        englishName: json["english_name"],
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "korean_name": koreanName,
        "english_name": englishName,
      };
}
