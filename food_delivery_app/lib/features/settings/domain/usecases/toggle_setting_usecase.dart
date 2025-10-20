import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class ToggleSettingUseCase
    implements UseCase<SettingsEntity, ToggleSettingParams> {
  final SettingsRepository repository;

  ToggleSettingUseCase(this.repository);

  @override
  Future<Either<Failure, SettingsEntity>> call(
      ToggleSettingParams params) async {
    return await repository.toggleSetting(params.key);
  }
}

class ToggleSettingParams extends Equatable {
  final String key;

  const ToggleSettingParams({required this.key});

  @override
  List<Object?> get props => [key];
}
