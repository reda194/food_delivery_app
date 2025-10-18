import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase implements UseCase<UserProfileEntity, NoParams> {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
