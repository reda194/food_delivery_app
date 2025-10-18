import 'package:equatable/equatable.dart';

/// Entity representing order status
class OrderStatusEntity extends Equatable {
  final String orderId;
  final OrderStatus status;
  final dynamic currentLocation; // LatLng or LatLngModel
  final DateTime? estimatedDeliveryTime;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String? driverImage;
  final double? driverRating;
  final String? deliveryAddress;
  final String? pickupAddress;
  final List<dynamic>? orderItems;
  final double? totalAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderStatusEntity({
    required this.orderId,
    required this.status,
    this.currentLocation,
    this.estimatedDeliveryTime,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverImage,
    this.driverRating,
    this.deliveryAddress,
    this.pickupAddress,
    this.orderItems,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        orderId,
        status,
        currentLocation,
        estimatedDeliveryTime,
        driverId,
        driverName,
        driverPhone,
        driverImage,
        driverRating,
        deliveryAddress,
        pickupAddress,
        orderItems,
        totalAmount,
        createdAt,
        updatedAt,
      ];
}

/// Order status enum
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  pickedUp,
  onTheWay,
  delivered,
  cancelled;

  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.ready:
        return 'ready';
      case OrderStatus.pickedUp:
        return 'picked_up';
      case OrderStatus.onTheWay:
        return 'on_the_way';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Order Pending';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Your Food';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.onTheWay:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'picked_up':
        return OrderStatus.pickedUp;
      case 'on_the_way':
        return OrderStatus.onTheWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}

/// Driver location entity
class DriverLocation extends Equatable {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const DriverLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, timestamp];
}

/// Destination location entity
class DestinationLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String address;

  const DestinationLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}
