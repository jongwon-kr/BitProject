import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static String id = "chat_screen";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final topArticles = <String, String>{};

  void crawling() async {
    var url = Uri.parse("https://www.bbc.com/korean/topics/c95y3gpd895t");
    http.Response response = await http.get(url);

    setState(() {
      for (int i = 1; i < 11; i++) {
        String article = response.body
            .split("<div class=\"promo-text\">")[i]
            .split("bbc-uk8dsi e1d658bg0\">")[1]
            .split("</a>")[0]
            .replaceAll("&#x27;", "'");
        if (article.contains("bbc-m04vo2")) {
          article = article
              .split("</span>")[1]
              .split("<span class=\"bbc-m04vo2\">")[0]
              .replaceAll("&#x27;", "'");
        }
        String href = response.body
            .split("<div class=\"promo-text\">")[i]
            .split("href=\"")[1]
            .split("\"")[0];
        article = "$i $article";
        topArticles.addAll({article: href});
      }
    });
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
            " ? 님 어서오세요Hello!!",
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
        child: ListView(
          children: const [Text("data")],
        ),
      ),
    );
  }
}
