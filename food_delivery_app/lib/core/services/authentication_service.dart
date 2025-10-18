import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase show AuthException;
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../models/user_model.dart';
import 'database_service.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

/// Authentication Service - Handles all authentication operations
class AuthenticationService {
  static AuthenticationService? _instance;
  static AuthenticationService get instance => _instance ??= AuthenticationService._();

  final SupabaseService _supabaseService;
  final DatabaseService _databaseService = DatabaseService.instance;
  final LoggerService _logger = LoggerService.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthenticationService._() : _supabaseService = SupabaseService.instance;

  /// ==================== USER REGISTRATION ====================

  /// Register new user with email and password
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? profileImage,
  }) async {
    try {
      _logger.auth('register', userId: email);

      // Validate inputs
      _validateEmail(email);
      _validatePassword(password);
      _validateFullName(fullName);

      // Create user in Supabase Auth
      final authResponse = await _supabaseService.signUpWithEmail(
        email: email,
        password: password,
        displayName: fullName,
        metadata: {
          'phone_number': phoneNumber,
          'registration_method': 'email',
        },
      );

      final user = authResponse.user;
      if (user == null) {
        throw AppException('Failed to create user account');
      }

      // Create user profile in database
      final userData = {
        'id': user.id,
        'email': user.email,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'profile_image': profileImage,
        'is_active': true,
        'is_verified': false,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _databaseService.insert(AppConstants.usersTable, userData);

      final userModel = UserModel.fromJson(userData);
      _logger.success('User registered successfully: ${userModel.id}');
      
      return userModel;
      
    } on gotrue.AuthException catch (e) {
      _logger.error('Registration error: $e');
      throw AppException('Registration failed: ${e.message}');
    } catch (e) {
      _logger.error('Unexpected registration error: $e');
      throw AppException('Registration failed: $e');
    }
  }

  /// Register with Google OAuth
  Future<UserModel> registerWithGoogle({
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      _logger.auth('register_with_google');

      final authResponse = await _supabaseService.signInWithGoogle();
      
      // This would need to be handled in OAuth callback
      // For now, we'll return a placeholder
      throw AppException('Google registration requires OAuth callback implementation');
      
    } on supabase.AuthException catch (e) {
      _logger.error('Google registration error: $e');
      rethrow;
    } catch (e) {
      _logger.error('Unexpected Google registration error: $e');
      throw AppException('Google registration failed: $e');
    }
  }

  /// ==================== USER LOGIN ====================

  /// Login with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _logger.auth('sign_in', userId: email);

      _validateEmail(email);

      final authResponse = await _supabaseService.signInWithEmail(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        throw AppException('Invalid credentials');
      }

      // Fetch user profile from database
      final userProfiles = await _databaseService.select(
        AppConstants.usersTable,
        where: 'id=eq.${user.id}',
      );

      if (userProfiles.isEmpty) {
        throw AppException('User profile not found');
      }

      final userModel = UserModel.fromJson(userProfiles.first);
      
      // Store tokens if remember me is enabled
      if (rememberMe) {
        await _secureStorage.write(
          key: 'remember_me',
          value: 'true',
        );
        
        await _secureStorage.write(
          key: 'user_email',
          value: email,
        );
      }

      _logger.success('User signed in successfully: ${userModel.id}');
      return userModel;
      
    } on supabase.AuthException catch (e) {
      _logger.error('Login error: $e');
      rethrow;
    } catch (e) {
      _logger.error('Unexpected login error: $e');
      throw AppException('Login failed: $e');
    }
  }

  /// Handle OAuth callback
  Future<UserModel> handleOAuthCallback() async {
    try {
      final session = _supabaseService.currentSession;
      if (session?.user == null) {
        throw AppException('OAuth callback failed');
      }

      final user = session!.user;
      
      // Check if user profile exists
      final userProfiles = await _databaseService.select(
        AppConstants.usersTable,
        where: 'id=eq.${user.id}',
      );

      Map<String, dynamic> userData;
      
      if (userProfiles.isEmpty) {
        // Create new user profile for OAuth user
        userData = {
          'id': user.id,
          'email': user.email,
          'full_name': user.userMetadata?['full_name'] ?? user.userMetadata?['display_name'] ?? '',
          'phone_number': user.userMetadata?['phone_number'],
          'profile_image': user.userMetadata?['avatar_url'],
          'is_active': true,
          'is_verified': true, // OAuth users are considered verified
          'registration_method': 'oauth',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        await _databaseService.insert(AppConstants.usersTable, userData);
      } else {
        userData = userProfiles.first;
        
        // Update last login
        await _databaseService.update(
          AppConstants.usersTable,
          {'last_login_at': DateTime.now().toIso8601String()},
          'id',
          user.id,
        );
      }

      final userModel = UserModel.fromJson(userData);
      _logger.success('OAuth user signed in successfully: ${userModel.id}');
      
      return userModel;
      
    } on supabase.AuthException catch (e) {
      _logger.error('OAuth callback error: $e');
      rethrow;
    } catch (e) {
      _logger.error('Unexpected OAuth callback error: $e');
      throw AppException('OAuth callback failed: $e');
    }
  }

  /// ==================== PASSWORD RESET ====================

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      _logger.auth('reset_password', userId: email);

      _validateEmail(email);

      await _supabaseService.resetPassword(email);
      
      _logger.success('Password reset email sent to: $email');
      
    } on supabase.AuthException catch (e) {
      _logger.error('Password reset error: $e');
      rethrow;
    } catch (e) {
      _logger.error('Unexpected password reset error: $e');
      throw AppException('Failed to send reset email: $e');
    }
  }

  /// Confirm password reset with new password
  Future<void> confirmPasswordReset({
    required String email,
    required String newPassword,
    required String code,
  }) async {
    try {
      _logger.auth('confirm_password_reset', userId: email);

      _validatePassword(newPassword);

      await _supabaseService.updatePassword(newPassword);
      
      _logger.success('Password reset completed for: $email');
      
    } on supabase.AuthException catch (e) {
      _logger.error('Password reset confirmation error: $e');
      rethrow;
    } catch (e) {
      _logger.error('Unexpected password reset confirmation error: $e');
      throw AppException('Failed to reset password: $e');
    }
  }

  /// ==================== USER SESSION MANAGEMENT ====================

  /// Sign out current user
  Future<void> signOut() async {
    try {
      _logger.auth('sign_out');

      await _supabaseService.signOut();
      
      // Clear secure storage
      await _secureStorage.deleteAll();
      
      _logger.success('User signed out successfully');
      
    } on supabase.AuthException catch (e) {
      _logger.error('Sign out error: $e');
      rethrow;
    } catch (e) {
      _logger.error('Unexpected sign out error: $e');
      throw AppException('Failed to sign out: $e');
    }
  }

  /// Check if user is currently authenticated
  bool get isAuthenticated => _supabaseService.isAuthenticated;

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) return null;

      final userProfiles = await _databaseService.select(
        AppConstants.usersTable,
        where: 'id=eq.${user.id}',
      );

      if (userProfiles.isEmpty) return null;

      return UserModel.fromJson(userProfiles.first);
      
    } catch (e) {
      _logger.error('Failed to get current user: $e');
      return null;
    }
  }

  /// Refresh user session
  Future<void> refreshSession() async {
    try {
      await _supabaseService.refreshSession();
      _logger.success('Session refreshed successfully');
      
    } on supabase.AuthException catch (e) {
      _logger.error('Session refresh error: $e');
      rethrow;
    } catch (e) {
      _logger.error('Unexpected session refresh error: $e');
      throw AppException('Failed to refresh session: $e');
    }
  }

  /// ==================== USER PROFILE MANAGEMENT ====================

  /// Update user profile
  Future<UserModel> updateProfile(String userId, Map<String, dynamic> updates) async {
    try {
      _logger.auth('update_profile', userId: userId);

      // Don't allow updating certain fields directly
      final allowedUpdates = Map<String, dynamic>.from(updates);
      allowedUpdates.remove('id');
      allowedUpdates.remove('email');
      allowedUpdates.remove('created_at');
      allowedUpdates['updated_at'] = DateTime.now().toIso8601String();

      final updatedProfile = await _databaseService.update(
        AppConstants.usersTable,
        allowedUpdates,
        'id',
        userId,
      );

      // Also update user metadata in Supabase Auth
      if (_supabaseService.currentUser?.id == userId) {
        await _supabaseService.client.auth.updateUser(
          UserAttributes(
            data: allowedUpdates,
          ),
        );
      }

      final userModel = UserModel.fromJson(updatedProfile);
      _logger.success('Profile updated for user: $userId');
      
      return userModel;
      
    } catch (e) {
      _logger.error('Profile update error: $e');
      throw AppException('Failed to update profile: $e');
    }
  }

  /// Update user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _logger.auth('change_password');

      _validatePassword(newPassword);

      // For Supabase, we need to re-authenticate and then update
      // This is a simplified version - in production, you'd want proper re-authentication
      await _supabaseService.updatePassword(newPassword);
      
      _logger.success('Password changed successfully');
      
    } on supabase.AuthException catch (e) {
      _logger.error('Password change error: $e');
      rethrow;
    } catch (e) {
      _logger.error('Unexpected password change error: $e');
      throw AppException('Failed to change password: $e');
    }
  }

  /// Upload user profile image
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      _logger.auth('upload_profile_image', userId: userId);

      final fileName = 'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}';
      final path = 'avatars/$userId/$fileName';

      await _supabaseService.uploadFile(
        bucket: AppConstants.avatarsBucket,
        path: path,
        file: imageFile,
      );

      final imageUrl = _supabaseService.getPublicUrl(AppConstants.avatarsBucket, path);
      
      // Update user profile with new image URL
      await updateProfile(userId, {'profile_image': imageUrl});
      
      _logger.success('Profile image uploaded for user: $userId');
      return imageUrl;
      
    } catch (e) {
      _logger.error('Profile image upload error: $e');
      throw AppException('Failed to upload profile image: $e');
    }
  }

  /// ==================== VALIDATION METHODS ====================

  void _validateEmail(String email) {
    if (!_supabaseService.isValidEmail(email)) {
      throw AppException('Invalid email format');
    }
  }

  void _validatePassword(String password) {
    if (password.length < AppConstants.minPasswordLength) {
      throw AppException('Password must be at least ${AppConstants.minPasswordLength} characters');
    }
    if (password.length > AppConstants.maxPasswordLength) {
      throw AppException('Password must be less than ${AppConstants.maxPasswordLength} characters');
    }
    // Add more password validation as needed
  }

  void _validateFullName(String fullName) {
    if (fullName.trim().isEmpty) {
      throw AppException('Full name cannot be empty');
    }
    if (fullName.length > AppConstants.maxUsernameLength) {
      throw AppException('Full name is too long');
    }
  }

  /// ==================== TOKEN MANAGEMENT ====================

  /// Get stored auth tokens
  Future<Map<String, String?>> getStoredTokens() async {
    final accessToken = await _secureStorage.read(key: 'user_token');
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  /// Check if user has stored credentials for auto-login
  Future<bool> hasStoredCredentials() async {
    final rememberMe = await _secureStorage.read(key: 'remember_me');
    final userEmail = await _secureStorage.read(key: 'user_email');
    
    return rememberMe == 'true' && userEmail != null;
  }

  /// Attempt auto-login with stored credentials
  Future<UserModel?> attemptAutoLogin() async {
    try {
      final hasCredentials = await hasStoredCredentials();
      if (!hasCredentials) {
        return null;
      }

      final userEmail = await _secureStorage.read(key: 'user_email');
      // For auto-login, user would need to enter password
      // This is a simplified implementation
      
      return null;
      
    } catch (e) {
      _logger.error('Auto-login error: $e');
      return null;
    }
  }

  /// ==================== ACCOUNT MANAGEMENT ====================

  /// Delete user account
  Future<void> deleteAccount(String userId, String password) async {
    try {
      _logger.auth('delete_account', userId: userId);

      // Verify current user
      final currentUser = _supabaseService.currentUser;
      if (currentUser?.id != userId) {
        throw AppException('Cannot delete another user\'s account');
      }

      // Delete user profile from database first
      await _databaseService.delete(AppConstants.usersTable, 'id', userId);
      
      // Delete user from Supabase Auth
      await _supabaseService.client.auth.admin.deleteUser(userId);
      
      // Clear all stored data
      await _secureStorage.deleteAll();
      
      _logger.success('Account deleted successfully: $userId');
      
    } catch (e) {
      _logger.error('Account deletion error: $e');
      throw AppException('Failed to delete account: $e');
    }
  }

  /// Check if email is already registered
  Future<bool> isEmailRegistered(String email) async {
    try {
      final users = await _databaseService.select(
        AppConstants.usersTable,
        where: 'email=eq.$email',
      );
      
      return users.isNotEmpty;
      
    } catch (e) {
      _logger.error('Email registration check error: $e');
      throw AppException('Failed to check email registration: $e');
    }
  }

  /// Enable/disable account
  Future<void> toggleAccountStatus(String userId, bool isActive) async {
    try {
      await _databaseService.update(
        AppConstants.usersTable,
        {'is_active': isActive, 'updated_at': DateTime.now().toIso8601String()},
        'id',
        userId,
      );
      
      _logger.success('Account status updated for user: $userId, active: $isActive');
      
    } catch (e) {
      _logger.error('Account status update error: $e');
      throw AppException('Failed to update account status: $e');
    }
  }
}
