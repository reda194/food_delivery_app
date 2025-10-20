import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/services/logger_service.dart';
import '../datasources/notifications_remote_datasource.dart';

/// FCM Integration Service for Notifications Feature
/// Connects Firebase Cloud Messaging with the Notifications feature
class FcmIntegrationService {
  static FcmIntegrationService? _instance;
  static FcmIntegrationService get instance =>
      _instance ??= FcmIntegrationService._();

  final FcmService _fcmService = FcmService.instance;
  final LoggerService _logger = LoggerService.instance;
  NotificationsRemoteDataSource? _notificationsDataSource;
  String? _currentUserId;

  FcmIntegrationService._();

  /// Initialize FCM integration
  Future<void> initialize({
    required NotificationsRemoteDataSource notificationsDataSource,
    required String userId,
  }) async {
    _notificationsDataSource = notificationsDataSource;
    _currentUserId = userId;

    // Initialize FCM Service
    await _fcmService.initialize();

    // Save FCM token to backend
    final token = _fcmService.fcmToken;
    if (token != null) {
      await _saveFcmToken(token);
    }

    // Listen to FCM messages
    _setupMessageListeners();
  }

  /// Save FCM token to backend
  Future<void> _saveFcmToken(String token) async {
    if (_notificationsDataSource == null || _currentUserId == null) return;

    try {
      await _notificationsDataSource!.saveFcmToken(_currentUserId!, token);
      _logger.success('FCM token saved successfully');
    } catch (e) {
      _logger.error('Failed to save FCM token', e);
    }
  }

  /// Setup message listeners
  void _setupMessageListeners() {
    // Foreground messages
    _fcmService.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Background message handler is set up in main.dart
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    _logger.info('Handling foreground notification: ${notification?.title}');

    // Note: Local notification is already shown by FcmService._showLocalNotification
    // This method handles the data payload and app-specific logic

    // Handle notification data
    _handleNotificationData(data);
  }

  /// Handle notification data
  void _handleNotificationData(Map<String, dynamic> data) {
    final type = data['type'] as String?;

    switch (type) {
      case 'order_update':
        _handleOrderUpdate(data);
        break;
      case 'promotion':
        _handlePromotion(data);
        break;
      case 'delivery_update':
        _handleDeliveryUpdate(data);
        break;
      case 'new_message':
        _handleNewMessage(data);
        break;
      default:
        _logger.warning('Unknown notification type: $type');
    }
  }

  /// Handle order update notification
  void _handleOrderUpdate(Map<String, dynamic> data) {
    final orderId = data['order_id'] as String?;
    final status = data['status'] as String?;

    _logger.info('Order Update: Order $orderId is now $status');
    // TODO: Navigate to order details or update order tracking
    // Can be implemented using a navigation service or event bus
  }

  /// Handle promotion notification
  void _handlePromotion(Map<String, dynamic> data) {
    final promoCode = data['promo_code'] as String?;
    final discount = data['discount'] as String?;

    _logger.info('Promotion: $promoCode - $discount% off');
    // TODO: Show promotion dialog or navigate to offers screen
    // Can be implemented using a navigation service or event bus
  }

  /// Handle delivery update notification
  void _handleDeliveryUpdate(Map<String, dynamic> data) {
    final orderId = data['order_id'] as String?;
    final driverLocationData = data['driver_location'] as Map?;

    _logger.info('Delivery Update for order: $orderId, location: $driverLocationData');
    // TODO: Update order tracking screen with driver location
    // Can be implemented using a real-time order tracking service
  }

  /// Handle new message notification
  void _handleNewMessage(Map<String, dynamic> data) {
    final senderId = data['sender_id'] as String?;
    final messageText = data['message'] as String?;

    _logger.info('New message from: $senderId - $messageText');
    // TODO: Navigate to chat screen or update chat badge
    // Can be implemented using a navigation service or event bus
  }

  /// Clean up on logout
  Future<void> cleanup() async {
    if (_notificationsDataSource == null || _currentUserId == null) return;

    try {
      await _notificationsDataSource!.deleteFcmToken(_currentUserId!);
      _currentUserId = null;
      _notificationsDataSource = null;
      _logger.success('FCM integration cleaned up successfully');
    } catch (e) {
      _logger.error('Failed to cleanup FCM integration', e);
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    return await _fcmService.requestPermissions();
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    return await _fcmService.areNotificationsEnabled();
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if needed
  // await Firebase.initializeApp();

  LoggerService.instance.info('Handling background message: ${message.messageId}');

  // Handle background message
  final data = message.data;
  final type = data['type'] as String?;

  switch (type) {
    case 'order_update':
      // TODO: Handle order update silently
      // Update local database or trigger background sync
      LoggerService.instance.info('Background order update: ${data['order_id']}');
      break;
    case 'delivery_update':
      // TODO: Update local database with driver location
      LoggerService.instance.info('Background delivery update: ${data['order_id']}');
      break;
    default:
      LoggerService.instance.info('Background notification type: $type');
  }
}
