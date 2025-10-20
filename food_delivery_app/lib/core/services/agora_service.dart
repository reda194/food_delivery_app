import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'logger_service.dart';

/// Agora RTC Service for Production-Grade Audio/Video Calling
/// Alternative to WebRTC, provides better quality and reliability
class AgoraService {
  static AgoraService? _instance;
  static AgoraService get instance => _instance ??= AgoraService._();

  final LoggerService _logger = LoggerService.instance;

  RtcEngine? _engine;
  String? _appId;
  String? _currentChannelId;
  int? _remoteUid;

  final _remoteUserJoinedController = StreamController<int>.broadcast();
  Stream<int> get onRemoteUserJoined => _remoteUserJoinedController.stream;

  final _remoteUserLeftController = StreamController<int>.broadcast();
  Stream<int> get onRemoteUserLeft => _remoteUserLeftController.stream;

  final _connectionStateController = StreamController<ConnectionStateType>.broadcast();
  Stream<ConnectionStateType> get onConnectionStateChange => _connectionStateController.stream;

  bool _isAudioEnabled = true;
  bool _isVideoEnabled = false;
  bool _isMuted = false;

  AgoraService._();

  /// Initialize Agora RTC Engine
  Future<void> initialize(String appId) async {
    try {
      _logger.info('Initializing Agora Service...');
      _appId = appId;

      // Request permissions
      await _requestPermissions();

      // Create RTC Engine
      _engine = createAgoraRtcEngine();

      await _engine!.initialize(RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      // Setup event handlers
      _setupEventHandlers();

      _logger.success('Agora Service initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize Agora Service', e);
      rethrow;
    }
  }

  /// Request necessary permissions
  Future<void> _requestPermissions() async {
    try {
      await [
        Permission.microphone,
        Permission.camera,
      ].request();

      _logger.info('Permissions requested');
    } catch (e) {
      _logger.error('Failed to request permissions', e);
    }
  }

  /// Setup event handlers for Agora callbacks
  void _setupEventHandlers() {
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _logger.success('Joined channel: ${connection.channelId}');
          _currentChannelId = connection.channelId;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _logger.info('Remote user joined: $remoteUid');
          _remoteUid = remoteUid;
          _remoteUserJoinedController.add(remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          _logger.info('Remote user left: $remoteUid (reason: $reason)');
          _remoteUserLeftController.add(remoteUid);
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          _logger.info('Left channel: ${connection.channelId}');
          _currentChannelId = null;
        },
        onConnectionStateChanged: (RtcConnection connection, ConnectionStateType state, ConnectionChangedReasonType reason) {
          _logger.info('Connection state changed: $state (reason: $reason)');
          _connectionStateController.add(state);
        },
        onError: (ErrorCodeType err, String msg) {
          _logger.error('Agora error: $err - $msg');
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          _logger.warning('Token will expire, need to renew');
          // TODO: Implement token renewal logic
        },
        onAudioVolumeIndication: (RtcConnection connection, List<AudioVolumeInfo> speakers, int speakerNumber, int totalVolume) {
          // Can be used for volume indicators UI
        },
        onNetworkQuality: (RtcConnection connection, int remoteUid, QualityType txQuality, QualityType rxQuality) {
          // Can be used to show network quality indicator
        },
      ),
    );
  }

  /// Join a call channel (audio only)
  Future<void> joinAudioCall({
    required String channelId,
    required String token,
    required int uid,
  }) async {
    try {
      _logger.info('Joining audio call: $channelId');

      // Enable audio
      await _engine!.enableAudio();

      // Join channel
      await _engine!.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          autoSubscribeAudio: true,
          autoSubscribeVideo: false,
          publishMicrophoneTrack: true,
          publishCameraTrack: false,
        ),
      );

      _isAudioEnabled = true;
      _isVideoEnabled = false;

      _logger.success('Joined audio call successfully');
    } catch (e) {
      _logger.error('Failed to join audio call', e);
      rethrow;
    }
  }

  /// Join a call channel (video call)
  Future<void> joinVideoCall({
    required String channelId,
    required String token,
    required int uid,
  }) async {
    try {
      _logger.info('Joining video call: $channelId');

      // Enable audio and video
      await _engine!.enableAudio();
      await _engine!.enableVideo();

      // Set video configuration
      await _engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 640, height: 480),
          frameRate: 15,
          bitrate: 0,
          orientationMode: OrientationMode.orientationModeAdaptive,
        ),
      );

      // Enable local video preview
      await _engine!.startPreview();

      // Join channel
      await _engine!.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
          publishMicrophoneTrack: true,
          publishCameraTrack: true,
        ),
      );

      _isAudioEnabled = true;
      _isVideoEnabled = true;

      _logger.success('Joined video call successfully');
    } catch (e) {
      _logger.error('Failed to join video call', e);
      rethrow;
    }
  }

  /// Mute/unmute local audio
  Future<void> toggleMute() async {
    if (_engine == null) return;

    try {
      _isMuted = !_isMuted;
      await _engine!.muteLocalAudioStream(_isMuted);
      _logger.info('Audio ${_isMuted ? 'muted' : 'unmuted'}');
    } catch (e) {
      _logger.error('Failed to toggle mute', e);
    }
  }

  /// Enable/disable local video
  Future<void> toggleVideo() async {
    if (_engine == null) return;

    try {
      _isVideoEnabled = !_isVideoEnabled;

      if (_isVideoEnabled) {
        await _engine!.enableLocalVideo(true);
        await _engine!.startPreview();
      } else {
        await _engine!.enableLocalVideo(false);
        await _engine!.stopPreview();
      }

      _logger.info('Video ${_isVideoEnabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      _logger.error('Failed to toggle video', e);
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_engine == null || !_isVideoEnabled) return;

    try {
      await _engine!.switchCamera();
      _logger.info('Camera switched');
    } catch (e) {
      _logger.error('Failed to switch camera', e);
    }
  }

  /// Set speaker mode (on/off)
  Future<void> setSpeakerphoneOn(bool enabled) async {
    if (_engine == null) return;

    try {
      await _engine!.setEnableSpeakerphone(enabled);
      _logger.info('Speakerphone ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      _logger.error('Failed to set speakerphone', e);
    }
  }

  /// Adjust recording volume
  Future<void> adjustRecordingVolume(int volume) async {
    if (_engine == null) return;

    try {
      await _engine!.adjustRecordingSignalVolume(volume);
      _logger.info('Recording volume adjusted to: $volume');
    } catch (e) {
      _logger.error('Failed to adjust recording volume', e);
    }
  }

  /// Adjust playback volume
  Future<void> adjustPlaybackVolume(int volume) async {
    if (_engine == null) return;

    try {
      await _engine!.adjustPlaybackSignalVolume(volume);
      _logger.info('Playback volume adjusted to: $volume');
    } catch (e) {
      _logger.error('Failed to adjust playback volume', e);
    }
  }

  /// Enable audio effects (echo cancellation, noise suppression, etc.)
  Future<void> enableAudioEffects() async {
    if (_engine == null) return;

    try {
      // Enable echo cancellation
      await _engine!.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioChatroom,
      );

      _logger.info('Audio effects enabled');
    } catch (e) {
      _logger.error('Failed to enable audio effects', e);
    }
  }

  /// Get call statistics
  /// Note: This is a placeholder - actual stats retrieval may require specific Agora methods
  Future<Map<String, dynamic>> getCallStats() async {
    if (_engine == null) return {};

    try {
      // Note: getRtcStats() may not be available in all versions
      // Use appropriate stats methods from your Agora SDK version
      return {
        'isInCall': isInCall,
        'isMuted': _isMuted,
        'isVideoEnabled': _isVideoEnabled,
        'channelId': _currentChannelId,
        'remoteUid': _remoteUid,
      };
    } catch (e) {
      _logger.error('Failed to get call stats', e);
      return {};
    }
  }

  /// Leave the channel and stop call
  Future<void> leaveChannel() async {
    if (_engine == null) return;

    try {
      _logger.info('Leaving channel...');

      // Stop preview if video is enabled
      if (_isVideoEnabled) {
        await _engine!.stopPreview();
      }

      // Leave channel
      await _engine!.leaveChannel();

      // Disable audio and video
      await _engine!.disableAudio();
      await _engine!.disableVideo();

      _currentChannelId = null;
      _remoteUid = null;

      _logger.success('Left channel successfully');
    } catch (e) {
      _logger.error('Failed to leave channel', e);
    }
  }

  /// Check if currently in a call
  bool get isInCall => _currentChannelId != null;

  /// Check if audio is muted
  bool get isMuted => _isMuted;

  /// Check if video is enabled
  bool get isVideoEnabled => _isVideoEnabled;

  /// Get current channel ID
  String? get currentChannelId => _currentChannelId;

  /// Get remote user ID
  int? get remoteUid => _remoteUid;

  /// Get RTC Engine instance (for UI widgets)
  RtcEngine? get engine => _engine;

  /// Dispose and cleanup resources
  Future<void> dispose() async {
    _logger.info('Disposing Agora Service...');

    try {
      await leaveChannel();
      await _engine?.release();
      _engine = null;

      await _remoteUserJoinedController.close();
      await _remoteUserLeftController.close();
      await _connectionStateController.close();

      _logger.success('Agora Service disposed');
    } catch (e) {
      _logger.error('Failed to dispose Agora Service', e);
    }
  }
}

/// Helper class for Agora token generation
/// In production, tokens should be generated on your backend server
class AgoraTokenHelper {
  /// Generate a temporary token for testing
  /// In production, implement proper token generation on your backend
  static Future<String> generateToken({
    required String channelId,
    required int uid,
  }) async {
    // TODO: Implement server-side token generation
    // For now, return empty string for testing (requires Agora project to be in testing mode)
    return '';
  }

  /// Refresh an expiring token
  static Future<String> refreshToken({
    required String channelId,
    required int uid,
  }) async {
    // TODO: Implement token refresh logic
    return '';
  }
}
