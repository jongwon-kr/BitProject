class CoinPirceModel {
  final dynamic market, change;
  final double tradePrice, signedChangeRate, acctradePrice, signedChangePrice;

  CoinPirceModel(
    this.market,
    this.change,
    this.tradePrice,
    this.signedChangeRate,
    this.acctradePrice,
    this.signedChangePrice,
  );

  CoinPirceModel.fromJson(Map<String, dynamic> json)
      : market = json['market'],
        tradePrice = json['trade_price'],
        change = json['change'],
        signedChangeRate = json['signed_change_rate'],
        signedChangePrice = json['signed_change_price'],
        acctradePrice = json['acc_trade_price'];
}
