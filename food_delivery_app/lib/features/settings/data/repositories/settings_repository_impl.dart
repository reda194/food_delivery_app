import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> updateSettings(
      SettingsEntity settings) async {
    try {
      final settingsModel = SettingsModel.fromEntity(settings);
      await localDataSource.saveSettings(settingsModel);
      return Right(settingsModel);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> resetSettings() async {
    try {
      await localDataSource.clearSettings();
      final defaultSettings = await localDataSource.getSettings();
      return Right(defaultSettings);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> updateSetting({
    required String key,
    required dynamic value,
  }) async {
    try {
      final updatedSettings = await localDataSource.updateSetting(key, value);
      return Right(updatedSettings);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> toggleSetting(String key) async {
    try {
      final updatedSettings = await localDataSource.toggleSetting(key);
      return Right(updatedSettings);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
