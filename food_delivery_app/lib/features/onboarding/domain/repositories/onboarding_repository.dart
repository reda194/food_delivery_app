import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/onboarding_page_entity.dart';

/// Repository interface for onboarding operations
abstract class OnboardingRepository {
  /// Check if onboarding has been completed
  Future<Either<Failure, bool>> isOnboardingComplete();

  /// Mark onboarding as complete
  Future<Either<Failure, void>> completeOnboarding();

  /// Save user preferences collected during onboarding
  Future<Either<Failure, void>> savePreferences(
    Map<String, dynamic> preferences,
  );

  /// Get saved onboarding preferences
  Future<Either<Failure, Map<String, dynamic>?>> getPreferences();

  /// Get list of onboarding pages to display
  Future<Either<Failure, List<OnboardingPageEntity>>> getOnboardingPages();

  /// Reset onboarding status (for testing/debug)
  Future<Either<Failure, void>> resetOnboarding();
}
