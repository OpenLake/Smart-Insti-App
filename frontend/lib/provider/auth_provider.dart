import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/models/alumni.dart';
import 'package:smart_insti_app/repositories/admin_repository.dart';
import 'package:smart_insti_app/repositories/faculty_repository.dart';
import 'package:smart_insti_app/repositories/student_repository.dart';
import 'package:smart_insti_app/repositories/alumni_repository.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../constants/constants.dart';

final authProvider =
    StateNotifierProvider<AuthProvider, AuthState>((ref) => AuthProvider(ref));

class AuthState {
  final Object? currentUser;
  final String? currentUserRole;
  final sb.User? sbUser;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final List<TextEditingController> otpDigitControllers;
  final List<FocusNode> otpFocusNodes;
  final String switchAuthLabel;
  final bool emailSent;
  final LoadingState emailSendingState;
  final LoadingState loginProgressState;
  final bool needsOnboarding;

  AuthState({
    this.currentUser,
    this.currentUserRole,
    this.sbUser,
    required this.emailController,
    required this.passwordController,
    required this.otpDigitControllers,
    required this.otpFocusNodes,
    required this.switchAuthLabel,
    required this.emailSent,
    required this.emailSendingState,
    required this.loginProgressState,
    this.needsOnboarding = false,
  });

  String? get token =>
      Supabase.instance.client.auth.currentSession?.accessToken;

  AuthState copyWith({
    Object? currentUser,
    String? currentUserRole,
    sb.User? sbUser,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    List<TextEditingController>? otpDigitControllers,
    List<FocusNode>? otpFocusNodes,
    String? switchAuthLabel,
    bool? emailSent,
    LoadingState? emailSendingState,
    LoadingState? loginProgressState,
    bool? needsOnboarding,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      currentUserRole: currentUserRole ?? this.currentUserRole,
      sbUser: sbUser ?? this.sbUser,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      otpDigitControllers: otpDigitControllers ?? this.otpDigitControllers,
      otpFocusNodes: otpFocusNodes ?? this.otpFocusNodes,
      switchAuthLabel: switchAuthLabel ?? this.switchAuthLabel,
      emailSent: emailSent ?? this.emailSent,
      emailSendingState: emailSendingState ?? this.emailSendingState,
      loginProgressState: loginProgressState ?? this.loginProgressState,
      needsOnboarding: needsOnboarding ?? this.needsOnboarding,
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
                List.generate(8, (index) => TextEditingController()),
            otpFocusNodes: List.generate(8, (index) => FocusNode()),
            switchAuthLabel: AuthConstants.studentAuthLabel,
            emailSent: false,
            emailSendingState: LoadingState.idle,
            loginProgressState: LoadingState.idle,
          ),
        ) {
    _init();
  }

  final AuthService _authService;
  final AdminRepository _adminRepository;
  final StudentRepository _studentRepository;
  final FacultyRepository _facultyRepository;
  final AlumniRepository _alumniRepository;
  final _logger = Logger();

  BuildContext? _pendingOAuthContext;

  void _init() {
    _authService.authStateChanges.listen((event) {
      final session = event.session;
      final user = session?.user;
      if (user != null) {
        state = state.copyWith(
            sbUser: user, currentUserRole: user.userMetadata?['role']);

        // Handle OAuth callback: when auth event is signedIn and we had a
        // pending Google login, run the profile sync + navigation.
        if (event.event == AuthChangeEvent.signedIn &&
            _pendingOAuthContext != null) {
          final ctx = _pendingOAuthContext!;
          _pendingOAuthContext = null;
          _handleOAuthSignedIn(ctx);
        }
      } else {
        state =
            state.copyWith(sbUser: null, currentUser: null, currentUserRole: null);
      }
    });
  }

  Future<void> _handleOAuthSignedIn(BuildContext context) async {
    try {
      await getCurrentUser(context);
      state = state.copyWith(loginProgressState: LoadingState.success);
      if (context.mounted) {
        if (state.needsOnboarding) {
          context.go('/onboarding');
        } else {
          context.go('/user_home');
        }
      }
    } catch (e) {
      _logger.e("OAuth post-signin error: $e");
      state = state.copyWith(loginProgressState: LoadingState.error);
    }
  }

  Future<void> sendOtp(BuildContext context) async {
    // Legacy support disabled.
  }

