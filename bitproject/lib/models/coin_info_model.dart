// To parse this JSON data, do
//
//     final coinInfo = coinInfoFromJson(jsonString);

import 'dart:convert';

CoinInfo coinInfoFromJson(String str) => CoinInfo.fromJson(json.decode(str));

String coinInfoToJson(CoinInfo data) => json.encode(data.toJson());

class CoinInfo {
  String market;
  String introduction;
  String tech;
  String nowFuture;

  CoinInfo({
    required this.market,
    required this.introduction,
    required this.tech,
    required this.nowFuture,
  });

  factory CoinInfo.fromJson(Map<String, dynamic> json) => CoinInfo(
        market: json["market"],
        introduction: json["introduction"],
        tech: json["tech"],
        nowFuture: json["nowFuture"],
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "introduction": introduction,
        "tech": tech,
        "nowFuture": nowFuture,
      };
}
