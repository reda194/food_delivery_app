import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase
    implements UseCase<UserProfileEntity, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(
      UpdateProfileParams params) async {
    return await repository.updateProfile(
      displayName: params.displayName,
      phoneNumber: params.phoneNumber,
      address: params.address,
      city: params.city,
      state: params.state,
      zipCode: params.zipCode,
      country: params.country,
      dateOfBirth: params.dateOfBirth,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String? displayName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime? dateOfBirth;

  const UpdateProfileParams({
    this.displayName,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
        displayName,
        phoneNumber,
        address,
        city,
        state,
        zipCode,
        country,
        dateOfBirth,
      ];
}
