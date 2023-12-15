class UpbitUrl {
  UpbitUrl._();
  // base url
  static const String baseUrl = 'https://api.upbit.com';

  // receiveTimeout
  static const Duration receiveTimeout = Duration(milliseconds: 500);

  // connectTimeout
  static const Duration connectionTimeout = Duration(milliseconds: 500);

  static const String tradePrice = '/v1/ticker?markets=';
  static const String coinList = '/v1/market/all';
}
