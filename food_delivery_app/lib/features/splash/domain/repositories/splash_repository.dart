import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_config_entity.dart';

/// Splash Repository Interface - Domain layer
/// Defines the contract for app initialization operations
abstract class SplashRepository {
  /// Initialize the app and get configuration
  Future<Either<Failure, AppConfigEntity>> initializeApp();

  /// Check if user has completed onboarding
  Future<Either<Failure, bool>> checkOnboardingStatus();

  /// Mark onboarding as complete
  Future<Either<Failure, void>> completeOnboarding();

  /// Check authentication status
  Future<Either<Failure, bool>> checkAuthStatus();

  /// Get current app version
  Future<Either<Failure, String>> getAppVersion();

  /// Check for app updates
  Future<Either<Failure, Map<String, dynamic>>> checkForUpdates();

  /// Preload essential data
  Future<Either<Failure, void>> preloadData();

  /// Clear app cache
  Future<Either<Failure, void>> clearCache();
}
