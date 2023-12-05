import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicalapp/screen/HomeScreen.dart';
import 'package:medicalapp/screen/TestScreen.dart';
import 'package:medicalapp/screen/login/registration_screen.dart';
import 'package:medicalapp/screen/login/welcome_screen.dart';

List<String> titles = <String>[
  '질환백과',
  '문진',
  'Home',
  'Q&A',
  '내정보',
];

List<Widget> screens = <Widget>[
  const WelcomeScreen(),
  const HomeScreen(),
  const TestScreen(),
  const HomeScreen(),
  const HomeScreen(),
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
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.grey[400],
        elevation: 1.0,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.manage_search),
            icon: const Icon(Icons.manage_search_outlined),
            label: titles[0],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.article),
            icon: const Icon(Icons.article_outlined),
            label: titles[1],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: titles[2],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.question_answer),
            icon: const Icon(Icons.question_answer_outlined),
            label: titles[3],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.person),
            icon: const Icon(Icons.person_outlined),
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
