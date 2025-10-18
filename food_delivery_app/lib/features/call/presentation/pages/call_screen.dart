import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/call_session_entity.dart';
import '../bloc/call_bloc.dart';
import '../bloc/call_event.dart';
import '../bloc/call_state.dart';

/// Call Screen - Enhanced with BLoC and video support
/// Shows ongoing call with driver (voice or video)
class CallScreen extends StatefulWidget {
  final String orderId;
  final String driverName;
  final String driverImage;
  final String driverPhone;
  final CallType callType;

  const CallScreen({
    super.key,
    required this.orderId,
    required this.driverName,
    required this.driverImage,
    required this.driverPhone,
    this.callType = CallType.voice,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    // Initiate call when screen opens
    context.read<CallBloc>().add(InitiateCallEvent(
          orderId: widget.orderId,
          driverName: widget.driverName,
          driverPhoneNumber: widget.driverPhone,
          driverImageUrl: widget.driverImage,
          callType: widget.callType,
        ));
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _endCall(CallSessionEntity callSession) {
    context.read<CallBloc>().add(EndCallEvent(callSession: callSession));
  }

  void _toggleMute() {
    context.read<CallBloc>().add(const ToggleMicrophoneEvent());
  }

  void _toggleSpeaker() {
    context.read<CallBloc>().add(const ToggleSpeakerEvent());
  }

  void _toggleCamera() {
    context.read<CallBloc>().add(const ToggleCameraEvent());
  }

  void _switchCamera() {
    context.read<CallBloc>().add(const SwitchCameraEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallBloc, CallState>(
      listener: (context, state) {
        if (state is CallEnded) {
          Navigator.of(context).pop();
        } else if (state is CallError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is CallInitiating) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is! CallInProgress) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final isVideoCall = state.callSession.callType == CallType.video;

        return Scaffold(
          backgroundColor: isVideoCall ? Colors.black : const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Stack(
              children: [
                // Video preview for video calls
                if (isVideoCall && state.isCameraOn)
                  Positioned.fill(
                    child: Container(
                      color: Colors.grey[900],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videocam,
                              size: 100,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Video Call Preview',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '(Mock - WebRTC/Twilio not integrated)',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Small self-view for video calls
                if (isVideoCall && state.isCameraOn)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 120,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Center(
                          child: Icon(
                            state.isFrontCamera
                                ? Icons.camera_front
                                : Icons.camera_rear,
                            color: Colors.white.withOpacity(0.5),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Main content
                Column(
                  children: [
                    const Spacer(flex: 2),

                    // Overlapping Profile Images (for voice calls)
                    if (!isVideoCall || !state.isCameraOn)
                      SizedBox(
                        height: 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Left profile (current user)
                            Positioned(
                              left: MediaQuery.of(context).size.width / 2 - 110,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Container(
                                    color: const Color(0xFFFFB84D),
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Right profile (driver)
                            Positioned(
                              right: MediaQuery.of(context).size.width / 2 - 110,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: widget.driverImage.isNotEmpty
                                      ? Image.network(
                                          widget.driverImage,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[800],
                                              child: const Icon(
                                                Icons.person,
                                                size: 60,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: Colors.grey[800],
                                          child: const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 40),

                    // Driver Name
                    Text(
                      widget.driverName,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: isVideoCall ? Colors.white : Colors.black,
                        letterSpacing: -1.5,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Call Timer
                    Text(
                      _formatDuration(state.currentDuration),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: isVideoCall
                            ? Colors.white.withOpacity(0.7)
                            : Colors.grey[500],
                        letterSpacing: 2,
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Mute Button
                          _buildActionButton(
                            icon: state.isMicrophoneMuted
                                ? Icons.mic_off
                                : Icons.mic,
                            isActive: state.isMicrophoneMuted,
                            onTap: _toggleMute,
                          ),

                          // Speaker Button (voice calls)
                          if (!isVideoCall)
                            _buildActionButton(
                              icon: state.isSpeakerOn
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              isActive: state.isSpeakerOn,
                              onTap: _toggleSpeaker,
                            ),

                          // Camera Toggle (video calls)
                          if (isVideoCall)
                            _buildActionButton(
                              icon: state.isCameraOn
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              isActive: !state.isCameraOn,
                              onTap: _toggleCamera,
                            ),

                          // Switch Camera (video calls)
                          if (isVideoCall && state.isCameraOn)
                            _buildActionButton(
                              icon: Icons.flip_camera_ios,
                              isActive: false,
                              onTap: _switchCamera,
                            ),

                          // End Call Button
                          GestureDetector(
                            onTap: () => _endCall(state.callSession),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4757),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF4757)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF6B6B) : Colors.grey[800],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isActive ? const Color(0xFFFF6B6B) : Colors.grey[800]!)
                  .withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
