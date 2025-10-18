import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String userId);

  Future<UserProfileModel> updateProfile({
    required String userId,
    String? displayName,
    String? phoneNumber,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    DateTime? dateOfBirth,
  });

  Future<String> uploadProfileImage(String userId, String imagePath);
  Future<UserProfileModel> updateProfileImage(String userId, String imageUrl);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> sendEmailVerification();
  Future<void> verifyEmail(String code);
  Future<void> sendPhoneVerification(String phoneNumber);
  Future<void> verifyPhone(String code);
  Future<void> deleteAccount(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseService supabaseService;

  ProfileRemoteDataSourceImpl({required this.supabaseService});

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await supabaseService.client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String userId,
    String? displayName,
    String? phoneNumber,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    DateTime? dateOfBirth,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (displayName != null) updateData['display_name'] = displayName;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (address != null) updateData['address'] = address;
      if (city != null) updateData['city'] = city;
      if (state != null) updateData['state'] = state;
      if (zipCode != null) updateData['zip_code'] = zipCode;
      if (country != null) updateData['country'] = country;
      if (dateOfBirth != null) {
        updateData['date_of_birth'] = dateOfBirth.toIso8601String();
      }

      final response = await supabaseService.client
          .from('user_profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage(String userId, String imagePath) async {
    try {
      final file = File(imagePath);
      final fileName = 'profile_$userId.${imagePath.split('.').last}';
      final path = 'avatars/$fileName';

      // Delete old image if exists
      try {
        await supabaseService.client.storage.from('profiles').remove([path]);
      } catch (_) {
        // Ignore if file doesn't exist
      }

      // Upload new image
      await supabaseService.client.storage.from('profiles').upload(
            path,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      // Get public URL
      final imageUrl =
          supabaseService.client.storage.from('profiles').getPublicUrl(path);

      return imageUrl;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateProfileImage(
      String userId, String imageUrl) async {
    try {
      final response = await supabaseService.client
          .from('user_profiles')
          .update({
            'profile_image_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Supabase requires re-authentication before password change
      await supabaseService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw ServerException('Failed to change password: ${e.toString()}');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = supabaseService.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      // Supabase sends verification email automatically on signup
      // For re-sending, we can use the resend verification API
      await supabaseService.client.auth.resend(
        type: OtpType.email,
        email: user.email!,
      );
    } catch (e) {
      throw ServerException('Failed to send email verification: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyEmail(String code) async {
    try {
      // Verify email with OTP
      await supabaseService.client.auth.verifyOTP(
        type: OtpType.email,
        token: code,
        email: supabaseService.currentUser?.email ?? '',
      );
    } catch (e) {
      throw ServerException('Failed to verify email: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPhoneVerification(String phoneNumber) async {
    try {
      await supabaseService.client.auth.signInWithOtp(
        phone: phoneNumber,
      );
    } catch (e) {
      throw ServerException(
          'Failed to send phone verification: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyPhone(String code) async {
    try {
      final user = supabaseService.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await supabaseService.client.auth.verifyOTP(
        type: OtpType.sms,
        token: code,
        phone: user.phone ?? '',
      );

      // Update phone_verified flag in user_profiles
      await supabaseService.client.from('user_profiles').update({
        'phone_verified': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);
    } catch (e) {
      throw ServerException('Failed to verify phone: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount(String userId) async {
    try {
      // Delete user profile data
      await supabaseService.client
          .from('user_profiles')
          .delete()
          .eq('id', userId);

      // Delete auth user (requires admin API or RLS policies)
      // Note: Supabase doesn't allow users to delete themselves from client
      // This would need to be handled via Edge Functions or admin API
      // For now, we'll mark the account as deleted
      await supabaseService.client.from('deleted_accounts').insert({
        'user_id': userId,
        'deleted_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException('Failed to delete account: ${e.toString()}');
    }
  }
}
