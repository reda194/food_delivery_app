import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/call_session_entity.dart';
import '../repositories/call_repository.dart';

/// Use case to initiate a call (voice or video)
class InitiateCallUseCase implements UseCase<CallSessionEntity, InitiateCallParams> {
  final CallRepository repository;

  InitiateCallUseCase(this.repository);

  @override
  Future<Either<Failure, CallSessionEntity>> call(InitiateCallParams params) async {
    try {
      // Create call session
      final callSession = CallSessionEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        orderId: params.orderId,
        driverName: params.driverName,
        driverPhoneNumber: params.driverPhoneNumber,
        driverImageUrl: params.driverImageUrl,
        callType: params.callType,
        startTime: DateTime.now(),
      );

      // For voice calls, launch native phone dialer
      if (params.callType == CallType.voice) {
        final Uri phoneUri = Uri(
          scheme: 'tel',
          path: params.driverPhoneNumber,
        );

        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          return Left(
            ServerFailure('Unable to launch phone dialer'),
          );
        }
      }

      // For video calls, the UI will handle the video interface
      // Since we're using mock video (no WebRTC/Twilio integration)

      return Right(callSession);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class InitiateCallParams extends Equatable {
  final String orderId;
  final String driverName;
  final String driverPhoneNumber;
  final String driverImageUrl;
  final CallType callType;

  const InitiateCallParams({
    required this.orderId,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.driverImageUrl,
    required this.callType,
  });

  @override
  List<Object?> get props => [
        orderId,
        driverName,
        driverPhoneNumber,
        driverImageUrl,
        callType,
      ];
}
