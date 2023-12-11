import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicalapp/screen/home/home_screen.dart';
import 'package:medicalapp/screen/market/market_screen.dart';

import 'package:medicalapp/screen/login/welcome_screen.dart';
import 'package:medicalapp/widget/price_chart.dart';
import 'package:medicalapp/widget/stock_chart_view.dart';

List<String> titles = <String>[
  '거래소',
  '코인정보',
  '투자내역',
  '내 자산',
  '내 정보',
];

List<Widget> screens = <Widget>[
  const MarketScreen(),
  const HomeScreen(),
  const HomeScreen(),
  StockChartView(),
  PriceChart(),
];

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  get scaffoldKey => null;
  @override
  State<NavigationScreen> createState() => _NavigationState();
}

class _NavigationState extends State<NavigationScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPageIndex = 2; // 2번이 Home

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.grey[200],
        backgroundColor: Colors.grey[50],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        elevation: 1.0,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black54,
            ),
            label: titles[0],
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.manage_search,
              color: Colors.black,
            ),
            icon: const Icon(
              Icons.manage_search,
              color: Colors.black54,
            ),
            label: titles[1],
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.article,
              color: Colors.black,
            ),
            icon: const Icon(
              Icons.article,
              color: Colors.black54,
            ),
            label: titles[2],
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.credit_card,
              color: Colors.black,
            ),
            icon: const Icon(
              Icons.credit_card_outlined,
              color: Colors.black54,
            ),
            label: titles[3],
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            icon: const Icon(
              Icons.person,
              color: Colors.black54,
            ),
            label: titles[4],
          ),
        ],
      ),
      body: <Widget>[
        screens[0],
        screens[1],
        screens[2],
        screens[3],
        screens[4],
      ][currentPageIndex],
    );
  }
}
