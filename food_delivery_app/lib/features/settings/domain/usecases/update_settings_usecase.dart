import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class UpdateSettingsUseCase
    implements UseCase<SettingsEntity, UpdateSettingsParams> {
  final SettingsRepository repository;

  UpdateSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, SettingsEntity>> call(
      UpdateSettingsParams params) async {
    return await repository.updateSettings(params.settings);
  }
}

class UpdateSettingsParams extends Equatable {
  final SettingsEntity settings;

  const UpdateSettingsParams({required this.settings});

  @override
  List<Object?> get props => [settings];
}
