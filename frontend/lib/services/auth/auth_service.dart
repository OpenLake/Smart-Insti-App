import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final authServiceProvider = Provider<AuthService>((_) => AuthService());

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Logger _logger = Logger();

  AuthService();

  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _logger.e("SignIn error: $e");
      rethrow;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final success = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.smartinstiapp://login-callback',
      );
      return success;
    } catch (e) {
      _logger.e("Google SignIn error: $e");
      rethrow;
    }
  }

  Future<AuthResponse> signUpWithPassword({
    required String email,
    required String password,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
    } catch (e) {
      _logger.e("SignUp error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      _logger.e("SignOut error: $e");
    }
  }

  Future<void> logout() async {
    await signOut();
  }

  // Legacy compatibility / Check helper
  Future<Map<String, String>> checkCredentials() async {
    final user = currentUser;
    if (user != null) {
      return {
        'token': currentSession?.accessToken ?? '',
        '_id': user.id,
        'name': user.userMetadata?['name'] ?? '',
        'email': user.email ?? '',
        'role': user.userMetadata?['role'] ?? '',
      };
    }
    return {};
  }

  // Legacy cleanup helper
  Future<void> clearCredentials() async {
    await signOut();
  }

  // OTP Fallback (if needed for Supabase)
  Future<void> sendOtp(String email) async {
    try {
      await _supabase.auth.signInWithOtp(email: email);
    } catch (e) {
      _logger.e("OTP Send error: $e");
      rethrow;
    }
  }

  Future<AuthResponse> verifyOtp(String email, String token) async {
    try {
      return await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );
    } catch (e) {
      _logger.e("OTP Verify error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String? token) async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      return response;
    } catch (e) {
      _logger.e("GetProfile error: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateProfile(
      String? token, Map<String, dynamic> data) async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('profiles')
          .update(data)
          .eq('id', user.id)
          .select()
          .single();

      return response;
    } catch (e) {
      _logger.e("UpdateProfile error: $e");
    }
    return null;
  }
}
