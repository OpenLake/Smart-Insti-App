import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/snackbar.dart';
import '../../services/auth/auth_service.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showOTPFields = false;
  final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  final emailController = TextEditingController();
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

    // Do the same for the other OTPBoxes
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Call sendOtp when the button is clicked
                if (emailRegex.hasMatch(emailController.text)) {
                  // If the email is valid, set the state
                  setState(() {
                    showOTPFields = true;
                  });
                  authService.sendOTP(
                    context: context,
                    email: emailController.text,
                  );
                } else {
                  // If the email is not valid, show a SnackBar with an error message
                  showSnackBar(
                    context,
                    'Please enter a valid email',
                  );
                }
              },
              child: Text('Send OTP'),
            ),
            if (showOTPFields) ...[
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OTPBox(controller: otpController1, focusNode: focusNode1),
                  OTPBox(controller: otpController2, focusNode: focusNode2),
                  OTPBox(controller: otpController3, focusNode: focusNode3),
                  OTPBox(controller: otpController4, focusNode: focusNode4),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  final otp = otpController1.text +
                      otpController2.text +
                      otpController3.text +
                      otpController4.text;
                  print('OTP: $otp'); // Print the OTP
                  // Call verifyOTP
                  final isVerified =
                      await authService.verifyOTP(emailController.text, otp);

                  if (isVerified) {
                    // Navigate to the admin home page
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
            ],
          ],
        ),
      ),
    );
  }
}

class OTPBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  OTPBox({required this.controller, required this.focusNode});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
