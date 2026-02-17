import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/repositories/admin_repository.dart';
import 'package:smart_insti_app/repositories/faculty_repository.dart';
import 'package:smart_insti_app/repositories/student_repository.dart';
import 'package:smart_insti_app/repositories/alumni_repository.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';

import '../models/faculty.dart';
import '../models/alumni.dart';

final authProvider =
    StateNotifierProvider<AuthProvider, AuthState>((ref) => AuthProvider(ref));

class AuthState {
  final Object? currentUser;
  final String? currentUserRole;
  final String? token;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final List<TextEditingController> otpDigitControllers;
  final List<FocusNode> otpFocusNodes;
  final String switchAuthLabel;
  final bool emailSent;
  final LoadingState emailSendingState;
  final LoadingState loginProgressState;
  final LoadingState fetchUserProgress;

  AuthState({
    this.currentUser,
    this.currentUserRole,
    this.token,
    required this.emailController,
    required this.passwordController,
    required this.otpDigitControllers,
    required this.otpFocusNodes,
    required this.switchAuthLabel,
    required this.emailSent,
    required this.emailSendingState,
    required this.loginProgressState,
    required this.fetchUserProgress,
  });

  AuthState copyWith({
    Object? currentUser,
    String? currentUserRole,
    String? token,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    List<TextEditingController>? otpDigitControllers,
    List<FocusNode>? otpFocusNodes,
    String? switchAuthLabel,
    bool? emailSent,
    LoadingState? emailSendingState,
    LoadingState? loginProgressState,
    LoadingState? fetchUserProgress,
  }) {
    return AuthState(
      currentUser: currentUser,
      currentUserRole: currentUserRole,
      token: token ?? this.token,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      otpDigitControllers: otpDigitControllers ?? this.otpDigitControllers,
      otpFocusNodes: otpFocusNodes ?? this.otpFocusNodes,
      switchAuthLabel: switchAuthLabel ?? this.switchAuthLabel,
      emailSent: emailSent ?? this.emailSent,
      emailSendingState: emailSendingState ?? this.emailSendingState,
      loginProgressState: loginProgressState ?? this.loginProgressState,
      fetchUserProgress: fetchUserProgress ?? this.fetchUserProgress,
    );
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(ref)
      : _facultyRepository = ref.read(facultyRepositoryProvider),
        _studentRepository = ref.read(studentRepositoryProvider),
        _adminRepository = ref.read(adminRepositoryProvider),
        _alumniRepository = ref.read(alumniRepositoryProvider),
        _authService = ref.read(authServiceProvider),
        super(
          AuthState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            otpDigitControllers:
                List.generate(4, (index) => TextEditingController()),
            otpFocusNodes: List.generate(4, (index) => FocusNode()),
            switchAuthLabel: AuthConstants.studentAuthLabel,
            emailSent: false,
            emailSendingState: LoadingState.idle,
            loginProgressState: LoadingState.idle,
            fetchUserProgress: LoadingState.idle,
          ),
        );

  final AuthService _authService;
  final AdminRepository _adminRepository;
  final StudentRepository _studentRepository;
  final FacultyRepository _facultyRepository;
  final AlumniRepository _alumniRepository;
  LoadingState tokenCheckProgress = LoadingState.idle;
  final _logger = Logger();

  Future<void> sendOtp(BuildContext context) async {
    // Send OTP to the email
    state = state.copyWith(emailSendingState: LoadingState.progress);

    ({int statusCode, String message}) response = await _authService.sendOtp(
        state.emailController.text, state.switchAuthLabel.toLowerCase());

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (response.statusCode == 200) {
      state = state.copyWith(
          emailSent: true, emailSendingState: LoadingState.success);
    } else {
      state = state.copyWith(
          emailSent: false, emailSendingState: LoadingState.error);
    }
  }

  Future<bool> verifyOTPAndLogin(BuildContext context) async {
    state = state.copyWith(loginProgressState: LoadingState.progress);

    String otp = state.otpDigitControllers.fold<String>(
      '',
      (previousValue, element) => previousValue + element.text,
    );

    try {
      ({int statusCode, String message}) response =
          await _authService.verifyOtp(state.emailController.text, otp);
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
      final response = await _authService.loginFacultyOrStudent(
          state.emailController.text, state.switchAuthLabel.toLowerCase());
      await _authService.saveCredentials(response);
      state = state.copyWith(loginProgressState: LoadingState.success);
      return true;
    } catch (e) {
      _logger.e(e);
      state = state.copyWith(loginProgressState: LoadingState.error);
      return false;
    }
  }

