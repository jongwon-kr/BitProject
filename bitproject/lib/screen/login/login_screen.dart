import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:medicalapp/screen/NavigationScreen.dart';
import 'package:medicalapp/screen/login/find_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  List<bool> checkList = [false, false];
  bool showSpinner = false;
  String email = '';
  String password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan[600],
        title: const Text(
          '로그인',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: const <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "이메일",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  email = value;
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
                  password = value;
                  checkList[1] = true;
                });
              },
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(),
                hintText: "비밀번호를 입력해주세요.",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const findPasswordScreen()),
                    );
                  },
                  child: const Text(
                    '비밀번호 재설정',
                    style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
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
                    return checkList[0] && checkList[1]
                        ? const Color.fromRGBO(0, 172, 193, 1)
                        : Colors.grey;
                  },
                ),
              ),
              child: const Text('Log in'),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                //Login to existing account
                try {
                  await _auth
                      .signInWithEmailAndPassword(
                          email: email, password: password)
                      .then((value) {
                    setState(() {
                      showSpinner = false;
                    });
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavigationScreen()),
                    );
                    return value;
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('등록되지 않은 이메일입니다');
                  } else if (e.code == 'wrong-password') {
                    print('비밀번호가 틀렸습니다');
                  } else {
                    print(e.code);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
