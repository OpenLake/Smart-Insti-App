import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/repositories/admin_repository.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) => AuthProvider(ref));

class AuthState {
  final Object? currentUser;
  final String? currentUserRole;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final List<TextEditingController> otpDigitControllers;
  final List<FocusNode> otpFocusNodes;
  final String switchAuthLabel;
  final bool emailSent;

  AuthState({
    this.currentUser,
    this.currentUserRole,
    required this.emailController,
    required this.passwordController,
    required this.otpDigitControllers,
    required this.otpFocusNodes,
    required this.switchAuthLabel,
    required this.emailSent,
  });

  AuthState copyWith({
    Object? currentUser,
    String? currentUserRole,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    List<TextEditingController>? otpDigitControllers,
    List<FocusNode>? otpFocusNodes,
    String? switchAuthLabel,
    bool? emailSent,
  }) {
    return AuthState(
      currentUser: currentUser,
      currentUserRole: currentUserRole,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      otpDigitControllers: otpDigitControllers ?? this.otpDigitControllers,
      otpFocusNodes: otpFocusNodes ?? this.otpFocusNodes,
      switchAuthLabel: switchAuthLabel ?? this.switchAuthLabel,
      emailSent: emailSent ?? this.emailSent,
    );
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(ref)
      : _adminRepository = ref.read(adminRepositoryProvider),
        _authService = ref.read(authServiceProvider),
        super(
          AuthState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            otpDigitControllers: List.generate(4, (index) => TextEditingController()),
            otpFocusNodes: List.generate(4, (index) => FocusNode()),
            switchAuthLabel: AuthConstants.studentAuthLabel,
            emailSent: false,
          ),
        );

  final AuthService _authService;
  final AdminRepository _adminRepository;
  final _logger = Logger();

  void toggleEmailSent() {
    state = state.copyWith(emailSent: !state.emailSent);
  }

  void getCurrentUser() async {
    final Map<String, String> credentials = await _authService.checkCredentials();
    switch (credentials['role']) {
      case 'admin':
        Admin? admin = await _adminRepository.getAdminById(credentials['_id']!);
        state = state.copyWith(currentUser: admin, currentUserRole: 'admin');
        break;
      case 'student':
        break;
      case 'faculty':
        break;
      default:
        break;
    }
  }

  void clearCurrentUser() {
    state = state.copyWith(currentUser: null, currentUserRole: null);
  }

  Future<bool> loginAdmin() async {
    // Login the admin
    state = state.copyWith(loginProgressState: LoadingState.progress);
    try {
      final response = await _authService.loginAdmin(state.emailController.text, state.passwordController.text);
      await _authService.saveCredentials(response);
      state = state.copyWith(loginProgressState: LoadingState.success);
      return true;
    } catch (e) {
      state = state.copyWith(loginProgressState: LoadingState.error);
      _logger.e(e);
      return false;
    }
  }

  void initializeOtpFocusNodes() {
    for (TextEditingController i in state.otpDigitControllers) {
      i.addListener(
        () {
          if (i.text.length == 1) {
            final int index = state.otpDigitControllers.indexOf(i);
            if (index != state.otpDigitControllers.length - 1) {
              state.otpFocusNodes[index + 1].requestFocus();
            }
          }
        },
      );
    }
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
    for (TextEditingController controller in state.otpDigitControllers) {
      controller.clear();
    }
  }
}
