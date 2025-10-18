import 'package:equatable/equatable.dart';
import '../../domain/entities/call_session_entity.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initiate a call
class InitiateCallEvent extends CallEvent {
  final String orderId;
  final String driverName;
  final String driverPhoneNumber;
  final String driverImageUrl;
  final CallType callType;

  const InitiateCallEvent({
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

/// Event to end the current call
class EndCallEvent extends CallEvent {
  final CallSessionEntity callSession;

  const EndCallEvent({required this.callSession});

  @override
  List<Object?> get props => [callSession];
}

/// Event to toggle microphone
class ToggleMicrophoneEvent extends CallEvent {
  const ToggleMicrophoneEvent();
}

/// Event to toggle speaker
class ToggleSpeakerEvent extends CallEvent {
  const ToggleSpeakerEvent();
}

/// Event to toggle camera (video calls only)
class ToggleCameraEvent extends CallEvent {
  const ToggleCameraEvent();
}

/// Event to switch camera (front/back)
class SwitchCameraEvent extends CallEvent {
  const SwitchCameraEvent();
}

/// Event to update call duration
class UpdateCallDurationEvent extends CallEvent {
  final Duration duration;

  const UpdateCallDurationEvent({required this.duration});

  @override
  List<Object?> get props => [duration];
}

/// Event to load call history
class LoadCallHistoryEvent extends CallEvent {
  const LoadCallHistoryEvent();
}
