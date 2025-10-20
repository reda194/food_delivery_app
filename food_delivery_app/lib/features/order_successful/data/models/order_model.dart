import 'package:json_annotation/json_annotation.dart';
import '../../domain/models/order_success_args.dart';

part 'order_model.g.dart';

/// Order Model - Data layer representation
/// Handles serialization/deserialization from JSON (Supabase)
@JsonSerializable()
class OrderModel {
  final String id;
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'restaurant_id')
  final String restaurantId;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  final String status;
  @JsonKey(name: 'delivery_address')
  final String? deliveryAddress;
  @JsonKey(name: 'estimated_delivery_time')
  final DateTime estimatedDeliveryTime;
  @JsonKey(name: 'driver_id')
  final String? driverId;
  @JsonKey(name: 'driver_name')
  final String? driverName;
  @JsonKey(name: 'driver_phone')
  final String? driverPhone;
  @JsonKey(name: 'driver_image')
  final String? driverImage;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<OrderItemModel>? items;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.restaurantId,
    required this.totalAmount,
    required this.status,
    this.deliveryAddress,
    required this.estimatedDeliveryTime,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverImage,
    this.paymentMethod,
    this.paymentStatus,
    required this.createdAt,
    this.updatedAt,
    this.items,
  });

  /// Create from JSON (from Supabase)
  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  /// Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  /// Convert to OrderSuccessArgs (for UI)
  OrderSuccessArgs toOrderSuccessArgs() {
    return OrderSuccessArgs(
      orderId: id,
      orderNumber: orderNumber,
      estimatedDeliveryTime: estimatedDeliveryTime,
      totalAmount: totalAmount,
      deliveryAddress: deliveryAddress,
      driverName: driverName,
      driverPhone: driverPhone,
      driverImage: driverImage,
      items: items?.map((item) => item.toOrderItemSummary()).toList(),
    );
  }
}

/// Order Item Model
@JsonSerializable()
class OrderItemModel {
  final String id;
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'menu_item_id')
  final String menuItemId;
  @JsonKey(name: 'menu_item_name')
  final String menuItemName;
  final int quantity;
  final double price;
  @JsonKey(name: 'subtotal')
  final double subtotal;
  final String? notes;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.menuItemName,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.notes,
  });

  /// Create from JSON
  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  /// Convert to OrderItemSummary
  OrderItemSummary toOrderItemSummary() {
    return OrderItemSummary(
      name: menuItemName,
      quantity: quantity,
      price: price,
    );
  }
}
