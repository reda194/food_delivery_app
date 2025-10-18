import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/authentication_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Auth Repository Implementation with Supabase Integration
class AuthRepositoryImpl implements AuthRepository {
  final AuthenticationService _authService = AuthenticationService.instance;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final userModel = await _authService.signInWithEmail(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      final userEntity = _mapUserModelToEntity(userModel);
      return Right(userEntity);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final userModel = await _authService.registerWithEmail(
        email: email,
        password: password,
        fullName: name,
        phoneNumber: phoneNumber,
      );

      final userEntity = _mapUserModelToEntity(userModel);
      return Right(userEntity);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithGoogle() async {
    try {
      final userModel = await _authService.registerWithGoogle();
      final userEntity = _mapUserModelToEntity(userModel);
      return Right(userEntity);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authService.signOut();
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await _authService.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String newPassword,
    required String code,
  }) async {
    try {
      await _authService.confirmPasswordReset(
        email: email,
        newPassword: newPassword,
        code: code,
      );
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      // This would need to be implemented based on your OTP verification flow
      // For now, we'll simulate success
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _authService.isAuthenticated;
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await _authService.getCurrentUser();
      if (userModel == null) {
        return const Left(AuthFailure('No user logged in'));
      }
      
      final userEntity = _mapUserModelToEntity(userModel);
      return Right(userEntity);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({required UserEntity user}) async {
    try {
      final userData = {
        'full_name': user.name,
        'phone_number': user.phoneNumber,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _authService.updateProfile(user.id, userData);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount({
    required String userId,
    required String password,
  }) async {
    try {
      await _authService.deleteAccount(userId, password);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    try {
      // This would need File object, updating signature to accept File
      final imageUrl = await _authService.uploadProfileImage(userId, File(imagePath));
      return Right(imageUrl);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailAvailable(String email) async {
    try {
      final isRegistered = await _authService.isEmailRegistered(email);
      return Right(!isRegistered);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> refreshSession() async {
    try {
      await _authService.refreshSession();
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Map UserModel to UserEntity
  UserEntity _mapUserModelToEntity(dynamic userModel) {
    // This assumes UserModel has similar structure to UserEntity
    // You may need to adjust based on actual UserModel implementation
    return UserEntity(
      id: userModel.id,
      email: userModel.email,
      name: userModel.fullName ?? userModel.name,
      phoneNumber: userModel.phoneNumber,
      profileImage: userModel.profileImage,
      createdAt: DateTime.tryParse(userModel.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(userModel.updatedAt) ?? DateTime.now(),
    );
  }

  /// Map exceptions to domain layer failures
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is AuthFailure) {
      return exception;
    }
    
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    }
    
    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }
    
    if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    }
    
    if (exception is TimeoutException) {
      return const NetworkFailure('Request timed out. Please try again.');
    }
    
    return const AuthFailure('Authentication failed. Please try again.');
  }
}
