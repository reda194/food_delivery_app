import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  /// Get current user profile
  Future<Either<Failure, UserProfileEntity>> getUserProfile();

  /// Update user profile
  Future<Either<Failure, UserProfileEntity>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    DateTime? dateOfBirth,
  });

  /// Upload profile image
  Future<Either<Failure, String>> uploadProfileImage(String imagePath);

  /// Update profile image
  Future<Either<Failure, UserProfileEntity>> updateProfileImage(String imageUrl);

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Send email verification
  Future<Either<Failure, void>> sendEmailVerification();

  /// Verify email with code
  Future<Either<Failure, void>> verifyEmail(String code);

  /// Send phone verification
  Future<Either<Failure, void>> sendPhoneVerification(String phoneNumber);

  /// Verify phone with code
  Future<Either<Failure, void>> verifyPhone(String code);

  /// Delete account
  Future<Either<Failure, void>> deleteAccount(String password);

  /// Logout
  Future<Either<Failure, void>> logout();
}
