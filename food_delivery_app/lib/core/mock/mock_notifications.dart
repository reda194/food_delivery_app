/// Mock notifications data for food delivery app
class MockNotifications {
  static final List<Map<String, dynamic>> notifications = [
    {
      'id': 'notif_1',
      'userId': 'user_123',
      'type': 'order_delivered',
      'title': 'Order Delivered',
      'message': 'Your order #FD1234 has been delivered successfully!',
      'data': {
        'orderId': 'order_1',
        'orderNumber': '#FD1234',
      },
      'imageUrl': 'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?w=300',
      'isRead': false,
      'createdAt': '2024-01-15T10:50:00Z',
    },
    {
      'id': 'notif_2',
      'userId': 'user_123',
      'type': 'order_on_the_way',
      'title': 'Order On The Way',
      'message': 'Your order #FD1235 is on the way. Driver Sarah will deliver in 15 mins.',
      'data': {
        'orderId': 'order_2',
        'orderNumber': '#FD1235',
        'driverId': 'driver_2',
        'driverName': 'Sarah Johnson',
      },
      'imageUrl': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=300',
      'isRead': false,
      'createdAt': '2024-01-16T14:30:00Z',
    },
    {
      'id': 'notif_3',
      'userId': 'user_123',
      'type': 'order_preparing',
      'title': 'Order Being Prepared',
      'message': 'Your order #FD1236 is being prepared at Sushi Bar.',
      'data': {
        'orderId': 'order_3',
        'orderNumber': '#FD1236',
        'restaurantId': '3',
        'restaurantName': 'Sushi Bar',
      },
      'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300',
      'isRead': true,
      'createdAt': '2024-01-16T15:10:00Z',
    },
    {
      'id': 'notif_4',
      'userId': 'user_123',
      'type': 'promo',
      'title': '50% Off Your Next Order',
      'message': 'Use code WELCOME50 to get 50% off on your next order. Valid for 7 days!',
      'data': {
        'promoCode': 'WELCOME50',
        'discount': 50,
        'expiryDate': '2024-01-23T23:59:59Z',
      },
      'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300',
      'isRead': true,
      'createdAt': '2024-01-14T09:00:00Z',
    },
    {
      'id': 'notif_5',
      'userId': 'user_123',
      'type': 'order_confirmed',
      'title': 'Order Confirmed',
      'message': 'Pizza Palace confirmed your order #FD1234. Estimated delivery: 35 mins.',
      'data': {
        'orderId': 'order_1',
        'orderNumber': '#FD1234',
        'restaurantId': '1',
        'restaurantName': 'Pizza Palace',
        'estimatedTime': 35,
      },
      'imageUrl': 'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?w=300',
      'isRead': true,
      'createdAt': '2024-01-15T10:05:00Z',
    },
    {
      'id': 'notif_6',
      'userId': 'user_123',
      'type': 'restaurant_favorite',
      'title': 'Your Favorite Restaurant',
      'message': 'Pizza Palace added new items to their menu. Check them out now!',
      'data': {
        'restaurantId': '1',
        'restaurantName': 'Pizza Palace',
      },
      'imageUrl': 'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?w=300',
      'isRead': true,
      'createdAt': '2024-01-13T16:30:00Z',
    },
    {
      'id': 'notif_7',
      'userId': 'user_123',
      'type': 'order_cancelled',
      'title': 'Order Cancelled',
      'message': 'Your order #FD1230 has been cancelled. Refund will be processed in 3-5 days.',
      'data': {
        'orderId': 'order_4',
        'orderNumber': '#FD1230',
        'refundAmount': 22.66,
      },
      'imageUrl': null,
      'isRead': true,
      'createdAt': '2024-01-14T18:10:00Z',
    },
    {
      'id': 'notif_8',
      'userId': 'user_123',
      'type': 'system',
      'title': 'Welcome to Food Delivery',
      'message': 'Start ordering your favorite food from thousands of restaurants nearby!',
      'data': {},
      'imageUrl': null,
      'isRead': true,
      'createdAt': '2024-01-01T00:00:00Z',
    },
  ];

  /// Get unread notification count
  static int getUnreadCount() {
    return notifications.where((notif) => notif['isRead'] == false).length;
  }

  /// Get unread notifications
  static List<Map<String, dynamic>> getUnreadNotifications() {
    return notifications
        .where((notif) => notif['isRead'] == false)
        .toList();
  }

  /// Mark notification as read
  static bool markAsRead(String notificationId) {
    try {
      final index =
          notifications.indexWhere((notif) => notif['id'] == notificationId);
      if (index != -1) {
        notifications[index]['isRead'] = true;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Mark all notifications as read
  static void markAllAsRead() {
    for (var notif in notifications) {
      notif['isRead'] = true;
    }
  }

  /// Delete notification
  static bool deleteNotification(String notificationId) {
    try {
      notifications.removeWhere((notif) => notif['id'] == notificationId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear all notifications
  static void clearAll() {
    notifications.clear();
  }

  /// Get notification icon based on type
  static String getNotificationIcon(String type) {
    switch (type) {
      case 'order_placed':
        return 'receipt';
      case 'order_confirmed':
        return 'check_circle';
      case 'order_preparing':
        return 'restaurant';
      case 'order_ready':
        return 'done_all';
      case 'order_picked_up':
        return 'local_shipping';
      case 'order_on_the_way':
        return 'two_wheeler';
      case 'order_delivered':
        return 'check_circle_outline';
      case 'order_cancelled':
        return 'cancel';
      case 'promo':
        return 'local_offer';
      case 'restaurant_favorite':
        return 'favorite';
      case 'system':
        return 'info';
      default:
        return 'notifications';
    }
  }

  /// Get notification color based on type
  static int getNotificationColor(String type) {
    switch (type) {
      case 'order_placed':
        return 0xFF2196F3; // Blue
      case 'order_confirmed':
        return 0xFF4CAF50; // Green
      case 'order_preparing':
        return 0xFFFF9800; // Orange
      case 'order_ready':
        return 0xFF9C27B0; // Purple
      case 'order_picked_up':
        return 0xFF00BCD4; // Cyan
      case 'order_on_the_way':
        return 0xFF3F51B5; // Indigo
      case 'order_delivered':
        return 0xFF4CAF50; // Green
      case 'order_cancelled':
        return 0xFFF44336; // Red
      case 'promo':
        return 0xFFFF5722; // Deep Orange
      case 'restaurant_favorite':
        return 0xFFE91E63; // Pink
      case 'system':
        return 0xFF607D8B; // Blue Grey
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Add new notification
  static Map<String, dynamic> addNotification(Map<String, dynamic> notifData) {
    final newNotification = {
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
      'userId': 'user_123',
      ...notifData,
      'isRead': false,
      'createdAt': DateTime.now().toIso8601String(),
    };
    notifications.insert(0, newNotification);
    return newNotification;
  }

  /// Get notifications by type
  static List<Map<String, dynamic>> getNotificationsByType(String type) {
    return notifications.where((notif) => notif['type'] == type).toList();
  }

  /// Get recent notifications (last 7 days)
  static List<Map<String, dynamic>> getRecentNotifications() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return notifications.where((notif) {
      final createdAt = DateTime.parse(notif['createdAt'] as String);
      return createdAt.isAfter(sevenDaysAgo);
    }).toList();
  }
}
