import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

/// Real-time Service - Handles real-time subscriptions and live data updates
class RealtimeService {
  static RealtimeService? _instance;
  static RealtimeService get instance => _instance ??= RealtimeService._();

  late final SupabaseClient _supabase;
  final LoggerService _logger = LoggerService.instance;
  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, StreamController<dynamic>> _streamControllers = {};

  RealtimeService._() {
    _supabase = SupabaseService.instance.client;
  }

  /// ==================== SUBSCRIPTION MANAGEMENT ====================

  /// Subscribe to real-time changes on a table
  Stream<dynamic> subscribeToTable({
    required String table,
    PostgresChangeEvent event = PostgresChangeEvent.all,
    PostgresChangeFilter? filter,
    String? channelId,
  }) {
    final channelKey = channelId ?? '${table}_subscription';

    // Remove existing channel if it exists
    if (_channels.containsKey(channelKey)) {
      unsubscribeFromChannel(channelKey);
    }

    final streamController = StreamController<dynamic>.broadcast();
    _streamControllers[channelKey] = streamController;

    try {
      _logger.info('Subscribing to real-time changes on $table');

      final channel = _supabase.channel(channelKey);

      channel.onPostgresChanges(
        event: event,
        schema: 'public',
        table: table,
        filter: filter,
        callback: (payload) {
          _logger.info('Real-time event received for $table: ${payload.eventType}');
          streamController.add(payload);
        },
      );

      channel.subscribe();
      _channels[channelKey] = channel;

      return streamController.stream;

    } catch (e) {
      _logger.error('Failed to subscribe to $table: $e');
      throw SubscriptionException('Failed to subscribe to $table: $e');
    }
  }

  /// Subscribe to order updates for a specific user
  Stream<dynamic> subscribeToUserOrders(String userId) {
    return subscribeToTable(
      table: AppConstants.ordersTable,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      channelId: 'user_orders_$userId',
    );
  }

  /// Subscribe to cart changes for a specific user
  Stream<dynamic> subscribeToUserCart(String userId) {
    return subscribeToTable(
      table: AppConstants.cartItemsTable,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      channelId: 'user_cart_$userId',
    );
  }

