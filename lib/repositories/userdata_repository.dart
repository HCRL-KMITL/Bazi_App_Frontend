import 'dart:convert';
import 'dart:developer';

import 'package:bazi_app_frontend/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserDataRepository {
  final String? apiUrl = dotenv.env['API_URL'];
  final User user = FirebaseAuth.instance.currentUser!;

  // HANDLE FIRST TIME USER CHECKING \\
  Future<bool> isFirstTimeUser() async {
    final String? tk = await user.getIdToken();
    //print("Token: $tk");
    final response = await http.post(
      Uri.parse('$apiUrl/auth/'),
      headers: {"Authorization": "$tk", "Content-Type": "application/json"},
      body: "{}",
    );
    //print("Code: ${response.statusCode}, Body: ${response.body}");
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 409) {
      return false;
    } else {
      FirebaseAuth.instance.signOut();
      return false;
    }
  }

  // HANDLE FIRST TIME USER DATA INSERTION \\
  Future<void> registerUser(
    String appDisplayName,
    String birthDate,
    String birthTime,
    int gender,
  ) async {
    final String? tk = await user.getIdToken();
    final request = {
      "name": appDisplayName,
      "birth_date": "$birthDate $birthTime",
      "gender": gender,
    };
    log("PUT Request: $request");
    final sth = await http.put(
      Uri.parse('$apiUrl/users/'),
      headers: {"Authorization": "$tk", "Content-Type": "application/json"},
      body: jsonEncode(request),
    );
    if (sth.statusCode != 200) {
      FirebaseAuth.instance.signOut();
      throw Exception(sth.body);
    }
    //print("Code: ${response.statusCode}, Body: ${response.body}");
  }

  // HANDLE USER DATA RETRIEVAL \\
  Future<UserModel> getUserData() async {
    final String? tk = await user.getIdToken();
    final response = await http.get(
      Uri.parse('$apiUrl/users/'),
      headers: {"Authorization": "$tk", "Content-Type": "application/json"},
    );
    //print("Code: ${response.statusCode}, Body: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception("Failed to get user data");
    }
  }

  // HANDLE USER DATA UPDATE \\
  // Future<void> updateUserData(String uid, String appDisplayName,
  //     String birthDate, String birthTime, int gender) async {
  //   await userData.doc(uid).update({
  //     'appDisplayName': appDisplayName,
  //     'birthDate': birthDate,
  //     'birthTime': birthTime,
  //     'gender': gender,
  //   });
  // }
}
