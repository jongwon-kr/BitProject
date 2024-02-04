class CoinPirceModel {
  final dynamic market, change;
  final double tradePrice, signedChangeRate, acctradePrice24h, changePrice;

  CoinPirceModel(
    this.market,
    this.change,
    this.tradePrice,
    this.signedChangeRate,
    this.changePrice,
    this.acctradePrice24h,
  );

  CoinPirceModel.fromJson(Map<String, dynamic> json)
      : market = json['market'],
        tradePrice = json['trade_price'],
        change = json['change'],
        signedChangeRate = json['signed_change_rate'],
        changePrice = json['change_price'],
        acctradePrice24h = json['acc_trade_price_24h'];
}
