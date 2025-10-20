import 'package:equatable/equatable.dart';

/// Arguments passed to Order Success Screen via navigation
class OrderSuccessArgs extends Equatable {
  final String orderId;
  final String orderNumber;
  final DateTime estimatedDeliveryTime;
  final double totalAmount;
  final String? deliveryAddress;
  final String? driverName;
  final String? driverPhone;
  final String? driverImage;
  final List<OrderItemSummary>? items;

  const OrderSuccessArgs({
    required this.orderId,
    required this.orderNumber,
    required this.estimatedDeliveryTime,
    required this.totalAmount,
    this.deliveryAddress,
    this.driverName,
    this.driverPhone,
    this.driverImage,
    this.items,
  });

  /// Get estimated delivery time in minutes from now
  int get estimatedMinutes {
    final now = DateTime.now();
    final difference = estimatedDeliveryTime.difference(now);
    return difference.inMinutes;
  }

  /// Format estimated delivery time
  String get formattedEstimatedTime {
    final hour = estimatedDeliveryTime.hour;
    final minute = estimatedDeliveryTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Format total amount
  String get formattedTotalAmount {
    return '\$${totalAmount.toStringAsFixed(2)}';
  }

  @override
  List<Object?> get props => [
        orderId,
        orderNumber,
        estimatedDeliveryTime,
        totalAmount,
        deliveryAddress,
        driverName,
        driverPhone,
        driverImage,
        items,
      ];
}

/// Summary of an order item (for receipt display)
class OrderItemSummary extends Equatable {
  final String name;
  final int quantity;
  final double price;

  const OrderItemSummary({
    required this.name,
    required this.quantity,
    required this.price,
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [name, quantity, price];
}
