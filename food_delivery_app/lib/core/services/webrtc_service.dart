import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'logger_service.dart';
import 'realtime_service.dart';

/// WebRTC Service for Audio/Video Calling
/// Handles peer-to-peer connections for calls between customer and driver
class WebRTCService {
  static WebRTCService? _instance;
  static WebRTCService get instance => _instance ??= WebRTCService._();

  final LoggerService _logger = LoggerService.instance;
  final RealtimeService _realtimeService = RealtimeService.instance;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  final _remoteStreamController = StreamController<MediaStream>.broadcast();
  Stream<MediaStream> get onRemoteStream => _remoteStreamController.stream;

  final _connectionStateController = StreamController<RTCPeerConnectionState>.broadcast();
  Stream<RTCPeerConnectionState> get onConnectionStateChange => _connectionStateController.stream;

  bool _isAudioEnabled = true;
  bool _isVideoEnabled = false;
  String? _currentCallId;

  WebRTCService._();

  /// Initialize WebRTC with configuration
  Future<void> initialize() async {
    try {
      _logger.info('Initializing WebRTC Service...');

      // No initialization needed for flutter_webrtc
      // Configuration is done when creating peer connection

      _logger.success('WebRTC Service initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize WebRTC Service', e);
      rethrow;
    }
  }

