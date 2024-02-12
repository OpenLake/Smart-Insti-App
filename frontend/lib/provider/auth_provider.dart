import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/repositories/admin_repository.dart';
import 'package:smart_insti_app/repositories/faculty_repository.dart';
import 'package:smart_insti_app/repositories/student_repository.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';

import '../models/faculty.dart';

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
  final LoadingState emailSendingState;
  final LoadingState loginProgressState;
  final LoadingState tokenCheckProgress;

  AuthState({
    this.currentUser,
    this.currentUserRole,
    required this.emailController,
    required this.passwordController,
    required this.otpDigitControllers,
    required this.otpFocusNodes,
    required this.switchAuthLabel,
    required this.emailSent,
    required this.emailSendingState,
    required this.loginProgressState,
    required this.tokenCheckProgress,
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
    LoadingState? emailSendingState,
    LoadingState? loginProgressState,
    LoadingState? tokenCheckProgress,
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
      emailSendingState: emailSendingState ?? this.emailSendingState,
      loginProgressState: loginProgressState ?? this.loginProgressState,
      tokenCheckProgress: tokenCheckProgress ?? this.tokenCheckProgress,
    );
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(ref)
      : _facultyRepository = ref.read(facultyRepositoryProvider),
        _studentRepository = ref.read(studentRepositoryProvider),
        _adminRepository = ref.read(adminRepositoryProvider),
        _authService = ref.read(authServiceProvider),
        super(
          AuthState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            otpDigitControllers: List.generate(4, (index) => TextEditingController()),
            otpFocusNodes: List.generate(4, (index) => FocusNode()),
            switchAuthLabel: AuthConstants.studentAuthLabel,
            emailSent: false,
            emailSendingState: LoadingState.idle,
            loginProgressState: LoadingState.idle,
            tokenCheckProgress: LoadingState.idle,
          ),
        );

  final AuthService _authService;
  final AdminRepository _adminRepository;
  final StudentRepository _studentRepository;
  final FacultyRepository _facultyRepository;
  final _logger = Logger();

  Future<void> sendOtp(BuildContext context) async {
    // Send OTP to the email
    state = state.copyWith(emailSendingState: LoadingState.progress);

    ({int statusCode, String message}) response =
        await _authService.sendOtp(state.emailController.text, state.switchAuthLabel.toLowerCase());

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (response.statusCode == 200) {
      state = state.copyWith(emailSent: true, emailSendingState: LoadingState.success);
    } else {
      state = state.copyWith(emailSent: false, emailSendingState: LoadingState.error);
    }
  }

  Future<bool> verifyOTPAndLogin(BuildContext context) async {
    state = state.copyWith(loginProgressState: LoadingState.progress);

    String otp = state.otpDigitControllers.fold<String>(
      '',
      (previousValue, element) => previousValue + element.text,
    );

    try {
      ({int statusCode, String message}) response = await _authService.verifyOtp(state.emailController.text, otp);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(loginProgressState: LoadingState.error);
      return false;
    }

    try {
      final response =
          await _authService.loginFacultyOrStudent(state.emailController.text, state.switchAuthLabel.toLowerCase());
      await _authService.saveCredentials(response);
      state = state.copyWith(loginProgressState: LoadingState.success);
      return true;
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(loginProgressState: LoadingState.error);
      return false;
    }
  }

  void getCurrentUser() async {
    final Map<String, String> credentials = await _authService.checkCredentials();
    switch (credentials['role']) {
      case 'admin':
        Admin? admin = await _adminRepository.getAdminById(credentials['_id']!);
        state = state.copyWith(currentUser: admin, currentUserRole: 'admin');
        break;
      case 'student':
        Student? student = await _studentRepository.getStudentById(credentials['_id']!);
        state = state.copyWith(currentUser: student, currentUserRole: 'student');
        break;
      case 'faculty':
        Faculty? faculty = await _facultyRepository.getFacultyById(credentials['_id']!);
        state = state.copyWith(currentUser: faculty, currentUserRole: 'faculty');
        break;
      default:
        break;
    }
  }

  void verifyAuthTokenExistence(BuildContext context) async {
    state = state.copyWith(tokenCheckProgress: LoadingState.progress);
    final Map<String, String> credentials = await _authService.checkCredentials();
    if (credentials['token'] == '' && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to continue'),
          duration: Duration(seconds: 2),
        ),
      );
      context.go('/');
    }
    state = state.copyWith(tokenCheckProgress: LoadingState.success);
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

  void clearControllers() {
    state.emailController.clear();
    state.passwordController.clear();
    for (TextEditingController controller in state.otpDigitControllers) {
      controller.clear();
    }
    state =
        state.copyWith(emailSent: false, emailSendingState: LoadingState.idle, loginProgressState: LoadingState.idle);
  }
}
