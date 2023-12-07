class CoinInfoModel {
  final String market, korean_name, english_name;
  CoinInfoModel.fromJson(Map<String, dynamic> json)
      : market = json['market'],
        korean_name = json['korean_name'],
        english_name = json['english_name'];
}
