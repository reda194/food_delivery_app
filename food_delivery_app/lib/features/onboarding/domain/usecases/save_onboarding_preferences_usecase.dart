import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

/// Use case to save user preferences from onboarding
class SaveOnboardingPreferencesUseCase implements UseCase<void, SavePreferencesParams> {
  final OnboardingRepository repository;

  SaveOnboardingPreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SavePreferencesParams params) async {
    return await repository.savePreferences(params.preferences);
  }
}

class SavePreferencesParams extends Equatable {
  final Map<String, dynamic> preferences;

  const SavePreferencesParams({required this.preferences});

  @override
  List<Object?> get props => [preferences];
}
