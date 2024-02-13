import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../components/snackbar.dart';
import '../../constants/error_handling.dart';
import '../../provider/student_provider.dart';
import '../../provider/user_provider.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  final String baseUrl =
      'http://10.0.2.2:3000'; // Replace with your backend API URL
  Future<void> signUpAdmin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$baseUrl/signup'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
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
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print(e);
    }
  }

  Future<void> signInAdmin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$baseUrl/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          context.go('/admin_login/admin_home');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> loginUser(String email, String jwt) async {
    var url = Uri.parse('$baseUrl/login');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('Login successful');
    } else {
      print('Login failed');
    }
  }
}
