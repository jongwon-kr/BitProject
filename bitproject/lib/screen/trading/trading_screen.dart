import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicalapp/controller/trading_controller.dart';
import 'package:medicalapp/controller/market_controller.dart';
import 'package:medicalapp/models/coin_info_model.dart';
import 'package:medicalapp/models/coin_order_book_model.dart';
import 'package:medicalapp/models/coin_price_model.dart';
import 'package:medicalapp/models/coin_trade_model.dart';
import 'package:medicalapp/screen/navigation_screen.dart';
import 'package:medicalapp/screen/trading/chart_screen.dart';
import 'package:medicalapp/screen/trading/coin_info_screen.dart';
import 'package:medicalapp/screen/trading/coin_trade_screen.dart';
import 'package:medicalapp/screen/trading/order_book_screen.dart';
import 'package:web_socket_channel/io.dart';

class TradingScreen extends StatefulWidget {
  static String id = "chat_screen";

  final CoinPrice coin;
  final List<CoinPrice> market;

  const TradingScreen({
    Key? key,
    required this.coin,
    required this.market,
  }) : super(key: key);

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen>
    with SingleTickerProviderStateMixin {
  final MarketController _controller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  bool isLoading = true;

  late CoinInfo coinInfo;
  late CoinPrice coin;
  late List<CoinPrice> market;
  late CoinOrderBook coinOrderBook;
  late CoinTrade coinTrade;

  late List<CoinTrade> coinTrades = [];
  late IOWebSocketChannel coinPriceChannel;
  late IOWebSocketChannel orderBookChannel;
  late IOWebSocketChannel tradeChannel;

  @override
  void initState() {
    super.initState();
    setCoin(widget.coin);
    setMarket(widget.market);
    getCoindata();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void setCoin(CoinPrice coin) {
    this.coin = coin;
    setState(() {});
  }

  void setMarket(List<CoinPrice> market) {
    this.market = market;
    setState(() {});
  }

  void getCoindata() async {
    getPricese();
    getOrderBook();
    getTrade();
  }

  void getPricese() async {
    coinPriceChannel = IOWebSocketChannel.connect(
        Uri.parse("wss://api.upbit.com/websocket/v1"));
    coinPriceChannel.sink.add(
        "[{\"ticket\": \"test example\"},{\"type\": \"ticker\",\"codes\": [\"${coin.code}\"]},{\"format\": \"DEFAULT\"}]");
    coinPriceChannel.stream.listen((message) {
      Map<String, dynamic> jsonData = json.decode(
          "{\"korean_name\":\"${coin.koreanName}\",\"english_name\":\"${coin.englishName}\",${String.fromCharCodes(message).substring(1)}");
      CoinPrice coinPrice = CoinPrice.fromJson(jsonData);
      coin = coinPrice;
      setState(() {});
    });
  }

  void getOrderBook() async {
    orderBookChannel = IOWebSocketChannel.connect(
        Uri.parse("wss://api.upbit.com/websocket/v1"));
    orderBookChannel.sink.add(
        "[{\"ticket\": \"test example\"},{\"type\": \"orderbook\",\"codes\": [\"${coin.code}\"]},{\"format\": \"DEFAULT\"}]");
    orderBookChannel.stream.listen((message) {
      Map<String, dynamic> jsonData = json.decode(
          "{\"korean_name\":\"${coin.koreanName}\",\"english_name\":\"${coin.englishName}\",${String.fromCharCodes(message).substring(1)}");
      CoinOrderBook coinOrderBook = CoinOrderBook.fromJson(jsonData);
      this.coinOrderBook = coinOrderBook;
      isLoading = false;
      setState(() {});
    });
  }

  void getTrade() async {
    tradeChannel = IOWebSocketChannel.connect(
        Uri.parse("wss://api.upbit.com/websocket/v1"));
    tradeChannel.sink.add(
        "[{\"ticket\": \"test example\"},{\"type\": \"trade\",\"codes\": [\"${coin.code}\"]},{\"format\": \"DEFAULT\"}]");
    tradeChannel.stream.listen((message) {
      Map<String, dynamic> jsonData =
          json.decode("{${String.fromCharCodes(message).substring(1)}");
      CoinTrade coinTrade = CoinTrade.fromJson(jsonData);
      addCoinTrade(coinTrade);
      setState(() {});
    });
  }

  void addCoinTrade(CoinTrade trade) {
    const int maxTradeCount = 20;
    if (coinTrades.length >= maxTradeCount) {
      coinTrades.removeLast(); // 마지막 요소 삭제
    }
    coinTrades.insert(0, trade); // 새로운 요소를 첫 번째 위치에 추가

    // 리스트가 최대 저장 개수를 초과할 경우 로테이션을 수행합니다.
    if (coinTrades.length > maxTradeCount) {
      coinTrades.removeLast(); // 초과된 요소를 삭제하고
      coinTrades.insert(0, trade); // 새로운 요소를 다시 첫 번째 위치에 추가하여 로테이션을 수행합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    final TradingController chartController = Get.put(TradingController());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        coinPriceChannel.sink.close();
        orderBookChannel.sink.close();
        tradeChannel.sink.close();
        _controller.onResume();
        Get.offAll;
        Get.to(() => const NavigationScreen());
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.black87,
          leading: GestureDetector(
            onTap: _openDrawer,
            child: const Icon(
              Icons.menu,
              size: 30,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: () {
                  coinPriceChannel.sink.close();
                  orderBookChannel.sink.close();
                  tradeChannel.sink.close();
                  _controller.onResume();
                  Get.offAll;
                  Get.to(() => const NavigationScreen());
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 25,
                ),
              ),
            ),
          ],
          centerTitle: true,
          title: Text(
            "${coin.koreanName}(${coin.code.split("-")[1]}/${coin.code.split("-")[0]})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          bottom: TabBar(
            dragStartBehavior: DragStartBehavior.start,
            dividerColor: Colors.grey,
            unselectedLabelColor: Colors.black38,
            labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
            indicatorColor: Colors.black87,
            controller: _tabController,
            tabs: const [
              Tab(text: '호가'),
              Tab(text: '차트'),
              Tab(text: '시세'),
              Tab(text: '코인 정보'),
            ],
          ),
        ),
        body: isLoading ? _buildLoadingIndicator() : _buildTabBarView(),
        drawer: Drawer(
          width: width * 0.6,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: market.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Container(
                      height: height * 0.13,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.orange.withOpacity(0.8),
                            Theme.of(context).primaryColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${market[index].code.split("-")[0]} Market',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          coinPriceChannel.sink.close();
                          orderBookChannel.sink.close();
                          tradeChannel.sink.close();
                          setCoin(market[index]);
                          getCoindata();
                          coinTrades.clear();
                          chartController.resetChart();
                          chartController.getCurrent200Candles();
                          chartController.getCoinInfo(coin.code);
                          Navigator.pop(context); // 변경: Drawer 닫기
                        },
                        titleTextStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "${market[index].koreanName}(${market[index].code.split("-")[1]}/${market[index].code.split("-")[0]})",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container(
                height: height * 0.06,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    coinPriceChannel.sink.close();
                    orderBookChannel.sink.close();
                    tradeChannel.sink.close();
                    setCoin(market[index]);
                    getCoindata();
                    coinTrades.clear();
                    chartController.resetChart();
                    chartController.getCurrent200Candles();
                    chartController.getCoinInfo(coin.code);
                    Navigator.pop(context); // 변경: Drawer 닫기
                  },
                  titleTextStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "${market[index].koreanName}(${market[index].code.split("-")[1]}/${market[index].code.split("-")[0]})",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(), // 로딩 표시 위젯
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        // 호가 화면
        OrderBookScreen(
          coin: coin,
          coinOrderBook: coinOrderBook,
          coinTrades: coinTrades,
        ),
        // 차트 화면
        ChartScreen(coin: coin),
        // 시세 화면
        CoinTradeScreen(
          coin: coin,
          coinOrderBook: coinOrderBook,
          coinTrades: coinTrades,
        ),
        // 코인 정보 화면
        CoinInfoScreen(
          coin: coin,
        ),
      ],
    );
  }
}
