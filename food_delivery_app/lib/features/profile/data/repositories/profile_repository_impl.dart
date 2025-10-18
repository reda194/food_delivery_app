import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final SupabaseService supabaseService;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.supabaseService,
  });

  String get _currentUserId => supabaseService.currentUser?.id ?? '';

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    try {
      if (_currentUserId.isEmpty) {
        return const Left(ServerFailure('User not authenticated'));
      }

      final profile = await remoteDataSource.getUserProfile(_currentUserId);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile({
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
      if (_currentUserId.isEmpty) {
        return const Left(ServerFailure('User not authenticated'));
      }

      final profile = await remoteDataSource.updateProfile(
        userId: _currentUserId,
        displayName: displayName,
        phoneNumber: phoneNumber,
        address: address,
        city: city,
        state: state,
        zipCode: zipCode,
        country: country,
        dateOfBirth: dateOfBirth,
      );

      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String imagePath) async {
    try {
      if (_currentUserId.isEmpty) {
        return const Left(ServerFailure('User not authenticated'));
      }

      final imageUrl =
          await remoteDataSource.uploadProfileImage(_currentUserId, imagePath);
      return Right(imageUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfileImage(
      String imageUrl) async {
    try {
      if (_currentUserId.isEmpty) {
        return const Left(ServerFailure('User not authenticated'));
      }

      final profile =
          await remoteDataSource.updateProfileImage(_currentUserId, imageUrl);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String code) async {
    try {
      await remoteDataSource.verifyEmail(code);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPhoneVerification(
      String phoneNumber) async {
    try {
      await remoteDataSource.sendPhoneVerification(phoneNumber);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhone(String code) async {
    try {
      await remoteDataSource.verifyPhone(code);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    try {
      if (_currentUserId.isEmpty) {
        return const Left(ServerFailure('User not authenticated'));
      }

      await remoteDataSource.deleteAccount(_currentUserId);
      await logout();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await supabaseService.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