  Future<bool> signUpWithPassword(BuildContext context) async {
    state = state.copyWith(loginProgressState: LoadingState.progress);
    try {
      final response = await _authService.signUpWithPassword(
          email: state.emailController.text,
          password: state.passwordController.text,
          metadata: {'role': state.switchAuthLabel.toLowerCase()});
      
      if (response.session == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Signup successful! Verification code sent.")));
          context.push('/verify-otp');
        }
        state = state.copyWith(loginProgressState: LoadingState.idle);
        return true;
      }

      state = state.copyWith(loginProgressState: LoadingState.success);
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Signup Failed: $e")));
      }
      state = state.copyWith(loginProgressState: LoadingState.error);
      return false;
    }
  }

  Future<bool> verifyEmailOTP(BuildContext context) async {
    final email = state.emailController.text;
    final otp = state.otpDigitControllers.map((c) => c.text).join();
    
    if (otp.length != 8) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a valid 8-digit OTP")));
      }
      return false;
    }

    state = state.copyWith(loginProgressState: LoadingState.progress);
    try {
      await _authService.verifyOtp(email, otp);
      await getCurrentUser(context);
      state = state.copyWith(loginProgressState: LoadingState.success);
      return true;
    } catch (e) {
      _logger.e("OTP Verification error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification Failed: Invalid OTP")));
      }
      state = state.copyWith(loginProgressState: LoadingState.error);
      return false;
    }
  }

  Future<bool> loginWithPassword(BuildContext context) async {
    state = state.copyWith(loginProgressState: LoadingState.progress);
    try {
      await _authService.signInWithPassword(
          state.emailController.text, state.passwordController.text);
      // Wait for the auth session to establish then run profile sync
      await getCurrentUser(context);
      state = state.copyWith(loginProgressState: LoadingState.success);
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login Failed: $e")));
      }
      state = state.copyWith(loginProgressState: LoadingState.error);
      return false;
    }
  }

  Future<bool> loginWithGoogle(BuildContext context) async {
    state = state.copyWith(loginProgressState: LoadingState.progress);
    try {
      _pendingOAuthContext = context;
      final launched = await _authService.signInWithGoogle();
      if (!launched) {
        _pendingOAuthContext = null;
        state = state.copyWith(loginProgressState: LoadingState.error);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Could not launch Google Sign-In")));
        }
        return false;
      }
      // Browser was launched; the auth state listener will handle the rest.
      return true;
    } catch (e) {
      _pendingOAuthContext = null;
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Google Login Failed: $e")));
      }
      state = state.copyWith(loginProgressState: LoadingState.error);
      return false;
    }
  }

  Future<String> getCurrentUser(BuildContext context) async {
    final user = _authService.currentUser;
    if (user == null) return '';

    final role = user.userMetadata?['role'] ?? '';

    state = state.copyWith(currentUserRole: role);

    try {
      final profileData = await _authService.getUserProfile(null);
      if (profileData != null) {
        Object? profile;
        switch (role) {
          case 'admin':
            profile = Admin.fromJson(profileData);
            break;
          case 'student':
            profile = Student.fromJson(profileData);
            if ((profile as Student).rollNumber.isEmpty) {
              state = state.copyWith(needsOnboarding: true);
            }
            break;
          case 'faculty':
            profile = Faculty.fromJson(profileData);
            break;
          case 'alumni':
            profile = Alumni.fromJson(profileData);
            break;
        }
        if (profile != null) {
          state = state.copyWith(currentUser: profile);
        }
      } else {
        // No profile found in Supabase
        state = state.copyWith(needsOnboarding: true);
      }
    } catch (e) {
      _logger.e("Error fetching profile: $e");
      // Fallback: Populate basic info from Supabase metadata if profile fetch fails
      if (state.currentUser == null) {
        final fallbackName = user.userMetadata?['name'] ?? 'Smart Insti User';
        if (role == 'student') {
          state = state.copyWith(
              currentUser: Student(
                  id: user.id,
                  name: fallbackName,
                  email: user.email ?? '',
                  rollNumber: ''),
              needsOnboarding: true);
        } else if (role == 'faculty') {
          state = state.copyWith(
              currentUser: Faculty(
                  id: user.id, name: fallbackName, email: user.email ?? ''),
              needsOnboarding: true);
        }
      }
    }
    return role;
  }

  Future<void> logout(BuildContext context) async {
    await _authService.signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }

  Future<void> verifyAuthTokenExistence(
      BuildContext context, String targetRole) async {
    final user = _authService.currentUser;
    if (user == null) {
      if (context.mounted) {
        context.go('/login');
      }
      return;
    }

    final role = user.userMetadata?['role'] ?? '';
    bool isInvalidRole = false;

    if (targetRole == AuthConstants.adminAuthLabel.toLowerCase() &&
        role != targetRole) {
      isInvalidRole = true;
    } else if (targetRole == AuthConstants.generalAuthLabel.toLowerCase() &&
        !(role == AuthConstants.facultyAuthLabel.toLowerCase() ||
            role == AuthConstants.studentAuthLabel.toLowerCase() ||
            role == AuthConstants.alumniAuthLabel.toLowerCase())) {
      isInvalidRole = true;
    }

    if (isInvalidRole) {
      await logout(context);
    }
  }

  LoadingState get tokenCheckProgress => state.loginProgressState; // Shim

  void initializeOtpFocusNodes() {
    for (var i = 0; i < state.otpDigitControllers.length; i++) {
      final controller = state.otpDigitControllers[i];
      controller.addListener(() {
        if (controller.text.length == 1) {
          if (i < state.otpFocusNodes.length - 1) {
            state.otpFocusNodes[i + 1].requestFocus();
          }
        }
      });
    }
  }

  Future<bool> updateProfile(
      BuildContext context, Map<String, dynamic> data) async {
    final token = _authService.currentSession?.accessToken;
    if (token == null) {
      state = state.copyWith(loginProgressState: LoadingState.error);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Session expired. Please log in again.")));
        context.go('/login');
      }
      return false;
    }

    state = state.copyWith(loginProgressState: LoadingState.progress);

    try {
      final updatedData = await _authService.updateProfile(token, data);
      if (updatedData != null) {
        state = state.copyWith(
            needsOnboarding: false); // Reset flag on successful update
        await getCurrentUser(context);
        state = state.copyWith(loginProgressState: LoadingState.success);
        return true;
      }
    } catch (e) {
      _logger.e("Update profile error: $e");
    }

    state = state.copyWith(loginProgressState: LoadingState.error);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to update profile. Please try again.")));
    }
    return false;
  }

  void clearCurrentUser() {
    state =
        state.copyWith(currentUser: null, currentUserRole: null, sbUser: null);
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
    state = state.copyWith(switchAuthLabel: nextLabel);
  }

  void clearControllers() {
    state.emailController.clear();
    state.passwordController.clear();
    for (var c in state.otpDigitControllers) {
      c.clear();
    }
    state = state.copyWith(
        emailSent: false,
        emailSendingState: LoadingState.idle,
        loginProgressState: LoadingState.idle);
  }
}
