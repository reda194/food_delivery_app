/// Mock orders data for food delivery app
class MockOrders {
  static final List<Map<String, dynamic>> orders = [
    {
      'id': 'order_1',
      'userId': 'user_123',
      'restaurantId': '1',
      'restaurantName': 'Pizza Palace',
      'restaurantImage': 'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?w=300',
      'orderNumber': '#FD1234',
      'status': 'delivered',
      'statusHistory': [
        {
          'status': 'placed',
          'timestamp': '2024-01-15T10:00:00Z',
          'description': 'Order placed successfully',
        },
        {
          'status': 'confirmed',
          'timestamp': '2024-01-15T10:05:00Z',
          'description': 'Restaurant confirmed your order',
        },
        {
          'status': 'preparing',
          'timestamp': '2024-01-15T10:10:00Z',
          'description': 'Your food is being prepared',
        },
        {
          'status': 'ready',
          'timestamp': '2024-01-15T10:25:00Z',
          'description': 'Order is ready for pickup',
        },
        {
          'status': 'picked_up',
          'timestamp': '2024-01-15T10:30:00Z',
          'description': 'Driver picked up your order',
        },
        {
          'status': 'on_the_way',
          'timestamp': '2024-01-15T10:35:00Z',
          'description': 'On the way to your location',
        },
        {
          'status': 'delivered',
          'timestamp': '2024-01-15T10:50:00Z',
          'description': 'Order delivered successfully',
        },
      ],
      'items': [
        {
          'id': '1',
          'menuItemId': '1',
          'name': 'Margherita Pizza',
          'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300',
          'price': 14.99,
          'quantity': 2,
          'specialInstructions': 'Extra cheese please',
        },
        {
          'id': '2',
          'menuItemId': '6',
          'name': 'Garlic Bread',
          'image': 'https://images.unsplash.com/photo-1573140401552-3fab0b2436f1?w=300',
          'price': 5.99,
          'quantity': 1,
          'specialInstructions': '',
        },
      ],
      'subtotal': 35.97,
      'deliveryFee': 2.99,
      'serviceFee': 1.50,
      'discount': 5.00,
      'tax': 2.85,
      'totalAmount': 38.31,
      'paymentMethod': {
        'type': 'credit_card',
        'last4': '4242',
        'brand': 'Visa',
      },
      'deliveryAddress': {
        'id': 'addr_1',
        'label': 'Home',
        'street': '123 Main Street',
        'city': 'San Francisco',
        'state': 'CA',
        'zipCode': '94102',
        'country': 'USA',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'instructions': 'Ring the doorbell',
      },
      'driver': {
        'id': 'driver_1',
        'name': 'John Smith',
        'phone': '+1234567890',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        'rating': 4.8,
        'vehicleType': 'Motorcycle',
        'vehicleNumber': 'ABC-123',
        'currentLocation': {
          'latitude': 37.7749,
          'longitude': -122.4194,
        },
      },
      'estimatedDeliveryTime': '2024-01-15T10:45:00Z',
      'actualDeliveryTime': '2024-01-15T10:50:00Z',
      'placedAt': '2024-01-15T10:00:00Z',
      'deliveredAt': '2024-01-15T10:50:00Z',
      'canCancel': false,
      'canReorder': true,
      'canReview': true,
      'isReviewed': false,
    },
    {
      'id': 'order_2',
      'userId': 'user_123',
      'restaurantId': '2',
      'restaurantName': 'Burger Hub',
      'restaurantImage': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=300',
      'orderNumber': '#FD1235',
      'status': 'on_the_way',
      'statusHistory': [
        {
          'status': 'placed',
          'timestamp': '2024-01-16T14:00:00Z',
          'description': 'Order placed successfully',
        },
        {
          'status': 'confirmed',
          'timestamp': '2024-01-16T14:03:00Z',
          'description': 'Restaurant confirmed your order',
        },
        {
          'status': 'preparing',
          'timestamp': '2024-01-16T14:08:00Z',
          'description': 'Your food is being prepared',
        },
        {
          'status': 'ready',
          'timestamp': '2024-01-16T14:20:00Z',
          'description': 'Order is ready for pickup',
        },
        {
          'status': 'picked_up',
          'timestamp': '2024-01-16T14:25:00Z',
          'description': 'Driver picked up your order',
        },
        {
          'status': 'on_the_way',
          'timestamp': '2024-01-16T14:30:00Z',
          'description': 'On the way to your location',
        },
      ],
      'items': [
        {
          'id': '1',
          'menuItemId': '7',
          'name': 'Classic Burger',
          'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300',
          'price': 12.99,
          'quantity': 2,
          'specialInstructions': 'No onions',
        },
        {
          'id': '2',
          'menuItemId': '8',
          'name': 'French Fries',
          'image': 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=300',
          'price': 4.99,
          'quantity': 2,
          'specialInstructions': 'Extra crispy',
        },
      ],
      'subtotal': 35.96,
      'deliveryFee': 2.99,
      'serviceFee': 1.50,
      'discount': 0.00,
      'tax': 3.12,
      'totalAmount': 43.57,
      'paymentMethod': {
        'type': 'credit_card',
        'last4': '5555',
        'brand': 'Mastercard',
      },
      'deliveryAddress': {
        'id': 'addr_1',
        'label': 'Home',
        'street': '123 Main Street',
        'city': 'San Francisco',
        'state': 'CA',
        'zipCode': '94102',
        'country': 'USA',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'instructions': 'Ring the doorbell',
      },
      'driver': {
        'id': 'driver_2',
        'name': 'Sarah Johnson',
        'phone': '+1234567891',
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=100',
        'rating': 4.9,
        'vehicleType': 'Car',
        'vehicleNumber': 'XYZ-789',
        'currentLocation': {
          'latitude': 37.7750,
          'longitude': -122.4195,
        },
      },
      'estimatedDeliveryTime': '2024-01-16T14:50:00Z',
      'actualDeliveryTime': null,
      'placedAt': '2024-01-16T14:00:00Z',
      'deliveredAt': null,
      'canCancel': false,
      'canReorder': false,
      'canReview': false,
      'isReviewed': false,
    },
    {
      'id': 'order_3',
      'userId': 'user_123',
      'restaurantId': '3',
      'restaurantName': 'Sushi Bar',
      'restaurantImage': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300',
      'orderNumber': '#FD1236',
      'status': 'preparing',
      'statusHistory': [
        {
          'status': 'placed',
          'timestamp': '2024-01-16T15:00:00Z',
          'description': 'Order placed successfully',
        },
        {
          'status': 'confirmed',
          'timestamp': '2024-01-16T15:05:00Z',
          'description': 'Restaurant confirmed your order',
        },
        {
          'status': 'preparing',
          'timestamp': '2024-01-16T15:10:00Z',
          'description': 'Your food is being prepared',
        },
      ],
      'items': [
        {
          'id': '1',
          'menuItemId': '9',
          'name': 'California Roll',
          'image': 'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?w=300',
          'price': 10.99,
          'quantity': 2,
          'specialInstructions': '',
        },
        {
          'id': '2',
          'menuItemId': '10',
          'name': 'Salmon Nigiri',
          'image': 'https://images.unsplash.com/photo-1564489563-81ec5bb4489e?w=300',
          'price': 8.99,
          'quantity': 3,
          'specialInstructions': 'Fresh wasabi',
        },
      ],
      'subtotal': 48.95,
      'deliveryFee': 3.99,
      'serviceFee': 1.75,
      'discount': 10.00,
      'tax': 3.57,
      'totalAmount': 48.26,
      'paymentMethod': {
        'type': 'debit_card',
        'last4': '6789',
        'brand': 'Visa',
      },
      'deliveryAddress': {
        'id': 'addr_2',
        'label': 'Office',
        'street': '456 Tech Street',
        'city': 'San Francisco',
        'state': 'CA',
        'zipCode': '94105',
        'country': 'USA',
        'latitude': 37.7891,
        'longitude': -122.4012,
        'instructions': 'Call when you arrive',
      },
      'driver': null,
      'estimatedDeliveryTime': '2024-01-16T15:45:00Z',
      'actualDeliveryTime': null,
      'placedAt': '2024-01-16T15:00:00Z',
      'deliveredAt': null,
      'canCancel': true,
      'canReorder': false,
      'canReview': false,
      'isReviewed': false,
    },
    {
      'id': 'order_4',
      'userId': 'user_123',
      'restaurantId': '1',
      'restaurantName': 'Pizza Palace',
      'restaurantImage': 'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?w=300',
      'orderNumber': '#FD1230',
      'status': 'cancelled',
      'statusHistory': [
        {
          'status': 'placed',
          'timestamp': '2024-01-14T18:00:00Z',
          'description': 'Order placed successfully',
        },
        {
          'status': 'confirmed',
          'timestamp': '2024-01-14T18:05:00Z',
          'description': 'Restaurant confirmed your order',
        },
        {
          'status': 'cancelled',
          'timestamp': '2024-01-14T18:10:00Z',
          'description': 'Order cancelled by customer',
        },
      ],
      'items': [
        {
          'id': '1',
          'menuItemId': '2',
          'name': 'Pepperoni Pizza',
          'image': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=300',
          'price': 16.99,
          'quantity': 1,
          'specialInstructions': '',
        },
      ],
      'subtotal': 16.99,
      'deliveryFee': 2.99,
      'serviceFee': 1.00,
      'discount': 0.00,
      'tax': 1.68,
      'totalAmount': 22.66,
      'paymentMethod': {
        'type': 'credit_card',
        'last4': '4242',
        'brand': 'Visa',
      },
      'deliveryAddress': {
        'id': 'addr_1',
        'label': 'Home',
        'street': '123 Main Street',
        'city': 'San Francisco',
        'state': 'CA',
        'zipCode': '94102',
        'country': 'USA',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'instructions': 'Ring the doorbell',
      },
      'driver': null,
      'estimatedDeliveryTime': null,
      'actualDeliveryTime': null,
      'placedAt': '2024-01-14T18:00:00Z',
      'deliveredAt': null,
      'cancelledAt': '2024-01-14T18:10:00Z',
      'cancelReason': 'Changed my mind',
      'canCancel': false,
      'canReorder': true,
      'canReview': false,
      'isReviewed': false,
    },
  ];

