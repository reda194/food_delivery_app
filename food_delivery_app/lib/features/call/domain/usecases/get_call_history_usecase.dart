import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_session_entity.dart';
import '../repositories/call_repository.dart';

/// Use case to get call history
class GetCallHistoryUseCase implements UseCase<List<CallSessionEntity>, NoParams> {
  final CallRepository repository;

  GetCallHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<CallSessionEntity>>> call(NoParams params) async {
    return await repository.getCallHistory();
  }
}
