import 'package:dio/dio.dart';
import 'mock_categories.dart';
import 'mock_restaurants.dart';
import 'mock_menu.dart';
import 'mock_orders.dart';
import 'mock_addresses.dart';
import 'mock_payment_methods.dart';
import 'mock_notifications.dart';

/// Mock API Service to simulate API responses
class MockApiService {
  static const int _mockDelay = 500; // Simulate network delay in milliseconds

  /// Simulate GET request for categories
  static Future<Response> getCategories() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));
    return Response(
      data: {
        'categories': MockCategories.categories,
        'total': MockCategories.categories.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/categories'),
    );
  }

  /// Simulate GET request for featured restaurants
  static Future<Response> getFeaturedRestaurants() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));
    return Response(
      data: {
        'restaurants': MockRestaurants.featuredRestaurants,
        'total': MockRestaurants.featuredRestaurants.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/restaurants/featured'),
    );
  }

  /// Simulate GET request for all restaurants
  static Future<Response> getAllRestaurants() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));
    return Response(
      data: {
        'restaurants': MockRestaurants.restaurants,
        'total': MockRestaurants.restaurants.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/restaurants'),
    );
  }

  /// Simulate GET request for restaurant details
  static Future<Response> getRestaurantDetails(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final restaurants = MockRestaurants.restaurants.cast<Map<String, dynamic>>();
    Map<String, dynamic>? restaurant;

    try {
      restaurant = restaurants.firstWhere((r) => r['id'] == restaurantId);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/restaurants/$restaurantId'),
        response: Response(
          statusCode: 404,
          data: {'error': 'Restaurant not found'},
          requestOptions: RequestOptions(path: '/restaurants/$restaurantId'),
        ),
      );
    }

    return Response(
      data: {'restaurant': restaurant},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/restaurants/$restaurantId'),
    );
  }

  /// Simulate GET request for menu items
  static Future<Response> getMenuItems(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final menu = MockMenu.restaurantMenus[restaurantId] ?? [];

    return Response(
      data: {
        'items': menu,
        'categories': MockMenu.categories,
        'total': menu.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/restaurants/$restaurantId/menu'),
    );
  }

  /// Simulate GET request for menu items by category
  static Future<Response> getMenuItemsByCategory(String restaurantId, String categoryId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final menu = MockMenu.restaurantMenus[restaurantId] ?? [];
    final filteredItems = menu.where((item) => item['category'] == categoryId).toList();

    return Response(
      data: {'items': filteredItems},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/restaurants/$restaurantId/menu'),
    );
  }

  /// Simulate POST request for submitting review
  static Future<Response> submitReview(String restaurantId, Map<String, dynamic> reviewData) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final mockReview = {
      'id': 'review_${DateTime.now().millisecondsSinceEpoch}',
      'restaurantId': restaurantId,
      'userId': 'user_123',
      'userName': 'John Doe',
      'userAvatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      'rating': reviewData['rating'],
      'comment': reviewData['comment'],
      'images': reviewData['images'] ?? [],
      'helpful': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'isVerified': true,
    };

    return Response(
      data: {'review': mockReview},
      statusCode: 201,
      requestOptions: RequestOptions(path: '/restaurants/$restaurantId/reviews'),
    );
  }

  /// Simulate GET request for reviews
  static Future<Response> getReviews(String restaurantId, {int page = 1, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final mockReviews = [
      {
        'id': 'review_1',
        'restaurantId': restaurantId,
        'userId': 'user_1',
        'userName': 'Sarah Johnson',
        'userAvatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=100',
        'rating': 5.0,
        'comment': 'Amazing food and great service! The pizza was delicious and arrived hot.',
        'images': [],
        'helpful': 12,
        'createdAt': '2024-01-15T10:30:00Z',
        'isVerified': true,
      },
      {
        'id': 'review_2',
        'restaurantId': restaurantId,
        'userId': 'user_2',
        'userName': 'Mike Chen',
        'userAvatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        'rating': 4.5,
        'comment': 'Great value for money. Food was fresh and delivery was quick.',
        'images': [],
        'helpful': 8,
        'createdAt': '2024-01-12T14:20:00Z',
        'isVerified': true,
      },
      {
        'id': 'review_3',
        'restaurantId': restaurantId,
        'userId': 'user_3',
        'userName': 'Emma Davis',
        'userAvatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
        'rating': 4.0,
        'comment': 'Good food but delivery took longer than expected.',
        'images': [],
        'helpful': 5,
        'createdAt': '2024-01-10T18:45:00Z',
        'isVerified': true,
      },
    ];

    return Response(
      data: {
        'reviews': mockReviews,
        'total': mockReviews.length,
        'page': page,
        'limit': limit,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/restaurants/$restaurantId/reviews'),
    );
  }

  /// Simulate POST request for marking review helpful
  static Future<Response> markReviewHelpful(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    return Response(
      statusCode: 200,
      requestOptions: RequestOptions(path: '/reviews/$reviewId/helpful'),
    );
  }

  // ========== Orders API ==========

  /// Get all orders for a user
  static Future<Response> getOrders({String? status}) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final orders = status != null
        ? MockOrders.getOrdersByStatus(status)
        : MockOrders.orders;

    return Response(
      data: {
        'orders': orders,
        'total': orders.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/orders'),
    );
  }

  /// Get active orders
  static Future<Response> getActiveOrders() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final orders = MockOrders.getActiveOrders();

    return Response(
      data: {
        'orders': orders,
        'total': orders.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/orders/active'),
    );
  }

  /// Get order history
  static Future<Response> getOrderHistory() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final orders = MockOrders.getOrderHistory();

    return Response(
      data: {
        'orders': orders,
        'total': orders.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/orders/history'),
    );
  }

  /// Get order by ID
  static Future<Response> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final order = MockOrders.getOrderById(orderId);

    if (order == null) {
      throw DioException(
        requestOptions: RequestOptions(path: '/orders/$orderId'),
        response: Response(
          statusCode: 404,
          data: {'error': 'Order not found'},
          requestOptions: RequestOptions(path: '/orders/$orderId'),
        ),
      );
    }

    return Response(
      data: {'order': order},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/orders/$orderId'),
    );
  }

  /// Cancel order
  static Future<Response> cancelOrder(String orderId, String reason) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    return Response(
      data: {'message': 'Order cancelled successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/orders/$orderId/cancel'),
    );
  }

  // ========== Addresses API ==========

  /// Get all addresses for a user
  static Future<Response> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    return Response(
      data: {
        'addresses': MockAddresses.addresses,
        'total': MockAddresses.addresses.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/addresses'),
    );
  }

  /// Get address by ID
  static Future<Response> getAddressById(String addressId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final address = MockAddresses.getAddressById(addressId);

    if (address == null) {
      throw DioException(
        requestOptions: RequestOptions(path: '/addresses/$addressId'),
        response: Response(
          statusCode: 404,
          data: {'error': 'Address not found'},
          requestOptions: RequestOptions(path: '/addresses/$addressId'),
        ),
      );
    }

    return Response(
      data: {'address': address},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/addresses/$addressId'),
    );
  }

  /// Add new address
  static Future<Response> addAddress(Map<String, dynamic> addressData) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final newAddress = MockAddresses.addAddress(addressData);

    return Response(
      data: {'address': newAddress},
      statusCode: 201,
      requestOptions: RequestOptions(path: '/addresses'),
    );
  }

  /// Update address
  static Future<Response> updateAddress(
      String addressId, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final updatedAddress = MockAddresses.updateAddress(addressId, updates);

    if (updatedAddress == null) {
      throw DioException(
        requestOptions: RequestOptions(path: '/addresses/$addressId'),
        response: Response(
          statusCode: 404,
          data: {'error': 'Address not found'},
          requestOptions: RequestOptions(path: '/addresses/$addressId'),
        ),
      );
    }

    return Response(
      data: {'address': updatedAddress},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/addresses/$addressId'),
    );
  }

  /// Delete address
  static Future<Response> deleteAddress(String addressId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final success = MockAddresses.deleteAddress(addressId);

    if (!success) {
      throw DioException(
        requestOptions: RequestOptions(path: '/addresses/$addressId'),
        response: Response(
          statusCode: 404,
          data: {'error': 'Address not found'},
          requestOptions: RequestOptions(path: '/addresses/$addressId'),
        ),
      );
    }

    return Response(
      data: {'message': 'Address deleted successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/addresses/$addressId'),
    );
  }

  // ========== Payment Methods API ==========

  /// Get all payment methods for a user
  static Future<Response> getPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    return Response(
      data: {
        'paymentMethods': MockPaymentMethods.paymentMethods,
        'total': MockPaymentMethods.paymentMethods.length,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/payment-methods'),
    );
  }

  /// Add new payment method
  static Future<Response> addPaymentMethod(
      Map<String, dynamic> paymentData) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final newPaymentMethod = MockPaymentMethods.addPaymentMethod(paymentData);

    return Response(
      data: {'paymentMethod': newPaymentMethod},
      statusCode: 201,
      requestOptions: RequestOptions(path: '/payment-methods'),
    );
  }

  /// Delete payment method
  static Future<Response> deletePaymentMethod(String paymentMethodId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final success = MockPaymentMethods.deletePaymentMethod(paymentMethodId);

    if (!success) {
      throw DioException(
        requestOptions: RequestOptions(path: '/payment-methods/$paymentMethodId'),
        response: Response(
          statusCode: 404,
          data: {'error': 'Payment method not found'},
          requestOptions: RequestOptions(path: '/payment-methods/$paymentMethodId'),
        ),
      );
    }

    return Response(
      data: {'message': 'Payment method deleted successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/payment-methods/$paymentMethodId'),
    );
  }

  // ========== Notifications API ==========

  /// Get all notifications
  static Future<Response> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    return Response(
      data: {
        'notifications': MockNotifications.notifications,
        'total': MockNotifications.notifications.length,
        'unreadCount': MockNotifications.getUnreadCount(),
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/notifications'),
    );
  }

  /// Mark notification as read
  static Future<Response> markNotificationAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final success = MockNotifications.markAsRead(notificationId);

    if (!success) {
      throw DioException(
        requestOptions: RequestOptions(path: '/notifications/$notificationId/read'),
        response: Response(
          statusCode: 404,
          data: {'error': 'Notification not found'},
          requestOptions: RequestOptions(path: '/notifications/$notificationId/read'),
        ),
      );
    }

    return Response(
      data: {'message': 'Notification marked as read'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/notifications/$notificationId/read'),
    );
  }

  /// Mark all notifications as read
  static Future<Response> markAllNotificationsAsRead() async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    MockNotifications.markAllAsRead();

    return Response(
      data: {'message': 'All notifications marked as read'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/notifications/read-all'),
    );
  }

  /// Delete notification
  static Future<Response> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    final success = MockNotifications.deleteNotification(notificationId);

    if (!success) {
      throw DioException(
        requestOptions: RequestOptions(path: '/notifications/$notificationId'),
        response: Response(
          statusCode: 404,
          data: {'error': 'Notification not found'},
          requestOptions: RequestOptions(path: '/notifications/$notificationId'),
        ),
      );
    }

    return Response(
      data: {'message': 'Notification deleted successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/notifications/$notificationId'),
    );
  }

  // ========== Search API ==========

  /// Search restaurants and menu items
  static Future<Response> search(String query) async {
    await Future.delayed(const Duration(milliseconds: _mockDelay));

    // Search restaurants
    final restaurants = MockRestaurants.restaurants
        .where((r) => (r['name'] as String)
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    // Search menu items across all restaurants
    final menuItems = <Map<String, dynamic>>[];
    MockMenu.restaurantMenus.forEach((restaurantId, menu) {
      final filteredItems = menu
          .where((item) =>
              (item['name'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (item['description'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .map((item) => {
                ...item,
                'restaurantId': restaurantId,
              })
          .toList();
      menuItems.addAll(filteredItems);
    });

    return Response(
      data: {
        'restaurants': restaurants,
        'menuItems': menuItems,
        'query': query,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: '/search'),
    );
  }
}
