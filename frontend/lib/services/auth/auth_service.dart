import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../components/snackbar.dart';
import '../../constants/error_handling.dart';

class AuthService {
  final storage = FlutterSecureStorage();
  final String baseUrl =
      'http://10.0.2.2:3000'; // Replace with your backend API URL

  Future<void> sendOTP({
    required BuildContext context,
    required String email,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'OTP sent successfully',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print(e);
    }
  }

  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        body: jsonEncode({'email': email, 'otp': otp}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String jwt = data['token'];
        await storage.write(key: 'jwt', value: jwt);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle network or server error
      print(e);
      return false;
    }
  }
}
