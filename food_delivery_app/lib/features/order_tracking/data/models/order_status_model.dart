import '../../domain/entities/order_status_entity.dart';

/// Model for order status from API
class OrderStatusModel extends OrderStatusEntity {
  const OrderStatusModel({
    required super.orderId,
    required super.status,
    required super.currentLocation,
    required super.estimatedDeliveryTime,
    super.driverId,
    super.driverName,
    super.driverPhone,
    super.driverImage,
    super.driverRating,
    super.deliveryAddress,
    super.pickupAddress,
    super.orderItems,
    super.totalAmount,
    super.createdAt,
    super.updatedAt,
  });

  /// Create from JSON
  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      orderId: json['id'] as String,
      status: OrderStatus.fromString(json['status'] as String),
      currentLocation: json['current_location'] != null
          ? LatLngModel.fromJson(json['current_location'] as Map<String, dynamic>)
          : null,
      estimatedDeliveryTime: json['estimated_delivery_time'] != null
          ? DateTime.parse(json['estimated_delivery_time'] as String)
          : null,
      driverId: json['driver_id'] as String?,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      driverImage: json['driver_image'] as String?,
      driverRating: json['driver_rating'] != null
          ? (json['driver_rating'] as num).toDouble()
          : null,
      deliveryAddress: json['delivery_address'] as String?,
      pickupAddress: json['pickup_address'] as String?,
      orderItems: json['order_items'] as List<dynamic>?,
      totalAmount: json['total_amount'] != null
          ? (json['total_amount'] as num).toDouble()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': orderId,
      'status': status.value,
      'current_location': currentLocation != null
          ? (currentLocation as LatLngModel).toJson()
          : null,
      'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'driver_image': driverImage,
      'driver_rating': driverRating,
      'delivery_address': deliveryAddress,
      'pickup_address': pickupAddress,
      'order_items': orderItems,
      'total_amount': totalAmount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create from entity
  factory OrderStatusModel.fromEntity(OrderStatusEntity entity) {
    return OrderStatusModel(
      orderId: entity.orderId,
      status: entity.status,
      currentLocation: entity.currentLocation,
      estimatedDeliveryTime: entity.estimatedDeliveryTime,
      driverId: entity.driverId,
      driverName: entity.driverName,
      driverPhone: entity.driverPhone,
      driverImage: entity.driverImage,
      driverRating: entity.driverRating,
      deliveryAddress: entity.deliveryAddress,
      pickupAddress: entity.pickupAddress,
      orderItems: entity.orderItems,
      totalAmount: entity.totalAmount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert to entity
  OrderStatusEntity toEntity() {
    return OrderStatusEntity(
      orderId: orderId,
      status: status,
      currentLocation: currentLocation,
      estimatedDeliveryTime: estimatedDeliveryTime,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      driverImage: driverImage,
      driverRating: driverRating,
      deliveryAddress: deliveryAddress,
      pickupAddress: pickupAddress,
      orderItems: orderItems,
      totalAmount: totalAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Model for latitude/longitude
class LatLngModel {
  final double latitude;
  final double longitude;

  const LatLngModel({
    required this.latitude,
    required this.longitude,
  });

  factory LatLngModel.fromJson(Map<String, dynamic> json) {
    return LatLngModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
