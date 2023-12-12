class CoinPirceModel {
  final dynamic market,
      trade_price,
      change,
      signed_change_rate,
      acc_trade_price;
  CoinPirceModel.fromJson(Map<String, dynamic> json)
      : market = json['market'],
        trade_price = json['trade_price'],
        change = json['change'],
        signed_change_rate = json['signed_change_rate'],
        acc_trade_price = json['acc_trade_price'];
}
