import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'logger_service.dart';

/// Firebase Cloud Messaging Service
/// Handles push notifications and local notifications
class FcmService {
  static FcmService? _instance;
  static FcmService get instance => _instance ??= FcmService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final LoggerService _logger = LoggerService.instance;

  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get onMessage => _messageStreamController.stream;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  FcmService._();

  /// Initialize FCM and local notifications
  Future<void> initialize() async {
    try {
      // Request permissions
      await requestPermissions();

      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      _logger.info('FCM Token: $_fcmToken');

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _logger.info('FCM Token refreshed: $newToken');
      });

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Setup message handlers
      _setupMessageHandlers();

      _logger.success('FCM Service initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize FCM Service: $e');
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final isAuthorized = settings.authorizationStatus == AuthorizationStatus.authorized;
      _logger.info('Notification permission: ${settings.authorizationStatus}');

      return isAuthorized;
    } catch (e) {
      _logger.error('Failed to request permissions: $e');
      return false;
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      _logger.error('Failed to check notification status: $e');
      return false;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.info('Foreground message received: ${message.notification?.title}');
      _messageStreamController.add(message);
      _showLocalNotification(message);
    });

    // Background messages (opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.info('Notification opened: ${message.notification?.title}');
      _messageStreamController.add(message);
    });

    // Check if app was opened from a terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _logger.info('App opened from terminated state: ${message.notification?.title}');
        _messageStreamController.add(message);
      }
    });
  }

  /// Show local notification when app is in foreground
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'Default notification channel for the app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    _logger.info('Notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      _logger.info('Subscribed to topic: $topic');
    } catch (e) {
      _logger.error('Failed to subscribe to topic $topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      _logger.info('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.error('Failed to unsubscribe from topic $topic: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _messageStreamController.close();
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LoggerService.instance.info('Background message: ${message.notification?.title}');
}
