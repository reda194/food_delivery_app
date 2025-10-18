import 'package:equatable/equatable.dart';

enum CallType {
  voice,
  video,
}

class CallSessionEntity extends Equatable {
  final String id;
  final String orderId;
  final String driverName;
  final String driverPhoneNumber;
  final String driverImageUrl;
  final CallType callType;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? duration;

  const CallSessionEntity({
    required this.id,
    required this.orderId,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.driverImageUrl,
    required this.callType,
    required this.startTime,
    this.endTime,
    this.duration,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        driverName,
        driverPhoneNumber,
        driverImageUrl,
        callType,
        startTime,
        endTime,
        duration,
      ];
}
