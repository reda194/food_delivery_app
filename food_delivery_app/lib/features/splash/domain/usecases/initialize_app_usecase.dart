import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_config_entity.dart';
import '../repositories/splash_repository.dart';

/// Use case for initializing the app
class InitializeAppUseCase implements UseCase<AppConfigEntity, NoParams> {
  final SplashRepository repository;

  InitializeAppUseCase(this.repository);

  @override
  Future<Either<Failure, AppConfigEntity>> call(NoParams params) async {
    return await repository.initializeApp();
  }
}

/// Use case for checking onboarding status
class CheckOnboardingStatusUseCase implements UseCase<bool, NoParams> {
  final SplashRepository repository;

  CheckOnboardingStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkOnboardingStatus();
  }
}

/// Use case for marking onboarding as complete
class CompleteOnboardingUseCase implements UseCase<void, NoParams> {
  final SplashRepository repository;

  CompleteOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.completeOnboarding();
  }
}

/// Use case for checking authentication status
class CheckAuthStatusUseCase implements UseCase<bool, NoParams> {
  final SplashRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}

/// Use case for preloading essential data
class PreloadDataUseCase implements UseCase<void, NoParams> {
  final SplashRepository repository;

  PreloadDataUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.preloadData();
  }
}

/// Use case for checking for app updates
class CheckForUpdatesUseCase
    implements UseCase<Map<String, dynamic>, NoParams> {
  final SplashRepository repository;

  CheckForUpdatesUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await repository.checkForUpdates();
  }
}
