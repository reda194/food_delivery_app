import 'package:equatable/equatable.dart';
import '../../domain/entities/call_session_entity.dart';

abstract class CallState extends Equatable {
  const CallState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CallInitial extends CallState {
  const CallInitial();
}

/// Initiating call state
class CallInitiating extends CallState {
  const CallInitiating();
}

/// Call in progress state
class CallInProgress extends CallState {
  final CallSessionEntity callSession;
  final Duration currentDuration;
  final bool isMicrophoneMuted;
  final bool isSpeakerOn;
  final bool isCameraOn;
  final bool isFrontCamera;

  const CallInProgress({
    required this.callSession,
    required this.currentDuration,
    this.isMicrophoneMuted = false,
    this.isSpeakerOn = false,
    this.isCameraOn = true,
    this.isFrontCamera = true,
  });

  @override
  List<Object?> get props => [
        callSession,
        currentDuration,
        isMicrophoneMuted,
        isSpeakerOn,
        isCameraOn,
        isFrontCamera,
      ];

  CallInProgress copyWith({
    CallSessionEntity? callSession,
    Duration? currentDuration,
    bool? isMicrophoneMuted,
    bool? isSpeakerOn,
    bool? isCameraOn,
    bool? isFrontCamera,
  }) {
    return CallInProgress(
      callSession: callSession ?? this.callSession,
      currentDuration: currentDuration ?? this.currentDuration,
      isMicrophoneMuted: isMicrophoneMuted ?? this.isMicrophoneMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
    );
  }
}

/// Call ended state
class CallEnded extends CallState {
  final CallSessionEntity callSession;

  const CallEnded({required this.callSession});

  @override
  List<Object?> get props => [callSession];
}

/// Call history loaded state
class CallHistoryLoaded extends CallState {
  final List<CallSessionEntity> callHistory;

  const CallHistoryLoaded({required this.callHistory});

  @override
  List<Object?> get props => [callHistory];
}

/// Call error state
class CallError extends CallState {
  final String message;

  const CallError({required this.message});

  @override
  List<Object?> get props => [message];
}
