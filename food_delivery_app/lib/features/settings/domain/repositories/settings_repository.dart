import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  /// Get current app settings
  Future<Either<Failure, SettingsEntity>> getSettings();

  /// Update app settings
  Future<Either<Failure, SettingsEntity>> updateSettings(SettingsEntity settings);

  /// Reset settings to default
  Future<Either<Failure, SettingsEntity>> resetSettings();

  /// Update a specific setting
  Future<Either<Failure, SettingsEntity>> updateSetting({
    required String key,
    required dynamic value,
  });

  /// Toggle a boolean setting
  Future<Either<Failure, SettingsEntity>> toggleSetting(String key);
}
