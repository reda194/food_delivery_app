import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase show AuthException;
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import 'logger_service.dart';

/// Supabase Service - Central point for all Supabase operations
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  late final SupabaseClient _supabase;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LoggerService _logger = LoggerService.instance;

  SupabaseService._();

  /// Initialize Supabase with configuration
  Future<void> initialize() async {
    try {
      final supabase = await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      _supabase = supabase.client;

      // Set up auth state listener
      _supabase.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;

        _logger.info('Auth state changed: $event, Session: ${session?.user.id}');

        if (event == AuthChangeEvent.signedIn) {
          _handleSignedIn(session);
        } else if (event == AuthChangeEvent.signedOut) {
          _handleSignedOut();
        }
      });

      _logger.success('Supabase initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize Supabase: $e');
      throw SupabaseException('Failed to initialize Supabase: $e');
    }
  }

  SupabaseClient get client => _supabase;

  /// Handle user signed in
  void _handleSignedIn(Session? session) async {
    if (session?.user != null) {
      // Store user token securely
      await _secureStorage.write(
        key: 'user_token',
        value: session!.accessToken,
      );
      
      // Store user ID for analytics/logging
      await _secureStorage.write(
        key: 'user_id',
        value: session.user.id,
      );
    }
  }

  /// Handle user signed out
  void _handleSignedOut() async {
    // Clear stored tokens
    await _secureStorage.delete(key: 'user_token');
    await _secureStorage.delete(key: 'user_id');
    await _secureStorage.delete(key: 'refresh_token');
  }

  /// ==================== AUTHENTICATION METHODS ====================

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'display_name': displayName ?? _extractDisplayNameFromEmail(email),
          ...?metadata,
        },
      );
      
      _logger.success('User signed up successfully: ${response.user?.id}');
      return response;
    } on supabase.AuthException catch (e) {
      _logger.error('Sign up error: ${e.message}');
      throw AppAuthException(e.message);
    } catch (e) {
      _logger.error('Unexpected sign up error: $e');
      throw SupabaseException('Failed to sign up: $e');
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      _logger.success('User signed in successfully: ${response.user?.id}');
      return response;
    } on supabase.AuthException catch (e) {
      _logger.error('Sign in error: ${e.message}');
      throw AppAuthException(e.message);
    } catch (e) {
      _logger.error('Unexpected sign in error: $e');
      throw SupabaseException('Failed to sign in: $e');
    }
  }

  /// Sign in with Google OAuth
  Future<bool> signInWithGoogle() async {
    try {
      final result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.fooddelivery://auth-callback',
      );

      _logger.success('Google OAuth initiated');
      return result;
    } on supabase.AuthException catch (e) {
      _logger.error('Google sign in error: ${e.message}');
      throw AppAuthException(e.message);
    } catch (e) {
      _logger.error('Unexpected Google sign in error: $e');
      throw SupabaseException('Failed to sign in with Google: $e');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _logger.success('User signed out successfully');
    } on supabase.AuthException catch (e) {
      _logger.error('Sign out error: ${e.message}');
      throw AppAuthException(e.message);
    } catch (e) {
      _logger.error('Unexpected sign out error: $e');
      throw SupabaseException('Failed to sign out: $e');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      _logger.success('Password reset email sent to: $email');
    } on supabase.AuthException catch (e) {
      _logger.error('Password reset error: ${e.message}');
      throw AppAuthException(e.message);
    } catch (e) {
      _logger.error('Unexpected password reset error: $e');
      throw SupabaseException('Failed to reset password: $e');
    }
  }

  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _logger.success('Password updated successfully');
    } on supabase.AuthException catch (e) {
      _logger.error('Password update error: ${e.message}');
      throw AppAuthException(e.message);
    } catch (e) {
      _logger.error('Unexpected password update error: $e');
      throw SupabaseException('Failed to update password: $e');
    }
  }

  /// ==================== DATABASE METHODS ====================

  /// Get current user session
  Session? get currentSession => _supabase.auth.currentSession;

  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  /// Get user JWT token
  String? get accessToken => _supabase.auth.currentSession?.accessToken;

  /// Refresh session
  Future<void> refreshSession() async {
    try {
      await _supabase.auth.refreshSession();
      _logger.success('Session refreshed successfully');
    } on supabase.AuthException catch (e) {
      _logger.error('Session refresh error: ${e.message}');
      throw AppAuthException(e.message);
    } catch (e) {
      _logger.error('Unexpected session refresh error: $e');
      throw SupabaseException('Failed to refresh session: $e');
    }
  }

  /// ==================== REALTIME SUBSCRIPTIONS ====================

  /// Subscribe to table changes
  RealtimeChannel subscribeToTable({
    required String table,
    required String channelId,
    required Function(Map<String, dynamic>) onInsert,
    required Function(Map<String, dynamic>) onUpdate,
    required Function(Map<String, dynamic>) onDelete,
    PostgresChangeFilter? filter,
  }) {
    final channel = _supabase.channel(channelId);

    channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: table,
      filter: filter,
      callback: (payload) {
        switch (payload.eventType) {
          case PostgresChangeEvent.insert:
            onInsert(payload.newRecord);
            break;
          case PostgresChangeEvent.update:
            onUpdate(payload.newRecord);
            break;
          case PostgresChangeEvent.delete:
            onDelete(payload.oldRecord);
            break;
          default:
            break;
        }
      },
    );

    channel.subscribe();
    return channel;
  }

  /// Unsubscribe from channel
  void unsubscribeFromChannel(RealtimeChannel channel) {
    channel.unsubscribe();
  }

  /// ==================== STORAGE METHODS ====================

  /// Upload file to Supabase Storage
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required File file,
    FileOptions? fileOptions,
  }) async {
    try {
      final response = await _supabase.storage
          .from(bucket)
          .upload(path, file, fileOptions: fileOptions ?? const FileOptions());

      _logger.success('File uploaded successfully: $path');
      return response;
    } catch (e) {
      _logger.error('File upload error: $e');
      throw SupabaseException('Failed to upload file: $e');
    }
  }

  /// Get public file URL
  String getPublicUrl(String bucket, String path) {
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }

  /// Delete file from storage
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await _supabase.storage.from(bucket).remove([path]);
      _logger.success('File deleted successfully: $path');
    } catch (e) {
      _logger.error('File delete error: $e');
      throw SupabaseException('Failed to delete file: $e');
    }
  }

  /// ==================== DATABASE OPERATIONS ====================

  /// Perform database operation with automatic retry and error handling
  Future<T> performOperation<T>({
    required Future<T> Function(SupabaseClient) operation,
    int maxRetries = 3,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await operation(_supabase);
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          _logger.error('Operation failed after $attempts attempts: $e');
          rethrow;
        }
        
        // Wait before retrying
        await Future.delayed(Duration(seconds: attempts));
        _logger.warning('Operation failed, retrying (attempt $attempts/$maxRetries)');
      }
    }
    
    throw SupabaseException('Operation failed after $maxRetries attempts');
  }

  /// ==================== UTILITY METHODS ====================

  /// Extract display name from email
  String _extractDisplayNameFromEmail(String email) {
    return email.split('@').first.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Hash sensitive data
  String hashString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Check if email is valid
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Clean up resources
  Future<void> dispose() async {
    // Unsubscribe all channels
    await _supabase.removeAllChannels();
    _logger.info('Supabase service disposed');
  }
}
