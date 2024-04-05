import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medicalapp/controller/market_controller.dart';
import 'package:medicalapp/screen/home_screen.dart';
import 'package:medicalapp/screen/market/market_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  get scaffoldKey => null;
  @override
  State<NavigationScreen> createState() => _NavigationState();
}

class _NavigationState extends State<NavigationScreen> {
  final MarketController _controller = Get.put(MarketController());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPageIndex = 0; // 0번이 market
  // 01 18 부터 다시 시작 rr
  final List<String> titles = <String>[
    '거래소',
    '코인정보',
    '투자내역',
    '내 자산',
    '내 정보',
  ];

  final List<Widget> screens = <Widget>[
    MarketScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;

    Future<bool> onWillPop() async {
      final now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        _controller.onPause();
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('한 번 더 누르면 종료됩니다.'),
            duration: Duration(milliseconds: 1500),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          _controller.onResume();
        });

        return false;
      }
      exit(0);
    }

    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          // ignore: sort_child_properties_last
          children: screens,
          physics: const NeverScrollableScrollPhysics(), // No sliding?
        ),
        bottomNavigationBar: NavigationBar(
          height: height * 0.08,
          indicatorColor: Colors.grey[200],
          backgroundColor: Colors.grey[50],
          onDestinationSelected: (int index) {
            onTap(index);
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
      ),
    );
  }
}
