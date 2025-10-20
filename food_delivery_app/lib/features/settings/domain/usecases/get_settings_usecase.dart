import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase implements UseCase<SettingsEntity, NoParams> {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, SettingsEntity>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