  /// Get orders by status
  static List<Map<String, dynamic>> getOrdersByStatus(String status) {
    return orders.where((order) => order['status'] == status).toList();
  }

  /// Get active orders (not delivered or cancelled)
  static List<Map<String, dynamic>> getActiveOrders() {
    return orders
        .where((order) =>
            order['status'] != 'delivered' &&
            order['status'] != 'cancelled')
        .toList();
  }

  /// Get order history (delivered or cancelled)
  static List<Map<String, dynamic>> getOrderHistory() {
    return orders
        .where((order) =>
            order['status'] == 'delivered' || order['status'] == 'cancelled')
        .toList();
  }

  /// Get order by ID
  static Map<String, dynamic>? getOrderById(String orderId) {
    try {
      return orders.firstWhere((order) => order['id'] == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Order status display info
  static Map<String, dynamic> getStatusInfo(String status) {
    final statusMap = {
      'placed': {
        'label': 'Order Placed',
        'description': 'Your order has been placed successfully',
        'icon': 'receipt',
        'color': 0xFF2196F3,
      },
      'confirmed': {
        'label': 'Confirmed',
        'description': 'Restaurant confirmed your order',
        'icon': 'check_circle',
        'color': 0xFF4CAF50,
      },
      'preparing': {
        'label': 'Preparing',
        'description': 'Your food is being prepared',
        'icon': 'restaurant',
        'color': 0xFFFF9800,
      },
      'ready': {
        'label': 'Ready',
        'description': 'Order is ready for pickup',
        'icon': 'done_all',
        'color': 0xFF9C27B0,
      },
      'picked_up': {
        'label': 'Picked Up',
        'description': 'Driver picked up your order',
        'icon': 'local_shipping',
        'color': 0xFF00BCD4,
      },
      'on_the_way': {
        'label': 'On the Way',
        'description': 'Driver is on the way',
        'icon': 'two_wheeler',
        'color': 0xFF3F51B5,
      },
      'delivered': {
        'label': 'Delivered',
        'description': 'Order delivered successfully',
        'icon': 'check_circle_outline',
        'color': 0xFF4CAF50,
      },
      'cancelled': {
        'label': 'Cancelled',
        'description': 'Order was cancelled',
        'icon': 'cancel',
        'color': 0xFFF44336,
      },
    };

    return statusMap[status] ??
        {
          'label': 'Unknown',
          'description': 'Status unknown',
          'icon': 'help',
          'color': 0xFF9E9E9E,
        };
  }
}
