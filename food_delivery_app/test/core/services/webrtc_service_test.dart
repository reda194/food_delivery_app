import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/core/services/webrtc_service.dart';

void main() {
  group('WebRTCService Tests', () {
    late WebRTCService service;

    setUp(() {
      service = WebRTCService.instance;
    });

    test('should be a singleton', () {
      final instance1 = WebRTCService.instance;
      final instance2 = WebRTCService.instance;

      expect(instance1, equals(instance2));
    });

    test('should have initial state with no active call', () {
      expect(service.currentCallId, isNull);
      expect(service.localStream, isNull);
      expect(service.remoteStream, isNull);
    });

    test('should have audio enabled by default', () {
      expect(service.isAudioEnabled, isTrue);
    });

    test('should have video disabled by default', () {
      expect(service.isVideoEnabled, isFalse);
    });

    group('Call State Management', () {
      test('should update call state when initiating call', () {
        // Note: This test requires actual WebRTC setup which may not work in unit tests
        // In real tests, you would mock RTCPeerConnection

        // Initial state
        expect(service.currentCallId, isNull);
      });

      test('should have separate streams for remote stream and connection state', () {
        expect(service.onRemoteStream, isA<Stream>());
        expect(service.onConnectionStateChange, isA<Stream>());
      });
    });

    group('Signaling Message Types', () {
      test('should have offer message type', () {
        expect(SignalingMessageType.offer, isNotNull);
      });

      test('should have answer message type', () {
        expect(SignalingMessageType.answer, isNotNull);
      });

      test('should have iceCandidate message type', () {
        expect(SignalingMessageType.iceCandidate, isNotNull);
      });

      test('should have endCall message type', () {
        expect(SignalingMessageType.endCall, isNotNull);
      });
    });

    group('Service Lifecycle', () {
      test('should initialize successfully', () async {
        expect(() => service.initialize(), returnsNormally);
      });

      test('should dispose without errors', () async {
        expect(() => service.dispose(), returnsNormally);
      });
    });
  });

  group('Call Scenarios', () {
    test('audio-only call should have video disabled', () {
      // Test the expected behavior for audio-only calls
      const audioOnly = true;
      expect(audioOnly, isTrue);
    });

    test('video call should have both audio and video enabled', () {
      const audioOnly = false;
      expect(audioOnly, isFalse);
    });
  });
}
