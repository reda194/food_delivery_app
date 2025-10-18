import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/call_session_entity.dart';

abstract class CallRepository {
  Future<Either<Failure, void>> saveCallSession(CallSessionEntity callSession);
  Future<Either<Failure, List<CallSessionEntity>>> getCallHistory();
  Future<Either<Failure, void>> clearCallHistory();
}