  Future<String> getCurrentUser(BuildContext context) async {
    final Map<String, String> credentials = await _authService.checkCredentials();
    final String role = credentials['role'] ?? '';
    final String token = credentials['token'] ?? '';
    final String id = credentials['_id'] ?? '';

    if (token.isEmpty || id.isEmpty) {
      return '';
    }

    try {
      switch (role) {
        case 'admin':
          // Admin fetching logic
          // TODO: Implement getAdminById in repository if not already returning throwing
          // Assuming repositories throw now.
           try {
              Admin? admin = await _adminRepository.getAdminById(id, token);
              state = state.copyWith(currentUser: admin, currentUserRole: 'admin', token: token);
           } catch (e) {
             _handleAuthError(e, context);
             // If network error, we keep role so verification passes
             if (state.currentUser == null) {
                state = state.copyWith(currentUserRole: 'admin', token: token);
             }
           }
          break;
        case 'student':
           try {
              Student? student = await _studentRepository.getStudentById(id, token);
              state = state.copyWith(currentUser: student, currentUserRole: 'student', token: token);
           } catch (e) {
             _handleAuthError(e, context);
             if (state.currentUser == null) {
                state = state.copyWith(currentUserRole: 'student', token: token);
             }
           }
          break;
        case 'faculty':
           try {
              Faculty? faculty = await _facultyRepository.getFacultyById(id, token);
              state = state.copyWith(currentUser: faculty, currentUserRole: 'faculty', token: token);
           } catch (e) {
             _handleAuthError(e, context);
             if (state.currentUser == null) {
                state = state.copyWith(currentUserRole: 'faculty', token: token);
             }
           }
          break;
        case 'alumni':
           try {
              Alumni? alumni = await _alumniRepository.getAlumniById(id, token);
              state = state.copyWith(currentUser: alumni, currentUserRole: 'alumni', token: token);
           } catch (e) {
             _handleAuthError(e, context);
             if (state.currentUser == null) {
                state = state.copyWith(currentUserRole: 'alumni', token: token);
             }
           }
          break;
        default:
          break;
      }
    } catch (e) {
      // General error trap
      _logger.e("Error in getCurrentUser outer block: $e");
    }
    return role;
  }

  void _handleAuthError(Object e, BuildContext context) {
    if (e is DioException) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _logger.e("Auth Token Expired or Invalid");
        _authService.clearCredentials();
        clearCurrentUser();
        return;
      }
    }
    // For other errors (Network, 500, etc.), we Log but DO NOT Clear Credentials.
    _logger.e("Network or Server Error fetching user details: $e");
    // Optionally show snackbar if context is mounted?
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Network Error: Could not refresh user details")));
  }

  Future<void> verifyAuthTokenExistence(
      BuildContext context, String targetRole) async {
    tokenCheckProgress = LoadingState.progress;
    final Map<String, String> credentials =
        await _authService.checkCredentials();

    bool isInvalidRole = false;
    if (credentials['token'] == '') {
      isInvalidRole = true;
    } else if (targetRole == AuthConstants.adminAuthLabel.toLowerCase() &&
        credentials['role'] != targetRole) {
      isInvalidRole = true;
      } else if (targetRole == AuthConstants.generalAuthLabel.toLowerCase() &&
        !(credentials['role'] ==
                AuthConstants.facultyAuthLabel.toLowerCase() ||
            credentials['role'] ==
                AuthConstants.studentAuthLabel.toLowerCase() ||
            credentials['role'] ==
                AuthConstants.alumniAuthLabel.toLowerCase())) {
      isInvalidRole = true;
    }

    if (isInvalidRole) {
      await _authService.clearCredentials();
      clearCurrentUser();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to continue'),
            duration: Duration(seconds: 2),
          ),
        );
        context.go('/');
      }
    }

    tokenCheckProgress = LoadingState.success;
  }

  void clearCurrentUser() {
    state = state.copyWith(currentUser: null, currentUserRole: null, token: null);
  }

  Future<bool> loginAdmin() async {
    // Login the admin
    state = state.copyWith(loginProgressState: LoadingState.progress);
    try {
      final response = await _authService.loginAdmin(
          state.emailController.text, state.passwordController.text);
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
    String nextLabel;
    if (state.switchAuthLabel == AuthConstants.studentAuthLabel) {
      nextLabel = AuthConstants.facultyAuthLabel;
    } else if (state.switchAuthLabel == AuthConstants.facultyAuthLabel) {
      nextLabel = AuthConstants.alumniAuthLabel;
    } else {
      nextLabel = AuthConstants.studentAuthLabel;
    }
    state = state.copyWith(
      switchAuthLabel: nextLabel,
    );
  }

  void clearControllers() {
    state.emailController.clear();
    state.passwordController.clear();
    for (TextEditingController controller in state.otpDigitControllers) {
      controller.clear();
    }
    state = state.copyWith(
        emailSent: false,
        emailSendingState: LoadingState.idle,
        loginProgressState: LoadingState.idle);
  }

  Future<bool> loginDemoStudent() async {
    state = state.copyWith(loginProgressState: LoadingState.progress);
    const demoEmail = 'demo@insti.app';
    const demoRole = 'student';

    // 1. Try to login
    try {
      final response =
          await _authService.loginFacultyOrStudent(demoEmail, demoRole);

      // If login successful
      if (response.containsKey('data')) {
        await _authService.saveCredentials(response);
        state = state.copyWith(loginProgressState: LoadingState.success);
        return true;
      }
    } catch (e) {
      _logger.i("Demo user not found, registering...");
    }

    // 2. If login failed / User not found, Register
    try {
      final registerResponse = await _authService.registerStudent({
        'email': demoEmail,
        'name': 'Demo Student',
        'rollNumber': 'DEMO123',
        'branch': 'CSE',
        'graduationYear': 2026,
      });

      if (registerResponse['status'] == true || registerResponse['message'] == 'User registered successfully.') {
         // Backend might return status: true or just a message.
         // Let's assume typical response.
         // Calling login anyway.
      }
       // 3. Login again after registration (or attempt to)
        final loginResponse =
            await _authService.loginFacultyOrStudent(demoEmail, demoRole);
        
        if (loginResponse.containsKey('data')) {
             await _authService.saveCredentials(loginResponse);
            state = state.copyWith(loginProgressState: LoadingState.success);
            return true;
        }

    } catch (e) {
      _logger.e("Demo login failed: $e");
    }

    state = state.copyWith(loginProgressState: LoadingState.error);
    return false;
  }
}