  /// Subscribe to restaurant updates
  Stream<dynamic> subscribeToRestaurantUpdates(String restaurantId) {
    return subscribeToTable(
      table: AppConstants.restaurantsTable,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: restaurantId,
      ),
      channelId: 'restaurant_$restaurantId',
    );
  }

  /// Subscribe to notifications for a user
  Stream<dynamic> subscribeToUserNotifications(String userId) {
    return subscribeToTable(
      table: AppConstants.notificationsTable,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      channelId: 'user_notifications_$userId',
    );
  }

  /// Subscribe to live delivery tracking
  Stream<dynamic> subscribeToOrderTracking(String orderId) {
    return subscribeToTable(
      table: AppConstants.ordersTable,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: orderId,
      ),
      channelId: 'order_tracking_$orderId',
    );
  }

  /// Subscribe to favorite items changes
  Stream<dynamic> subscribeToUserFavorites(String userId) {
    return subscribeToTable(
      table: AppConstants.favoritesTable,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      channelId: 'user_favorites_$userId',
    );
  }

  /// Subscribe to reviews for a restaurant
  Stream<dynamic> subscribeToRestaurantReviews(String restaurantId) {
    return subscribeToTable(
      table: AppConstants.reviewsTable,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'restaurant_id',
        value: restaurantId,
      ),
      channelId: 'restaurant_reviews_$restaurantId',
    );
  }

  /// Subscribe to menu items for a restaurant
  Stream<dynamic> subscribeToRestaurantMenu(String restaurantId) {
    return subscribeToTable(
      table: AppConstants.menuItemsTable,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'restaurant_id',
        value: restaurantId,
      ),
      channelId: 'restaurant_menu_$restaurantId',
    );
  }

  /// Subscribe to nearby restaurants (location-based)
  Stream<dynamic> subscribeToNearbyRestaurants(double latitude, double longitude, double radius) {
    // This would require a PostgreSQL function or custom filtering
    return subscribeToTable(
      table: AppConstants.restaurantsTable,
      channelId: 'nearby_restaurants_${latitude}_$longitude',
    );
  }

  /// Subscribe to chat messages for a conversation
  Stream<dynamic> subscribeToMessages(String conversationId) {
    return subscribeToTable(
      table: 'messages',
      event: PostgresChangeEvent.insert,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'conversation_id',
        value: conversationId,
      ),
      channelId: 'conversation_messages_$conversationId',
    );
  }

  /// Subscribe to typing indicators for a conversation
  Stream<dynamic> subscribeToTypingIndicator(String conversationId) {
    return subscribeToTable(
      table: 'typing_indicators',
      event: PostgresChangeEvent.update,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'conversation_id',
        value: conversationId,
      ),
      channelId: 'conversation_typing_$conversationId',
    );
  }

  /// ==================== BROADCAST CHANNELS ====================

  /// Send broadcast message
  Future<void> broadcastEvent(String eventName, Map<String, dynamic> payload) async {
    try {
      final channel = _supabase.channel('broadcast_events');

      await channel.sendBroadcastMessage(
        event: 'system',
        payload: {'event': eventName, ...payload},
      );

      _logger.info('Broadcast event sent: $eventName');
      channel.subscribe();

    } catch (e) {
      _logger.error('Failed to broadcast event $eventName: $e');
      throw SubscriptionException('Failed to broadcast event: $e');
    }
  }

  /// Listen to broadcast events
  Stream<dynamic> listenToBroadcasts(String eventName) {
    final streamController = StreamController<dynamic>.broadcast();

    final channel = _supabase.channel('broadcast_listener');

    channel.onBroadcast(
      event: 'system',
      callback: (payload) {
        if (payload['event'] == eventName) {
          streamController.add(payload);
        }
      },
    );

    channel.subscribe();

    return streamController.stream;
  }

  /// ==================== PRESENCE TRACKING ====================

  /// Track user presence (online status)
  Future<void> trackUserPresence(String userId, Map<String, dynamic> status) async {
    try {
      final channel = _supabase.channel('presence_tracking');

      channel.subscribe();

      await channel.track(status);
      _logger.info('User presence tracking started for: $userId');

    } catch (e) {
      _logger.error('Failed to track presence for $userId: $e');
      throw SubscriptionException('Failed to track presence: $e');
    }
  }

  /// ==================== CHANNEL MANAGEMENT ====================

  /// Unsubscribe from a specific channel
  Future<void> unsubscribeFromChannel(String channelKey) async {
    try {
      final channel = _channels[channelKey];
      if (channel != null) {
        await _supabase.removeChannel(channel);
        _channels.remove(channelKey);
        _logger.info('Unsubscribed from channel: $channelKey');
      }

      final controller = _streamControllers[channelKey];
      if (controller != null) {
        await controller.close();
        _streamControllers.remove(channelKey);
      }
    } catch (e) {
      _logger.error('Failed to unsubscribe from $channelKey: $e');
    }
  }

  /// Unsubscribe from all channels
  Future<void> unsubscribeAll() async {
    _logger.info('Unsubscribing from all channels...');

    final channelKeys = _channels.keys.toList();
    for (final key in channelKeys) {
      await unsubscribeFromChannel(key);
    }

    _channels.clear();
    _streamControllers.clear();

    _logger.success('All channels unsubscribed');
  }

  /// Get active channel count
  int get activeChannelCount => _channels.length;

  /// Get list of active channels
  List<String> get activeChannels => _channels.keys.toList();

  /// Check if a channel is active
  bool isChannelActive(String channelKey) => _channels.containsKey(channelKey);

  /// ==================== UTILITY METHODS ====================

  /// Merge multiple streams into one
  Stream<T> _mergeStreams<T>(List<Stream<T>> streams) {
    final controller = StreamController<T>.broadcast();

    for (final stream in streams) {
      stream.listen(
        (data) => controller.add(data),
        onError: (error) => controller.addError(error),
      );
    }

    return controller.stream;
  }

  /// Dispose and clean up
  Future<void> dispose() async {
    _logger.info('Disposing RealtimeService...');
    await unsubscribeAll();
    _logger.success('RealtimeService disposed');
  }
}