  /// Create a peer connection with STUN/TURN servers
  Future<RTCPeerConnection> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302',
          ]
        },
        // Add your TURN server here for production
        // {
        //   'urls': 'turn:your-turn-server.com:3478',
        //   'username': 'your-username',
        //   'credential': 'your-password',
        // },
      ],
      'sdpSemantics': 'unified-plan',
    };

    final pc = await createPeerConnection(configuration);

    pc.onIceCandidate = (RTCIceCandidate candidate) {
      _logger.info('ICE Candidate generated');
      // Send candidate to remote peer via signaling
      if (_currentCallId != null) {
        _sendSignalingMessage(_currentCallId!, {
          'type': 'ice_candidate',
          'candidate': {
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMLineIndex': candidate.sdpMLineIndex,
          },
        });
      }
    };

    pc.onIceConnectionState = (RTCIceConnectionState state) {
      _logger.info('ICE Connection State: $state');
    };

    pc.onConnectionState = (RTCPeerConnectionState state) {
      _logger.info('Peer Connection State: $state');
      _connectionStateController.add(state);
    };

    pc.onTrack = (RTCTrackEvent event) {
      _logger.info('Track received: ${event.track.kind}');
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        _remoteStreamController.add(_remoteStream!);
      }
    };

    return pc;
  }

  /// Initialize local media stream (audio/video)
  Future<MediaStream> _initializeLocalStream({
    bool audio = true,
    bool video = false,
  }) async {
    try {
      final constraints = {
        'audio': audio,
        'video': video
            ? {
                'facingMode': 'user',
                'width': {'ideal': 640},
                'height': {'ideal': 480},
              }
            : false,
      };

      final stream = await navigator.mediaDevices.getUserMedia(constraints);
      _localStream = stream;
      _isAudioEnabled = audio;
      _isVideoEnabled = video;

      _logger.success('Local media stream initialized (audio: $audio, video: $video)');
      return stream;
    } catch (e) {
      _logger.error('Failed to initialize local stream', e);
      rethrow;
    }
  }

  /// Initiate a call (caller side)
  Future<MediaStream> initiateCall({
    required String callId,
    required String calleeId,
    bool audioOnly = true,
  }) async {
    try {
      _logger.info('Initiating call: $callId to $calleeId (audioOnly: $audioOnly)');
      _currentCallId = callId;

      // Initialize local stream
      final localStream = await _initializeLocalStream(
        audio: true,
        video: !audioOnly,
      );

      // Create peer connection
      _peerConnection = await _createPeerConnection();

      // Add local stream tracks to peer connection
      localStream.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, localStream);
      });

      // Create and send offer
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      _logger.info('Sending call offer to $calleeId');
      await _sendSignalingMessage(callId, {
        'type': 'offer',
        'callerId': calleeId,
        'offer': {
          'sdp': offer.sdp,
          'type': offer.type,
        },
        'audioOnly': audioOnly,
      });

      // Subscribe to signaling messages for this call
      _subscribeToSignaling(callId);

      return localStream;
    } catch (e) {
      _logger.error('Failed to initiate call', e);
      await endCall();
      rethrow;
    }
  }

  /// Answer a call (callee side)
  Future<MediaStream> answerCall({
    required String callId,
    required Map<String, dynamic> offerData,
    bool audioOnly = true,
  }) async {
    try {
      _logger.info('Answering call: $callId (audioOnly: $audioOnly)');
      _currentCallId = callId;

      // Initialize local stream
      final localStream = await _initializeLocalStream(
        audio: true,
        video: !audioOnly,
      );

      // Create peer connection
      _peerConnection = await _createPeerConnection();

      // Add local stream tracks to peer connection
      localStream.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, localStream);
      });

      // Set remote description from offer
      final offer = RTCSessionDescription(
        offerData['sdp'] as String,
        offerData['type'] as String,
      );
      await _peerConnection!.setRemoteDescription(offer);

      // Create and send answer
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      _logger.info('Sending call answer');
      await _sendSignalingMessage(callId, {
        'type': 'answer',
        'answer': {
          'sdp': answer.sdp,
          'type': answer.type,
        },
      });

      // Subscribe to signaling messages for this call
      _subscribeToSignaling(callId);

      return localStream;
    } catch (e) {
      _logger.error('Failed to answer call', e);
      await endCall();
      rethrow;
    }
  }

  /// Handle incoming signaling messages
  void _subscribeToSignaling(String callId) {
    _logger.info('Subscribing to signaling for call: $callId');

    final stream = _realtimeService.subscribeToTable(
      table: 'call_signaling',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'call_id',
        value: callId,
      ),
      channelId: 'call_signaling_$callId',
    );

    stream.listen((payload) async {
      final data = payload.newRecord as Map<String, dynamic>;
      final type = data['type'] as String?;

      _logger.info('Received signaling message: $type');

      try {
        switch (type) {
          case 'answer':
            final answerData = data['answer'] as Map<String, dynamic>;
            final answer = RTCSessionDescription(
              answerData['sdp'] as String,
              answerData['type'] as String,
            );
            await _peerConnection?.setRemoteDescription(answer);
            _logger.success('Remote answer set successfully');
            break;

          case 'ice_candidate':
            final candidateData = data['candidate'] as Map<String, dynamic>;
            final candidate = RTCIceCandidate(
              candidateData['candidate'] as String,
              candidateData['sdpMid'] as String,
              candidateData['sdpMLineIndex'] as int,
            );
            await _peerConnection?.addCandidate(candidate);
            _logger.info('ICE candidate added');
            break;

          case 'end_call':
            _logger.info('Call ended by remote peer');
            await endCall();
            break;

          default:
            _logger.warning('Unknown signaling message type: $type');
        }
      } catch (e) {
        _logger.error('Failed to handle signaling message', e);
      }
    });
  }

  /// Send signaling message via Supabase real-time
  Future<void> _sendSignalingMessage(
    String callId,
    Map<String, dynamic> message,
  ) async {
    try {
      // In production, use Supabase database to store signaling messages
      // For now, we'll use the broadcast feature
      await _realtimeService.broadcastEvent('call_signaling', {
        'call_id': callId,
        ...message,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _logger.info('Signaling message sent: ${message['type']}');
    } catch (e) {
      _logger.error('Failed to send signaling message', e);
      rethrow;
    }
  }

  /// Toggle audio (mute/unmute)
  void toggleAudio() {
    if (_localStream == null) return;

    _isAudioEnabled = !_isAudioEnabled;
    _localStream!.getAudioTracks().forEach((track) {
      track.enabled = _isAudioEnabled;
    });

    _logger.info('Audio ${_isAudioEnabled ? 'enabled' : 'disabled'}');
  }

  /// Toggle video (camera on/off)
  void toggleVideo() {
    if (_localStream == null) return;

    _isVideoEnabled = !_isVideoEnabled;
    _localStream!.getVideoTracks().forEach((track) {
      track.enabled = _isVideoEnabled;
    });

    _logger.info('Video ${_isVideoEnabled ? 'enabled' : 'disabled'}');
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_localStream == null) return;

    try {
      final videoTrack = _localStream!.getVideoTracks()[0];
      await Helper.switchCamera(videoTrack);
      _logger.info('Camera switched');
    } catch (e) {
      _logger.error('Failed to switch camera', e);
    }
  }

  /// End the call and cleanup resources
  Future<void> endCall() async {
    try {
      _logger.info('Ending call...');

      // Send end call signal
      if (_currentCallId != null) {
        await _sendSignalingMessage(_currentCallId!, {
          'type': 'end_call',
        });
      }

      // Unsubscribe from signaling
      if (_currentCallId != null) {
        await _realtimeService.unsubscribeFromChannel('call_signaling_$_currentCallId');
      }

      // Stop local stream tracks
      _localStream?.getTracks().forEach((track) {
        track.stop();
      });

      // Close peer connection
      await _peerConnection?.close();

      // Dispose streams
      await _localStream?.dispose();
      await _remoteStream?.dispose();

      // Clear references
      _peerConnection = null;
      _localStream = null;
      _remoteStream = null;
      _currentCallId = null;

      _logger.success('Call ended successfully');
    } catch (e) {
      _logger.error('Failed to end call cleanly', e);
    }
  }

  /// Get current call statistics
  Future<Map<String, dynamic>> getCallStats() async {
    if (_peerConnection == null) {
      return {};
    }

    try {
      final stats = await _peerConnection!.getStats();
      return {
        'connectionState': _peerConnection!.connectionState?.toString(),
        'iceConnectionState': _peerConnection!.iceConnectionState?.toString(),
        'signalingState': _peerConnection!.signalingState?.toString(),
        'stats': stats,
      };
    } catch (e) {
      _logger.error('Failed to get call stats', e);
      return {};
    }
  }

  /// Check if audio is enabled
  bool get isAudioEnabled => _isAudioEnabled;

  /// Check if video is enabled
  bool get isVideoEnabled => _isVideoEnabled;

  /// Get local stream
  MediaStream? get localStream => _localStream;

  /// Get remote stream
  MediaStream? get remoteStream => _remoteStream;

  /// Get current call ID
  String? get currentCallId => _currentCallId;

  /// Dispose resources
  Future<void> dispose() async {
    _logger.info('Disposing WebRTC Service...');
    await endCall();
    await _remoteStreamController.close();
    await _connectionStateController.close();
    _logger.success('WebRTC Service disposed');
  }
}

/// Call signaling messages types
enum SignalingMessageType {
  offer,
  answer,
  iceCandidate,
  endCall,
}
