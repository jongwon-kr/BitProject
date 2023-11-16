import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class findPasswordScreen extends StatefulWidget {
  static String id = "login_screen";

  const findPasswordScreen({super.key});

  @override
  findPasswordScreenState createState() => findPasswordScreenState();
}

class findPasswordScreenState extends State<findPasswordScreen> {
  bool checkEmail = false;
  bool showSpinner = false;
  String email = '';
  String password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan[600],
        title: const Text(
          '비밀번호 변경',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: const <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const Text(
              "본인 이메일",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  email = value;
                  checkEmail = true;
                });
              },
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(),
                hintText: "이메일를 입력해주세요.",
              ),
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
                    return checkEmail
                        ? const Color.fromRGBO(0, 172, 193, 1)
                        : Colors.grey;
                  },
                ),
              ),
              child: const Text('비밀번호 재설정 메일전송'),
              onPressed: () {
                if (email.isNotEmpty) {
                  resetPassword(email);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
