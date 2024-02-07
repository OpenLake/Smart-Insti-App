import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_insti_app/constants/constants.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider();
});

class AuthState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final List<TextEditingController> otpDigitControllers;
  final String switchAuthLabel;
  final bool emailSent;

  AuthState({
    required this.emailController,
    required this.passwordController,
    required this.otpDigitControllers,
    required this.switchAuthLabel,
    required this.emailSent,
  });

  AuthState copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    List<TextEditingController>? otpDigitControllers,
    String? switchAuthLabel,
    bool? emailSent,
  }) {
    return AuthState(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      otpDigitControllers: otpDigitControllers ?? this.otpDigitControllers,
      switchAuthLabel: switchAuthLabel ?? this.switchAuthLabel,
      emailSent: emailSent ?? this.emailSent,
    );
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider()
      : super(
          AuthState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            otpDigitControllers: List.generate(4, (index) => TextEditingController()),
            switchAuthLabel: AuthConstants.studentAuthLabel,
            emailSent: false,
          ),
        );

  void toggleEmailSent() {
    state = state.copyWith(emailSent: !state.emailSent);
  }

  void toggleAuthSwitch() {
    state = state.copyWith(
      switchAuthLabel: state.switchAuthLabel == AuthConstants.studentAuthLabel
          ? AuthConstants.facultyAuthLabel
          : AuthConstants.studentAuthLabel,
    );
  }

  void sendOtp() {
    // Send OTP to the email
  }

  void clearControllers() {
    state.emailController.clear();
    state.passwordController.clear();
    for (var controller in state.otpDigitControllers) {
      controller.clear();
    }
  }
}
