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
    RealtimeChangeEvent event = RealtimeChangeEvent.all,
    String? filter,
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
      final eventFilter = PostgresChanges(
        event: event,
        schema: 'public',
        table: table,
        filter: filter,
      );
      
      channel.onPostgresChanges(
        [eventFilter],
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
    final filter = 'user_id=eq.$userId';
    return subscribeToTable(
      table: AppConstants.ordersTable,
      filter: filter,
      channelId: 'user_orders_$userId',
    );
  }

  /// Subscribe to cart changes for a specific user
  Stream<dynamic> subscribeToUserCart(String userId) {
    // Subscribe to cart table
    final cartFilter = 'user_id=eq.$userId';
    final cartStream = subscribeToTable(
      table: AppConstants.cartTable,
      filter: cartFilter,
      channelId: 'user_cart_$userId',
    );
    
    // Also subscribe to cart_items table
    final cartItemsFilter = 'user_id=eq.$userId';
    final cartItemsStream = subscribeToTable(
      table: AppConstants.cartItemsTable,
      filter: cartItemsFilter,
      channelId: 'user_cart_items_$userId',
    );
    
    return _mergeStreams([cartStream, cartItemsStream]);
  }

  /// Subscribe to restaurant updates
  Stream<dynamic> subscribeToRestaurantUpdates(String restaurantId) {
    final filter = 'id=eq.$restaurantId';
    return subscribeToTable(
      table: AppConstants.restaurantsTable,
      filter: filter,
      channelId: 'restaurant_$restaurantId',
    );
  }

  /// Subscribe to notifications for a user
  Stream<dynamic> subscribeToUserNotifications(String userId) {
    final filter = 'user_id=eq.$userId&read=eq.false';
    return subscribeToTable(
      table: AppConstants.notificationsTable,
      filter: filter,
      channelId: 'user_notifications_$userId',
    );
  }

  /// Subscribe to live delivery tracking
  Stream<dynamic> subscribeToOrderTracking(String orderId) {
    final filter = 'id=eq.$orderId';
    return subscribeToTable(
      table: AppConstants.ordersTable,
      filter: filter,
      channelId: 'order_tracking_$orderId',
    );
  }

  /// Subscribe to favorite items changes
  Stream<dynamic> subscribeToUserFavorites(String userId) {
    final filter = 'user_id=eq.$userId';
    return subscribeToTable(
      table: AppConstants.favoritesTable,
      filter: filter,
      channelId: 'user_favorites_$userId',
    );
  }

  /// Subscribe to reviews for a restaurant
  Stream<dynamic> subscribeToRestaurantReviews(String restaurantId) {
    final filter = 'restaurant_id=eq.$restaurantId';
    return subscribeToTable(
      table: AppConstants.reviewsTable,
      filter: filter,
      channelId: 'restaurant_reviews_$restaurantId',
    );
  }

  /// Subscribe to menu items for a restaurant
  Stream<dynamic> subscribeToRestaurantMenu(String restaurantId) {
    final filter = 'restaurant_id=eq.$restaurantId';
    return subscribeToTable(
      table: AppConstants.menuItemsTable,
      filter: filter,
      channelId: 'restaurant_menu_$restaurantId',
    );
  }

  /// Subscribe to nearby restaurants (location-based)
  Stream<dynamic> subscribeToNearbyRestaurants(double latitude, double longitude, double radius) {
    // This would require a PostgreSQL function
    return subscribeToTable(
      table: AppConstants.restaurantsTable,
      channelId: 'nearby_restaurants_${latitude}_${longitude}',
    );
  }

  /// ==================== BROADCAST CHANNELS ====================

  /// Send broadcast event to all connected devices
  Future<void> broadcastEvent(String eventName, Map<String, dynamic> payload) async {
    try {
      final channel = _supabase.channel('broadcast_events');
      await channel.sendBroadcastEvent('system', {'event': eventName, ...payload});
      _logger.info('Broadcast event sent: $eventName');
      
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
      'system',
      (payload) {
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
  void trackUserPresence(String userId, Map<String, dynamic> status) {
    final channel = _supabase.channel('presence_tracking');
    
    channel.onChannelSubscribeStateChange((realtimeSubscriptionStatus, reason) {
      if (realtimeSubscriptionStatus == RealtimeSubscriptionStatus.subscribed) {
        channel.track(userId, status);
        _logger.info('User presence tracking started for: $userId');
      }
    });
    
    channel.subscribe();
  }

  /// Listen to user presence changes
  Stream<Map<String, dynamic>> listenToPresenceChanges(List<String> userIds) {
    final streamController = StreamController<Map<String, dynamic>>.broadcast();
    
    final channel = _supabase.channel('presence_listener');
    channel.onPresence((presence) {
      for (final userId in userIds) {
        if (presence.joins.containsKey(userId)) {
          streamController.add({
            'user_id': userId,
            'status': presence.joins[userId],
            'event': 'online',
          });
        }
        
        if (presence.leaves.containsKey(userId)) {
          streamController.add({
            'user_id': userId,
            'status': presence.leaves[userId],
            'event': 'offline',
          });
        }
      }
    });
    
    channel.subscribe();
    
    return streamController.stream;
  }

  /// ==================== UTILITY METHODS ====================

  /// Unsubscribe from a specific channel
  void unsubscribeFromChannel(String channelId) {
    if (_channels.containsKey(channelId)) {
      _channels[channelKey]?.unsubscribe();
      _channels.remove(channelId);
      
      if (_streamControllers.containsKey(channelId)) {
        _streamControllers[channelId]?.close();
        _streamControllers.remove(channelId);
      }
      
      _logger.info('Unsubscribed from channel: $channelId');
    }
  }

  /// Unsubscribe from all channels
  void unsubscribeFromAll() {
    for (final channelId in _channels.keys) {
      unsubscribeFromChannel(channelId);
    }
    
    _supabase.removeAllChannels();
    _logger.info('Unsubscribed from all channels');
  }

  /// Get list of active subscriptions
  List<String> getActiveSubscriptions() {
    return _channels.keys.toList();
  }

  /// Check if subscription is active
  bool isSubscribed(String channelId) {
    return _channels.containsKey(channelId);
  }

  /// Resubscribe to all channels after reconnection
  Future<void> resubscribeAll() async {
    final activeSubscriptions = getActiveSubscriptions();
    
    // Store subscription details to resubscribe
    // This would require storing subscription parameters
    
    _logger.info('Resubscribing to ${activeSubscriptions.length} channels');
    
    for (final channelId in activeSubscriptions) {
      // Implementation would depend on stored subscription details
      unsubscribeFromChannel(channelId);
    }
  }

  /// ==================== REAL-TIME EVENTS HANDLING ====================

  /// Handle order status updates
  Stream<Map<String, dynamic>> handleOrderStatusUpdates(String userId) {
    return subscribeToUserOrders(userId).map((payload) {
      if (payload.eventType == RealtimeChangeEvent.update) {
        final order = payload.newRecord;
        return {
          'type': 'order_status_update',
          'order_id': order['id'],
          'status': order['status'],
          'updated_at': order['updated_at'],
          'data': order,
        };
      }
      return null;
    }).where((event) => event != null).cast<Map<String, dynamic>>();
  }

  /// Handle new notifications
  Stream<Map<String, dynamic>> handleNewNotifications(String userId) {
    return subscribeToUserNotifications(userId).map((payload) {
      if (payload.eventType == RealtimeChangeEvent.insert) {
        final notification = payload.newRecord;
        return {
          'type': 'new_notification',
          'notification_id': notification['id'],
          'title': notification['title'],
          'body': notification['body'],
          'data': notification,
        };
      }
      return null;
    }).where((event) => event != null).cast<Map<String, dynamic>>();
  }

  /// Handle delivery location updates
  Stream<Map<String, dynamic>> handleDeliveryTracking(String orderId) {
    return subscribeToOrderTracking(orderId).map((payload) {
      if (payload.eventType == RealtimeChangeEvent.update) {
        final order = payload.newRecord;
        return {
          'type': 'delivery_location_update',
          'order_id': order['id'],
          'latitude': order['delivery_latitude'],
          'longitude': order['delivery_longitude'],
          'estimated_time': order['estimated_delivery_time'],
          'status': order['delivery_status'],
          'data': order,
        };
      }
      return null;
    }).where((event) => event != null).cast<Map<String, dynamic>>();
  }

  /// Handle restaurant availability changes
  Stream<Map<String, dynamic>> handleRestaurantAvailability(String restaurantId) {
    return subscribeToRestaurantUpdates(restaurantId).map((payload) {
      if (payload.eventType == RealtimeChangeEvent.update) {
        final restaurant = payload.newRecord;
        return {
          'type': 'restaurant_availability_update',
          'restaurant_id': restaurant['id'],
          'is_available': restaurant['is_available'],
          'open_status': restaurant['open_status'],
          'data': restaurant,
        };
      }
      return null;
    }).where((event) => event != null).cast<Map<String, dynamic>>();
  }

  /// ==================== STREAM UTILITIES ====================

  /// Merge multiple streams
  Stream<dynamic> _mergeStreams(List<Stream<dynamic>> streams) {
    return StreamGroup.merge(streams);
  }

  /// Debounce stream events
  Stream<T> debounceStream<T>(Stream<T> stream, Duration duration) {
    return stream.transform(StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) {
        Timer(duration, () => sink.add(data));
      },
    ));
  }

  /// Throttle stream events
  Stream<T> throttleStream<T>(Stream<T> stream, Duration duration) {
    return stream.transform(
      ThrottleStreamTransformer<T>(
        () => TimerStream(null, duration),
        trailing: true,
      ),
    );
  }

  /// Filter stream by specific event type
  Stream<T> filterStreamByType<T, K>(
    Stream<T> stream,
    String eventType,
    K Function(T) extractor,
  ) {
    return stream.where((event) =>
        event is Map && event.containsKey('type') && event['type'] == eventType
    ).map((event) => extractor(event as T));
  }

  /// Clean up resources
  void dispose() {
    unsubscribeFromAll();
    
    for (final controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
    
    _logger.info('Realtime service disposed');
  }
}

/// Extension for StreamGroup
extension StreamGroupExtensions on Stream<dynamic> {
  static Stream<dynamic> merge(List<Stream<dynamic>> streams) {
    return StreamGroup<dynamic>(StreamController<dynamic>.broadcast());
  }
}
