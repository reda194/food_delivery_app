import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock Auth Repository Implementation
/// For demonstration purposes, this uses mock data instead of real API calls
class AuthRepositoryImpl implements AuthRepository {
  // Mock user data
  final Map<String, Map<String, dynamic>> _mockUsers = {
    'user@example.com': {
      'password': 'password123',
      'user': UserEntity(
        id: '1',
        email: 'user@example.com',
        name: 'John Doe',
        phoneNumber: '+1234567890',
        profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    },
  };

  UserEntity? _currentUser;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final userData = _mockUsers[email];
    if (userData == null) {
      return const Left(AuthFailure('User not found'));
    }

    if (userData['password'] != password) {
      return const Left(AuthFailure('Invalid password'));
    }

    _currentUser = userData['user'] as UserEntity;
    return Right(_currentUser!);
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_mockUsers.containsKey(email)) {
      return const Left(AuthFailure('User already exists'));
    }

    final newUser = UserEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      phoneNumber: phoneNumber ?? '',
      profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _mockUsers[email] = {
      'password': password,
      'user': newUser,
    };

    _currentUser = newUser;
    return Right(newUser);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Always succeed for demo purposes
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Always succeed for demo purposes
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Always succeed with OTP "123456" for demo
    if (otp == '123456') {
      return const Right(null);
    }

    return const Left(AuthFailure('Invalid OTP'));
  }

  @override
  Future<bool> isLoggedIn() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser != null;
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    if (_currentUser != null) {
      return Right(_currentUser!);
    }

    return const Left(AuthFailure('No user logged in'));
  }

  Future<Either<Failure, void>> updateProfile({required UserEntity user}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser != null) {
      _currentUser = user;
      return const Right(null);
    }

    return const Left(AuthFailure('No user logged in'));
  }

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Always succeed for demo purposes
    return const Right(null);
  }

  Future<Either<Failure, void>> deleteAccount() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser != null) {
      _mockUsers.remove(_currentUser!.email);
      _currentUser = null;
      return const Right(null);
    }

    return const Left(AuthFailure('No user logged in'));
  }
}
