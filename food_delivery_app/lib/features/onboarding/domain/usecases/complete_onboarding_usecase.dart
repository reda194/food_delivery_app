import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

/// Use case to mark onboarding as complete
class CompleteOnboardingUseCase implements UseCase<void, NoParams> {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.completeOnboarding();
  }
}
