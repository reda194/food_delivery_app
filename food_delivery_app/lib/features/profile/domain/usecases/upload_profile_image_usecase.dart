import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UploadProfileImageUseCase
    implements UseCase<UserProfileEntity, UploadProfileImageParams> {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(
      UploadProfileImageParams params) async {
    // First upload the image
    final uploadResult = await repository.uploadProfileImage(params.imagePath);

    return uploadResult.fold(
      (failure) => Left(failure),
      (imageUrl) async {
        // Then update profile with the new image URL
        return await repository.updateProfileImage(imageUrl);
      },
    );
  }
}

class UploadProfileImageParams extends Equatable {
  final String imagePath;

  const UploadProfileImageParams({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}
