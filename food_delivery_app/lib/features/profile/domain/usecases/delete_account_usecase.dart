import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class DeleteAccountUseCase implements UseCase<void, DeleteAccountParams> {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    return await repository.deleteAccount(params.password);
  }
}

class DeleteAccountParams extends Equatable {
  final String password;

  const DeleteAccountParams({required this.password});

  @override
  List<Object?> get props => [password];
}
