import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

/// Use case to check if onboarding has been completed
class CheckOnboardingStatusUseCase implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  CheckOnboardingStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isOnboardingComplete();
  }
}
