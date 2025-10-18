import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/onboarding_page_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';
import '../models/onboarding_page_model.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> isOnboardingComplete() async {
    try {
      final isComplete = await localDataSource.isOnboardingComplete();
      return Right(isComplete);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to check onboarding status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    try {
      await localDataSource.setOnboardingComplete();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to complete onboarding: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> savePreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      await localDataSource.saveOnboardingPreferences(preferences);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to save preferences: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getPreferences() async {
    try {
      final preferences = await localDataSource.getOnboardingPreferences();
      return Right(preferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get preferences: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OnboardingPageEntity>>> getOnboardingPages() async {
    try {
      // Define onboarding pages
      final pages = [
        const OnboardingPageModel(
          title: 'Browse Your Menu\n& Order Directly',
          description: 'The best food delivery app you\nhave ever used!',
          imagePath: 'assets/images/delivery.png',
          backgroundColor: '#FAF7F2',
        ),
        const OnboardingPageModel(
          title: 'Fast & Reliable\nDelivery',
          description: 'Get your favorite meals delivered\nquickly and safely',
          imagePath: 'assets/images/fast_delivery.png',
          backgroundColor: '#FFF8E7',
        ),
        const OnboardingPageModel(
          title: 'Track Your Order\nin Real-Time',
          description: 'Know exactly where your food is\nand when it will arrive',
          imagePath: 'assets/images/tracking.png',
          backgroundColor: '#F0F8FF',
        ),
      ];

      return Right(pages.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to load onboarding pages: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetOnboarding() async {
    try {
      await localDataSource.resetOnboarding();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to reset onboarding: $e'));
    }
  }
}
