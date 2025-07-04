import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  User? _currentUser;
  Map<String, dynamic>? _currentUserProfile;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<AuthState>? _authSubscription;

  // Getters
  User? get currentUser => _currentUser;
  Map<String, dynamic>? get currentUserProfile => _currentUserProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Get current session
    _currentUser = _authService.currentUser;

    if (_currentUser != null) {
      _loadUserProfile();
    }

    // Listen to auth state changes
    _authSubscription = _authService.authStateChanges.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn && data.session != null) {
        _currentUser = data.session!.user;
        _loadUserProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        _currentUser = null;
        _currentUserProfile = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      _currentUserProfile = await _userService.getCurrentUserProfile();
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading user profile: $error');
    }
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? bloodType,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        bloodType: bloodType,
      );

      if (response.user != null) {
        _currentUser = response.user;
        await _loadUserProfile();
        return true;
      }
      return false;
    } catch (error) {
      _setError(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = response.user;
        await _loadUserProfile();
        return true;
      }
      return false;
    } catch (error) {
      _setError(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final success = await _authService.signInWithGoogle();
      return success;
    } catch (error) {
      _setError(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _currentUser = null;
      _currentUserProfile = null;
    } catch (error) {
      _setError(error.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.resetPassword(email);
      return true;
    } catch (error) {
      _setError(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.updatePassword(newPassword);
      return true;
    } catch (error) {
      _setError(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? bloodType,
    DateTime? dateOfBirth,
    double? weight,
    String? locationCity,
    String? locationRegion,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelationship,
    String? preferredLanguage,
    String? profilePhotoUrl,
    Map<String, dynamic>? notificationPreferences,
    Map<String, dynamic>? appPreferences,
  }) async {
    if (_currentUser == null) return false;

    try {
      _setLoading(true);
      _clearError();

      final updatedProfile = await _userService.updateUserProfile(
        userId: _currentUser!.id,
        fullName: fullName,
        phone: phone,
        bloodType: bloodType,
        dateOfBirth: dateOfBirth,
        weight: weight,
        locationCity: locationCity,
        locationRegion: locationRegion,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        emergencyContactRelationship: emergencyContactRelationship,
        preferredLanguage: preferredLanguage,
        profilePhotoUrl: profilePhotoUrl,
        notificationPreferences: notificationPreferences,
        appPreferences: appPreferences,
      );

      _currentUserProfile = updatedProfile;
      notifyListeners();
      return true;
    } catch (error) {
      _setError(error.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
