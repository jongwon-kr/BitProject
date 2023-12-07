import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicalapp/models/coinInfo_model.dart';
import 'package:medicalapp/services/upbit_api.dart';

class TestScreen extends StatefulWidget {
  static String id = "chat_screen";

  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late final topArticles = <String, String>{};

  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isLogin = false;
  late User loggedInUser;
  String nickname = '';

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        isLogin = true;
      } else {
        isLogin = false;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        shadowColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleSpacing: 10,
        backgroundColor: Colors.teal[700],
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
        ),
        leadingWidth: 10,
        title: ListTile(
          title: Text(
            isLogin
                ? "${loggedInUser.email!.split("@")[0]} 님 어서오세요Hello!!"
                : "안녕하세요!",
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey[100],
                fontWeight: FontWeight.w500),
          ),
        ),
        actions: const [],
      ),
      body: Container(
        color: Colors.teal[50],
        child: ListView(children: [
          TextButton(
            onPressed: onPressed,
            child: const Text("버튼"),
          ),
        ]),
      ),
    );
  }

  void onPressed() {
    UpbitApi.getCoinInfo();
  }
}
