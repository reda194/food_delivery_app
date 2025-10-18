import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/call_session_entity.dart';
import '../../domain/usecases/end_call_usecase.dart';
import '../../domain/usecases/get_call_history_usecase.dart';
import '../../domain/usecases/initiate_call_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final InitiateCallUseCase initiateCallUseCase;
  final EndCallUseCase endCallUseCase;
  final GetCallHistoryUseCase getCallHistoryUseCase;

  Timer? _callDurationTimer;

  CallBloc({
    required this.initiateCallUseCase,
    required this.endCallUseCase,
    required this.getCallHistoryUseCase,
  }) : super(const CallInitial()) {
    on<InitiateCallEvent>(_onInitiateCall);
    on<EndCallEvent>(_onEndCall);
    on<ToggleMicrophoneEvent>(_onToggleMicrophone);
    on<ToggleSpeakerEvent>(_onToggleSpeaker);
    on<ToggleCameraEvent>(_onToggleCamera);
    on<SwitchCameraEvent>(_onSwitchCamera);
    on<UpdateCallDurationEvent>(_onUpdateCallDuration);
    on<LoadCallHistoryEvent>(_onLoadCallHistory);
  }

  Future<void> _onInitiateCall(
    InitiateCallEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(const CallInitiating());

    final result = await initiateCallUseCase(
      InitiateCallParams(
        orderId: event.orderId,
        driverName: event.driverName,
        driverPhoneNumber: event.driverPhoneNumber,
        driverImageUrl: event.driverImageUrl,
        callType: event.callType,
      ),
    );

    result.fold(
      (failure) => emit(CallError(message: failure.message)),
      (callSession) {
        // Start call duration timer
        _startCallDurationTimer();

        emit(CallInProgress(
          callSession: callSession,
          currentDuration: Duration.zero,
          isSpeakerOn: event.callType == CallType.video,
          isCameraOn: event.callType == CallType.video,
        ));
      },
    );
  }

  Future<void> _onEndCall(
    EndCallEvent event,
    Emitter<CallState> emit,
  ) async {
    // Stop timer
    _callDurationTimer?.cancel();
    _callDurationTimer = null;

    final result = await endCallUseCase(
      EndCallParams(
        callSession: event.callSession,
        endTime: DateTime.now(),
      ),
    );

    result.fold(
      (failure) => emit(CallError(message: failure.message)),
      (_) => emit(CallEnded(callSession: event.callSession)),
    );
  }

  void _onToggleMicrophone(
    ToggleMicrophoneEvent event,
    Emitter<CallState> emit,
  ) {
    if (state is CallInProgress) {
      final currentState = state as CallInProgress;
      emit(currentState.copyWith(
        isMicrophoneMuted: !currentState.isMicrophoneMuted,
      ));
    }
  }

  void _onToggleSpeaker(
    ToggleSpeakerEvent event,
    Emitter<CallState> emit,
  ) {
    if (state is CallInProgress) {
      final currentState = state as CallInProgress;
      emit(currentState.copyWith(
        isSpeakerOn: !currentState.isSpeakerOn,
      ));
    }
  }

  void _onToggleCamera(
    ToggleCameraEvent event,
    Emitter<CallState> emit,
  ) {
    if (state is CallInProgress) {
      final currentState = state as CallInProgress;
      emit(currentState.copyWith(
        isCameraOn: !currentState.isCameraOn,
      ));
    }
  }

  void _onSwitchCamera(
    SwitchCameraEvent event,
    Emitter<CallState> emit,
  ) {
    if (state is CallInProgress) {
      final currentState = state as CallInProgress;
      emit(currentState.copyWith(
        isFrontCamera: !currentState.isFrontCamera,
      ));
    }
  }

  void _onUpdateCallDuration(
    UpdateCallDurationEvent event,
    Emitter<CallState> emit,
  ) {
    if (state is CallInProgress) {
      final currentState = state as CallInProgress;
      emit(currentState.copyWith(
        currentDuration: event.duration,
      ));
    }
  }

  Future<void> _onLoadCallHistory(
    LoadCallHistoryEvent event,
    Emitter<CallState> emit,
  ) async {
    final result = await getCallHistoryUseCase(const NoParams());

    result.fold(
      (failure) => emit(CallError(message: failure.message)),
      (callHistory) => emit(CallHistoryLoaded(callHistory: callHistory)),
    );
  }

  void _startCallDurationTimer() {
    _callDurationTimer?.cancel();

    var duration = Duration.zero;
    _callDurationTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        duration += const Duration(seconds: 1);
        add(UpdateCallDurationEvent(duration: duration));
      },
    );
  }

  @override
  Future<void> close() {
    _callDurationTimer?.cancel();
    return super.close();
  }
}
