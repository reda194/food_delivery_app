import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_session_entity.dart';
import '../repositories/call_repository.dart';

/// Use case to end a call and save to history
class EndCallUseCase implements UseCase<void, EndCallParams> {
  final CallRepository repository;

  EndCallUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(EndCallParams params) async {
    try {
      // Calculate duration
      final duration = params.endTime.difference(params.callSession.startTime);

      // Create updated call session with end time and duration
      final updatedSession = CallSessionEntity(
        id: params.callSession.id,
        orderId: params.callSession.orderId,
        driverName: params.callSession.driverName,
        driverPhoneNumber: params.callSession.driverPhoneNumber,
        driverImageUrl: params.callSession.driverImageUrl,
        callType: params.callSession.callType,
        startTime: params.callSession.startTime,
        endTime: params.endTime,
        duration: duration,
      );

      // Save to call history
      return await repository.saveCallSession(updatedSession);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

class EndCallParams extends Equatable {
  final CallSessionEntity callSession;
  final DateTime endTime;

  const EndCallParams({
    required this.callSession,
    required this.endTime,
  });

  @override
  List<Object?> get props => [callSession, endTime];
}
