import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class UserService {
  late final SupabaseClient _client;

  UserService() {
    _client = SupabaseService().syncClient;
  }

  // Get current user profile
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
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
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updateData['full_name'] = fullName;
      if (phone != null) updateData['phone'] = phone;
      if (bloodType != null) updateData['blood_type'] = bloodType;
      if (dateOfBirth != null)
        updateData['date_of_birth'] =
            dateOfBirth.toIso8601String().split('T')[0];
      if (weight != null) updateData['weight'] = weight;
      if (locationCity != null) updateData['location_city'] = locationCity;
      if (locationRegion != null)
        updateData['location_region'] = locationRegion;
      if (emergencyContactName != null)
        updateData['emergency_contact_name'] = emergencyContactName;
      if (emergencyContactPhone != null)
        updateData['emergency_contact_phone'] = emergencyContactPhone;
      if (emergencyContactRelationship != null)
        updateData['emergency_contact_relationship'] =
            emergencyContactRelationship;
      if (preferredLanguage != null)
        updateData['preferred_language'] = preferredLanguage;
      if (profilePhotoUrl != null)
        updateData['profile_photo_url'] = profilePhotoUrl;
      if (notificationPreferences != null)
        updateData['notification_preferences'] = notificationPreferences;
      if (appPreferences != null)
        updateData['app_preferences'] = appPreferences;

      final response = await _client
          .from('user_profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }

  // Update eligibility status
  Future<Map<String, dynamic>> updateEligibilityStatus({
    required String userId,
    required String eligibilityStatus,
  }) async {
    try {
      final response = await _client
          .from('user_profiles')
          .update({
            'eligibility_status': eligibilityStatus,
            'last_eligibility_check': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to update eligibility status: $error');
    }
  }

  // Get all donation centers
  Future<List<Map<String, dynamic>>> getDonationCenters() async {
    try {
      final response = await _client
          .from('donation_centers')
          .select()
          .eq('is_active', true)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get donation centers: $error');
    }
  }

  // Get donation centers by city
  Future<List<Map<String, dynamic>>> getDonationCentersByCity(
      String city) async {
    try {
      final response = await _client
          .from('donation_centers')
          .select()
          .eq('is_active', true)
          .eq('city', city)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get donation centers by city: $error');
    }
  }

  // Search donation centers
  Future<List<Map<String, dynamic>>> searchDonationCenters(String query) async {
    try {
      final response = await _client
          .from('donation_centers')
          .select()
          .eq('is_active', true)
          .or('name.ilike.%$query%,city.ilike.%$query%,region.ilike.%$query%')
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to search donation centers: $error');
    }
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('email', email)
          .maybeSingle();

      return response;
    } catch (error) {
      throw Exception('Failed to get user by email: $error');
    }
  }
}
