import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/onboarding_page_entity.dart';
import '../repositories/onboarding_repository.dart';

/// Use case to get the list of onboarding pages
class GetOnboardingPagesUseCase implements UseCase<List<OnboardingPageEntity>, NoParams> {
  final OnboardingRepository repository;

  GetOnboardingPagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<OnboardingPageEntity>>> call(NoParams params) async {
    return await repository.getOnboardingPages();
  }
}
