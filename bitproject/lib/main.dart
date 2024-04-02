import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:medicalapp/screen/navigation_screen.dart';
import 'package:medicalapp/screen/test_screen.dart';
import 'package:web_socket_channel/io.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (TestScreen()),
    );
  }
}
