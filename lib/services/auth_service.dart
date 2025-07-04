import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  late final SupabaseClient _client;

  AuthService() {
    _client = SupabaseService().syncClient;
  }

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Get current session
  Session? get currentSession => _client.auth.currentSession;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? bloodType,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
          'blood_type': bloodType,
          'role': 'donor',
          'preferred_language': 'English',
        },
      );

      if (response.user != null && response.session != null) {
        // Profile will be automatically created by database trigger
        return response;
      } else {
        throw Exception('Failed to create user account');
      }
    } catch (error) {
      throw Exception('Sign up failed: $error');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null && response.session != null) {
        return response;
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (error) {
      throw Exception('Sign in failed: $error');
    }
  }

  // Sign in with Google OAuth
  Future<bool> signInWithGoogle() async {
    try {
      return await _client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (error) {
      throw Exception('Google sign in failed: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user != null) {
        return response;
      } else {
        throw Exception('Failed to update password');
      }
    } catch (error) {
      throw Exception('Password update failed: $error');
    }
  }

  // Update email
  Future<UserResponse> updateEmail(String newEmail) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(email: newEmail),
      );

      if (response.user != null) {
        return response;
      } else {
        throw Exception('Failed to update email');
      }
    } catch (error) {
      throw Exception('Email update failed: $error');
    }
  }
}
