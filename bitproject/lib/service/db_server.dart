import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:medicalapp/model/user_model.dart';
import 'package:medicalapp/screen/HomeScreen.dart';

Future<void> saveUser(User user) async {
  try {
    final response = await http.post(
      Uri.parse("http://server-uri/user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to send data");
    } else {
      print("User Data sent successfully");
      Get.to(const HomeScreen());
    }
  } catch (e) {
    print("Failed to send post data: $e");
  }
}
