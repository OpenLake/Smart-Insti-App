import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/otp_box.dart';
import '../../components/snackbar.dart';
import '../../services/auth/auth_service.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  bool showOTPFields = false;
  final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController1 = TextEditingController();
  final otpController2 = TextEditingController();
  final otpController3 = TextEditingController();
  final otpController4 = TextEditingController();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();

  final authService = AuthService(); // Create an instance of AuthService

  @override
  void initState() {
    super.initState();

    // When the text in the first OTPBox changes, request focus for the second OTPBox
    otpController1.addListener(() {
      if (otpController1.text.length >= 1) {
        FocusScope.of(context).requestFocus(focusNode2);
      }
    });

    otpController2.addListener(() {
      if (otpController2.text.length >= 1) {
        FocusScope.of(context).requestFocus(focusNode3);
      }
    });

    otpController3.addListener(() {
      if (otpController3.text.length >= 1) {
        FocusScope.of(context).requestFocus(focusNode4);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              context.go('/admin_login');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Admin',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ),
        ],
        title: Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome User',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (emailRegex.hasMatch(emailController.text)) {
                        setState(() {
                          showOTPFields = true;
                        });
                        authService.sendOTP(
                          context: context,
                          email: emailController.text,
                        );
                      } else {
                        showSnackBar(
                          context,
                          'Please enter a valid email',
                        );
                      }
                    },
                    child: Text('Send OTP'),
                  ),
                  SizedBox(height: 16.0),
                  if (showOTPFields) ...[
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OTPBox(
                            controller: otpController1, focusNode: focusNode1),
                        OTPBox(
                            controller: otpController2, focusNode: focusNode2),
                        OTPBox(
                            controller: otpController3, focusNode: focusNode3),
                        OTPBox(
                            controller: otpController4, focusNode: focusNode4),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final otp = otpController1.text +
                            otpController2.text +
                            otpController3.text +
                            otpController4.text;
                        final isVerified = await authService.verifyOTP(
                            emailController.text, otp);

                        if (isVerified) {
                          context.go('/admin_home');
                        } else {
                          showSnackBar(
                            context,
                            'Incorrect OTP',
                          );
                        }
                      },
                      child: Text('Verify OTP'),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
