import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Authentication Repository Interface - Domain layer
/// Defines the contract that data layer must implement
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Forgot password - send reset link
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  });

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify OTP
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Get current user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
