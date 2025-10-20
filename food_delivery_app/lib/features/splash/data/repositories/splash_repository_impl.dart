import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/entities/app_config_entity.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/app_local_datasource.dart';

/// Splash Repository Implementation
class SplashRepositoryImpl implements SplashRepository {
  final AppLocalDataSource localDataSource;
  final SupabaseService _supabaseService = SupabaseService.instance;
  final LoggerService _logger = LoggerService.instance;

  SplashRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AppConfigEntity>> initializeApp() async {
    try {
      _logger.info('Initializing app...');

      // Run initialization tasks in parallel
      final results = await Future.wait([
        _getAppVersion(),
        localDataSource.getOnboardingStatus(),
        _checkAuthentication(),
        localDataSource.getAppSettings(),
      ]);

      final appVersion = results[0] as String;
      final onboardingComplete = results[1] as bool;
      final isAuthenticated = results[2] as bool;
      final settings = results[3] as Map<String, dynamic>;

      final config = AppConfigEntity(
        appVersion: appVersion,
        onboardingComplete: onboardingComplete,
        isAuthenticated: isAuthenticated,
        userId: _supabaseService.currentUser?.id,
        settings: settings,
      );

      _logger.info('App initialized successfully: $config');
      return Right(config);
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize app: $e', stackTrace);
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> checkOnboardingStatus() async {
    try {
      final status = await localDataSource.getOnboardingStatus();
      return Right(status);
    } catch (e) {
      _logger.error('Failed to check onboarding status: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    try {
      await localDataSource.setOnboardingStatus(true);
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to complete onboarding: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final isAuthenticated = await _checkAuthentication();
      return Right(isAuthenticated);
    } catch (e) {
      _logger.error('Failed to check auth status: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> getAppVersion() async {
    try {
      final version = await _getAppVersion();
      return Right(version);
    } catch (e) {
      _logger.error('Failed to get app version: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> checkForUpdates() async {
    try {
      _logger.info('Checking for app updates...');

      final currentVersion = await _getAppVersion();

      // In a real app, you would:
      // 1. Call a backend API to get latest version info
      // 2. Compare versions
      // 3. Return update information

      // For now, return no update needed
      return Right({
        'currentVersion': currentVersion,
        'latestVersion': currentVersion,
        'needsUpdate': false,
        'forceUpdate': false,
        'updateUrl': null,
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to check for updates: $e', stackTrace);
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> preloadData() async {
    try {
      _logger.info('Preloading essential data...');

      // In a real app, you might preload:
      // - App settings from backend
      // - Essential cached data
      // - Initialize services
      // - Warm up network connections

      await Future.delayed(const Duration(milliseconds: 500));

      _logger.info('Data preloading complete');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to preload data: $e', stackTrace);
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to clear cache: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  // Helper methods

  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      _logger.warning('Failed to get package version, using default: $e');
      return '1.0.0'; // Default version
    }
  }

  Future<bool> _checkAuthentication() async {
    try {
      final user = _supabaseService.currentUser;
      final session = _supabaseService.currentSession;
      return user != null && session != null;
    } catch (e) {
      _logger.error('Failed to check authentication: $e');
      return false;
    }
  }

  /// Map exceptions to domain layer failures
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }

    if (exception is ServerException) {
      return ServerFailure(exception.message);
    }

    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is TimeoutException) {
      return const NetworkFailure('Request timed out. Please try again.');
    }

    if (exception is SocketException) {
      return const NetworkFailure(
          'No internet connection. Please check your network.');
    }

    return ServerFailure('Unexpected error: ${exception.toString()}');
  }
}
