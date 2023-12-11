import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicalapp/screen/navigation_screen.dart';

import 'package:scroll_date_picker/scroll_date_picker.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "Registration_screen";

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

enum Gender { MAN, WOMEN }

Gender _gender = Gender.MAN;

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<bool> checkList = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  List<String> questionList = [
    '---- 질문을 선택해주세요 ----',
    '가장 좋아하는 것은?',
    '가장 싫어하는 것은?',
    '아버지 성함은?',
    '어머니 성함은?',
    '가장 좋아하는 색깔은?',
    '가장 좋아하는 계절은?',
    '감명깊게 본 영화 제목은?',
  ];

  DateTime _selectedDate = DateTime.now();
  bool showSpinner = false;
  String _email = '';
  String _password = '';

  String birth = '';
  String gender = '';
  String nickname = '';
  String answer = '';
  String hint = '---- 질문을 선택해주세요 ----';

  late bool checkhealth = false;
  late bool checkarduino = false;
  late int oxquiz = 0;
  late Timestamp date = Timestamp.now();
  late bool todayCheck = false;

  late final userPoint = <String, dynamic>{
    "email": _email,
    "point": 0,
  };

  late final userInfo = <String, dynamic>{
    "birth": birth,
    "gender": gender,
    "hint": hint,
    "answer": answer,
    "nickname": nickname,
  };

  late final dailyquest = <String, dynamic>{
    "checkhealth": checkhealth,
    "checkarduino": checkarduino,
    "oxquiz": oxquiz,
    "date": date,
  };

  String get email => _email;
  String get password => _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text(
          '회원가입',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: const <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 24.0,
                ),
                const Text(
                  "이메일",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                      checkList[0] = true;
                    });
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(),
                    hintText: "이메일를 입력해주세요.",
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Text(
                  "비밀번호",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                      checkList[1] = true;
                    });
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(),
                    hintText: "비밀번호를 입력해주세요.(6자리이상)",
                  ),
                ),
                const Text(
                  "닉네임",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    nickname = value;
                    checkList[2] = true;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(),
                    hintText: "닉네임을 입력해주세요.",
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const Text(
                  "성별",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ListTile(
                  title: const Text('남자'),
                  leading: Radio(
                    value: Gender.MAN,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as Gender;
                        gender = "man";
                        checkList[3] = true;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('여자'),
                  leading: Radio(
                    value: Gender.WOMEN,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as Gender;
                        gender = "woman";
                        checkList[3] = true;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Text(
                  "생년월일",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        _selectedDate.toString().split(" ")[0],
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ScrollDatePicker(
                    selectedDate: _selectedDate,
                    locale: const Locale('ko'),
                    onDateTimeChanged: (DateTime value) {
                      setState(() {
                        birth = _selectedDate.toString().split(" ")[0];
                        _selectedDate = value;
                        checkList[4] = true;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const Text(
                  "비밀번호 재설정 힌트/답",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                DropdownButton(
                  value: hint,
                  items: questionList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      hint = value;
                    });
                  },
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      answer = value;
                      checkList[5] = true;
                    });
                  },
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(),
                    hintText: "질문의 답을 입력해주세요.",
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        }
                        return checkList[0] &&
                                checkList[1] &&
                                checkList[2] &&
                                checkList[3] &&
                                checkList[4] &&
                                checkList[5]
                            ? Colors.cyan
                            : Colors.grey;
                      },
                    ),
                  ),
                  onPressed: checkList[0] &&
                          checkList[1] &&
                          checkList[2] &&
                          checkList[3] &&
                          checkList[4] &&
                          checkList[5]
                      ? () async {
                          setState(() {
                            showSpinner = true;
                          });
                          //Create new Account
                          try {
                            await _auth
                                .createUserWithEmailAndPassword(
                                    email: email, password: password)
                                .then(
                              (value) {
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NavigationScreen(),
                                  ),
                                );
                                print('Successfully Created');
                                _firestore
                                    .collection("mileages")
                                    .doc(_email)
                                    .set(
                                      userPoint,
                                      SetOptions(merge: true),
                                    )
                                    .onError(
                                      (e, _) => print("Error:$e"),
                                    );
                                _firestore
                                    .collection("userinfo")
                                    .doc(_email)
                                    .set(
                                      userInfo,
                                      SetOptions(merge: true),
                                    )
                                    .onError(
                                      (e, _) => print("Error:$e"),
                                    );
                                _firestore
                                    .collection("dailyquest")
                                    .doc(_email)
                                    .set(
                                      dailyquest,
                                      SetOptions(merge: true),
                                    )
                                    .onError(
                                      (e, _) => print("Error:$e"),
                                    );
                              },
                            );
                          } catch (e) {
                            print(e);
                          }
                        }
                      : () {},
                  child: const Text(
                    '가입하기',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
