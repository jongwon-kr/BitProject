import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:medicalapp/bluetooths/screens/bluetooth_screen.dart';

import 'package:medicalapp/screens/login/chat_screen.dart';
import 'package:medicalapp/screens/login/welcome_screen.dart';

import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static String id = "chat_screen";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late bool isLogin = false;
  late User loggedInUser;
  late String messageText;
  late String email;
  late int point = 0;
  bool quizSolve = false;
  late bool quizResult;
  String nickname = '';
  late int selectQuiz;
  late bool checkhealth = false;
  late bool checkarduino = false;
  late int oxquiz = 0;
  late Timestamp date = Timestamp.now();
  late bool todayCheck = false;

  late final userPoint = <String, dynamic>{
    "email": email,
    "point": point,
  };

  late final userInfo = <String, dynamic>{
    "nickname": nickname,
  };

  late final dailyquest = <String, dynamic>{
    "checkhealth": checkhealth,
    "checkarduino": checkarduino,
    "oxquiz": oxquiz,
    "date": date,
  };

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

  Future signOut() async {
    try {
      print('sign out complete');
      return await _auth.signOut();
    } catch (e) {
      print('sign out failed');
      print(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    getCurrentUser();
    crawling();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        isLogin = true;
        email = loggedInUser.email!;
        await _firestore
            .collection("mileages")
            .doc(loggedInUser.email)
            .get()
            .then((value) => userPoint["point"] = value.data()?["point"]);
        await _firestore
            .collection("userinfo")
            .doc(loggedInUser.email)
            .get()
            .then((value) => userInfo["nickname"] = value.data()?["nickname"]);
        final quest =
            _firestore.collection("dailyquest").doc(loggedInUser.email).get();
        await quest.then((value) =>
            dailyquest["checkhealth"] = value.data()?["checkhealth"]);
        await quest.then((value) =>
            dailyquest["checkarduino"] = value.data()?["checkarduino"]);
        await quest
            .then((value) => dailyquest["oxquiz"] = value.data()?["oxquiz"]);
        await quest.then((value) => dailyquest["date"] = value.data()?["date"]);
        setState(() {
          todayCheck = dailyquest["date"].toDate().toString().split(" ")[0] ==
              DateTime.now().toString().split(" ")[0];
        });
      } else {
        isLogin = false;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!quizSolve) {
      selectQuiz = Random().nextInt(14);
    }

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
            isLogin ? "${userInfo["nickname"]}님 어서오세요" : "Hello!!",
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey[100],
                fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          //Dialog Main Title
                          title: const Column(
                            children: <Widget>[
                              Text("Logout"),
                            ],
                          ),
                          //
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "로그아웃 하시겠습니까?",
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text(
                                    "예",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal[400],
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      signOut();
                                      quizSolve = false;
                                      isLogin = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    "아니오",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal[400],
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.grey[100],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.teal[50],
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                StreamBuilder(
                    stream: _firestore
                        .collection('quiz')
                        .orderBy('id', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        final quiz = snapshot.data?.docs;
                        List<DailyQuiz> quizs = [];
                        for (var q in quiz!) {
                          final id = (q.data())['id'];
                          final quiz = (q.data())['quiz'];
                          final answer = (q.data())['answer'];
                          final comment = (q.data())['comment'];
                          quizs.add(
                            DailyQuiz(
                              id: id,
                              quiz: quiz,
                              answer: answer,
                              comment: comment,
                              isLogin: isLogin,
                            ),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.all(10),
                          width: width * 0.90,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 5.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0, 7),
                              )
                            ],
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: isLogin
                              ? !(dailyquest["oxquiz"] >= 5 && todayCheck)
                                  ? quizSolve
                                      ? quizAnswer(
                                          quizResult, height, quizs, selectQuiz)
                                      : OXquiz(quizs, selectQuiz)
                                  : const Column(
                                      children: [Text("일일 OX퀴즈 완료")],
                                    )
                              : loginColumn(
                                  height: height,
                                  width: width,
                                  isLogin: isLogin),
                        );
                      }
                    }),
                SizedBox(
                  height: height * 0.02,
                )
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: height * 0.15,
                      width: width * 0.27,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                            offset: const Offset(0, 7),
                          )
                        ],
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: isLogin
                          ? !dailyquest["checkhealth"] && todayCheck
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "일일 문진표\n작성 X",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "일일 문진표\n작성 O",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "로그인 후\n일일문진\n이용가능",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: height * 0.15,
                      width: width * 0.27,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                            offset: const Offset(0, 7),
                          )
                        ],
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          splashColor: Colors.grey,
                          onTap: isLogin &&
                                  !dailyquest["checkarduino"] &&
                                  todayCheck
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BluetoothScreen(),
                                    ),
                                  );
                                }
                              : () {},
                          child: SizedBox(
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: RichText(
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    text: isLogin
                                        ? !dailyquest["checkarduino"] &&
                                                todayCheck
                                            ? const TextSpan(
                                                text: "자가 진단\n이동하기",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : const TextSpan(
                                                text: "자가진단\n마일리지\n지급O",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                        : const TextSpan(
                                            text: "로그인 후\n자가진단\n이용가능",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: height * 0.15,
                      width: width * 0.27,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                            offset: const Offset(0, 7),
                          )
                        ],
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: isLogin
                          ? dailyquest["oxquiz"] < 5 && todayCheck
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "OX 퀴즈\n",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "정답: ${dailyquest["oxquiz"]}개",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("OX 퀴즈\n마일리지 500\n지급완료"),
                                  ],
                                )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "로그인 후\nOX 퀴즈\n이용가능",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                )
              ],
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: width * 0.90,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 7),
                      )
                    ],
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // 채팅창 이동
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                          child: InkWell(
                            splashColor: Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                            onTap: () {
                              isLogin
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChatScreen(),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WelcomeScreen(),
                                      ),
                                    );
                            },
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    isLogin ? "채팅방으로 이동하기" : "로그인 후 이용가능합니다.",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    isLogin ? "" : "회원 채팅방",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  SizedBox(
                                    height: !isLogin ? height * 0.01 : 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                )
              ],
            ),
            // BBC 건강 칼럼 top 10
            Column(
              children: [
                Container(
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          blurRadius: 5.0,
                          spreadRadius: 0.0,
                          offset: const Offset(0, 7),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.01,
                        ),
                        const Text(
                          "BBC 건강칼럼 top 10",
                          style: TextStyle(
                              color: Color.fromARGB(184, 184, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "기사를 눌러 더 자세히 볼 수 있습니다.",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[800]),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        for (String ar in topArticles.keys)
                          Atricle(height, width, ar, topArticles[ar]),
                        SizedBox(
                          height: height * 0.02,
                        ),
                      ],
                    )),
                SizedBox(
                  height: height * 0.02,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  openArticle(href) async {
    final url = Uri.parse(href);
    await launchUrl(url);
  }

  Container Atricle(height, width, article, href) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.4)),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey,
          onTap: () {
            openArticle(href);
          },
          child: SizedBox(
            width: width,
            child: Padding(
              padding: EdgeInsets.only(
                  left: (width * 0.02),
                  top: height * 0.01,
                  bottom: height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: article,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column quizAnswer(quizResult, height, quizs, selectQuiz) {
    return Column(
      children: [
        SizedBox(
          height: quizResult ? null : height * 0.01,
        ),
        Text(
          quizResult ? "정답입니다!" : "오답입니다..",
          style: const TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: height * 0.03,
        ),
        Text(
          quizResult ? "" : "Fact",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: quizResult ? null : height * 0.01,
        ),
        Text(quizResult
            ? "100point가 적립되었습니다!"
            : quizs.elementAt(selectQuiz).comment),
        SizedBox(
          height: height * 0.01,
        ),
        IconButton(
          onPressed: () {
            quizSolve = false;
            selectQuiz = Random().nextInt(14);
            setState(() {});
          },
          icon: Icon(
            Icons.check,
            color: Colors.teal[800],
          ),
          iconSize: 40,
        ),
      ],
    );
  }

  Column OXquiz(List<DailyQuiz> quizs, int selectQuiz) {
    return Column(
      children: [
        Text(
          "OX 퀴즈",
          style: TextStyle(
              color: Colors.teal[800],
              fontSize: 24,
              fontWeight: FontWeight.w600),
        ),
        quizs.elementAt(selectQuiz),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                if (quizs.elementAt(selectQuiz).answer == "O") {
                  quizResult = true;
                  userPoint["point"] += 100;
                  _firestore
                      .collection("mileages")
                      .doc(loggedInUser.email)
                      .set(
                        userPoint,
                        SetOptions(merge: true),
                      )
                      .onError(
                        (e, _) => print("Error:$e"),
                      );
                  dailyquest["oxquiz"] += 1;
                  dailyquest["date"] = DateTime.now();
                  _firestore
                      .collection("dailyquest")
                      .doc(loggedInUser.email)
                      .set(
                        dailyquest,
                        SetOptions(merge: true),
                      )
                      .onError(
                        (e, _) => print("Error:$e"),
                      );
                  print(dailyquest);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.teal[700],
                    content: const Text('마일리지 100 적립!!'),
                    action: SnackBarAction(
                      textColor: Colors.white,
                      label: '확인',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  quizResult = false;
                }
                setState(() {
                  quizSolve = true;
                });
              },
              icon: const Icon(Icons.circle_outlined),
              iconSize: 35,
            ),
            IconButton(
              onPressed: () {
                if (quizs.elementAt(selectQuiz).answer == "X") {
                  quizResult = true;
                  userPoint["point"] += 100;
                  _firestore
                      .collection("mileages")
                      .doc(loggedInUser.email)
                      .set(
                        userPoint,
                        SetOptions(merge: true),
                      )
                      .onError(
                        (e, _) => print("Error:$e"),
                      );
                  dailyquest["oxquiz"] += 1;
                  dailyquest["date"] = DateTime.now();
                  _firestore
                      .collection("dailyquest")
                      .doc(loggedInUser.email)
                      .set(
                        dailyquest,
                        SetOptions(merge: true),
                      )
                      .onError(
                        (e, _) => print("Error:$e"),
                      );
                  final snackBar = SnackBar(
                    backgroundColor: Colors.teal[700],
                    content: const Text('마일리지 100 적립!!'),
                    action: SnackBarAction(
                      textColor: Colors.white,
                      label: '확인',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  quizResult = false;
                }
                setState(() {
                  quizSolve = true;
                });
              },
              icon: const Icon(Icons.close),
              iconSize: 40,
            ),
          ],
        ),
      ],
    );
  }
}

class loginColumn extends StatelessWidget {
  const loginColumn({
    super.key,
    required this.height,
    required this.width,
    required this.isLogin,
  });

  final double height;
  final double width;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0), color: Colors.white),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            child: InkWell(
              splashColor: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                );
              },
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "로그인 후 이용가능합니다.",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "클릭 시 로그인으로 이동합니다",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: !isLogin ? height * 0.01 : 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DailyQuiz extends StatelessWidget {
  final int id;
  final String quiz;
  final String answer;
  final String comment;
  final bool isLogin;

  const DailyQuiz(
      {Key? key,
      required this.isLogin,
      required this.id,
      required this.quiz,
      required this.answer,
      required this.comment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              "Q. $quiz",
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
