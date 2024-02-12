import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/provider/otp_provider.dart';

import '../../components/otp_box.dart';
import '../../components/snackbar.dart';

import '../../provider/student_provider.dart';
import '../../provider/user_provider.dart';
import '../../services/auth/auth_service.dart';

class UserLogin extends ConsumerWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              context.go('/admin_login');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                'Admin',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ),
        ],
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: ref.read(otpProvider).emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (emailRegex.hasMatch(
                          ref.read(otpProvider).emailController.text)) {
                        ref.read(otpProvider.notifier).setShowOTPFields(true);
                        bool isShowOTPFields =
                            ref.read(otpProvider).showOTPFields;
                        print('showOTPFields is $isShowOTPFields');
                        authService.sendOTP(
                          context: context,
                          email: ref.read(otpProvider).emailController.text,
                        );
                      } else {
                        showSnackBar(
                          context,
                          'Please enter a valid email',
                        );
                      }
                    },
                    child: const Text('Send OTP'),
                  ),
                  const SizedBox(height: 16.0),
                  if (ref.watch(otpProvider).showOTPFields) ...[
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OTPBox(
                          controller: ref.read(otpProvider).otpController1,
                          focusNode: ref.read(otpProvider).focusNode1,
                          nextFocusNode: ref.read(otpProvider).focusNode2,
                        ),
                        OTPBox(
                          controller: ref.read(otpProvider).otpController2,
                          focusNode: ref.read(otpProvider).focusNode2,
                          nextFocusNode: ref.read(otpProvider).focusNode3,
                        ),
                        OTPBox(
                          controller: ref.read(otpProvider).otpController3,
                          focusNode: ref.read(otpProvider).focusNode3,
                          nextFocusNode: ref.read(otpProvider).focusNode4,
                        ),
                        OTPBox(
                          controller: ref.read(otpProvider).otpController4,
                          focusNode: ref.read(otpProvider).focusNode4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      width: 200,
                      child: DropdownButton<String>(
                        value: ref.read(otpProvider).dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          ref
                              .read(otpProvider.notifier)
                              .setDropdownValue(newValue!);
                        },
                        items: <String>['student', 'faculty']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    ElevatedButton(
                        child: const Text('Verify OTP'),
                        onPressed: () async {
                          final otp =
                              ref.read(otpProvider).otpController1.text +
                                  ref.read(otpProvider).otpController2.text +
                                  ref.read(otpProvider).otpController3.text +
                                  ref.read(otpProvider).otpController4.text;
                          final isVerified = await authService.verifyOTP(
                              ref.read(otpProvider).emailController.text, otp);
                          if (isVerified &&
                              ref.read(otpProvider).dropdownValue ==
                                  'student') {
                            ref.read(userProvider.notifier).postStudent(
                                ref.read(otpProvider).emailController.text);
                            context.go('/user_home');
                          } else if (isVerified &&
                              ref.read(otpProvider).dropdownValue ==
                                  'faculty') {
                            ref.read(userProvider.notifier).postFaculty(
                                ref.read(otpProvider).emailController.text);
                            context.go('/user_home');
                          } else {
                            showSnackBar(context, 'Incorrect OTP');
                          }
                        }),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
